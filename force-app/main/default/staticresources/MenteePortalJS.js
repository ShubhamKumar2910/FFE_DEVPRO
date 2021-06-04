 var app = angular.module('menteeDetailApp', ['ngMaterial' , 'jkAngularRatingStars']);  
        app.controller('menteeDetailController', function($scope) {
            var menteeId = '{!$CurrentPage.parameters.Id}';
            $scope.menteeDetail; 
            $scope.editable = false;
            
            $scope.showDetails = false;
            $scope.showProgramDetail = false;
            $scope.showSessions = false;
            $scope.showHomepage = false;
            $scope.showprofileDetails = false;
            $scope.mentorDescription = '';
            $scope.menteeDescription = '';
            $scope.mentorRating = 0;
            $scope.menteeRating = 0;
            $scope.getMenteeDetails = function() {
                debugger;
                Visualforce.remoting.Manager.invokeAction(
                    '{!$RemoteAction.MenteePortal_Controller.getMenteeDetails}',
                    menteeId,
                    function(result, event){
                        
                        if(event.status){
                            $scope.menteeDetail = result;                    
                            $scope.$apply();                                        
                        }               
                    },
                    {escape: true}
                );
            }
            $scope.getMenteeDetails();
            
            $scope.uploadDoc = function(param){
                debugger;
            	uploadFile(param)
            }
            
            $scope.openNav = function(){
                debugger;
                if($scope.showprofileDetails == false){
                    $scope.showprofileDetails = true;
                }else{
                    $scope.showprofileDetails = false;
                }
            }
            
            $scope.editDetails = function(){
                $scope.editable = true;
                $scope.showDetails = false;
                $scope.showProgramDetail = false;
                $scope.showprofileDetails = false;
                $scope.showHomepage = false;
                $scope.showSessionListing = false;
            }
            
             $scope.homepage = function(){
             	$scope.showProgramDetail = false;
                $scope.showSessionListing = false;
                $scope.showDetails = false;
                $scope.editable = false;
                $scope.showHomepage = true;
            }
             
              $scope.progDetails = function() {
                debugger;
                $scope.showDetails = false;
                $scope.showProgramDetail = true;
                $scope.showSessionListing = false;
                $scope.editable = false;
                $scope.showHomepage = false;
                $scope.showMentorFeedback = false;
            }
              
              $scope.programDetails =[];
            $scope.sessionList = [];	
              $scope.getprogramDetail = function(){
                debugger;
                Visualforce.remoting.Manager.invokeAction(
                    '{!$RemoteAction.MenteePortal_Controller.getProgramDetails}',
                    function(result,event){
                        if(event.status){
                            $scope.programDetails=result;
                            $scope.$apply();
                        }
                        else if (event.type==='exception'){
                            alert(event.message);
                        }else{
                            alert(event.message);
                        }
                    },
                    {escape:true}
                );
            }
            $scope.getprogramDetail();
            $scope.sessionListing = function(){
                debugger;
                $scope.showProgramDetail = false;
                $scope.showSessionListing = true;
                $scope.showDetails = false;
                $scope.editable = false;
                $scope.showHomepage = false;
                $scope.showMentorFeedback = false;
            } 
            
             $scope.getSessionDetail = function(){
                debugger;
                Visualforce.remoting.Manager.invokeAction(
                    '{!$RemoteAction.MenteePortal_Controller.getAllSession}',
                    menteeId,
                    function(result,event){
                        if(event.status){
                            $scope.sessionList=result;
                            $scope.$apply();
                        }
                        else if (event.type==='exception'){
                            alert(event.message);
                        }else{
                            alert(event.message);
                        }
                    },
                    {escape:true}
                );
            }
             $scope.getSessionDetail();
            $scope.viewSessionDetails = function(index){
                debugger;
                $scope.menteeFeedback = [];
                $scope.showReschedule = false;
                $scope.showMentorFeedback = false;
                $scope.showMentorFeedback = false;
                if($scope.sessionList.length > 0)
                    
                    $scope.session  = $scope.sessionList[index] ;
                $scope.showDetails = true;
                $scope.mentorDescription = '';
                $scope.menteeDescription = '';
                $scope.mentorRating = 0;
                $scope.menteeRating = 0;
                
                $scope.rescheduleSession = $scope.sessionList[index];
                $scope.rescheduleSessionDate = new Date($scope.rescheduleSession.Date__c); 
                if($scope.sessionList[index].Feedbacks__r != null){
                    
                    for(var i=0;i<$scope.sessionList[index].Feedbacks__r.length; i++){
                        if($scope.sessionList[index].Feedbacks__r[i].Feedback_given_by__c == "MENTOR"){
                            $scope.showMentorFeedback = true;
                            $scope.mentorFeedback = $scope.sessionList[index].Feedbacks__r[i];
                            $scope.mentorDescription = $scope.sessionList[index].Feedbacks__r[i].Description__c;
                            $scope.mentorRating = $scope.sessionList[index].Feedbacks__r[i].Mentor_Rating__c;

                        }
                        if($scope.sessionList[index].Feedbacks__r[i].Feedback_given_by__c == "MENTEE"){
                            $scope.disableInput = true;
                            $scope.showSubmitButton = false;
                            $scope.menteeFeedback = $scope.sessionList[index].Feedbacks__r[i];
                            $scope.menteeDescription = $scope.sessionList[index].Feedbacks__r[i].Description__c;
                            $scope.menteeRating = $scope.sessionList[index].Feedbacks__r[i].Mentee_Rating__c;
                        }
                        if($scope.menteeFeedback.length == 0){
                            $scope.disableInput = false;
                            $scope.showSubmitButton = true;
                        }
                    }
                    
                    
                }else{
                    $scope.showMentorFeedback = false ;
                    $scope.disableInput = false;
                    $scope.showSubmitButton = true;
                }
            }
             $scope.firstRate = 0;
            $scope.mentorRating;
            $scope.menteeRating;
            $scope.readOnly = true;
           
            $scope.onMentorRating = function(rating){
                $scope.menteeRating = rating;
                debugger;
                console.log('$scope.menteeDescription::'+$scope.menteeDescription);
                alert('On Rating: ' + rating);
            }; 
            $scope.submitFeedBack = function (){
                debugger;
                $scope.session;
                console.log('$scope.Description'+$scope.Description);
                Visualforce.remoting.Manager.invokeAction(
                    '{!$RemoteAction.MenteePortal_Controller.submitFeedBack}',
                    	$scope.session.Id,$scope.menteeDescription,$scope.menteeRating,
                    function(result,event){
                        if(event.status){
                        $scope.disableInput = true;
                        $scope.showSubmitButton = false;
                            $scope.$apply();
                        }
                        else if (event.type==='exception'){
                            alert(event.message);
                        }else{
                            alert(event.message);
                        }
                    },
                    {escape:true}
                );
                
            }
            
            $scope.applyForProgram = function(programId){
            	 debugger;
                  console.log('$scope.Description'+$scope.Description);
                Visualforce.remoting.Manager.invokeAction(
                    '{!$RemoteAction.MenteePortal_Controller.insertMentorMenteeAssociation}',
                    menteeId,programId,	
                    function(result,event){
                        if(event.status){
                         alert('Applied sucessfully');
                        }
                        else if (event.type==='exception'){
                            alert(event.message);
                        }else{
                            alert(event.message);
                        }
                    },
                    {escape:true}
                );  
            }
            
            $scope.redirectURL = function(pageName){
                let mainURL = window.location.origin+'/apex';
                window.location.replace(mainURL + "/"+pageName+"?Id="+menteeId);
            }
          
            
        });
        function downloadDoc() {
            debugger;
            let initial_url = window.location.href;
            let anchorTagA = document.createElement('a');
            anchorTagA.href = 'https://ffe--devpro--c.documentforce.com/servlet/servlet.FileDownload?file=00P1e000000sRZrEAM';
            anchorTagA.download = 'downloadDoc';
            document.body.appendChild(anchorTagA);  
            anchorTagA.click();
            document.body.removeChild(anchorTagA);
            
        }