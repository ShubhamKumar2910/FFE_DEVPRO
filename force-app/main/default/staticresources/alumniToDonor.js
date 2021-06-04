var app=angular.module('ffe', ['ngRoute','ngAnimate']);

app.controller('ffeCtrl', function($scope, $timeout, $window, $location ) {
    $scope.scholarResidenstilPickValues	= scholarResidenstilPickValues;
    $scope.donor						= {};
    $scope.formInvalid					= false;
    $scope.confirmationMsg				= confirmMsg;
    $scope.newConfirMsg                 = newConfirMsg;
    $scope.aadharErrMsg					= aadharErrMsg;
    $scope.panErrMsg					= panErrMsg;
    $scope.mobileErrMsg					= mobileErrMsg;
    $scope.googleAndFacebookdup         = googleAndFacebookdup;
    $scope.isStudentMsg			        = isStudentMsg;
    $scope.donorProfileURL				= profileURL;
    $scope.donorCategory				= JSON.parse(donorCategory);
    $scope.popupdisplay                 = false;
    $scope.maskEmail                    = '';
    $scope.currentEmail                 =  '';
    $scope.currentYear                  = currentYear;
    $scope.countryList						= countryList;
    $scope.countrySelected                  = 'India';
    $scope.listStates						= listOfStates;
    $scope.listOfStates						= [];
    $scope.indianStates						= [];
    
    for(var i=0;i<$scope.listStates.length;i++){
        $scope.listOfStates.push($scope.listStates[i].Label);
        $scope.indianStates.push($scope.listStates[i].Label);
        }
    
    
    
         $scope.getstateList = function(__country){
        $scope.listOfStates	= [];
        $scope.listStates	= [];
        $scope.listOfCities	= [];
        $scope.loading=true;
        Alumni_To_Donor_Ctrl.getStateList(__country,function(result,event){
            if(event.status){
                $scope.listStates = result;
                for(var i=0;i<$scope.listStates.length;i++){
                    $scope.listOfStates.push($scope.listStates[i].Label);
                }
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
         }
     $scope.listOfCities	= [];
    $scope.getcityList = function(__state){
        $scope.listOfCities	= [];
         $scope.listcities	= [];
        $scope.loading=true;
        Alumni_To_Donor_Ctrl.getCityList(__state,function(result,event){
            if(event.status){
                $scope.listcities = result;
                for(var i=0;i<$scope.listcities.length;i++){
                    $scope.listOfCities.push($scope.listcities[i].City__c);
                }
                $scope.listOfCities.push('Other');
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
    }
    
        $scope.dislpayOtherCity = false;
        $scope.otherCityCheck = function(cityName){
            if(cityName == 'Other'){
               $scope.dislpayOtherCity = true; 
            }else{
                $scope.dislpayOtherCity = false;
            }
        } 
        

        
        $scope.othercityvalues = function(val){
            $scope.otherCity ='';
            $scope.otherCity = val;
            //alert($scope.otherCity);
        }
        
    $scope.checkCurrentYearisGreate = function(year){
        $scope.typedYear = parseInt(year);
        if($scope.typedYear >=$scope.currentYear){
            swal({title:'',
                  text:'Year of graduation should be less than the current year ['+$scope.currentYear+'].'});
        }
    }
    
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
    
    $scope.disableSchlrDtls = false;
    $scope.disableScholarDetails = function(categoryType){
        if(categoryType == 'Scholar'){
           $scope.disableSchlrDtls = true;
        }else{
           $scope.disableSchlrDtls = false;
        }
    }
    
    $scope.register = function(num){
        $scope.loading=true;
        
        $scope.donor.MailingCountry = '';
        $scope.donor.MailingState   = '';
        $scope.donor.MailingCity    =  '';
		$scope.donor.MailingCountry = $scope.countrySelected;   
        $scope.donor.MailingState   = $scope.locationSelected;
        if($scope.locationCitySelected == 'Other'){
           $scope.donor.MailingCity    = $scope.otherCity;
        }else{
           $scope.donor.MailingCity    = $scope.locationCitySelected;
        }
        $scope.donor.DN_Donor_Category__c = 'Scholar';
        if($scope.donor.DN_Year_Of_Graduation__c >=$scope.currentYear  && $scope.donor.DN_Donor_Category__c == 'Scholar'){
            $scope.loading=false;
            swal({title:'',
                  text:'Year of graduation should be less than the current year ['+$scope.currentYear+'].'});
            return;
        }
        
        if(num == 2){
            $scope.donor.Alumni_Email__c = $scope.donor.Email;
            $scope.donor.Email = '';
        }
        
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
            Alumni_To_Donor_Ctrl.createDonorInSFDC($scope.donor,function(result,event){
                if(event.status){
                    if(result.message == $scope.isStudentMsg){
                        $scope.popupdisplay = false;
                        $scope.loading=false;
                        swal({
                            title: "",
                            text: result.message,
                            type: "warning",
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
                                     window.location.replace('http://www.ffe.org/');
                                 } 
                             });
                        
                        $scope.$apply();
                    }else {
                        if(result.message == $scope.newConfirMsg){
                            $scope.popupdisplay  = false;
                            $scope.loading=false;
                            swal({
                                title: "",
                                text: $scope.newConfirMsg,
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
                            //add condition only for email
                            if(result.message!=$scope.googleAndFacebookdup && !(result.message == $scope.aadharErrMsg ||result.message == $scope.panErrMsg ||result.message == $scope.mobileErrMsg)){
                                $scope.popupdisplay = true;   
                                $scope.maskEmail = result.message;
                                $scope.currentEmail = $scope.donor.Email;
                                $scope.loading=false;
                                $scope.$apply();
                            }else{
                                $scope.popupdisplay = false;
                                $scope.loading=false;
                                $scope.$apply();
                                swal({title:'',text:result.message});
                            }
                        }
                        
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
    
    
    $scope.clear = function(){
        $scope.popupdisplay = false;
    }
    
    $scope.sendEmail = function(){
        Alumni_To_Donor_Ctrl.sendEmail($scope.currentEmail,function(result,event){
            if(event.status){ 
                $scope.popupdisplay  = false;
                $scope.loading=false;
                $scope.$apply();
                //swal({title:'',text:result});
                swal({
                                 title: "",
                                 text: result,
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
                                          window.location.replace('http://www.ffe.org/');
                                      } 
                                  });
                
            }else{
                $scope.popupdisplay = true;
                $scope.loading=false;
                $scope.$apply();
                swal({title:'',text:result});
                
            }
        });
    }
    
    $scope.emailAlternate = function(){
        swal({
            title: "Email Address",
            text: "Enter your new Email address",
            type: "input",
            closeOnConfirm: false,
            showCancelButton: true,
            animation: "slide-from-top",
            confirmButtonColor: "#ff793c",
            inputPlaceholder: "Email Address"
        },
             function(inputValue){
                 if (inputValue === false) return false;
                 
                 if(inputValue!=undefined){
                    var x=inputValue;
                    var atpos = x.indexOf("@");
                    var dotpos = x.lastIndexOf(".");
                   if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                       swal.showInputError("Please Enter a valid email address!");
                       return false;
                   }
                 }
                 
                 if (inputValue === "") {
                     swal.showInputError("Please Enter your new email address!");
                     return false;
                 }else{
                     Alumni_To_Donor_Ctrl.updateAlumniEmail($scope.currentEmail,$scope.donor.MobilePhone,$scope.donor.DN_PAN__c,$scope.donor.Aadhar_number__c,inputValue,function(result,event){
                         if(event.status && result == $scope.confirmationMsg){ 
                             $scope.popupdisplay  = false;
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
                                          window.location.replace('http://www.ffe.org/');
                                      } 
                                  });
                             $scope.$apply();
                         }else{
                             $scope.popupdisplay = true;   
                             $scope.maskEmail = result.message;
                             $scope.currentEmail = $scope.donor.Email;
                             $scope.loading=false;
                             $scope.$apply();
                             swal({title:'',text:result});
                         }
                     });
                 }
                 
             });
        
    }; 
    
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