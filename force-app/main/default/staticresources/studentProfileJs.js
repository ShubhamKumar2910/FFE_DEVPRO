var app=angular.module('Student', ['ngRoute','ngAnimate','ngMaterial']);

var sitePrefix = '/application';
if (sitePrefix=='') sitePrefix='/application';

app.config( function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(false).hashPrefix('');
    $routeProvider

    .when('/profile', {templateUrl: sitePrefix+'/profile',
                      })
    .when('/trainings', {templateUrl: sitePrefix+'/trainings',
                        })
    .when('/faciliatator', {templateUrl: sitePrefix+'/faciliatator',
                           })
    .when('/placementdata', {templateUrl: sitePrefix+'/placementdata',
                            })
    .otherwise({redirectTo: '/profile'});
});



app.controller('studentProfile',function($scope, $timeout, $window, $location,$element) {

    $scope.selected =0;
    $scope.student ={};
    $scope.basicInfos=[1];
    $scope.educations=[1];
    $scope.courses=[1];
    $scope.NoImage =false;
    $scope.showdiv=false;
    $scope.profilePopup=false;
    $scope.isFile=false;
    $scope.choosePopUp = false;
    $scope.chooseDiv = false;
    $scope.maxStringSize 				= 6000000;
    $scope.maxFileSize	 				= parseInt(maxAttchmentSize);
    $scope.chunkSize 	 				= 950000;
    $scope.selectedtabsInternal=0;
    $scope.indexValueInternal=0;
    $scope.profileImageSFId='';
    $scope.editFileds = true;
     $scope.editTYSFileds = true;
    $scope.gradSystemList =gradSystemList;
    $scope.accomTypes =accomTypesList;
    $scope.btechYearList				= btechYearList;
    $scope.MtechYearList				= MtechYearList;
    $scope.MbbsYearList					= MbbsYearList;
    $scope.studentCourse 				= studentCourse;
    $scope.typeOfBankAccounts 		    = typeOfBankAccounts;
    $scope.StudentBranches				= StudentBranches;
    $scope.StudentLawBranches           = StudentLawBranches;
    $scope.listOfStates					= listOfStates;
    $scope.todate						= new Date();
    $scope.fileNameToUpload = '';
    $scope.isIncomeCert  = false;
    $scope.isExpenseDoc = true;
    $scope.disableSubmitAndReplaceButtons = false;
    $scope.missingFilesUploaded = [];
	$scope.scholarshipGrantedAtLeastOnce = false;
    // Gourab---Start
    //var todaydate = new Date(2019, 01, 11, 00, 00, 00, 0);//Note: 0=January, 1=February etc.
    var prevYear;
    var prevMonth;
    var pravday;
    console.log('$scope.todate : '+$scope.todate);
    if($scope.todate.getMonth()>=06 && $scope.todate.getMonth()<=11){ //greate than july and less than = dec.
        prevYear = $scope.todate.getFullYear();
        prevMonth = 06;
        pravday = 01;
    }else{
        prevYear = $scope.todate.getFullYear();
        prevMonth = 00;
        pravday = 01;
    }

    $scope.fromdate						= new Date(prevYear, prevMonth, pravday, 00, 00, 00, 0);//January as 00 , hence july as 06
     console.log('$scope.fromdate : '+$scope.fromdate);
    // <---End--->.
    $scope.closedAppli=[];
    $scope.notValidPhone = false;
    $scope.show=[];
    $scope.AcademicScores = [];
    $scope.placementOptions = [];
    $scope.oddIFDisplay = true;
    $scope.evenIFDisplay = true;
    $scope.currentFinancialYear = currentFinancialYear;
    $scope.displayUplodedDoc = false;
    $scope.otherFieldDisplay = false;
    $scope.dontDisplayRenewal = false;
      $scope.ifscCodeNotValid = false;
    $scope.showVerifyIFSChelpTextFlag = false;
      $scope.ifscCodeValid = false;
    $scope.ifscServiceDisabled = false;
    $scope.ifscCodeMessage = '';
    $scope.minDate = new Date();
    console.log('minDate ' +$scope.minDate);
    $scope.minDate.setDate($scope.minDate.getDate() + 1);

    for(var i=0; i<placementOptions.length ; i++)
        $scope.placementOptions.push({uKey:i,value:placementOptions[i]});

    $scope.todate.setDate($scope.todate.getDate()-1);
    if(typeof isRenewalAvailable == 'string'){
        $scope.displayRenewal	= JSON.parse(isRenewalAvailable);
        $scope.dontDisplayRenewal = $scope.displayRenewal
    }else{
        $scope.displayRenewal		= isRenewalAvailable;
        $scope.dontDisplayRenewal = $scope.displayRenewal
    }
    $scope.eligibleStage				= eligibleStatus;
    $scope.collegeOther					= false;
    $scope.facilitator					= {};
    $scope.errorMessage					= errMsg;
    $scope.successMsg					= appSuccess;
    $scope.facilitaorInputDone			= true;
    $scope.disableSubmitBtn				= true;
    $scope.uploadForScholar				= studentUpload;
    $scope.resumeupload                 = studentResumeUpload;
    $scope.uploadForFacilitator			= facilitatorUpload;
    $scope.finalYearOddSem              = finalYearOddSem;
    $scope.finalYearEvenSem				= finalYearEvenSem;
    $scope.facilitatorAttachements      = [];
    $scope.prelimDocsName				= prelimFiles;
    $scope.renewalDocsName				= renewalFiles;
    $scope.remainingFilesList			= [];
    $scope.missingDocFilesList			= [];
    $scope.renewalPopupDocs				=false;
    $scope.studendId					= studendId;
    $scope.IsPrelimApplication			= false;
    $scope.IsRenewalApplication         = false;
    $scope.renewalNotification			= renewalNotification;
    $scope.trainings 					= false;
    var firstYear 						= '1st Year';
    var secondYear 						= '2nd Year';
    $scope.studentCurrentCourse   		= '';
    $scope.studentYear                  = '';
    $scope.closedYears                  = [];
    $scope.displayedYears               = [];
    $scope.primaryLogo                  = '';
    $scope.secondaryLogo                = '';
    $scope.secondaryLogoDisplay         = false;
    $scope.primaryLogoDisplay         	= false;
    $scope.logoDescription           	= donorLogDescription;
    $scope.DisplayLogoDesc         		= false;
    $scope.resumeattachemts	      		=[];
    $scope.displayPlacement = false;
    $scope.displayResume = false;
    $scope.displayOther = false;
    $scope.displayPlacementTab = false;
    $scope.displayTellYourStoryTab = true;
    $scope.finalYearMarksnoti = finalYearMarksnoti;
    $scope.displayfinalYearEven=false;
    $scope.displayfinalYearOddSem=false;
    $scope.FinalYearAttachments = [];
    $scope.UploadfinalDocList = true;
    $scope.displayIntMtchFinalYear = false;

    $scope.ondonorLogoMousehover = function(){
        $scope.DisplayLogoDesc = true;
    }

    $scope.closeDescJs = function(){
        $scope.DisplayLogoDesc = false;
    }
    $scope.checkCertificateDate = function(certDate){
        var certExpDate = Date.parse(new Date(certDate));
        var currYear = new Date().getFullYear();
		var checkDate = new Date(currYear + 1, 2, 31);
        checkDate = Date.parse(checkDate);

        var month = (new Date(certDate).getMonth() + 1);
        var day = (new Date(certDate).getDate());
        var year = (new Date(certDate).getFullYear());
        var dateToShow = month + "/" + day + "/" + year;

        if(certExpDate < checkDate){
            swal("Your Income certificate is expiring on "+dateToShow +". Please renew the same and upload the new document");
        }
    }


    $scope.colletMarksSheet = false;
    //External_Status__c = Scholarship Transferred
    $scope.getstudentDetails= function(){
        AP_Application_CTRL.getStudentUserDetail(studendId,function(result,event){
            if(event.status){
                $scope.closedAppli=[];
                $scope.student=JSON.parse(result);console.log($scope.student);
                $scope.selectedplacementInfo = $scope.student.Placement_Info__c;
                console.log($scope.dontDisplayRenewal);
                console.log($scope.student);

                /*
                if(($scope.student.Course__c=='MBBS' && $scope.student.Current_year__c =='Year III (Part 2), Sem 9')||($scope.student.Course__c=='BE/B.Tech' && $scope.student.Current_year__c =='4th Year')||($scope.student.Course__c=='Integrated MTech' && $scope.student.Current_year__c =='5th Year')){
                    $scope.displayRenewal = false;
                    $scope.displayPlacementTab = true;
                    $scope.colletMarksSheet = true;
                    if($scope.selectedplacementInfo == 'Placed'){
                        $scope.displayPlacement = true;
                        $scope.displayResume = false;
                        $scope.displayOther = false;
                    }else if($scope.selectedplacementInfo == 'Not Placed'){
                        $scope.displayPlacement = false;
                        $scope.displayResume = true;
                        $scope.displayOther = false;
                    }else if($scope.selectedplacementInfo == 'Others'){
                        $scope.displayPlacement = false;
                        $scope.displayResume = false;
                        $scope.displayOther = true;
                    }

                    if($scope.selectedplacementInfo == 'Higher Studies' || $scope.selectedplacementInfo == 'Seeking Entreprenuership' || $scope.selectedplacementInfo == 'Seeking Govt. Jobs'){
                       $scope.displayOther = true;
                    }


                }*/




                if($scope.student.MailingCity!=undefined && $scope.student.MailingCity!==''){
                    $scope.getCities($scope.student.MailingState);
                }
                if($scope.student.Birthdate !='' && $scope.student.Birthdate!=undefined){
                    $scope.student.Birthdate= new Date($scope.student.Birthdate);
                }
                if($scope.student.Profile_Pic_Attachment_Id__c != null){
                    $scope.profileImageSFId	= $scope.student.Profile_Pic_Attachment_Id__c;
                    $scope.Image=true;
                    $scope.NoImage = false;
                }else{
                    $scope.NoImage = true;
                }

                if($scope.student.Donor_Application_Mappings1__r != undefined){
                    if($scope.student.Donor_Application_Mappings1__r.records[0].Donor__r.Primary_Donor_logo_attachment_Id__c != null || $scope.student.Donor_Application_Mappings1__r.records[0].Donor__r.Primary_Donor_logo_attachment_Id__c != undefined){
                        $scope.primaryLogo = $scope.student.Donor_Application_Mappings1__r.records[0].Donor__r.Primary_Donor_logo_attachment_Id__c;
                        $scope.primaryLogoDisplay=true;
                    }else{
                        $scope.primaryLogoDisplay = false;
                    }

                    if($scope.student.Donor_Application_Mappings1__r.records[0].Donor__r.Secondary_Donor_logo_attachment_id__c != null || $scope.student.Donor_Application_Mappings1__r.records[0].Donor__r.Secondary_Donor_logo_attachment_id__c != undefined){
                        $scope.secondaryLogo =  $scope.student.Donor_Application_Mappings1__r.records[0].Donor__r.Secondary_Donor_logo_attachment_id__c;
                        $scope.secondaryLogoDisplay=true;
                    }else{
                        $scope.secondaryLogoDisplay = false;
                    }
                }

				//Removing eAadhar from prelimDocsName when KYC Verification is completed -- Sumit Gaurav -- 24-June-2020
				if($scope.student.KYC_Verified__c == true){
					for(var i=0;i<$scope.prelimDocsName.length;i++){
						if($scope.prelimDocsName[i].Attachment_Name__c=='Copy of Aadhaar'){
							$scope.prelimDocsName.splice(i, 1);
							break;
						}
					}
				}

                if($scope.student.Other__c != '' || $scope.student.Other__c != undefined){
                    $scope.otherFieldDisplay = true;
                }
                console.log($scope.primaryLogo);
                console.log($scope.secondaryLogo);
                if($scope.student.Applications__r != undefined){
                    var counter = 0;
                    for (var i=0; i<$scope.student.Applications__r.records.length;i++){

                        //changes made here
                        var docmissing = '';
                        if($scope.student.Applications__r.records[i].External_Status__c =='Document Missing'){
                            docmissing = 'Document Missing';
                        }
                        //changes ended

                        //$scope.student.Applications__r.records[i].External_Status__c !='Document Missing' &&
                        if($scope.student.Applications__r.records[i].External_Status__c !='Scholarship Transferred' && $scope.student.Applications__r.records[i].Application_Stage__c =='Active' ){
                            $scope.student.Applications__r.records[i].External_Status__c = 'In Progress';
                            $scope.student.ScholarshipAmount__c = 0;
                        }

                        //changes made here
                        if(docmissing =='Document Missing'){
                            $scope.student.Applications__r.records[i].External_Status__c = 'Document Missing';
                        }
                        //changes ended

						//Identify at least one application with Disbursed internal status -- Sumit Gaurav -- 24-June-2020
                        if($scope.student.Applications__r.records[i].Internal_Status__c =='Disbursed'){
							$scope.scholarshipGrantedAtLeastOnce = true;
						}

                        if($scope.student.Applications__r.records[i].Application_Stage__c =='Active'){
                            $scope.switchInternal(0,0);
                            $scope.activeAppli = $scope.student.Applications__r.records[i];

                            //string to date convertion
                            console.log('$scope.activeAppli.Facilitator_meet_date__c : '+$scope.activeAppli.Facilitator_meet_date__c);
                            $scope.activeAppli.Facilitator_meet_date__c = new Date($scope.activeAppli.Facilitator_meet_date__c);
                             console.log('$scope.activeAppli.Facilitator_meet_date__c : '+$scope.activeAppli.Facilitator_meet_date__c);
                                console.log('$scope.fromdate: '+$scope.fromdate);
                                     console.log('$scope.todate: '+$scope.todate);
                            if($scope.student.Certificate_Expiry_Date__c  != undefined && $scope.student.Certificate_Expiry_Date__c != null)
                                $scope.student.Certificate_Expiry_Date__c  = new Date($scope.student.Certificate_Expiry_Date__c );
                            else
                                $scope.student.Certificate_Expiry_Date__c  = null;
                            //

                            if($scope.student.Applications__r.records[i].RecordType.DeveloperName == 'Scholarship'){
                                $scope.IsPrelimApplication	= true;
                                $scope.IsRenewalApplication = false;
                                $scope.facilitaorInputDone	= $scope.student.Applications__r.records[i].FacilitatorInputDone__c;
                                $scope.listOfDocsToShow 	= $scope.prelimDocsName;
                            }else{
                                $scope.IsPrelimApplication	= false;
                                $scope.IsRenewalApplication = true;
                                $scope.listOfDocsToShow 	= $scope.renewalDocsName;
                            }    counter =counter +1;
                        }else{
                            $scope.switchInternal(1,1);
                            $scope.closedAppli.push($scope.student.Applications__r.records[i]);

                            if($scope.student.Applications__r.records[i].Application_Stage__c == 'Closed'){
                                $scope.closedYears.push($scope.student.Applications__r.records[i].Year__c);
                            }

                        }
                    }


                    if(counter == 0 && $scope.dontDisplayRenewal==true){
                        $scope.displayRenewal = true;
                    }else{
                        $scope.displayRenewal = false;
                    }


                    if($scope.student.Course__c=='MBBS'){
                        $scope.yearPickList($scope.MbbsYearList,$scope.closedYears);
                    }
                    else if($scope.student.Course__c=='BE/B.Tech'){
                        $scope.yearPickList($scope.btechYearList,$scope.closedYears);
                    }
                        else{
                            $scope.yearPickList($scope.MtechYearList,$scope.closedYears);
                            $scope.displayIntMtchFinalYear = true;
                        }

                    if($scope.student.Id !=undefined){
                        $scope.getAllAttachments($scope.student.Id,$scope.resumeupload);
                        $scope.getAllAttachments($scope.student.Id,$scope.finalYearOddSem);
                        $scope.getAllAttachments($scope.student.Id,$scope.finalYearEvenSem);

                    }



                    // Student Uploaded Attachments
                    if($scope.activeAppli != undefined && $scope.activeAppli.Id != undefined)
                        $scope.getAllAttachments($scope.activeAppli.Id,$scope.uploadForScholar);
                }

                if($scope.activeAppli != undefined && ( $scope.activeAppli.External_Status__c == 'Approved' || $scope.activeAppli.Internal_Status__c == 'Pending Approval' || $scope.activeAppli.Internal_Status__c == 'Awaiting for Fund')) {
                       $scope.disableSubmitAndReplaceButtons = true;
                }

                if($scope.activeAppli != undefined && $scope.activeAppli.Id != undefined && $scope.activeAppli.Missing_Documents__c != '' && $scope.activeAppli.Missing_Documents__c != undefined){
                    var docsMissing = $scope.activeAppli.Missing_Documents__c ;
                    var docsMissingList = docsMissing.split(';');
                    $scope.missingFilesUploaded = docsMissingList;
                    console.log('missing files : '+ JSON.stringify($scope.missingFilesUploaded));
                }





                if(($scope.student.Course__c=='MBBS' && $scope.student.Current_year__c =='Year III (Part 2), Sem 9')||($scope.student.Course__c=='BE/B.Tech' && $scope.student.Current_year__c =='4th Year')||($scope.student.Course__c=='Integrated MTech' && $scope.student.Current_year__c =='5th Year')){
                    if($scope.dontDisplayRenewal == true){
                        $scope.displayRenewal = false;}
                    $scope.displayPlacementTab = true;
                    $scope.colletMarksSheet = true;
                    if($scope.selectedplacementInfo == 'Placed'){
                        $scope.displayPlacement = true;
                        $scope.displayResume = false;
                        $scope.displayOther = false;
                    }else if($scope.selectedplacementInfo == 'Not Placed'){
                        $scope.displayPlacement = false;
                        $scope.displayResume = true;
                        $scope.displayOther = false;
                    }else if($scope.selectedplacementInfo == 'Others'){
                        $scope.displayPlacement = false;
                        $scope.displayResume = false;
                        $scope.displayOther = true;
                    }

                    if($scope.selectedplacementInfo == 'Higher Studies' || $scope.selectedplacementInfo == 'Seeking Entreprenuership' || $scope.selectedplacementInfo == 'Seeking Govt. Jobs'){
                        $scope.displayOther = true;
                    }


                }

                $scope.studentCurrentCourse   = $scope.student.Course__c;
                $scope.studentYear 			  = $scope.student.Current_year__c;
                $scope.AcademicDetails();
                if($scope.student.Course__c ==StudentCourseBEBTECH || $scope.student.Course__c ==StudentCourseMTech){
                    if($scope.student.Current_year__c==firstYear || $scope.student.Current_year__c==secondYear){
                        $scope.trainings 	= true;
                        $scope.getTrainings();
                    }else{
                        $scope.trainings = false;
                    }
                }


                $scope.loading = false;

                if($scope.student.Renewal_On__c){
                    $scope.displayRenewal = true;
                }
                else
                {
                     $scope.displayRenewal = false;
                }

                $timeout(function () {
                    if($scope.student.College_Name__c != undefined && $scope.student.College_Name__r.Name != undefined ){
                        console.log($scope.student.College_Name__c );
                        $scope.getCollege($scope.student.College_Name__r.Name);
                    }
                }, 3000);

                if($scope.renewalPopupDocs)
                    $scope.switch(2,2);
                $scope.$apply();
            }
            else{
                $scope.loading = false;
                $scope.$apply();
            }
        },{escape:false})
    }

    $scope.yearPickList = function(courseYears,closedYears){
        $scope.displayedYears = courseYears.filter(function(val) {
            return closedYears.indexOf(val) == -1;
        });
    }

    $scope.temp =false;
    $scope.getAllAttachments = function(id,filesFor){

        AP_Application_CTRL.getAllAttachments(id,filesFor,function(result,event){
            if(event.status){
                if(filesFor==$scope.uploadForScholar){
                    $scope.attachemts	=[];
                    $scope.attachemts = JSON.parse(result);
                }
                else if(filesFor==$scope.uploadForFacilitator)
                {
                    $scope.facilitatorAttachements = JSON.parse(result);
                    if($scope.facilitatorAttachements.length>0){
                        $scope.disableSubmitBtn= false;
                    }
                    else{
                        $scope.disableSubmitBtn= true;
                    }
                }
                if(filesFor==$scope.resumeupload){

                    $scope.resumeattachemts = JSON.parse(result);
                    if($scope.resumeattachemts.length>0)
                        $scope.displayUplodedDoc=true;
                }
                /*if($scope.temp ==true){
                $scope.FinalYearAttachments = [];
                }*/

                if(filesFor==$scope.finalYearOddSem){

                    $scope.finalYearOddSemSemattachemts = JSON.parse(result);
                    if($scope.finalYearOddSemSemattachemts.length>0){
                        $scope.displayfinalYearOddSem=true;
                        if($scope.FinalYearAttachments.length<1)
                            $scope.FinalYearAttachments.push($scope.finalYearOddSemSemattachemts[0]);
                        $scope.oddIFDisplay = false;
                    }
                }
                if(filesFor==$scope.finalYearEvenSem){

                    $scope.finalYearEvenSemattachemts = JSON.parse(result);
                    if($scope.finalYearEvenSemattachemts.length>0){
                        $scope.displayfinalYearEven=true;
                        if($scope.FinalYearAttachments.length<2)
                            $scope.FinalYearAttachments.push($scope.finalYearEvenSemattachemts[0]);
                        $scope.evenIFDisplay = false;

                    }
                }
                if(!$scope.oddIFDisplay && !$scope.evenIFDisplay){
                    $scope.UploadfinalDocList = false;
                }
                $scope.getListofFiles();
                $scope.$apply();
            }
        },{escape:false});
    }

    $scope.getListofFiles = function(){
        $scope.remainingFilesList			= [];
        if($scope.attachemts != undefined && $scope.attachemts.length >0){
            for(var i=0;i<$scope.listOfDocsToShow.length;i++){
                for(var j=0;j<$scope.attachemts.length;j++){
                    /* var a =$scope.attachemts[j].Name.split(".");
                    $scope.attachemts[j].Name=a[0]*/
                    var input = $scope.attachemts[j].Name;
                    $scope.attachemts[j].Name = input.substr(0, input.lastIndexOf('.')) || input;
                    if($scope.attachemts[j].Name==$scope.listOfDocsToShow[i].Attachment_Name__c){
                        $scope.isFileName=true;
                        $scope.rList='';
                        break;
                    }
                    else{
                        $scope.isFileName=false;
                        $scope.rList=$scope.listOfDocsToShow[i];
                    }
                }
                if(!$scope.isFileName){
                    if($scope.rList!='')
                        $scope.remainingFilesList.push($scope.rList);
                }
            }
        }
        else{
            $scope.remainingFilesList= $scope.listOfDocsToShow;
        }
    }

    $scope.getAttachedFiles = function(){
        if(!$scope.facilitaorInputDone){
            $scope.getAllAttachments($scope.activeAppli.Id,$scope.uploadForFacilitator);
        }
    }


    window.onload = function(){
        $scope.loading = true;
        $scope.getstudentDetails();

    }

    $scope.getTrainings = function(){
        $scope.currentYr	= $scope.student.Current_year__c;
        $scope.currentCourse= $scope.student.Course__c;
        $scope.amcatEnglishScore = $scope.student.AMCAT_1_English_Assesment__c;
        $scope.amcatRestScore = $scope.student.AMCAT_1_Rest_of_the_Assesment__c;

        $scope.aptitudeAnlyticalScore = $scope.student.Aptitude_Analytical_Score__c;
        $scope.AptitudeLogicalScore = $scope.student.Aptitude_Logical_Score__c;
        $scope.EnglishSpokenScore = $scope.student.English_Spoken_Score__c;
        $scope.EnglishWrittenScore = $scope.student.English_Written_Score__c;

        $scope.studentID = $scope.student.id;
        if($scope.currentYr != undefined && $scope.currentYr !='' && $scope.currentCourse !=undefined && $scope.currentCourse !=''){
            $scope.loading = true;
            AP_Application_CTRL.getAllTrainings($scope.currentCourse, $scope.currentYr,$scope.aptitudeAnlyticalScore,$scope.AptitudeLogicalScore,$scope.EnglishSpokenScore,$scope.EnglishWrittenScore,$scope.studendId, function(result, event){

                if(event.status){
                    $scope.trainigList = JSON.parse(result);

                    $scope.loading = false;
                    $scope.$apply();
                }
                else{
                    $scope.loading = false;
                    $scope.$apply();
                }
            },{escape:false})
        }
    }

    $scope.trainingScore = function(index){
        for(var i=0;i<$scope.trainigList.length;i++){
            if(i==index){
                $scope.show[index] = !$scope.show[index];
            }
            else{
                $scope.show[i]=false;
            }
        }
    }

    $scope.cancelChanges = function(){
        $scope.getstudentDetails();
        $scope.editFileds = true;
        $scope.formInvalid = false;
        $scope.formCourseInvalid=false;
    }
        $scope.cancelTYSChanges = function(){
        $scope.getstudentDetails();
        $scope.editTYSFileds = true;
        $scope.formInvalid = false;
        $scope.formCourseInvalid=false;
    }
    $scope.showProfile= function(){
        $scope.showdiv=true;
        $scope.profilePopup=true;

    }

    $scope.showUpload = function(){
        $scope.choosePopUp = true;
        $scope.chooseDiv = true;
        // document.getElementById('profilePicDi').src=$scope.fileSrc;
    }


    $scope.validateImageType = function (){
        var _validFileExtensions = [".png", ".jpeg", ".jpg"];
        var arrInputs = document.getElementById("profilePic");
        var oInput = arrInputs;
        if (oInput.type == "file") {
            var sFileName = oInput.value;
            if (sFileName.length > 0) {
                var blnValid = false;
                for (var j = 0; j < _validFileExtensions.length; j++) {
                    var sCurExtension = _validFileExtensions[j];
                    var fileType=sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase();
                    if (fileType == sCurExtension.toLowerCase()) {
                        blnValid = true;
                        break;
                    }
                }
                if (!blnValid) {
                    $scope.tabsValidSs=true;
                    $scope.tabsValidBlueSs=false;
                    $scope.loading=false;
                    var filename = sFileName.slice(12);
                    swal({title:'',
                          text:"Sorry, " + filename + " is invalid, allowed extensions are: " + _validFileExtensions.join(", ")});
                    document.getElementById("profilePic").value = "";
                    return false;
                }
            }
        }
        //$scope.NoImage=false;
        return true;
    };

    $scope.profile	= function(_activity){
        console.log('Test');
        $scope.loading=true;
        $scope.filebody			= '';
        $scope.fileSize			= 0;
        $scope.fileName			= '';
        $scope.positionIndex	= 0;;
        $scope.doneUploading	= false;

        var reader 		= new FileReader();
        var attachFile	= document.getElementById('profilePic').files[0];
        if(attachFile != undefined && attachFile != null){

            var _isDocCorrect	= $scope.validateImageType();
            if(_isDocCorrect){
                if(attachFile.size < 102400){

                    reader.onload = function(e) {
                        $scope.fileName = attachFile.name;
                        $scope.filebody = window.btoa(e.target.result).toString();
                        $scope.fileSize	= $scope.filebody.length;
                        $scope.positionIndex=0;
                        $scope.doneUploading = false;

                        if($scope.fileSize < $scope.maxStringSize){
                            $scope.NoImage=false;
                            $scope.isFile = true;
                            $scope.fileSrc=e.target.result;
                            document.getElementById('profilePicDi').src=e.target.result;
                            $scope.Image=true;
                            if(_activity != undefined && _activity =='save'){
                                $scope.uploadImage(null);
                            }
                            else{
                                $scope.loading = false;
                            }

                        }
                        else {
                            $scope.loading = false;
                            swal({title:'',
                                  text:'Base 64 Encoded file is too large.  Maximum size is '+ $scope.maxStringSize + ' your file is '+ $scope.savefileSize + '.'});
                        }
                    };

                    if(_activity != undefined && _activity =='save'){
                        reader.readAsBinaryString(attachFile);
                    }else{
                        reader.readAsDataURL(attachFile);
                    }

                }
                else{
                    $scope.loading = false;
                    swal({title:'',
                          text:'File should be under 100 Kb. Please upload a smaller file.'});
                }
            }
            else{
                $scope.loading = false;
            }
        }
        else{
            $scope.loading = false;
            swal({title:'',text:'Please select file'});
        }
    };

    $scope.SaveProfile = function(){
        if($scope.fileSrc != undefined){
            document.getElementById('profilePicDiv').src=$scope.fileSrc;
            document.getElementById('profilePicDivPop').src=$scope.fileSrc;
            $scope.choosePopUp = false;
            $scope.chooseDiv = false;
            $scope.showdiv=false;
            $scope.profilePopup=false;
            $scope.Image=true;
            //$scope.NoImage =false;
            $scope.profile('save');
        }
        else{
            swal({title:'', text:'Please choose profile image to save'});
        }
    }

    $scope.uploadImage = function(fileId){
        $scope.loading=true;
        var attachmentBody = "";
        if($scope.fileSize <= $scope.positionIndex + $scope.chunkSize) {
            attachmentBody = $scope.filebody.substring($scope.positionIndex);
            $scope.doneUploading = true;
        }else {
            attachmentBody = $scope.filebody.substring($scope.positionIndex, $scope.positionIndex + $scope.chunkSize);
        }
        AP_Application_CTRL.uploadProfilePic(attachmentBody,$scope.fileName,$scope.student.Id,fileId, function(result, event){
            if(event.type === 'exception') {
                $scope.loading=false;
                swal({title:'',
                      text:'There is some problem while uploading your image.Please try again.'});
                $scope.$apply();
            }
            else if(event.status) {
                debugger;
                if(result.substring(0,3) == '00P') {
                    if($scope.doneUploading == true) {

                        //Remote action here to update application doc missing field value
                        if($scope.activeAppli) {
                            AP_Application_CTRL.updateDocMissing($scope.activeAppli.Id, 'Profile Picture', function(result, event) {
                                if(event.status){
                                     $scope.missingFilesUploaded.remove("Profile Picture");
                                    swal({title:'',text:'Profile picture uploaded successfully, Continue uploading of Bank Passbook copy and the remaining documents. Click on Submit after all documents are uploaded.'});
                                }
                                else{
                                 	console.log('Something went wrong');
                                }
                            });
                        }
                        //
                        $scope.profileImageSFId	= result;
                        attachmentBody='';
                        $scope.fileName='';
                        $scope.loading=false;
                         swal({title:'',text:'Profile picture uploaded successfully, Continue uploading of Bank Passbook copy and the remaining documents. Click on Submit after all documents are uploaded.'});
                        $scope.$apply();
                    }else {
                        $scope.positionIndex += $scope.chunkSize;
                        $scope.uploadImage(result);
                        $scope.$apply();
                    }
                }
            } else {
                swal({title:'',
                      text:event.message});
                $scope.loading=false;
                $scope.$apply();
            }
        }, {buffer: true, escape: true, timeout: 120000});
    };

    $scope.cancel = function(){
        if(!$scope.Image)
            $scope.NoImage = true;

        $scope.choosePopUp = false;
        $scope.chooseDiv = false;
    }

    $scope.closeSignOutPopUp = function(){
        $scope.showdiv=false;
        $scope.profilePopup=false;
    }

    $scope.showTabcontent=function(value){
        $scope.selected	=value;
        $scope.disableSubmitBtn=true;
    }

    $scope.switch = function(switchvalue, tabvalue){
        $scope.selectedtabs=tabvalue;
        console.log('here tabvalue '+tabvalue);
        $scope.indexValue=switchvalue;
        console.log($scope.activeAppli)
        if($scope.activeAppli ==undefined){
            $scope.switchInternal(1,1);
        }
        else{
            console.log('here');
            $scope.switchInternal(0,0);
        }
    }

    $scope.switchInternal =function(switchvalue, tabvalue){
        $scope.selectedtabsInternal=tabvalue;
        $scope.indexValueInternal=switchvalue;
    }

    $scope.add = function(){
        $scope.basicInfos.push($scope.basicInfos.length+1);
    }

    $scope.addEdu = function(){
        $scope.educations.push($scope.educations.length+1);
    }

    $scope.addCourse = function(){
        $scope.courses.push($scope.courses.length+1);
    }

    $scope.delete = function(index){
        $scope.basicInfos.splice(index,1);
    }

    $scope.deleteEdu = function(index){
        $scope.educations.splice(index,1);
    }

    $scope.deleteCourse = function(index){
        $scope.courses.splice(index,1);
    }

    $scope.moveToTop = function(){
        var myDiv = document.getElementById('myContainerDiv');
        myDiv.scrollTop = 0;
    }
    $scope.saveTYS = function(){
        $scope.loading=true;
        var studentTYSwrapper = {};
		studentTYSwrapper.TYS_Video_Link__c = $scope.student.TYS_Video_Link__c;
        studentTYSwrapper.TYS_SchoolLife__c = $scope.student.TYS_SchoolLife__c;
        studentTYSwrapper.TYS_GuidanceProvider__c = $scope.student.TYS_GuidanceProvider__c;
        studentTYSwrapper.TYS_CollegeAssessment__c = $scope.student.TYS_CollegeAssessment__c;
        studentTYSwrapper.TYS_FFE_Scholarship_and_Impact__c = $scope.student.TYS_FFE_Scholarship_and_Impact__c;
        studentTYSwrapper.TYS_Future_Plans__c = $scope.student.TYS_Future_Plans__c;
        studentTYSwrapper.TYS_Dreams_and_Responsibilities__c = $scope.student.TYS_Dreams_and_Responsibilities__c;
        studentTYSwrapper.TYS_How_would_you_help_other_Students__c = $scope.student.TYS_How_would_you_help_other_Students__c;
        studentTYSwrapper.Id = $scope.student.Id;
        console.log('$scope.student : '+JSON.stringify(studentTYSwrapper));
        AP_Application_CTRL.updateStudentInSFDC_TYS(studentTYSwrapper, function(result,event){
            if(event.status){
                $scope.loading=false;
                $scope.formInvalid = false;
                $scope.formCourseInvalid=false;
                $scope.editTYSFileds = true;
                swal({title:'',
                      text:result
                     },
                     function(isConfirm){
                         $scope.getstudentDetails();
                     });
                $scope.$apply();

            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }

        },{escape:false})

        $scope.loading=false;
    }
    $scope.save = function(){
        //console.log('save called');
        $scope.loading=true;
        $scope.notValidPhone =false;

		    if(this.basicInfo.$invalid){
            $scope.loading=false;
            $scope.formInvalid = true;
            $scope.formCourseInvalid=true;
            swal({title:'',text:"Please fill all the mandatory (* marked) fields."});
        }
		else if($scope.ifscCodeValid == false){
			$scope.loading=false;
            $scope.formInvalid = true;
            $scope.formCourseInvalid=true;
            swal({title:'',text:"Verification of IFSC code is mandatory."});
		}
		/* Commented validation for Bank Account Type -- Sumit Gaurav - 30-June-2020
        else if($scope.student.Type_Of_Bank_Account__c === 'Minor'){
            $scope.loading=false;
            $scope.formInvalid = true;
            $scope.formCourseInvalid=true;
            swal({title:'',text:"You can not receive the scholarship if the Bank Account Type is minor."});
        } */
        else{
            if($scope.NoImage){
                $scope.loading=false;
                swal({title:'',text:"Uploading profile photo is mandatory."});   return;
            }

            $scope.notValidPhone =false;
            $scope.student.Birthdate = (Date.parse($scope.student.Birthdate) + (6*60*60*1000));
            if($scope.student!=undefined)
                delete $scope.student["attributes"];
            if($scope.student.Facilitator_Name__r!=undefined)
                delete $scope.student.Facilitator_Name__r["attributes"];
            if($scope.student.RecordType!=undefined)
                delete $scope.student.RecordType["attributes"];
            if($scope.student.College_Name__r!=undefined)
                delete $scope.student.College_Name__r["attributes"];
            if($scope.student!=undefined)
                delete $scope.student['Applications__r'];
            if($scope.student.Course__c=='MBBS'){
                $scope.student.Branch_Stream__c ='';
                $scope.student.Branch_Other__c ='';
            }
			//Blank the value stored in other type Bank account -- Sumit Gaurav -- 1-June-2020
			if($scope.student.Type_Of_Bank_Account__c != 'Other'){
				$scope.student.Other_Type_Bank_Account__c='';
			}
             delete $scope.student['Donor_Application_Mappings1__r'];
             delete $scope.student['Certificate_Expiry_Date__c'];
            console.log('$scope.student : '+JSON.stringify($scope.student));
            AP_Application_CTRL.updateStudentInSFDC($scope.student, function(result,event){
                if(event.status){
                    $scope.loading=false;
                    $scope.formInvalid = false;
                    $scope.formCourseInvalid=false;
                    $scope.editFileds = true;
                    $scope.student.Birthdate = new Date($scope.student.Birthdate);
                    swal({title:'',
                          text:result
                         },
                         function(isConfirm){
                             $scope.getstudentDetails();
                         });
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false})
        }
    }

    $scope.savefacilitator = function(){
        if(this.regForm.$invalid){
            $scope.formInvalidFaci = true;
            swal({title:'',text:"Please fill all the mandatory (* marked) fields."});
        }
        else{
            $scope.formInvalidFaci	= false;
            $scope.loading			= true;
            var appln				= $scope.facilitator;
            appln.Id				= $scope.activeAppli.Id;
            appln.Student__C		= $scope.student.Id;
            AP_Application_CTRL.facilitatorInbutByStudent(appln, function(result,event){
                if(event.status){
                    if(result != $scope.errorMessage){
                        $scope.facilitaorInputDone = true;
                    }
                    swal({title:'',text:result});
                    $scope.loading	= false;
                    $location.path('/profile');
                    $scope.$apply();
                }else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false})
        }
    }

    $scope.tabs =function(){
        $scope.index=0;
        $scope.selected=0;
        $scope.loading=true;
        var i;
        var x = document.getElementsByClassName("city");
        for (i = 0; i < x.length; i++) {
            if(i==1){
                x[i].style.display = "block";
            }
            else{
                x[i].style.display = "none";
            }
        }
        $scope.loading=false;
    }

    $scope.colletFinalYearDetail = false;

    $scope.finalYearMarks = function(){

        $scope.colletFinalYearDetail = true;
    }

    //$scope.docparentId = '';
    $scope.documentUpload	= function(__parentId, __fileId, __DocforWhom, __fileName, __deleteDocId){
        debugger;
        $scope.loading=true;
        $scope.docparentId		= __parentId;
        $scope.filebody			= '';
        $scope.fileSize			= 0;
        $scope.fileName			= __fileName;
        $scope.positionIndex	= 0;
        $scope.doneUploading	= false;
        $scope.filedesc			= __DocforWhom;
        $scope.fileId			= __fileId;
        $scope.deleteDocId		= __deleteDocId;

        console.log('File Name Selected : '+__fileName);
        $scope.fileNameToUpload = __fileName;
        if(__fileName != undefined && __fileName === 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable' ){
            var certificateExpiryDate = $scope.student.Certificate_Expiry_Date__c;
            $scope.isIncomeCert = true;
            if( typeof $scope.student.Father_Occupation__c !== undefined && $scope.student.Father_Occupation__c != 'Service' && (!(typeof certificateExpiryDate !== 'undefined' && certificateExpiryDate != null))  && $scope.IsRenewalApplication == false){
                swal({title:'',
                      text:"Please populate the Certificate Expiry Date."});
                $scope.loading=false;
                return;
            }

        }
        else if(__fileName != undefined && __fileName ==='Copy of First Sheet of Bank Pass Book or Cancelled Cheque'){
            if($scope.student.Full_Bank_Account_No_With_all_digits__c === undefined || $scope.student.Full_Bank_Account_No_With_all_digits__c === '' || $scope.student.Full_Bank_Account_No_With_all_digits__c === null ||
               $scope.student.X11_character_IFSC_Code_of_the_Branch__c === undefined || $scope.student.X11_character_IFSC_Code_of_the_Branch__c === '' || $scope.student.X11_character_IFSC_Code_of_the_Branch__c === null ||
               $scope.student.Bank_Account_Holder_s_Name__c === undefined || $scope.student.Bank_Account_Holder_s_Name__c === '' || $scope.student.Bank_Account_Holder_s_Name__c === null ||
               $scope.student.Bank_Name__c === undefined || $scope.student.Bank_Name__c === '' || $scope.student.Bank_Name__c === null ||
               $scope.student.Branch_Address__c === undefined || $scope.student.Branch_Address__c === '' || $scope.student.Branch_Address__c === null ||
               $scope.student.Type_Of_Bank_Account__c === undefined || $scope.student.Type_Of_Bank_Account__c === '' || $scope.student.Type_Of_Bank_Account__c === null){
                swal({title:'',text:'Please go to Profile Details and provide Bank Information in order to upload Bank Passbook or Cancelled Cheque.'});
                $scope.loading=false; 
                return;
            }
        }
        else
        {
             $scope.isIncomeCert = false;
        }

        if(__fileName != undefined && (__fileName === 'Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform)' || __fileName === 'Expense Receipts for Actual Expenses incurred for current academic year(College Fee/Hostel & Mess/Transport/Books/Uniform)' ) ){


            if($scope.activeAppli.Student_College_Fees__c === undefined || $scope.activeAppli.Student_College_Fees__c === '' || $scope.activeAppli.Student_College_Fees__c === null){
            	swal({title:'',text:' Please fill Actual Expense/Fee Details as per the values in your Fee Receipts Or Fill value as 0.'});
                $scope.loading=false;
                return;
            }
            if($scope.activeAppli.Student_Transportation_Expenses__c === undefined || $scope.activeAppli.Student_Transportation_Expenses__c === '' || $scope.activeAppli.Student_Transportation_Expenses__c === null){
            	swal({title:'',text:'Please fill Actual Student Transportation Fee or Enter value as 0.'});
                $scope.loading=false;
                return;
            }
            if($scope.activeAppli.Student_Hostel_Mess_Expenses__c === undefined || $scope.activeAppli.Student_Hostel_Mess_Expenses__c === '' || $scope.activeAppli.Student_Hostel_Mess_Expenses__c === null){
            	swal({title:'',text:'Please fill Actual Student Hostel/Mess Fee or Enter value as 0.'});
                $scope.loading=false;
                return;
            }
            if($scope.activeAppli.Student_Books_Expenses__c === undefined || $scope.activeAppli.Student_Books_Expenses__c === '' || $scope.activeAppli.Student_Books_Expenses__c === null){
            	swal({title:'',text:'Please fill Actual Student Books Expenses or Enter value as 0.'});
                $scope.loading=false;
                return;
            }
            if($scope.activeAppli.Student_Uniform_Expenses__c === undefined || $scope.activeAppli.Student_Uniform_Expenses__c === '' || $scope.activeAppli.Student_Uniform_Expenses__c === null){
            	swal({title:'',text:'Please fill Actual Student Uniform expenses or Enter value as 0.'});
                $scope.loading=false;
                return;
            }
            //if($scope.IsRenewalApplication == false)
           	 //$scope.isExpenseDoc = false;
        }

        var reader 		= new FileReader();
        var attachFile	= document.getElementById(__fileId).files[0];
        if(attachFile != undefined && attachFile != null){

            var _isDocCorrect	= $scope.validateDocType();
            if(_isDocCorrect){
                if(attachFile.size < $scope.maxFileSize){

                    reader.onload = function(e) {
                        if(__DocforWhom == $scope.uploadForFacilitator){
                            //$scope.fileName = attachFile.name;
                            //This change is to rename the file uploaded for facilitator
                            $scope.fileName = 'Facilitator Remarks_'+$scope.student.Name + '_'+$scope.student.FFE_ID__c+$scope.fileExten;
                        }
                        else{
                            $scope.missingFilesUploaded.remove($scope.fileName);
                            console.log('missingFiles : '+JSON.stringify($scope.missingFilesUploaded));
                            $scope.fileName = $scope.fileName +$scope.fileExten;
                        }
                        $scope.filebody = window.btoa(e.target.result).toString();
                        $scope.fileSize	= $scope.filebody.length;
                        $scope.positionIndex=0;
                        $scope.doneUploading = false;

                        if($scope.fileSize < $scope.maxStringSize){
                            $scope.loading=true;
                            $scope.uploadDoc(null);

                        }else {
                            $scope.loading=false;
                            swal({title:'',
                                  text:'Base 64 Encoded file is too large.  Maximum size is '+ $scope.maxStringSize + ' your file is '+ $scope.savefileSize + '.'});
                        }
                    };
                    reader.readAsBinaryString(attachFile);
                }else{
                    $scope.loading=false;
                    swal({title:'',
                          text:'File should be under 500 kb. Please upload a smaller file.'});
                }
            }
        }else{
            $scope.loading=false;
            swal({title:'',text:'Please select file'});
        }
    };

    $scope.uploadDoc = function(fileId){
        $scope.facilitatorAttachements=[];
        $scope.loading=true;
        var attachmentBody = "";
        if($scope.fileSize <= $scope.positionIndex + $scope.chunkSize) {
            attachmentBody = $scope.filebody.substring($scope.positionIndex);
            $scope.doneUploading = true;
        }else {
            attachmentBody = $scope.filebody.substring($scope.positionIndex, $scope.positionIndex + $scope.chunkSize);
        }
        var certificateExpiryDate = '';
        if($scope.isIncomeCert && typeof $scope.student.Father_Occupation__c !== undefined && $scope.student.Father_Occupation__c != 'Service'){
            certificateExpiryDate = $scope.student.Certificate_Expiry_Date__c;
            var date = new Date(certificateExpiryDate),
                mnth = ("0" + (date.getMonth()+1)).slice(-2),
                day  = ("0" + date.getDate()).slice(-2);
            certificateExpiryDate =  [date.getFullYear(), mnth, day ].join("-");
        }
        var expenseDet = '';
        if($scope.isExpenseDoc){
            console.log($scope.activeAppli.Student_Hostel_Mess_Expenses__c);
            console.log($scope.activeAppli.Student_Transportation_Expenses__c);
            console.log($scope.activeAppli.Student_College_Fees__c);
            console.log($scope.activeAppli.Student_Books_Expenses__c);
            console.log($scope.activeAppli.Student_Uniform_Expenses__c);
            expenseDet = expenseDet + $scope.activeAppli.Student_Hostel_Mess_Expenses__c + ';' + $scope.activeAppli.Student_Transportation_Expenses__c + ';' + $scope.activeAppli.Student_College_Fees__c + ';' + $scope.activeAppli.Student_Books_Expenses__c + ';' + $scope.activeAppli.Student_Uniform_Expenses__c;

        }
        //AP_Application_CTRL.uploadDoc(attachmentBody,$scope.fileName,$scope.docparentId,fileId,$scope.filedesc,$scope.deleteDocId, function(result, event){
        AP_Application_CTRL.uploadDoc_new(expenseDet,$scope.student.Id,certificateExpiryDate,attachmentBody,$scope.fileName,$scope.docparentId,fileId,$scope.filedesc,$scope.deleteDocId, function(result, event){
            if(event.type === 'exception') {
                $scope.loading=false;
                swal({title:'',
                      text:'There is some problem while uploading your document. Please try again.'});
            } else if(event.status) {
                if(result.substring(0,3) == '00P') {
                    if($scope.doneUploading == true) {
                        console.log('---> $scope.fileName'+$scope.fileName);
                        //Remote action here to update application doc missing field value
                        AP_Application_CTRL.updateDocMissing($scope.docparentId, $scope.fileName, function(result, event) {
                            if(event.status)
                                console.log('update successfull');
                            else
                                console.log('Something went wrong');
                        });
                        //
                        $scope.disableSubmitBtn	= false;
                        $scope.deleteDocId		= '';
                        var _attachmnt			= {};
                        _attachmnt.Name			= $scope.fileName;
                        _attachmnt.Id			= result;
                        _attachmnt.Description	= $scope.filedesc;
                        _attachmnt.CreatedDate	= new Date();
                        if($scope.filedesc == $scope.uploadForScholar){
                            var input = _attachmnt.Name
                            _attachmnt.Name = input.substr(0, input.lastIndexOf('.')) || input;
                            for(var i=0;i<$scope.attachemts.length;i++){
                                if($scope.attachemts[i].Name==_attachmnt.Name){
                                    $scope.attachemts.splice(i,1);
                                }
                            }
                            $scope.attachemts.push(_attachmnt);
                            $scope.getListofFiles();

                        }
                        else if($scope.filedesc ==$scope.uploadForFacilitator)
                            $scope.facilitatorAttachements.push(_attachmnt);
                        attachmentBody		= '';
                        $scope.fileName		= '';
                        $scope.docparentId 	= '';
                        $scope.filedesc		= '';
                        document.getElementById($scope.fileId).value = "";
                        $scope.fileId		= '';$scope.displayUplodedDoc = true;

                        /*if($scope.filedesc == 'Odd Semester Mark Sheet of Final year'){
                            $scope.oddIFDisplay = false;
                        }else if($scope.filedesc == 'Even Semester Mark Sheet of Final year'){
                            $scope.evenIFDisplay = false;
                        }*/

                        $scope.replcaefinalYearDoct = false;
                        // This message is to ask users to recheck the recently added file
                        swal({title:'',text:'Document uploaded successfully. Please recheck the file recently added.'});
                        $scope.closeReplaceDoc();
                        $scope.loading=false;
                        $scope.$apply();
                    }else {
                        $scope.positionIndex += $scope.chunkSize;
                        $scope.uploadDoc(result);
                        $scope.$apply();
                    }
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }

            } else {
                swal({title:'',
                      text:event.message});
                $scope.loading=false;
                $scope.$apply();
            }
        }, {buffer: true, escape: true, timeout: 120000});
    };

    $scope.validateDocType = function (){
        debugger;
        var fileType;
        // changed by subham on 11th Mayt 2019, only pdf upload is allowed
        // var _validFileExtensions = [".png", ".jpeg", ".jpg",".pdf",".docx",".doc"];
        var _validFileExtensions = [".pdf"];
        var message = 'Please upload Thank you Letter in Word Format';
        if($scope.fileNameToUpload == 'Letter of Thanks to Donors'){
            _validFileExtensions = [".docx",".doc"];
        }
        var arrInputs = document.getElementsByTagName("input");
        for (var i = 0; i < arrInputs.length; i++) {
            var oInput = arrInputs[i];
            if (oInput.type == "file" && oInput.id !== "profilePic") {
                var sFileName = oInput.value;
                if (sFileName.length > 0) {
                    var blnValid = false;
                    for (var j = 0; j < _validFileExtensions.length; j++) {
                        var sCurExtension = _validFileExtensions[j];
                        fileType=sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase();
                        if (fileType == sCurExtension.toLowerCase()) {
                            blnValid = true;
                            break;
                        }
                    }
                    if (!blnValid) {
                        $scope.tabsValidSs=true;
                        $scope.tabsValidBlueSs=false;
                        $scope.loading=false;
                        if($scope.fileNameToUpload == 'Letter of Thanks to Donors'){
                            swal({title:'',
                                  text:message});
                             }
                        else{
                            swal({title:'',
                                text: "Sorry, " + sFileName.slice(sFileName.lastIndexOf('\\') + 1) + " is invalid, allowed extensions is/are: " + _validFileExtensions.join(", ")});
                          }
                        return false;
                    }
                    else{
                        $scope.fileExten = fileType;
                    }
                }
            }
        }
        return true;
    };

    $scope.yearOnChange = function(year){
        $scope.studentYear = year;
        $scope.AcademicDetails();
    };

    $scope.AcademicDetails = function(){
        AP_Application_CTRL.getAccademicDetails($scope.studentCurrentCourse,$scope.studentYear, function(result, event){
            if(event.status){
                console.log(JSON.parse(result));
                $scope.AcademicScores = JSON.parse(result);
                $scope.$apply();
            }
            else{}},{escape:false});
    }

    $scope.renew = function(){
        if($scope.displayRenewal && ($scope.student.Active_Application_ID__c==undefined
                                     || $scope.student.Active_Application_ID__c==null)){
            if($scope.student.Aadhar_number__c!=null || $scope.student.Aadhar_number__c!=undefined){
                $scope.renewalPopup =true;
            }
            else{
                swal({title:'',
                      text:"Aadhar No. is missing. Please update in your profile and come back again."});
            }
        }
    }

    $scope.closeFinalMarkcolletorSheet = function(){
        $scope.colletFinalYearDetail = false;
    }
    $scope.closeRenew = function(){

        $scope.renewalPopup =false;
        $scope.studentRenew	= {};
        $scope.student.Semester1__c ='';$scope.student.Semester2__c ='';$scope.student.Semester3__c ='';$scope.student.Semester4__c ='';$scope.student.Semester5__c ='';$scope.student.Semester6__c ='';$scope.student.Semester7__c ='';$scope.student.Semester8__c ='';
        $scope.student.MBBS_Year_1__c='';$scope.student.MBBS_Year_2__c='';$scope.student.MBBS_Year_3_Part_1__c='';$scope.student.MBBS_Year_3_Part_2__c='';
    }

    $scope.showVerifyIFSChelpText = function(){
        //console.log('YASSSS');
        $scope.showVerifyIFSChelpTextFlag = true;
    }
      $scope.hideVerifyIFSChelpText = function(){
        //console.log('YASSSS');
        $scope.showVerifyIFSChelpTextFlag = false;
    }
    $scope.closeRenewDocs = function(){
        $scope.renewalPopupDocs =false;
    }
    $scope.edit = function (){
        $scope.editFileds =false;
        			$scope.ifscCodeNotValid=false;
					//changed ifscCodeValid it to true if IFSC code is alredy verified -- Sumit Gaurav 1-July-2020
					console.log('IFSC Verified==='+$scope.student.Is_IFSC_Code_Verified__c);
					if($scope.student.Is_IFSC_Code_Verified__c){
						$scope.ifscCodeValid=true;//changed it to true if IFSC code is alredy present -- Sumit Gaurav 1-July-2020
					}
                    $scope.ifscServiceDisabled = false;
                    $scope.ifscCodeMessage = '';
    }
	//Added to control IFSC verification on edit profile page when there is change in IFSC code -- Sumit Gaurav -- 1-July-2020
	$scope.ifscChanged = function (){
		$scope.ifscCodeValid=false;
	}
        $scope.editTYS = function (){
        $scope.editTYSFileds =false;
    }
    $scope.verifyIfsc = function (ifscCode){
        $scope.loading=true;
        console.log('$scope.student.Id :'+ $scope.student.Id);
        var code = ifscCode.$viewValue;
        var studentId = $scope.student.Id;
        if(code == undefined || code == ''){
            alert('Please populate the IFSC code.');
            return;
        }
        AP_Application_CTRL.ifscCodeResponse(code,studentId, function(result, event){
            if(event.status) {
                $scope.loading=false;
                //console.log('result :  '+result)
                if(result != undefined && result != '' && result != 'Service is disabled.'){
                    $scope.ifscCodeNotValid=false;
                    $scope.ifscCodeValid=true;
                    $scope.ifscServiceDisabled = false;
                    $scope.ifscCodeMessage = result;

                    console.log('ifscCodeMessage :  '+ $scope.ifscCodeMessage);
                }
                else if(result != undefined && result == 'Service is disabled.' ){
                    $scope.ifscCodeNotValid=false;
                    $scope.ifscCodeValid=false;
                    $scope.ifscServiceDisabled = true;
                }
                else
                {
                    $scope.ifscCodeNotValid=true;
                    $scope.ifscCodeValid=false;
                    $scope.ifscServiceDisabled = false;
                }
                $scope.$apply();
            }});
    }
    debugger;
    $scope.submitRenew = function(){
        if(this.basicInfoRenew.$invalid){
            $scope.loading=false;
            $scope.formInvalid = true;
            $scope.formInvalidRenew=true;
            $scope.showSpaceRenew = true;
            swal({title:'',text:"Please fill all the mandatory (* marked) fields."});
        }
        else{
            if(!$scope.displayRenewal){
                return;
            }
            $scope.loading										= true;
            $scope.showSpaceRenew 								= false;
            $scope.studentRenew.Student__c						= $scope.student.Id;
            $scope.studentRenew.Email__c						= $scope.student.Email;
            $scope.studentRenew.Course_Name__c					= $scope.student.Course__c;
            if($scope.student.Branch_Stream__c	== 'Other'){
                $scope.studentRenew.Branch__c	= $scope.student.Branch_Other__c;
            }else{
                $scope.studentRenew.Branch__c	= $scope.student.Branch_Stream__c;
            }
            if($scope.student.College_Name__r != undefined){
                if($scope.student.College_Name__r.Name == 'Other')
                    $scope.studentRenew.College_Name__c	= $scope.student.College_Other__c;
                else
                    $scope.studentRenew.College_Name__c	= $scope.student.College_Name__r.Name;
            }
            $scope.studentRenew.Failure_ATKT__c 				= JSON.parse($scope.studentRenew.Failure_ATKT__c);

            $scope.studentRenew.Receiving_Full_AICTE_OtherTution_Fee_Wa__c 	= JSON.parse($scope.studentRenew.Receiving_Full_AICTE_OtherTution_Fee_Wa__c);
            $scope.studentRenew.Change_in_AnnualIncome_of_Parents__c 		= JSON.parse($scope.studentRenew.Change_in_AnnualIncome_of_Parents__c);
            $scope.studentRenew.SchlrShp_FinancialAsst_Other_Than_FFE__c 	= JSON.parse($scope.studentRenew.SchlrShp_FinancialAsst_Other_Than_FFE__c);
            $scope.application__c= $scope.studentRenew;
            if($scope.student!=undefined)
                delete $scope.student["attributes"];
            if($scope.student.Facilitator_Name__r!=undefined)
                delete $scope.student.Facilitator_Name__r["attributes"];
            if($scope.student.RecordType!=undefined)
                delete $scope.student.RecordType["attributes"];
            if($scope.student.College_Name__r!=undefined)
                delete $scope.student.College_Name__r["attributes"];
            if($scope.student!=undefined)
                delete $scope.student['Applications__r'];
            if($scope.student!=undefined)
                delete $scope.student['RecordType'];
            if($scope.student!=undefined)
                delete $scope.student['College_Name__r'];
            if($scope.student!=undefined)
                delete $scope.student['Facilitator_Name__r'];

            $scope.wrapper ={scholar:{},ScholarAppln:{}};
            $scope.wrapper.scholar.Id = $scope.student.Id;
            $scope.wrapper.scholar.Current_Annual_Family_Income__c = $scope.student.Current_Annual_Family_Income__c;
            if($scope.student.Course__c =='MBBS'){
                $scope.wrapper.scholar.MBBS_Year_1__c=$scope.student.MBBS_Year_1__c;
                $scope.wrapper.scholar.MBBS_Year_2__c=$scope.student.MBBS_Year_2__c;
                $scope.wrapper.scholar.MBBS_Year_3_Part_1__c=$scope.student.MBBS_Year_3_Part_1__c;
                $scope.wrapper.scholar.MBBS_Year_3_Part_2__c=$scope.student.MBBS_Year_3_Part_2__c;
            }
            else{
                $scope.wrapper.scholar.Semester1__c=$scope.student.Semester1__c;
                $scope.wrapper.scholar.Semester2__c=$scope.student.Semester2__c;
                $scope.wrapper.scholar.Semester3__c=$scope.student.Semester3__c;
                $scope.wrapper.scholar.Semester4__c=$scope.student.Semester4__c;
                $scope.wrapper.scholar.Semester5__c=$scope.student.Semester5__c;
                $scope.wrapper.scholar.Semester6__c=$scope.student.Semester6__c;
                $scope.wrapper.scholar.Semester7__c=$scope.student.Semester7__c;
                $scope.wrapper.scholar.Semester8__c=$scope.student.Semester8__c;
            }

            $scope.wrapper.ScholarAppln=$scope.studentRenew;

            // If no Active application present then only,sumission is allowed
            if($scope.student.Active_Application_ID__c == undefined){

                AP_Application_CTRL.renewApplication($scope.wrapper, function(result, event){
                    if(event.status) {
                        $scope.loading=false;
                        $scope.studentRenew.Failure_ATKT__c = $scope.studentRenew.Failure_ATKT__c.toString();
                        $scope.studentRenew.Receiving_Full_AICTE_OtherTution_Fee_Wa__c = $scope.studentRenew.Receiving_Full_AICTE_OtherTution_Fee_Wa__c.toString();
                        $scope.studentRenew.Change_in_AnnualIncome_of_Parents__c = $scope.studentRenew.Change_in_AnnualIncome_of_Parents__c.toString();
                        $scope.studentRenew.SchlrShp_FinancialAsst_Other_Than_FFE__c = $scope.studentRenew.SchlrShp_FinancialAsst_Other_Than_FFE__c.toString();
                        swal({title:'',
                              text:result
                             },
                             function(isConfirm){
                                 if (isConfirm) {
                                     $scope.renewalPopup 	= false;
                                     $scope.studentRenew	= {};
                                     $scope.application__c	= {};
                                     $scope.formInvalid = false;
                                     $scope.formInvalidRenew=false;
                                     $scope.showSpaceRenew = true;
                                     $scope.getstudentDetails();
                                     openCity('course');
                                     $scope.getListofFiles();
                                     $scope.renewalPopupDocs = true;
                                     $scope.$apply();
                                 }
                             });
                        $scope.$apply();
                    }
                },{escape:false});
            }
        }
    };

    $scope.getCollege = function(value){
        if(value !='' && value != undefined){
            AP_Application_CTRL.searchCollege(value,function(result,event){
                if(event.status){
                    $scope.colleges=result;
                    console.log(result);
                    $scope.$apply();
                }
            });
        }
    }

    $scope.selectedValue = function(value){
        console.log(value);
        for(var i=0;i<$scope.colleges.length;i++){
            if(value==$scope.colleges[i].Name){
                $scope.student.College_Name__r.Id=$scope.colleges[i].Id;
                $scope.student.College_Name__c = $scope.student.College_Name__r.Id;
                break;
            }
        }
    }

    $scope.changeCollege = function(college){
        for(var i=0;i<$scope.colleges.length;i++){
            if(college == $scope.colleges[i].Id){
                if($scope.colleges[i].Name == 'Other'){
                    $scope.collegeOther=true;
                }
                else{
                    $scope.collegeOther=false;
                }
            }
        }

        $scope.clg ='';
        $scope.$apply();
    };

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
    $scope.replcaestudentDoc = false;
    $scope.replcaefinalYearDoct = false;
    $scope.replaceFinalYeardoc = function(attachment,type){
        if(type==$scope.finalYearOddSem || type==$scope.finalYearEvenSem){
            $scope.replaceAttachments = attachment;
            $scope.type=type;
            $scope.replcaefinalYearDoct = true;
        }
    }

    $scope.replace = function(attachment,type){
        //console.log('replace - type : '+type);
        if(type==$scope.uploadForScholar){
            $scope.replaceAttachments = attachment;
			console.log('replaceAttachments.Name : '+$scope.replaceAttachments.Name);//added by sumit
			if($scope.replaceAttachments.Name=='Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable' && $scope.student.Father_Occupation__c != 'Service'){
				$scope.student.Certificate_Expiry_Date__c=null;
			}
			console.log('Certificate_Expiry_Date__c : '+$scope.student.Certificate_Expiry_Date__c);
            $scope.type=type;
            $scope.replcaeDoc = true;
        }
        else if(type==$scope.uploadForFacilitator){
            $scope.replaceAttachments = attachment;
            $scope.type=type;
            $scope.replcaeDoc = true;
        }


        if(type==$scope.resumeupload){
            $scope.replaceAttachments = attachment;
            $scope.replcaestudentDoc = true;
            $scope.type= $scope.resumeupload;
        }

    }
    $scope.closeReplaceFinalDoc = function(finalmarkName){
        $scope.replcaefinalYearDoct = false;
    }
    $scope.closeReplaceDoc = function(){
        $scope.replcaeDoc = false;
        $scope.replcaeDoc_FacilitatorInput = false;
        $scope.replcaestudentDoc = false;
        $scope.temp =true;
        $scope.getAllAttachments($scope.student.Id,$scope.resumeupload);
        $scope.getAllAttachments($scope.student.Id,$scope.finalYearOddSem);
        $scope.getAllAttachments($scope.student.Id,$scope.finalYearEvenSem);


    }

    $scope.docuUpload = function(){
        console.log('$scope.missingFilesUploaded : '+JSON.stringify($scope.missingFilesUploaded));
        if($scope.missingFilesUploaded.length != 0){
            debugger;
            let docMissingMessage = '';

            for(let index = 1; index <= $scope.missingFilesUploaded.length; index++) {
                docMissingMessage += index + ") " + $scope.missingFilesUploaded[index - 1] +"\n";
            }
            swal({title:'',text:'Please upload the below missing documents.\n\n'+docMissingMessage});
            return;
        }


        $scope.loading=true;
        AP_Application_CTRL.missingDocumentUplaoded($scope.activeAppli.Id,function(result,event){
            if(event.status){
                if($scope.activeAppli.Id==result.Id){
                    $scope.activeAppli.External_Status__c = result.External_Status__c;
                    swal({title:'',text:$scope.successMsg.replace(/"/g, "")});
                }
                else{
                    swal({title:'',text:$scope.errorMessage.replace(/"/g, "")});
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






    $scope.expenseUpload = function(){
        // This change is to make the attachments upload mandatory in student application submit screen
        var attachmentsMissing = $scope.remainingFilesList;
        var certificateExpiryDate = $scope.student.Certificate_Expiry_Date__c;
        if ((typeof attachmentsMissing !== 'undefined' && attachmentsMissing.length > 0) && true) {
            swal({title:'',
                  text:"Please upload all the Attachments before submitting the Application."});
        }
        else{
            if(typeof $scope.student.Father_Occupation__c !== undefined && $scope.student.Father_Occupation__c != 'Service' && (!(typeof certificateExpiryDate !== 'undefined' && certificateExpiryDate != null)) && $scope.IsRenewalApplication == false){
                swal({title:'',
                      text:"Please populate the Certificate Expiry Date."});
            }
            else{
                var basicInfoRenew=this.basicInfoRenew.$invalid;
                if(basicInfoRenew){
                    $scope.loading=false;
                    $scope.formInvalid = true;
                    $scope.formInvalidRenew=true;
                    $scope.showSpaceRenew = true;
                    swal({title:'',text:"Please fill all the mandatory (* marked) fields."});
                }else{
                    if($scope.NoImage){
                        $scope.loading=false;
                        swal({title:'',text:"Uploading profile photo is mandatory."});   return;
                    }
                    $scope.student.Bank_Name__c = $scope.student.Bank_Name__c;
                    $scope.student.X11_character_IFSC_Code_of_the_Branch__c = $scope.student.X11_character_IFSC_Code_of_the_Branch__c;
                    $scope.student.Full_Bank_Account_No_With_all_digits__c = $scope.student.Full_Bank_Account_No_With_all_digits__c;


                    if($scope.student.Full_Bank_Account_No_With_all_digits__c == null || $scope.student.Bank_Name__c == null || $scope.student.X11_character_IFSC_Code_of_the_Branch__c == null || $scope.student.Type_Of_Bank_Account__c == null){

                        swal({
                            title: "No Data!",
                            text: "Bank details are not complete, please go to your profile detail Page and update Bank Details.",
                            type: "warning",
                            showCancelButton: false,
                            confirmButtonColor: "#DD6B55",
                            confirmButtonText: "OK",
                            cancelButtonText: "Cancel",
                            closeOnConfirm: true,
                            closeOnCancel: true
                        },
                             function(isConfirm){
                                  if (isConfirm) {

                                 }else{

                                 }
                             });


                    }else{
                        swal({
                            title: "Are you sure?",
                            text: "Please review all information once before submitting!",
                            //type: "warning",
                            showCancelButton: true,
                            confirmButtonColor: "#DD6B55",
                            confirmButtonText: "Submit",
                            cancelButtonText: "Cancel",
                            closeOnConfirm: true,
                            closeOnCancel: true
                        },
                             function(isConfirm){
                                 if (isConfirm) {
                                     // custom added here

                                     $scope.loading=true;
                                     $scope.expenses={Id:'',Requested_College_Fees__c:'',Requested_Books_Expenses__c:'',Requested_Hostel_Mess_Expenses__c:'',Requested_Transportation_Expenses__c:'',Requested_Uniform_Expenses__c:'',Assistance_Source__c:'',SchlrShp_FinancialAsst_Other_Than_FFE__c:'',If_Yes_How_much_Other_Source__c:'',Scholarship_Amount__c:'',Change_in_AnnualIncome_of_Parents__c:'',Receiving_Full_AICTE_OtherTution_Fee_Wa__c:'',Annual_Marks_Scored_CGPA__c:'',Even_Semester_Marks_Scored_SGPA__c:'',Odd_Semester_Marks_Scored_SGPA__c:'',Failure_Subject_s__c:'',Failure_ATKT_Yes_If_Yes_Semester__c:'',Failure_ATKT__c:'',Grading_System__c:'',If_Yes_How_much_AICTE_Fee_from_Govt__c:''};

                                     if($scope.activeAppli.Requested_College_Fees__c !=undefined && $scope.activeAppli.Requested_College_Fees__c !=''){
                                         $scope.expenses.Requested_College_Fees__c = $scope.activeAppli.Requested_College_Fees__c;
                                     }
                                     if($scope.activeAppli.Requested_Books_Expenses__c !=undefined && $scope.activeAppli.Requested_Books_Expenses__c !=''){
                                         $scope.expenses.Requested_Books_Expenses__c = $scope.activeAppli.Requested_Books_Expenses__c;
                                     }
                                     if($scope.activeAppli.Requested_Hostel_Mess_Expenses__c !=undefined && $scope.activeAppli.Requested_Hostel_Mess_Expenses__c !=''){
                                         $scope.expenses.Requested_Hostel_Mess_Expenses__c = $scope.activeAppli.Requested_Hostel_Mess_Expenses__c;
                                     }
                                     if($scope.activeAppli.Requested_Transportation_Expenses__c !=undefined && $scope.activeAppli.Requested_Transportation_Expenses__c !=''){
                                         $scope.expenses.Requested_Transportation_Expenses__c = $scope.activeAppli.Requested_Transportation_Expenses__c;
                                     }
                                     if($scope.activeAppli.Requested_Uniform_Expenses__c !=undefined && $scope.activeAppli.Requested_Uniform_Expenses__c !=''){
                                         $scope.expenses.Requested_Uniform_Expenses__c = $scope.activeAppli.Requested_Uniform_Expenses__c;
                                     }

                                     if($scope.activeAppli.Assistance_Source__c !=undefined && $scope.activeAppli.Assistance_Source__c !=''){
                                         $scope.expenses.Assistance_Source__c = $scope.activeAppli.Assistance_Source__c;
                                     }
                                     if($scope.activeAppli.SchlrShp_FinancialAsst_Other_Than_FFE__c !=undefined && $scope.activeAppli.SchlrShp_FinancialAsst_Other_Than_FFE__c !=''){
                                         $scope.expenses.SchlrShp_FinancialAsst_Other_Than_FFE__c = $scope.activeAppli.SchlrShp_FinancialAsst_Other_Than_FFE__c;
                                     }
                                     if($scope.activeAppli.If_Yes_How_much_Other_Source__c !=undefined && $scope.activeAppli.If_Yes_How_much_Other_Source__c !=''){
                                         $scope.expenses.If_Yes_How_much_Other_Source__c = $scope.activeAppli.If_Yes_How_much_Other_Source__c;
                                     }
                                     if($scope.activeAppli.Scholarship_Amount__c !=undefined && $scope.activeAppli.Scholarship_Amount__c !=''){
                                         $scope.expenses.Scholarship_Amount__c = $scope.activeAppli.Scholarship_Amount__c;
                                     }
                                     if($scope.activeAppli.Change_in_AnnualIncome_of_Parents__c !=undefined && $scope.activeAppli.Change_in_AnnualIncome_of_Parents__c !=''){
                                         $scope.expenses.Change_in_AnnualIncome_of_Parents__c = $scope.activeAppli.Change_in_AnnualIncome_of_Parents__c;
                                     }
                                     if($scope.activeAppli.Receiving_Full_AICTE_OtherTution_Fee_Wa__c !=undefined && $scope.activeAppli.Receiving_Full_AICTE_OtherTution_Fee_Wa__c !=''){
                                         $scope.expenses.Receiving_Full_AICTE_OtherTution_Fee_Wa__c = $scope.activeAppli.Receiving_Full_AICTE_OtherTution_Fee_Wa__c;
                                     }
                                     if($scope.activeAppli.Annual_Marks_Scored_CGPA__c !=undefined && $scope.activeAppli.Annual_Marks_Scored_CGPA__c !=''){
                                         $scope.expenses.Annual_Marks_Scored_CGPA__c = $scope.activeAppli.Annual_Marks_Scored_CGPA__c;
                                     }
                                     if($scope.activeAppli.Even_Semester_Marks_Scored_SGPA__c !=undefined && $scope.activeAppli.Even_Semester_Marks_Scored_SGPA__c !=''){
                                         $scope.expenses.Even_Semester_Marks_Scored_SGPA__c = $scope.activeAppli.Even_Semester_Marks_Scored_SGPA__c;
                                     }
                                     if($scope.activeAppli.Odd_Semester_Marks_Scored_SGPA__c !=undefined && $scope.activeAppli.Odd_Semester_Marks_Scored_SGPA__c !=''){
                                         $scope.expenses.Odd_Semester_Marks_Scored_SGPA__c = $scope.activeAppli.Odd_Semester_Marks_Scored_SGPA__c;
                                     }
                                     if($scope.activeAppli.Failure_Subject_s__c !=undefined && $scope.activeAppli.Failure_Subject_s__c !=''){
                                         $scope.expenses.Failure_Subject_s__c = $scope.activeAppli.Failure_Subject_s__c;
                                     }
                                     if($scope.activeAppli.Failure_ATKT_Yes_If_Yes_Semester__c !=undefined && $scope.activeAppli.Failure_ATKT_Yes_If_Yes_Semester__c !=''){
                                         $scope.expenses.Failure_ATKT_Yes_If_Yes_Semester__c = $scope.activeAppli.Failure_ATKT_Yes_If_Yes_Semester__c;
                                     }
                                     if($scope.activeAppli.Failure_ATKT__c !=undefined && $scope.activeAppli.Failure_ATKT__c !=''){
                                         $scope.expenses.Failure_ATKT__c = $scope.activeAppli.Failure_ATKT__c;
                                     }
                                     if($scope.activeAppli.Grading_System__c !=undefined && $scope.activeAppli.Grading_System__c !=''){
                                         $scope.expenses.Grading_System__c = $scope.activeAppli.Grading_System__c;
                                     }
                                     if($scope.activeAppli.If_Yes_How_much_AICTE_Fee_from_Govt__c !=undefined && $scope.activeAppli.If_Yes_How_much_AICTE_Fee_from_Govt__c !=''){
                                         $scope.expenses.If_Yes_How_much_AICTE_Fee_from_Govt__c = $scope.activeAppli.If_Yes_How_much_AICTE_Fee_from_Govt__c;
                                     }
                                     //gourab
                                     if($scope.activeAppli.Have_you_called_met_your_facilitator__c !=undefined && $scope.activeAppli.Have_you_called_met_your_facilitator__c !=''){
                                         $scope.expenses.Have_you_called_met_your_facilitator__c = $scope.activeAppli.Have_you_called_met_your_facilitator__c;
                                     }
                                     if($scope.activeAppli.Facilitator_meet_date__c !=undefined && $scope.activeAppli.Facilitator_meet_date__c !=''){
                                         $scope.expenses.Facilitator_meet_date__c = $scope.activeAppli.Facilitator_meet_date__c;
                                     }
                                     console.log('$scope.expenses.Facilitator_meet_date__c: '+$scope.expenses.Facilitator_meet_date__c);
                                     console.log('$scope.fromdate: '+$scope.fromdate);
                                     console.log('$scope.todate: '+$scope.todate);
                                     //if($scope.activeAppli.FFE_Certificate_Expiry_Date__c !=undefined && ($scope.activeAppli.FFE_Certificate_Expiry_Date__c !='' || $scope.activeAppli.FFE_Certificate_Expiry_Date__c !=null) ){
                                         //$scope.activeAppli.FFE_Certificate_Expiry_Date__c=Date.parse($scope.activeAppli.FFE_Certificate_Expiry_Date__c);
                                         //$scope.activeAppli.FFE_Certificate_Expiry_Date__c = $scope.activeAppli.FFE_Certificate_Expiry_Date__c + (6*60*60*1000);
                                        // $scope.expenses.FFE_Certificate_Expiry_Date__c = $scope.activeAppli.FFE_Certificate_Expiry_Date__c;
                                    // }

                                     $scope.expenses.Student_Hostel_Mess_Expenses__c = $scope.activeAppli.Student_Hostel_Mess_Expenses__c;
                                     $scope.expenses.Student_Transportation_Expenses__c = $scope.activeAppli.Student_Transportation_Expenses__c;
                                     $scope.expenses.Student_College_Fees__c = $scope.activeAppli.Student_College_Fees__c;
                                     $scope.expenses.Student_Books_Expenses__c = $scope.activeAppli.Student_Books_Expenses__c;
                                     $scope.expenses.Student_Uniform_Expenses__c  = $scope.activeAppli.Student_Uniform_Expenses__c ;
                                     $scope.expenses.FFE_Accommodation_Type__c = $scope.activeAppli.FFE_Accommodation_Type__c;
                                     //End
                                     $scope.expenses.Id= $scope.activeAppli.Id;

                                     $scope.expenses.Failure_ATKT__c 				            = JSON.parse($scope.activeAppli.Failure_ATKT__c);
                                     $scope.expenses.Receiving_Full_AICTE_OtherTution_Fee_Wa__c 	= JSON.parse($scope.activeAppli.Receiving_Full_AICTE_OtherTution_Fee_Wa__c);
                                     $scope.expenses.Change_in_AnnualIncome_of_Parents__c 		= JSON.parse($scope.activeAppli.Change_in_AnnualIncome_of_Parents__c);
                                     $scope.expenses.SchlrShp_FinancialAsst_Other_Than_FFE__c 	= JSON.parse($scope.activeAppli.SchlrShp_FinancialAsst_Other_Than_FFE__c);

                                     $scope.wrapper ={scholar:{},ScholarAppln:{}};
                                     $scope.wrapper.scholar.Id = $scope.student.Id;

                                     if($scope.student.Course__c =='MBBS'){
                                         $scope.wrapper.scholar.MBBS_Year_1__c=$scope.student.MBBS_Year_1__c;
                                         $scope.wrapper.scholar.MBBS_Year_2__c=$scope.student.MBBS_Year_2__c;
                                         $scope.wrapper.scholar.MBBS_Year_3_Part_1__c=$scope.student.MBBS_Year_3_Part_1__c;
                                         $scope.wrapper.scholar.MBBS_Year_3_Part_2__c=$scope.student.MBBS_Year_3_Part_2__c;
                                     }
                                     else{
                                         $scope.wrapper.scholar.Semester1__c=$scope.student.Semester1__c;
                                         $scope.wrapper.scholar.Semester2__c=$scope.student.Semester2__c;
                                         $scope.wrapper.scholar.Semester3__c=$scope.student.Semester3__c;
                                         $scope.wrapper.scholar.Semester4__c=$scope.student.Semester4__c;
                                         $scope.wrapper.scholar.Semester5__c=$scope.student.Semester5__c;
                                         $scope.wrapper.scholar.Semester6__c=$scope.student.Semester6__c;
                                         $scope.wrapper.scholar.Semester7__c=$scope.student.Semester7__c;
                                         $scope.wrapper.scholar.Semester8__c=$scope.student.Semester8__c;
                                     }
                                     //$scope.wrapper.scholar.Certificate_Expiry_Date__c = $scope.expenses.FFE_Certificate_Expiry_Date__c;
                                     if($scope.student.Do_you_have_Linkedin_Profile__c != undefined && $scope.student.Do_you_have_Linkedin_Profile__c)
                                     {
                                         $scope.wrapper.scholar.Do_you_have_Linkedin_Profile__c = $scope.student.Do_you_have_Linkedin_Profile__c;

                                     }
                                     else{
                                         $scope.wrapper.scholar.Do_you_have_Linkedin_Profile__c = false;

                                     }
                                     if($scope.student.Linkedin_Profile_Link__c != '' && $scope.student.Linkedin_Profile_Link__c != undefined)
                                     	$scope.wrapper.scholar.Linkedin_Profile_Link__c = $scope.student.Linkedin_Profile_Link__c;

                                     if($scope.student.Current_Annual_Family_Income__c != null && $scope.student.Current_Annual_Family_Income__c != undefined){
                                        $scope.wrapper.scholar.Current_Annual_Family_Income__c = $scope.student.Current_Annual_Family_Income__c;
                                     }
                                     if($scope.IsRenewalApplication){
                                         $scope.expenses.Internal_Status__c = 'Pending FFE Staff Review';
                                     }

                                     $scope.wrapper.ScholarAppln=$scope.expenses;
                                    // console.log('Here : '+JSON.stringify($scope.wrapper));
                                     // console.log('is renewal : '+$scope.IsRenewalApplication);

                                     AP_Application_CTRL.applicationExpenseUpdate($scope.wrapper,function(result,event){
                                         if(event.status){
                                             swal({title:'',text:result});
                                             $scope.loading=false;
                                             $scope.$apply();
                                         }
                                         else{
                                             swal({title:'',text:'Oops! Something went wrong. Please try again.'});
                                             $scope.loading=false;
                                             $scope.$apply();
                                         }
                                     },{escape:false})

                                     //
                                 } else {
                                     //swal("Cancelled", "Your imaginary file is safe :)", "error");
                                 }
                             });
                    }
                }
            }
        }
    }


    $scope.boolToStr = function(arg) {return arg ? 'Yes' : 'No'};

    $scope.clearFieldValues = function() {

        if($scope.activeAppli.Receiving_Full_AICTE_OtherTution_Fee_Wa__c==false){
            $scope.activeAppli.If_Yes_How_much_AICTE_Fee_from_Govt__c = '';
        }
        if($scope.activeAppli.Failure_ATKT__c==false){
            $scope.activeAppli.Failure_ATKT_Yes_If_Yes_Semester__c='';
            $scope.activeAppli.Failure_Subject_s__c='';
        }
        if($scope.activeAppli.SchlrShp_FinancialAsst_Other_Than_FFE__c==false){
            $scope.activeAppli.If_Yes_How_much_Other_Source__c='';
            $scope.activeAppli.Assistance_Source__c='';
        }
    }
    $scope.clearRenewalFieldValues = function() {

        if($scope.studentRenew.Receiving_Full_AICTE_OtherTution_Fee_Wa__c=='false'){
            $scope.studentRenew.If_Yes_How_much_AICTE_Fee_from_Govt__c = '';
        }
        if($scope.studentRenew.Failure_ATKT__c=='false'){
            $scope.studentRenew.Failure_ATKT_Yes_If_Yes_Semester__c='';
            $scope.studentRenew.Failure_Subject_s__c='';
        }
        if($scope.studentRenew.SchlrShp_FinancialAsst_Other_Than_FFE__c=='false'){
            $scope.studentRenew.If_Yes_How_much_Other_Source__c='';
            $scope.studentRenew.Assistance_Source__c='';
        }

    }

    $scope.generateAsPdf	= function(){
        var form = document.createElement("form");
        form.setAttribute("method", "post");
        form.setAttribute("action", '/application/ApplicationStudentInfoPDF');

        form.setAttribute("target", "_blank");

        var hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "ScholarId");
        hiddenField.setAttribute("value", $scope.studendId);
        form.appendChild(hiddenField);
        document.body.appendChild(form);

        window.open('', '_top');

        form.submit();
    }

    $scope.editplacementFileds =true;
    $scope.editplacement = function (){
        $scope.editplacementFileds =false;
    }
    $scope.cancleplacementchanges = function (){
        $scope.editplacementFileds =true;
        $scope.formInvalidplacement=false;
    }
    $scope.submitPlacementInfo = function(){

        $scope.loading=true;
        if(this.basicInfo.$invalid){
            $scope.loading=false;
            $scope.formInvalidplacement = true;
            swal({title:'',text:"Please fill all the mandatory (* marked) fields."});
        }
        else{
            $scope.PlacementWrp = {id:$scope.student.Id,CompanyName:$scope.student.Company_Name__c,Designation:$scope.student.Designation__c,Location:$scope.student.Location__c,CTC:$scope.student.CTC__c};
            console.log($scope.PlacementWrp);
            AP_Application_CTRL.submitPlacementInfo($scope.PlacementWrp,function(result,event){
                if(event.status){
                    $scope.loading=false;
                    $scope.formInvalidplacement=false;
                    $scope.editplacementFileds = true;
                    swal({title:'',
                          text:result
                         },
                         function(isConfirm){
                             $scope.getstudentDetails();
                         });
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false})
        }
    }



    $scope.submitPlacementInfoforOther = function(){

        $scope.loading=true;
        if($scope.student.Other__c == '' || $scope.student.Other__c == undefined){
            $scope.loading=false;
            swal({title:'',text:"Please fill the Other field"});
        }
        else{
            AP_Application_CTRL.submitOtherInfo($scope.student.Id,$scope.student.Other__c,function(result,event){
                if(event.status){
                    $scope.loading=false;
                    swal({title:'',
                          text:result
                         },
                         function(isConfirm){
                             $scope.getstudentDetails();
                             $scope.otherFieldDisplay = true;
                         });
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false})
        }
    }
    $scope.allowtoEnterValue  = function(){
        $scope.otherFieldDisplay = false;
    }


    $scope.selectedPlacementOption = function(info){
        //alert(info);
        if(info != 'Placed'){
            $scope.student.Company_Name__c = '';
            $scope.student.Designation__c = '';
            $scope.student.Location__c = '';
            $scope.student.CTC__c = '';
        }
        if(info == 'Placed'){
            $scope.student.Other__c = '';
            $scope.displayPlacement = true;
            $scope.displayResume = false;
            $scope.displayOther = false;
        }else if(info == 'Not Placed'){
            $scope.student.Other__c = '';
            $scope.displayPlacement = false;
            $scope.displayResume = true;
            $scope.displayOther = false;
        }else if(info == 'Others' || info == 'Seeking Entreprenuership' ||info == 'Seeking Govt. Jobs' || info == 'Higher Studies'){
            $scope.displayPlacement = false;
            $scope.displayResume = false;
            $scope.displayOther = true;
        }else{
            $scope.displayPlacement = false;
            $scope.displayResume = false;
            $scope.displayOther = false;
        }
        AP_Application_CTRL.savePlacementInfo($scope.student.Id,info,function(result,event){
            if(event.status){
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})

    },
        $scope.submitFinalYearMarksDetails = function(){
            $scope.student.Birthdate = (Date.parse($scope.student.Birthdate) + (6*60*60*1000));
            if($scope.student!=undefined)
                delete $scope.student["attributes"];
            if($scope.student.Facilitator_Name__r!=undefined)
                delete $scope.student.Facilitator_Name__r["attributes"];
            if($scope.student.RecordType!=undefined)
                delete $scope.student.RecordType["attributes"];
            if($scope.student.College_Name__r!=undefined)
                delete $scope.student.College_Name__r["attributes"];
            if($scope.student!=undefined)
                delete $scope.student['Applications__r'];
            delete $scope.student['Donor_Application_Mappings1__r'];
            AP_Application_CTRL.submitFinalYearMarksDetails($scope.student,function(result,event){
                if(event.status){
                    swal({title:'',
                          text:result});
                    $scope.loading=false;
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false})
        }
		console.log('$scope.scholarshipGrantedAtLeastOnce==='+$scope.scholarshipGrantedAtLeastOnce);
		console.log('$scope.student.KYC_Verified__c==='+$scope.student.KYC_Verified__c);
})
