var app=angular.module('ffe', ['ngRoute','ngAnimate']);

app.controller('ffeCtrl', function($scope, $timeout, $window, $location ) {
    $scope.scholarResidenstilPickValues	= scholarResidenstilPickValues;
    $scope.donor						= {};
    $scope.formInvalid					= false;
    $scope.confirmationMsg				= confirmMsg;
    $scope.donorProfileURL				= profileURL;
    $scope.donorCategory				= JSON.parse(donorCategory);
    
    $scope.residential = function(value){
        if(value==CitizenIndian){
            $scope.pan=true;
            $scope.passport=false;
        }
        else if(value==CitizenNonIndian){
            $scope.passport=true;
            $scope.pan=false;
        }
    }
    $scope.register = function(){
        $scope.loading=true;
        if($scope.regForm.$invalid || $scope.emailvalidation.$invalid || $scope.gmailvalidation.$invalid){
            $scope.loading=false;
            $scope.formInvalid=true;
            swal({title:'',text:"Please fill all mandatory (*) fields"});
        }
        else if($scope.emailValidation($scope.donor.Email) && $scope.emailValidation($scope.donor.Facebook_login_ID__c) && $scope.emailValidation($scope.donor.Google_login_ID__c)){
            $scope.notGmail=false;
            $scope.invalidGmail = false;
            $scope.invalidFEmail = false;
            $scope.invalidEmail = false;
            DN_DonorRegistration_CTRL.createDonorInSFDC($scope.donor,function(result,event){
                if(event.status){ 
                    if(result.message == $scope.confirmationMsg){
                        $scope.loading=false;
                        swal({
                            title: "",
                            text: $scope.confirmationMsg,
                            type: "success",
                            showCancelButton: false,
                            confirmButtonColor: '#DD6B55',
                            confirmButtonText: 'Ok',
                            closeOnConfirm: false,
                            allowEscapeKey:false,
                            html:true
                        },
                             function(isConfirm) {
                                 if (isConfirm) {
                                     swal.close();
                                     var form = document.createElement("form");
                                     form.setAttribute("method", "post");
                                     form.setAttribute("action", $scope.donorProfileURL);
                                     
                                     form.setAttribute("target", "_top");
                                     
                                     var hiddenField = document.createElement("input"); 
                                     hiddenField.setAttribute("type", "hidden");
                                     hiddenField.setAttribute("name", "encDonorId");
                                     hiddenField.setAttribute("value", result.recordId);
                                     form.appendChild(hiddenField);
                                     document.body.appendChild(form);
                                     
                                     window.open('', '_top');
                                     
                                     form.submit();
                                 } 
                             });
                        $scope.$apply();
                    }else{ 
                        swal({title:'',text:result.message});     
                        $scope.loading=false;
                        $scope.$apply();
                    }
                }else{
                    $scope.loading=false;
                    swal({title:'',text:'Oops! Somthing went wrong.Please try again.'}); 
                    $scope.$apply();
                }
            });
        }
            else{
                swal({title:'',text:"Not a valid e-mail address"});
                $scope.loading=false;
            }
    }
    $scope.emailValidation = function(value){
        $scope.valid(value);
        if(value!=undefined && value!=''){
            var x=value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                swal({title:'',text:"Not a valid e-mail address"});
                return false;
            }
           else if (value==$scope.donor.Google_login_ID__c){
                var String=value.substring(value.lastIndexOf("@")+1,value.lastIndexOf(".com"));
                String=String.toLowerCase();
                if(String!='gmail'){
                   swal({title:'',text:"Please enter your Gmail Id"});
                    $scope.notGmail=true;
                    return false;
                }
                else{
                    $scope.notGmail=false;
                    return true;
                }
            }
                else{
                    return true;
                }
        }
        else{
            return true
        }
    }
    $scope.valid = function(value){
        if(value!=undefined){
            var x=value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                if(value==$scope.donor.Email){
                    $scope.invalidEmail = true;
                }
                else if(value==$scope.donor.Facebook_login_ID__c){
                    $scope.invalidFEmail = true;
                }
                    else if(value==$scope.donor.Google_login_ID__c){
                        $scope.invalidGmail = true;
                    }
            }
            else{
                if(value==$scope.donor.Email){
                    $scope.invalidEmail = false;
                }
                else if(value==$scope.donor.Facebook_login_ID__c){
                    $scope.invalidFEmail = false;
                }
                    else if(value==$scope.donor.Google_login_ID__c){
                        $scope.invalidGmail = false;
                    }
            }
        }
    }
    $scope.gValue = function(value){
        if(!value){
            $scope.donor.Google_login_ID__c='';
        }
    }
    $scope.fbValue = function(value){
        if(!value){
            $scope.donor.Facebook_login_ID__c='';
        }
    }
    
    $scope.clearFields = function(){
        $scope.donor={};
        $scope.formInvalid =false;
    }
});