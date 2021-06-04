var app=angular.module('Facilitator', ['ngRoute','ngAnimate','ngMaterial']);
var sitePrefix = '/application';
if (sitePrefix=='') sitePrefix='/application';
app.config( function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(false).hashPrefix('');
    $routeProvider
    
    .when('/facilitatorProfileListings', {templateUrl: sitePrefix+'/facilitatorProfileListings',
                                         })
    .when('/viewStudentProfile', {templateUrl: sitePrefix+'/viewStudentProfile',
                                 })    
    .otherwise({redirectTo: '/facilitatorProfileListings'});
});

app.controller('FacilitatorProfile', function($scope, $timeout, $window, $location,$element) {
    
    $scope.viewStudent 					= false;
    $scope.application__c				= {};
    $scope.maxStringSize 				= 6000000;
    $scope.maxFileSize	 				= 4350000;
    $scope.chunkSize 	 				= 950000;
    $scope.editFileds					= true;
    $scope.IsdocUploaded 				= false;
    $scope.uploadForFacilitator			= facilitatorUpload;
    $scope.uploadedByStudent			= studentUpload;
    $scope.listOfStates					= listOfStates;
    $scope.terms						= false;
    $scope.selectedtabsInternal			= 0;
    $scope.indexValueInternal           = 0;
    //const FAC_COMPLETED_STATUSES        = ["FACILITATOR MATCHED","FACILITATOR_MATCHED", "ELIGIBLE", "INELIGIBLE", "SELECTED", "REJECTED_BY_FACILITATOR", "REJECTED BY FACILITATOR", "REJECTED BY FFE STAF", "NOT INTERESTED"]; 
    
    $scope.showTabcontent=function(value){
        $scope.selected=value;
    }
    
    $scope.moveToTop = function(){
        var myDiv = document.getElementById('myContainerDiv');
        myDiv.scrollTop = 0;
    }
    $scope.previous = function(){
        $scope.viewStudent 		= false;
        $scope.application__c	= {};
        $scope.attachemts		= {};
        $location.path('/facilitatorProfileListings');
    }
    $scope.getFacilitatorDetails = function(){
        $scope.loading= true;
        AP_Application_CTRL.getFacilitatorUserDetail(facilitatorId, function(result,event){
            if(event.status){
                $scope.Facilitator =JSON.parse(result);
                if($scope.Facilitator.MailingState != undefined && $scope.Facilitator.MailingState != ''){
                    $scope.getCities($scope.Facilitator.MailingState);
                }
                $scope.loading= false;
                $scope.$apply();
            }
            else{
                $scope.loading= false;
                $scope.$apply();
            }
        },{escape:false})
    }
    
    window.onload=function(){
        var i;
        var x = document.getElementsByClassName("city");
        for (i = 0; i < x.length; i++) {
            if(i==0){
                x[i].style.display = "block";
            }
            else{
                x[i].style.display = "none";
            }
        }
        if(!$scope.viewStudent){
            $scope.previous();
        }
        $scope.getFacilitatorDetails();
        
    }
    
    $scope.getAttStudents =function(){
        $scope.completedList = [];
        $scope.tobeProcessedList =[];
        $scope.loading=true;
        AP_Application_CTRL.getFacilitatorStudents(facilitatorId, function(result,event){
            if(event.status){
                let studentListingWrapper = JSON.parse(result);
                if(studentListingWrapper != undefined) {
                    $scope.completedList = studentListingWrapper.completed;
                    $scope.tobeProcessedList = studentListingWrapper.toBeProcessed;
                }
                /* if($scope.studentListings.length>0){ 
                    for(var i=0;i<$scope.studentListings.length;i++){
                        if($scope.studentListings[i].Applications__r && $scope.studentListings[i].Applications__r.records && $scope.studentListings[i].Applications__r.records.length > 0) {
                            let internalStatus = $scope.studentListings[i].Applications__r.records[0].Internal_Status__c;
                            if(internalStatus != null && internalStatus != undefined) {
                                internalStatus = internalStatus.toUpperCase();
                                if($scope.studentListings[i].IsPrelimProcessed__c && !FAC_COMPLETED_STATUSES.includes(internalStatus)){
                                    $scope.completedList.push($scope.studentListings[i]);
                                }
                                else if(!$scope.studentListings[i].IsPrelimProcessed__c && (internalStatus == "FACILITATOR MATCHED" || internalStatus == "FACILITATOR_MATCHED")){
                                    $scope.tobeProcessedList.push($scope.studentListings[i]);
                                }
                            }
                        }
                        
                    }
                } */
                if($scope.tobeProcessedList.length <= 0){
                    $scope.switchInternal(1,1);
                }
                
                $scope.loading= false;
                $scope.$apply();
            }
            else{
                $scope.loading= false;
                $scope.$apply();
            }
        },{escape:false})
        
    }
    
    $scope.tabs =function(){
        $scope.index=0;
        $scope.selected=0;
        $scope.loading=true;
        var i;
        var x = document.getElementsByClassName("city");
        for (i = 0; i < x.length; i++) {
            if(i==0){
                x[i].style.display = "block";
            }
            else{
                x[i].style.display = "none";
            }
        }
        $scope.loading=false;
    }
    
    $scope.save = function(){
        $scope.loading=true;
        if(this.basicInfo.$invalid){
            $scope.showSpace = true;
            $scope.loading=false;
            $scope.formInvalid = true;
            swal({title:'',text:"Please fill all the mandatory (* marked) fileds."});
        }
        else if($scope.emailValidation($scope.Facilitator.Email) && $scope.emailValidation($scope.Facilitator.Facebook_login_ID__c) && $scope.emailValidation($scope.Facilitator.Google_login_ID__c)){
            $scope.loading=true;
            $scope.notGmail=false;
            $scope.invalidGmail = false;
            $scope.invalidFEmail = false;
            $scope.invalidEmail = false;
            if($scope.Facilitator != undefined)
                delete $scope.Facilitator["attributes"];
            if($scope.Facilitator.RecordType != undefined)
                delete $scope.Facilitator.RecordType["attributes"];
            AP_Application_CTRL.updateFacilitatorInSFDC($scope.Facilitator, function(result,event){
                if(event.status){
                    $scope.loading=false;
                    $scope.showSpace = false;
                    $scope.editFileds = true;
                    swal({title:'',text:result});
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false})
        }
        else{
                swal({title:'',text:"Not a valid e-mail address"});
                $scope.loading=false;
            }
    }
    
    $scope.currentStudent = function(studentId){
        $scope.terms= false;
        $scope.application__c	={};
        if(studentId!=undefined && studentId!=''){
            $scope.contantId	= studentId;
            $scope.viewStudent = true;
            if($scope.contantId !== undefined){
                $scope.loading=true;
                AP_Application_CTRL.viewStudentProfile($scope.contantId,function(result, event){
                    if(event.status){ 
                        $scope.studentDetails = JSON.parse(result);
                        console.log($scope.studentDetails);
                        if($scope.studentDetails.Applications__r != undefined){
                            for(var i=0;i<$scope.studentDetails.Applications__r.records.length;i++){
                                if($scope.studentDetails.Applications__r.records[i] != undefined){
                                    if($scope.studentDetails.Applications__r.records[i].RecordType.DeveloperName =='Scholarship'){
                                        $scope.activeIndex=i;
                                        $scope.application__c.Id 										= $scope.studentDetails.Applications__r.records[i].Id;
                                        if($scope.studentDetails.Applications__r.records[$scope.activeIndex].FacilitatorInputDone__c == true || $scope.studentDetails.Applications__r.records[$scope.activeIndex].Internal_Status__c=='Pending FFE Staff Review' || $scope.studentDetails.Applications__r.records[$scope.activeIndex].Internal_Status__c=='Rejected by Facilitator'){
                                            $scope.application__c.Has_student_provided_Justification__c 	= $scope.studentDetails.Applications__r.records[i].Has_student_provided_Justification__c.toString();
                                            $scope.application__c.Have_you_met_the_student_s_parent_s__c 	= $scope.studentDetails.Applications__r.records[i].Have_you_met_the_student_s_parent_s__c.toString();
                                            $scope.application__c.Have_you_visited_the_student_s_house__c 	= $scope.studentDetails.Applications__r.records[i].Have_you_visited_the_student_s_house__c.toString();
                                            $scope.application__c.Please_Comment_on_Parent_s_Backgroun__c 	= $scope.studentDetails.Applications__r.records[i].Please_Comment_on_Parent_s_Backgroun__c;
                                            $scope.application__c.Student_truly_deserves_a_scholarship__c 	= $scope.studentDetails.Applications__r.records[i].Student_truly_deserves_a_scholarship__c.toString();
                                        }
                                        if($scope.studentDetails.Applications__r.records[i].Receiving_Full_AICTE_OtherTution_Fee_Wa__c){
                                            $scope.Receiving_Full_AICTE_OtherTution_Fee_Wa__c ='Yes'
                                        }
                                        else{
                                            $scope.Receiving_Full_AICTE_OtherTution_Fee_Wa__c ='No'
                                        }
                                        if($scope.studentDetails.Applications__r.records[i].SchlrShp_FinancialAsst_Other_Than_FFE__c){
                                            $scope.SchlrShp_FinancialAsst_Other_Than_FFE__c ='Yes'
                                        }
                                        else{
                                            $scope.SchlrShp_FinancialAsst_Other_Than_FFE__c ='No'
                                        }
                                        $scope.If_Yes_How_much_Other_Source__c = $scope.studentDetails.Applications__r.records[i].If_Yes_How_much_Other_Source__c;
                                        $scope.Assistance_Source__c = $scope.studentDetails.Applications__r.records[i].Assistance_Source__c;
                                    }
                                    
                                }
                            }
                        }
                        if($scope.studentDetails.Profile_Pic_Attachment_Id__c !=undefined && $scope.studentDetails.Profile_Pic_Attachment_Id__c !=''){
                            $scope.noImage=false;
                            $scope.imageSFIdURL= "/application/servlet/servlet.FileDownload?file="+$scope.studentDetails.Profile_Pic_Attachment_Id__c;
                        }else{
                            $scope.noImage=true;
                        }

                        $scope.loading=false;
                        if($scope.application__c != undefined && $scope.application__c.Id != undefined){
                            $scope.getAllAttachments($scope.application__c.Id,$scope.uploadedByStudent);
                        }
                        $scope.$apply();
                    }
                    else{
                        $scope.loading=false;
                        $scope.$apply();
                    }
                },{escape:false});
                $scope.loading=false;
            }           
        }
        else{
            $scope.viewStudent = false;
            $location.path('/facilitatorProfileListings');
        }
    }
    
     $scope.getAllAttachments = function(id,Student){
        $scope.attachemts	= {};
        AP_Application_CTRL.getAllAttachments(id,Student,function(result,event){
            if(event.status){
                $scope.attachemts = JSON.parse(result);
                if($scope.attachemts != undefined && $scope.attachemts.length > 0){
                    $scope.IsdocUploaded	= true;
                }
                $scope.$apply();
            }
        },{escape:false});
    }
     
    $scope.loadStudentProfile = function(){
        if($scope.contantId!=undefined && $scope.contantId!=''){
            $scope.currentStudent($scope.contantId);
        }
        else{
            $scope.viewStudent = false;
            $location.path('/facilitatorProfileListings');
            
        }
    }
    
    $scope.verified = function(){
        if($scope.application__c != undefined && $scope.application__c.Id != undefined){
            $scope.application__c.Student__c	= $scope.contantId;
            $scope.application__c.Id 			= $scope.application__c.Id;
            $scope.loading=true;
            if(this.regForm.$invalid){
                $scope.formInvalidFaci =true;
                $scope.loading=false;
                console.log($scope.application__c);
                swal({title:'',text:"Please fill all mandatory (*) fields"});
            }
            else{
                console.log($scope.application__c);
                
                AP_Application_CTRL.verifyStudent($scope.application__c,function(result, event){
                    if(event.status){ 
                        console.log(result);
                        $scope.loading=false;
                        swal({title:'',
                              text:result,
                              allowEscapeKey:false,
                              closeOnConfirm: false,
                              closeOnCancel: false
                             },
                             function(isConfirm){
                                 swal.close();
                                 $scope.viewStudent = false;
                                 $location.path('/facilitatorProfileListings');
                                 $scope.$apply();
                             });
                        $scope.$apply();
                    }
                    else{
                        $scope.loading=false;
                        $scope.$apply();
                    }
                });
            }
        }       
    }
    
    $scope.reject = function(){
        if($scope.application__c != undefined && $scope.application__c.Id != undefined){
            $scope.application__c.Student__c	= $scope.contantId;
            $scope.application__c.Id 			= $scope.application__c.Id;
            $scope.loading=true;
            if(this.regForm.$invalid){
                $scope.formInvalidFaci =true;
                $scope.loading=false;
                swal({title:'',text:"Please fill all mandatory (*) fields"});
            }
            else{
                console.log($scope.application__c);
                AP_Application_CTRL.rejectStudent($scope.application__c,function(result, event){
                    if(event.status){ 
                        console.log(result);
                        $scope.loading=false;
                        swal({title:'',
                              text:result,
                              allowEscapeKey:false,
                              closeOnConfirm: true,
                              closeOnCancel: false,
                              allowEscapeKey:false
                             },
                             function(isConfirm){
                                 $scope.moveToTop();
                                 $scope.viewStudent = false;
                                 $location.path('/facilitatorProfileListings');
                                 $scope.$apply();
                             });
                        $scope.$apply();
                    }
                    else{
                        $scope.loading=false;
                        $scope.$apply();
                    }
                });
            }
        }
    }
    
    $scope.valid = function(value){
        if(value!=undefined){
            var x=value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                if(value==$scope.Facilitator.Email){
                    $scope.invalidEmail = true;
                    $scope.showSpace=true;
                }
                else if(value==$scope.Facilitator.Facebook_login_ID__c){
                    $scope.invalidFEmail = true;
                    $scope.showSpace=true;
                }
                    else if(value==$scope.Facilitator.Google_login_ID__c){
                        $scope.invalidGmail = true;
                        $scope.showSpace=true;
                    }
            }
            else{
                if(value==$scope.Facilitator.Email){
                    $scope.invalidEmail = false;
                }
                else if(value==$scope.Facilitator.Facebook_login_ID__c){
                    $scope.invalidFEmail = false;
                }
                    else if(value==$scope.Facilitator.Google_login_ID__c){
                        $scope.invalidGmail = false;
                    }
            }
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
            else if (value==$scope.Facilitator.Google_login_ID__c){
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
    
    $scope.gValue = function(value){
        if(!value){
            $scope.Facilitator.Google_login_ID__c='';
        }
    }
    $scope.fbValue = function(value){
        if(!value){
            $scope.Facilitator.Facebook_login_ID__c='';
        }
    }
    
     $scope.edit = function (){
        $scope.editFileds =false;
    }
     
	 $scope.cancelChanges = function(){
        $scope.getFacilitatorDetails();
        $scope.editFileds = true;
        $scope.formInvalid = false;
        $scope.formCourseInvalid=false;
}
     $scope.checkValue = function(terms){
         $scope.terms = !$scope.terms;
     }
     $scope.switchInternal =function(switchvalue, tabvalue){
         $scope.selectedtabsInternal=tabvalue;
         $scope.indexValueInternal=switchvalue;
     }
     
       $scope.getCities = function(state){
        $scope.loading=true;
        AP_Application_CTRL.getCities(state,function(result,event){
            if(event.status){
                $scope.listOfCities = JSON.parse(result);
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
        
    }
     
});
