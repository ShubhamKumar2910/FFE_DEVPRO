var app=angular.module('DonorAllocation', ['ngRoute','ngAnimate','ngMaterial','rzModule']);
app.controller('donorAllocation', function($scope, $timeout, $window, $location,$element ) {
    $scope.DonorCategory = DonorCategory;
    $scope.totalScholarshipAmount = 0;
    $scope.totalEnteredAmount = 0;
    $scope.DonorCategoryselected = '';
    $scope.chooseDonorMapping = false;
    $scope.studentPopup						= false;
    $scope.donorBalance						= 'false';
    $scope.locations						= [];
    $scope.loca								= '';    
    $scope.studentClzRatingPicklistValues	= studentClzRatingPicklistValues;
    $scope.studentCoursePicklistValues		= studentCoursePicklistValues;
    
    $scope.studentCourseYearPicklistValues  = studentCourseYearPicklistValues;
    $scope.CourseIntegratedMTech            = CourseIntegratedMTech;
    $scope.CourseMBBS                       = CourseMBBS;
    $scope.CourseBEBTech                    = CourseBEBTech;
    
    //$scope.listOfGAUS						= JSON.parse(listOfGAUS);
    $scope.listOfPrgms						= JSON.parse(listOfPrgms);
    $scope.listStates						= listOfStates;
    $scope.genderList						= genderList;
    $scope.branchList						= branchList;
    $scope.countryList						= countryList;
    $scope.countrySelected                  = 'India';//$scope.countryList[0].DeveloperName;
    $scope.gaus								= [];
    $scope.listOfStates						= [];
    $scope.indianStates						= [];
    $scope.selectedStudents					= [];
    $scope.selectedDonors					= [];
    $scope.selectedApplications				= [];
    $scope.selectedStudent					= true;
    $scope.selectedDonor					= true;
    $scope.maxFamilyIncome					= maxIncome;
    $scope.isSelected						= true;
    $scope.isSelectedGau					= true;
    $scope.isSelectedpState				 	= true;
    $scope.isSelectedcState					= true;
    $scope.isSelectedcours					= true;
    $scope.isSelectedcoursYear              = true;
    $scope.isSelectedrating					= true;
    $scope.isSelectedGender					= true;
    $scope.isSelectedbranch					= true;
    $scope.isSelectedexam					= true;
    $scope.isSelectedRank					= true;
    $scope.selectedReviewStudentDetails 	= [];
    $scope.selectAllRen                     = {isTrueRen:false};
    $scope.selectAll 					    = {isTrue:false};
    //gourab
    //  $scope.examList 						= examList;
    //  $scope.ExamRankList						= ExamRankList;
    $scope.ScholarList						= ScholarList;
    $scope.priorityList					    = priorityList;
    /*  $scope.ExamNameList = [];
    // Gourab
    for(var i=0;i<$scope.examList.length;i++){
        $scope.ExamNameList.push($scope.examList[i].Entrance_Test_Name__c);
    }  */
    
    for(var i=0;i<$scope.listOfPrgms.length;i++){
        $scope.gaus.push($scope.listOfPrgms[i].Name);
    }
    for(var i=0;i<$scope.listStates.length;i++){
        $scope.listOfStates.push($scope.listStates[i].Label);
        $scope.indianStates.push($scope.listStates[i].Label);
    }
    $element.find('input').on('keydown', function(ev) {
        ev.stopPropagation();
    });
    
    $scope.getCourseYear = function(courseYear){
        
        if(courseYear.includes('Integrated MTech') && courseYear.includes('MBBS')){
            $scope.studentCourseYearPicklistValues = $scope.CourseIntegratedMTech.concat($scope.CourseMBBS);
            
        }else if(courseYear.includes('BE/B.Tech') && courseYear.includes('MBBS')){
            $scope.studentCourseYearPicklistValues = $scope.CourseBEBTech.concat($scope.CourseMBBS);
            
        }else if(courseYear.includes('MBBS')){
            $scope.studentCourseYearPicklistValues = $scope.CourseMBBS;
            
        }else if(courseYear.includes('Integrated MTech')){
            $scope.studentCourseYearPicklistValues = $scope.CourseIntegratedMTech;
            
        }else if(courseYear.includes('BE/B.Tech')){
            $scope.studentCourseYearPicklistValues = $scope.CourseBEBTech;
        }
    }
    $scope.clearCourseYear = function(){
        $scope.studentCourseYearPicklistValues = null;
    }
    
    $scope.clearLocation = function() {
        $scope.searchLoc = '';
    };
    $scope.clearGau=function(){
        $scope.searchGau = '';
    }
    $scope.clearState=function(){
        $scope.state = '';
    }
    $scope.clearCstate=function(){
        $scope.cstate = '';
    }
    $scope.clearinstState=function(value){
        $scope.city = '';
        $scope.insCities=value;
    }
    $scope.clearInst=function(value){
        $scope.institue = '';
        $scope.institues=value;
    }
    $scope.clearCourse=function(){
        $scope.cour = '';
    }
    
    $scope.clearCourseyear=function(){
        $scope.courYear ='';
    }
    
    $scope.clearCRate=function(){
        $scope.cRating = '';
    }
    /* gourab
    $scope.clearCExam=function(){
        $scope.cExamming = '';
    }
    // gourab
    $scope.clearCRank=function(){
        $scope.cRanking='';
    } */
    
    //gourab
    $scope.clearCSchol=function(){
        $scope.cschling='';
    }
    //gourab
    $scope.clearcPriority=function(){
        $scope.cprioritying='';
    }
    
    
    $scope.locations = function(){
        if ($scope.isSelected) {
            $scope.locationSelected = $scope.listOfStates;
            $scope.isSelected=false;
        }
        else if(!$scope.isSelected ){
            $scope.locationSelected = '';
            $scope.isSelected=true;
        }
        
    }
    $scope.gauSelected=[];
    $scope.gau = function(){
        if ($scope.isSelectedGau) {
            for(var i=0;i<$scope.listOfPrgms.length;i++){
                $scope.gauSelected.push($scope.listOfPrgms[i].Id);
                $scope.isSelectedGau=false;
            }
        }
        else if(!$scope.isSelectedGau ){
            $scope.gauSelected = [];
            $scope.isSelectedGau=true;
        }
        
    }
    
    $scope.pState = function(){
        if ($scope.isSelectedpState) {
            $scope.permState = $scope.indianStates;
            $scope.isSelectedpState=false;
        }
        else if(!$scope.isSelectedpState){
            $scope.permState = '';
            $scope.isSelectedpState=true;
        }
    }
    $scope.cState = function(){
        if ($scope.isSelectedcState) {
            $scope.CurrState = $scope.indianStates;
            $scope.isSelectedcState=false;
        }
        else if(!$scope.isSelectedcState){
            $scope.CurrState = '';
            $scope.isSelectedcState=true;
        }
    }
    $scope.iState = function(){
        if ($scope.isSelectediState) {
            $scope.instState = $scope.insCities;
            $scope.isSelectediState=false;
        }
        else if(!$scope.isSelectediState){
            $scope.instState = '';
            $scope.isSelectediState=true;
        }
    }
    $scope.instit = function(){
        if ($scope.isSelectedinstit) {
            $scope.inst = $scope.institues;
            $scope.isSelectedinstit=false;
        }
        else if(!$scope.isSelectedinstit){
            $scope.inst = '';
            $scope.isSelectedinstit=true;
        }
    }
    $scope.cours = function(){
        if ($scope.isSelectedcours) {
            $scope.course = $scope.studentCoursePicklistValues;
            $scope.isSelectedcours=false;
        }
        else if(!$scope.isSelectedcours){
            $scope.course = '';
            $scope.isSelectedcours=true;
        }
    }
    
    //$scope.isSelectedcoursYear              = true;
    $scope.coursYear = function(){
        if ($scope.isSelectedcoursYear) {
            $scope.courseYear = $scope.studentCourseYearPicklistValues;
            $scope.isSelectedcoursYear=false;
        }
        else if(!$scope.isSelectedcoursYear){
            $scope.courseYear = '';
            $scope.isSelectedcoursYear=true;
        }
    }
    
    
    $scope.rating = function(){
        if ($scope.isSelectedrating) {
            $scope.cRate = $scope.studentClzRatingPicklistValues;
            $scope.isSelectedrating=false;
        }
        else if(!$scope.isSelectedrating){
            $scope.cRate = '';
            $scope.isSelectedrating=true;
        }
    }
    //gourab- Added
    /*   $scope.examName = function(){
        if($scope.isSelectedexam) {
            $scope.cExam = $scope.ExamNameList;
            $scope.isSelectedexam= false; 
        }
        
        else if(!$scope.isSelectedexam){
            $scope.cExam ='';
            $scope.isSelectedexam=true;
        }
    } */
    
    
    $scope.branchs = function(){
        if ($scope.isSelectedbranch) {
            $scope.branch = $scope.branchList;
            $scope.isSelectedbranch=false;
        }
        else if(!$scope.isSelectedbranch){
            $scope.branch = '';
            $scope.isSelectedbranch=true;
        }
    }
    $scope.genders = function(){
        if ($scope.isSelectedGender) {
            $scope.gender = $scope.genderList;
            $scope.isSelectedGender=false;
        }
        else if(!$scope.isSelectedGender){
            $scope.gender = '';
            $scope.isSelectedGender=true;
        }
    }
    $scope.getinstState = function(value){
        if(value != '' && value != undefined){
            $scope.insCities=[];
            DN_DonorAllocation_CTRL.getStudentCollegeCity(value,function(result,event){ 
                if(event.status){
                    result=JSON.parse(result);
                    if(result.length > 0){
                        $scope.isSelectediState= true;
                        $scope.isIState= true;
                        for(var i=0; i<result.length;i++){
                            /*if ($scope.insCities.indexOf(result[i].College_Name__r.College_City__c) == -1) {
                            $scope.insCities.push(result[i].College_Name__r.College_City__c);
                        }*/
                            if ($scope.insCities.indexOf(result[i].College_City__c) == -1) {
                                $scope.insCities.push(result[i].College_City__c);
                            }
                        }
                    }
                    $scope.$apply();
                }
            },{escape:false});
        }else{
            $scope.insCities=[];
        }
    }
    
    $scope.getInst = function(value){
        if(value !='' && value != undefined){
            $scope.institues=[];
            DN_DonorAllocation_CTRL.getStudentCollegeName(value,function(result,event){ 
                if(event.status){
                    result=JSON.parse(result);
                    if(result.length > 0){
                        $scope.isSelectedinstit= true;
                        $scope.isInst= true;
                        for(var i=0; i<result.length;i++){
                            /*if ($scope.institues.indexOf(result[i].College_Name__r.Name) == -1) {
                            $scope.institues.push(result[i].College_Name__r.Name);
                        }*/
                            if ($scope.institues.indexOf(result[i].Name) == -1) {
                                $scope.institues.push(result[i].Name);
                            }
                        }
                    }
                    $scope.$apply();
                }
            },{escape:false});
        }else{
            $scope.institues=[];
        }        
    }
    
    $scope.cancel = function(){
        $scope.studentPopup=false;
        $scope.selectAll.isTrue = false;
        $scope.RenewalselectedStudentsCount = 0;
        $scope.RenewalselectedStudentsTotalSum = 0;
        $scope.selectedStudentsCount = 0;
        $scope.selectedStudentsTotalSum = 0;
        $scope.clearStudent();
    }
    
    $scope.cancel_multiDonor = function(){
        
        location.reload();
        
    }
    
    $scope.income = {
        minValue: 0,
        maxValue: parseInt($scope.maxFamilyIncome),
        options: {
            floor: 0,
            ceil: parseInt($scope.maxFamilyIncome),
            step: 5000,
            translate: function(minValue) {
                minValue= minValue.toLocaleString();
                return minValue;
            },
            translate: function(maxValue) {
                maxValue= maxValue.toLocaleString();
                return maxValue;
            }
        }
    };
    $scope.clear =function(){
        $scope.locationSelected	= [];
        $scope.gauSelected		= [];
        $scope.FFEUID ='';
        $scope.donorBalance='';
        $scope.donorDetails={};
        $scope.isSelected						= true;
        $scope.isSelectedGau					= true;
        $scope.isSelectedRank					= true;
        $scope.DonorCategoryselected = '';
        //$scope.getDonorDetails();
    }
    $scope.search = function(){
        $scope.searchFilters={};
        $scope.loading=true; 
        $scope.searchFilters.locations	= [];
        $scope.searchFilters.gaus		= [];
        $scope.searchFilters.FFEUID     ='';
        
        if($scope.countrySelected != undefined && $scope.countrySelected != ''){
            $scope.searchFilters.countryName=$scope.countrySelected;
        }
        
        if($scope.locationSelected != undefined && $scope.locationSelected != ''){
            $scope.searchFilters.locations=$scope.locationSelected;
            $scope.noSearchDataLoc = true;
        }
        else{
            $scope.noSearchDataLoc = false;
            $scope.searchFilters.locations=[];
        }
        if($scope.gauSelected != undefined && $scope.gauSelected != ''){
            $scope.searchFilters.gaus=$scope.gauSelected;
            $scope.noSearchDataGau = true;
        }
        else{
            $scope.noSearchDataGau = false;
            $scope.searchFilters.gaus=[];
        }
        if($scope.donorBalance != undefined && $scope.donorBalance !=''){
            $scope.searchFilters.isDonorBalance=$scope.donorBalance;
        }
        else{
            $scope.searchFilters.isDonorBalance= false;
        }
        if($scope.FFEUID != undefined && $scope.FFEUID !=''){
            $scope.searchFilters.FFEUID=$scope.FFEUID;
            $scope.noSearchDataGau = true;
        }
        
        if ($scope.noSearchDataGau || $scope.noSearchDataLoc){
            debugger;
            DN_DonorAllocation_CTRL.getFilteredDonors($scope.searchFilters,function(result,event){
                if(event.status){
                    $scope.donorDetails=JSON.parse(result);
                    $scope.matchedDonors = $scope.donorDetails;
                    if($scope.donorDetails.length <= 0){
                        swal({title:'', text:'No results found.'});
                    }
                    $scope.loading=false;
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false});
        }
        else{
            swal({title:'', text:'Please select at least Location/State Filter.'});
            $scope.loading=false;
            $scope.$apply();
        }
    }
    
    $scope.search_multidonor = function(){
        console.log('search_multidonor');
        $scope.searchFilters={};
        $scope.loading=true; 
        $scope.searchFilters.locations	= [];
        $scope.searchFilters.gaus		= [];
        $scope.searchFilters.FFEUID     ='';
        
        if($scope.countrySelected != undefined && $scope.countrySelected != ''){
            $scope.searchFilters.countryName=$scope.countrySelected;
        }
        
        if($scope.locationSelected != undefined && $scope.locationSelected != ''){
            $scope.searchFilters.locations=$scope.locationSelected;
            $scope.noSearchDataLoc = true;
        }
        else{
            $scope.noSearchDataLoc = false;
            $scope.searchFilters.locations=[];
        }
        if($scope.gauSelected != undefined && $scope.gauSelected != ''){
            $scope.searchFilters.gaus=$scope.gauSelected;
            $scope.noSearchDataGau = true;
            console.log('$scope.gauSelected : '+$scope.gauSelected);
        }
        else{
            /*swal({title:'', text:'Please select a Program.'});
             $scope.loading=false;
             $scope.$apply();
             return; */
            $scope.noSearchDataGau = false;
            $scope.searchFilters.gaus=[];    
        }
        if($scope.donorBalance != undefined && $scope.donorBalance !=''){
            $scope.searchFilters.isDonorBalance=$scope.donorBalance;
        }
        else{
            $scope.searchFilters.isDonorBalance= false;
        }
        if($scope.FFEUID != undefined && $scope.FFEUID !=''){
            $scope.searchFilters.FFEUID=$scope.FFEUID;
            $scope.noSearchDataGau = true;
        }
        
        console.log('DonorCategoryselected : '+$scope.DonorCategoryselected);
 
        if(!($scope.DonorCategoryselected != undefined && $scope.DonorCategoryselected != null && $scope.DonorCategoryselected != '')){
            $scope.DonorCategoryselected = '';
        }        
        if ($scope.noSearchDataGau || $scope.noSearchDataLoc){
            debugger;
            console.log('$scope.searchFilters : '+JSON.stringify($scope.searchFilters));
            DN_DonorAllocation_CTRL.getFilteredDonors_multiDonor($scope.searchFilters,$scope.DonorCategoryselected,function(result,event){
                if(event.status){
                    console.log('result : '+JSON.stringify(result));
                    $scope.donorDetails=JSON.parse(result);
                    $scope.matchedDonors = $scope.donorDetails;
                    if($scope.donorDetails.length <= 0){
                        swal({title:'', text:'No results found.'});
                    }
                    $scope.loading=false;
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    $scope.$apply();
                }
            },{escape:false});
        }
        else{
            swal({title:'', text:'Please select at least Location/State Filter.'});
            $scope.loading=false;
            $scope.$apply();
        }
    }
    
    
    $scope.matchDonors = function(value){
        console.log('selected application : '+JSON.stringify(value));
        $scope.chooseDonorMapping =true;
    }
    $scope.matchDonors_multiDonor = function(value){
        console.log('selected application : '+JSON.stringify(value));
        $scope.selectedApplications = [];
        $scope.selectedApplications.push(value);
        $scope.chooseDonorMapping =true;
        console.log('value.Student__r.ScholarshipAmount__c : ' + value.Student__r.ScholarshipAmount__c );
        $scope.totalScholarshipAmount = value.Student__r.ScholarshipAmount__c;
        
    }
    $scope.match = function(value){
        $scope.donorID=value;
        $scope.chooseMapping =true;
        /*$scope.StudentsDetails='';
        $scope.studentPopup=true;
        $scope.showNoresults=false;
        // $scope.getMatchStudents();
        // 
        swal({ 
            title:'',
            text:'<span style="font-size:18px;font-weight:bold;color:#032559;">Choose Mapping Type</span>',
            showCancelButton: true,                        
            cancelButtonText: "Review Pre. Mapping",
            cancelButtonColor: '#ff793c',
            confirmButtonColor: "#ff793c",
            confirmButtonText: "Create New Mapping",
            closeOnConfirm: false,
            closeOnCancel: false,
            allowEscapeKey:true,
            html:true
        }, 
             function(isConfirm){ 
                 if (isConfirm) {
                     $scope.StudentsDetails='';
                     $scope.studentPopup=true;
                     $scope.showNoresults=false;
                     swal.close();
                     $scope.$apply();
                 }else { 
                     $scope.studentPopupReview =true;
                     swal.close();
                     $scope.loading=true;
                     DN_DonorAllocation_CTRL.getPreviousYearApplnfrmDB($scope.donorID,function(result,event){
                         if(event.status){
                             console.log(result);
                             $scope.reviewDetails =result;
                             $scope.StudentsDetailsReviewDetails = result;
                             $scope.loading=false;
                             $scope.$apply();
                         }
                     })
                     $scope.$apply();
                 }
             });
						*/        
    }
    
    $scope.reviewPreMapping =function(){
        $scope.chooseMapping =false;
        $scope.loading=true;
        DN_DonorAllocation_CTRL.getPreviousYearApplnfrmDB($scope.donorID,function(result,event){
            if(event.status){
                console.log(result);
                $scope.reviewDetails =result;
                $scope.StudentsDetailsReviewDetails = result;
                for(var i=0; i<$scope.StudentsDetailsReviewDetails.length;i++){
                    $scope.StudentsDetailsReviewDetails[i].currentApp.Funding_amount__c = $scope.StudentsDetailsReviewDetails[i].currentApp.Student__r.ScholarshipAmount__c;
                }
                if($scope.StudentsDetailsReviewDetails.length>0){
                    $scope.studentPopupReview =true;
                }
                else{
                    swal({title:'',text:"No active application available for previous year mapping."});
                }
                $scope.loading=false;
                $scope.$apply();
            }
        },{esacpe:false})
    }
    
    $scope.createNewMapping =function(){
        $scope.StudentsDetails='';
        $scope.studentPopup=true;
        $scope.showNoresults=false;
        $scope.chooseMapping =false;
    }
    
    $scope.cancelMapping =function(){
        $scope.chooseMapping =false;
    }
    $scope.cancelDonorMapping =function(){
        $scope.chooseDonorMapping =false;
    }
    
    $scope.studentFilter = function(id){
        $scope.StudentsDetailsReviewDetails=[];
        if(id==undefined){
            id='';
        }
        if(id!=''){
            for(i=0;i<$scope.reviewDetails.length;i++){
                if(id==$scope.reviewDetails[i].currentApp.Student__r.FFE_ID__c){
                    $scope.StudentsDetailsReviewDetails.push($scope.reviewDetails[i]);
                }
            }
        }
        else{
            $scope.StudentsDetailsReviewDetails =$scope.reviewDetails;
        }
        
    }
    /*  $scope.selectAllRen = function(selectallTrue){
        if(selectallTrue == true){
            for(var i=0; i<$scope.StudentsDetailsReviewDetails.length;i++){
                $scope.StudentsDetailsReviewDetails[i].currentApp.selectedStudent=true;
                $scope.selectedStudents.push($scope.StudentsDetailsReviewDetails[i]);
            }
        }else{
            for(var i=0; i<$scope.StudentsDetailsReviewDetails.length;i++){
                $scope.StudentsDetailsReviewDetails[i].currentApp.selectedStudent=false;
                $scope.selectedStudents=[];
            } 
        }
    }
    
        $scope.selectStudentRenew = function(selectTrue){
            if(selectTrue == false){
                $scope.selectAllRen.isTrueRen = false;
            }
        }*/
    
    $scope.saveReviewDetails =function(){
        $scope.selectedReviewStudentDetails=[];
        $scope.selectedStudentsCount = 0;
        $scope.selectedStudentsTotalSum = 0;
        $scope.IsFundAmtGreater 	= false;
        $scope.IsNegativeNumber 	= false;
        $scope.selectAllRen.isTrueRen = false;
        
        for(i=0;i<$scope.StudentsDetailsReviewDetails.length;i++){
            if($scope.StudentsDetailsReviewDetails[i].currentApp.selectedStudent){
                $scope.selected = {};
                $scope.selected.appId = $scope.StudentsDetailsReviewDetails[i].currentApp.Id;
                $scope.selected.donorRemark = $scope.StudentsDetailsReviewDetails[i].currentApp.Donor_Remark__c;
                if($scope.StudentsDetailsReviewDetails[i].currentApp.Funding_amount__c != undefined){
                    if($scope.StudentsDetailsReviewDetails[i].currentApp.Funding_amount__c > 0){
                        if($scope.StudentsDetailsReviewDetails[i].currentApp.Funding_amount__c > $scope.StudentsDetailsReviewDetails[i].currentApp.Student__r.ScholarshipAmount__c){
                            $scope.IsFundAmtGreater = true;
                        }else{
                            $scope.selected.fundingAmount = $scope.StudentsDetailsReviewDetails[i].currentApp.Funding_amount__c;
                        } 
                    }else{
                        $scope.IsNegativeNumber = true;
                    }
                    
                }                    
                $scope.selectedReviewStudentDetails.push($scope.selected);
            }
        }
        
        //if($scope.IsNegativeNumber){
        //            swal({title:'',text:'Funding Amount can\'t be less than zero. Please review the selected rows.'});
        //    return true;
        // }
        if($scope.IsFundAmtGreater){
            swal({title:'',text:'Funding Amount can\'t be more than Approved Scholarship Amount. Please review the selected rows.'});
            return true;
        } 
        if($scope.selectedReviewStudentDetails.length ==0){
            swal({title:'',text:'No row selected'});
            return;
        }
        $scope.loading=true;
        DN_DonorAllocation_CTRL.createDonorStudentMapping($scope.donorID,$scope.selectedReviewStudentDetails,function(result,event){
            if(event.status){
                swal({title:'',text:result});
                $scope.studentPopupReview =false;
                $scope.reviewDetails =[];
                $scope.StudentsDetailsReviewDetails = [];
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                swal({title:'',text:'Oops! something went wrong.'});
                $scope.$apply();
            }
        })
    }
    
    $scope.cancelReview = function(){
        $scope.studentPopupReview =false;
        $scope.selectAllRen.isTrueRen = false;
        $scope.RenewalselectedStudentsCount = 0;
        $scope.RenewalselectedStudentsTotalSum = 0;
        $scope.selectedStudentsCount = 0;
        $scope.selectedStudentsTotalSum = 0;
    }
    
    $scope.StudentsDetails = {};
    $scope.searchStudent =function(isone){
        console.log('searchStudent');
        $scope.loading=true;
        $scope.searchStudentFilters={};
        if($scope.permState != undefined && $scope.permState != ''){
            $scope.searchStudentFilters.studentState=$scope.permState;
        }
        else{
            $scope.searchStudentFilters.studentState=[];
        }
        if($scope.CurrState != undefined && $scope.CurrState != ''){
            $scope.searchStudentFilters.collegStates=$scope.CurrState;
        }
        else{
            $scope.searchStudentFilters.collegStates=[];
        }
        if($scope.instState != undefined && $scope.instState !=''){
            $scope.searchStudentFilters.collegeCity=$scope.instState;
        }
        else{
            $scope.searchStudentFilters.collegeCity=[];
        }
        if($scope.inst != undefined && $scope.inst !=''){
            $scope.searchStudentFilters.collegeName=$scope.inst;
        }
        else{
            $scope.searchStudentFilters.collegeName=[];
        }
        if($scope.course != undefined && $scope.course !=''){
            $scope.searchStudentFilters.Course=$scope.course;
        }
        else{
            $scope.searchStudentFilters.Course=[];
        }
        
        if($scope.courseYear != undefined && $scope.courseYear !=''){
            $scope.searchStudentFilters.courseYear=$scope.courseYear;
        }
        else{
            $scope.searchStudentFilters.courseYear=[];
        }
        
        if($scope.cRate != undefined && $scope.cRate !=''){
            $scope.searchStudentFilters.collegeRating=$scope.cRate;
        }
        else{
            $scope.searchStudentFilters.collegeRating=[];
        }
        //gourab
        /*if($scope.cExam != undefined && $scope.cExam !=''){
            $scope.searchStudentFilters.examNameList=$scope.cExam;
        }
        else{
            $scope.searchStudentFilters.examNameList='';
        } */
        
        //gourab
        /* if($scope.cRank != undefined && $scope.cRank !=''){
            $scope.searchStudentFilters.ExamRankList=$scope.cRank;
        }
        else{
            $scope.searchStudentFilters.ExamRankList='';
        }*/
        //gourab
        if($scope.cScholor != undefined && $scope.cScholor !=''){
            $scope.searchStudentFilters.ScholarshipAmountList=$scope.cScholor;
        }
        else {
            $scope.searchStudentFilters.ScholarshipAmountList='';
        }
        
        //gourab
        if($scope.cPriority != undefined && $scope.cPriority !=''){
            $scope.searchStudentFilters.priorityList=$scope.cPriority;
        }
        else {
            $scope.searchStudentFilters.priorityList='';
        }
        
        
        if($scope.branch != undefined && $scope.branch !=''){
            $scope.searchStudentFilters.branchList=$scope.branch;
        }
        else{
            $scope.searchStudentFilters.branchList=[];
        }
        if($scope.gender != undefined && $scope.gender !=''){
            $scope.searchStudentFilters.genderList=$scope.gender;
        }
        else{
            $scope.searchStudentFilters.genderList=[];
        }
        
        if($scope.FFEUIDofStudent != undefined && $scope.FFEUIDofStudent != '' && isone == 2){
            $scope.searchStudentFilters.FFEUId=$scope.FFEUIDofStudent;
        }
        else{
            $scope.searchStudentFilters.FFEUId=null;
        }
        $scope.searchStudentFilters.minIncome=$scope.income.minValue;
        $scope.searchStudentFilters.maxIncome=$scope.income.maxValue;
        console.log('searchStudent :$scope.donorID:  '+$scope.donorID);
        console.log('searchStudent :$scope.searchStudentFilters:  '+JSON.stringify($scope.searchStudentFilters));
        var donorIdValue = $scope.donorID;
        if(!(donorIdValue != undefined && donorIdValue != null)){
            donorIdValue = '';
        }
        DN_DonorAllocation_CTRL.getFilteredStudents($scope.searchStudentFilters,donorIdValue,function(result,event){
            if(event.status){
                $scope.StudentsDetails=result;
                console.log($scope.StudentsDetails);
                if(result.length>0){
                    $scope.showNoresults=false;
                    for(var i=0; i<$scope.StudentsDetails.length;i++){
                        $scope.StudentsDetails[i].selectedStudent=false;
                        $scope.StudentsDetails[i].Funding_amount__c = $scope.StudentsDetails[i].Student__r.ScholarshipAmount__c;
                        var ts = $scope.StudentsDetails[i].Approval_Date__c;
                        ts = Number(ts); // cast it to a Number
                        var date = new Date(ts); // works 
                        
                        var date = new Date(date.toString()),
                            mnth = ("0" + (date.getMonth()+1)).slice(-2),
                            day  = ("0" + date.getDate()).slice(-2);
                        var resulttt = [ date.getFullYear(), mnth, day ].join("-");
                        
                        $scope.StudentsDetails[i].Approval_Date__c = resulttt;
                    }
                }
                else{
                    $scope.showNoresults=true;
                }
                $scope.loading=false;
                $scope.$apply();
            } 
            else{
                $scope.loading=false;
                $scope.$apply();
                swal({title:'',text:"Oops! something went wrong."});
            }
        },{escape:false}); 
    }
    
    
    $scope.clearFFEuid = function(){
        $scope.FFEUIDofStudent = '';
        $scope.showNoresults=false;
        $scope.StudentsDetails='';
        
        $scope.selectAll.isTrue = false;
    }
    
    $scope.clearStudent =function(){
        $scope.selectAll.isTrue = false;
        $scope.FFEUIDofStudent = '';
        $scope.showNoresults=false;
        $scope.StudentsDetails='';
        $scope.permState='';
        $scope.instState='';
        $scope.inst='';
        $scope.course='';
        $scope.cRate='';
        $scope.CurrState='';
        $scope.gender='';
        $scope.branch='';
        $scope.cExam='';
        $scope.cRank='';
        $scope.cScholor='';
        $scope.cPriority = '';
        $scope.isInst=false;
        $scope.isIState=false;
        $scope.isSelectedpState				 	= true;
        $scope.isSelectedcState					= true;
        $scope.isSelectediState					= true;
        $scope.isSelectedinstit					= true;
        $scope.isSelectedcours					= true;
        $scope.isSelectedcoursYear              = true;
        $scope.isSelectedrating					= true;
        $scope.isSelectedGender					= true;
        $scope.isSelectedbranch					= true;
        $scope.isSelectedexam					= true;
        $scope.isSelectedRank					= true;
        $scope.isSelectedSch					= true;
        $scope.income = {
            minValue: 0,
            maxValue: parseInt($scope.maxFamilyIncome),
            options: {
                floor: 0,
                ceil: parseInt($scope.maxFamilyIncome),
                step: 5000,
                translate: function(minValue) {
                    minValue= minValue.toLocaleString();
                    return minValue;
                },
                translate: function(maxValue) {
                    maxValue= maxValue.toLocaleString();
                    return maxValue;
                }
            }
        };
        // $scope.getMatchStudents();
    }
    $scope.RenewalselectedStudentsCount = 0;
    $scope.RenewalselectedStudentsTotalSum = 0;
    
    $scope.selectAllRen = function(selectallTrue){
        $scope.RenewalselectedStudentsCount = 0;
        $scope.RenewalselectedStudentsTotalSum = 0;
        if(selectallTrue == true){
            for(var i=0; i<$scope.StudentsDetailsReviewDetails.length;i++){
                $scope.StudentsDetailsReviewDetails[i].currentApp.selectedStudent=true;
                $scope.selectedStudents.push($scope.StudentsDetailsReviewDetails[i]);
                $scope.RenewalselectedStudentsCount = $scope.StudentsDetailsReviewDetails.length;
                $scope.RenewalselectedStudentsTotalSum = $scope.RenewalselectedStudentsTotalSum + $scope.StudentsDetailsReviewDetails[i].currentApp.Funding_amount__c;
                
            }
        }else{
            for(var i=0; i<$scope.StudentsDetailsReviewDetails.length;i++){
                $scope.StudentsDetailsReviewDetails[i].currentApp.selectedStudent=false;
                $scope.selectedStudents=[];
            } 
        }
    }
    
    $scope.selectStudentRenew = function(selectTrue,value){
        if(selectTrue == false){
            $scope.selectAllRen.isTrueRen = false;
        }
        
        if(value.selectedStudent){
            $scope.RenewalselectedStudentsCount = parseInt($scope.RenewalselectedStudentsCount) + 1;
            $scope.RenewalselectedStudentsTotalSum = parseInt($scope.RenewalselectedStudentsTotalSum) + parseInt(value.Funding_amount__c);
        }else{
            $scope.RenewalselectedStudentsCount = parseInt($scope.RenewalselectedStudentsCount) -1;
            $scope.RenewalselectedStudentsTotalSum = parseInt($scope.RenewalselectedStudentsTotalSum) - parseInt(value.Funding_amount__c);
        }
        
    }
    $scope.selectedStudentsCount = 0;
    $scope.selectedStudentsTotalSum = 0;
    
    $scope.selectAll = function(selectallTrue){
        $scope.selectedStudentsCount = 0;
        $scope.selectedStudentsTotalSum = 0;
        if(selectallTrue == true){
            for(var i=0; i<$scope.StudentsDetails.length;i++){
                $scope.StudentsDetails[i].selectedStudent=true;
                $scope.selectedStudents.push($scope.StudentsDetails[i]);
                $scope.selectedStudentsCount = $scope.StudentsDetails.length;
                $scope.selectedStudentsTotalSum = $scope.selectedStudentsTotalSum + $scope.StudentsDetails[i].Funding_amount__c;
            }
        }else{
            for(var i=0; i<$scope.StudentsDetails.length;i++){
                $scope.StudentsDetails[i].selectedStudent=false;
                $scope.selectedStudents=[];
            } 
        }
    }
    
    $scope.selectStudent = function(value,index){  
        
        if(value.selectedStudent){
            $scope.selectedStudentsCount = parseInt($scope.selectedStudentsCount) + 1;
            $scope.selectedStudentsTotalSum = parseInt($scope.selectedStudentsTotalSum) + parseInt(value.Funding_amount__c);
        }else{
            $scope.selectedStudentsCount = parseInt($scope.selectedStudentsCount) -1;
            $scope.selectedStudentsTotalSum = parseInt($scope.selectedStudentsTotalSum) - parseInt(value.Funding_amount__c);
        }
        
        
        
        if(!value.selectedStudent){
            $scope.selectAll.isTrue = false;
        }
        
        if($scope.StudentsDetails[index].selectedStudent){
            if($scope.selectedStudents.indexOf(value) == -1) {
                $scope.selectedStudents.push(value);
            }
        }
        else{
            var i = $scope.selectedStudents.indexOf(value);
            if(i != -1) {
                $scope.selectedStudents.splice(i, 1);
            }
        }
        //alert($scope.StudentsDetails.length);
        //alert($scope.selectedStudents.length);
        if($scope.selectedStudents.length == $scope.StudentsDetails.length){
            $scope.selectAll.isTrue = true;
        }
    }
    $scope.save_multiDonor= function(){
        console.log('save_multiDonor: selected application : '+JSON.stringify($scope.selectedApplications[0]));
        
        $scope.appList = [];
        $scope.selectedStudentsCount = 0;
        $scope.selectedStudentsTotalSum = 0;
        $scope.IsFundAmtGreater 	= false;
        $scope.IsNegativeNumber 	= false;
        $scope.selectAll.isTrue = false;
        
        if(!($scope.selectedDonors != undefined && $scope.selectedDonors.length > 0)){
            swal({title:'',text:"No rows selected."});
            return true;
        }
        if($scope.totalScholarshipAmount - $scope.totalEnteredAmount != 0){
            swal({title:'',text:"Mapping still pending. Please map the entire amount."});
            return true;
        }
        
        var donorBalanceList = [];
        var donorAppList = [];
        for(var i=0;i<$scope.selectedDonors.length;i++){
            // update donor balances
            var donorBalanceMap = {"donorBalanceId" : "","Mapped_Fund__c":""};
            donorBalanceMap.donorBalanceId = $scope.selectedDonors[i].donorBalanceId;
            donorBalanceMap.Mapped_Fund__c = $scope.selectedDonors[i].Mapped_Fund__c;
            donorBalanceList.push(donorBalanceMap); 
            // create donor app mappings
            var donorAppMap = {"Application__c" : "","Donor__c":"","Funding_amount__c" : "","Student__c":"","gauName":"","Donor_Remark__c":""};
            donorAppMap.Application__c = $scope.selectedApplications[0].Id;
            donorAppMap.Donor__c  = $scope.selectedDonors[i].donorInfo.Id;
            donorAppMap.Funding_amount__c = $scope.selectedDonors[i].Mapped_Fund__c;
            donorAppMap.Student__c = $scope.selectedApplications[0].Student__c; 
            donorAppMap.gauName = $scope.selectedDonors[i].gauName;
            donorAppMap.Donor_Remark__c = $scope.selectedDonors[i].Donor_Remark__c;
            donorAppList.push(donorAppMap);
        }
        console.log('donorBalanceList : '+JSON.stringify(donorBalanceList));
        console.log('donorAppList : '+JSON.stringify(donorAppList));
        //donorAppList : [{"Application__c":"a0nO0000005gfS1IAI","Donor__c":"0036F000028jKhTQAU","Funding_amount__c":10,"Student__c":"003O000001Fg5BwIAJ","gauName":"Offline Donation - General Funds of the Trust (723 - FCRA)","Donor_Remark__c":"ten"},{"Application__c":"a0nO0000005gfS1IAI","Donor__c":"0036F000028jKhTQAU","Funding_amount__c":20,"Student__c":"003O000001Fg5BwIAJ","gauName":"Offline Donation - General Funds of the Trust (598 - Non FCRA)","Donor_Remark__c":"twenty"}]
        //donorBalanceList : [{"donorBalanceId":"a0rO0000005ejf2IAA","Mapped_Fund__c":10},{"donorBalanceId":"a0rO0000005elBuIAI","Mapped_Fund__c":20}]
        
        $scope.loading=true;
        DN_DonorAllocation_CTRL.save_multiDonor(donorBalanceList,donorAppList,function(result,event){
            if(event.status){
                $scope.selectedDonors=[];
                //$scope.studentPopup=false;
                // swal({title:'',text:result});
                //$scope.getMatchStudents();
                $scope.loading=false;
                $scope.$apply();
                alert(result);
                location.reload();
                
                
            }
            else{
                $scope.loading=false;
                swal({title:'',text:"Oops! something went wrong."});
            }
        },{escape:false});
        
        
    }
    $scope.checkDisburseAmount = function(value,index){
        value.selectedDonor = false;
        if(value.Mapped_Fund__c > (value.currentBalance - value.mappedFund)){ 
            
            var i = $scope.selectedDonors.indexOf(value);
            if(i != -1) {
                $scope.selectedDonors.splice(i, 1);
                //$scope.totalEnteredAmount -= value.Mapped_Fund__c;
            }
            value.selectedDonor = false;
            if(value.Mapped_Fund__c > value.currentBalance)
                swal({title:'',text:'Disburse Amount cannot be greater than Current Balance.'}); 
            else
                swal({title:'',text:'Amount exhausted. Please crosscheck.'});
            value.Mapped_Fund__c = 0;
            return;
        }
        if(!(value.Mapped_Fund__c != undefined && value.Mapped_Fund__c > 0)){ 
            
            var i = $scope.selectedDonors.indexOf(value);
            if(i != -1) {
                $scope.selectedDonors.splice(i, 1);
               // $scope.totalEnteredAmount -= value.Mapped_Fund__c;
            }
            value.selectedDonor = false;
            value.Mapped_Fund__c = 0;
            swal({title:'',text:'Disburse Amount should be greater than 0.'}); 
            return;
        }
       
        //console.log('Selected Donors : '+JSON.stringify($scope.selectedDonors));
    }
   
    $scope.selectDonor = function(value,index){  
        
        //console.log('index : '+index);
        // console.log('$scope.matchedDonors[index] : '+JSON.stringify($scope.matchedDonors[index]));
        
        if($scope.matchedDonors[index].selectedDonor){
            if($scope.matchedDonors[index].Mapped_Fund__c > ($scope.matchedDonors[index].currentBalance - $scope.matchedDonors[index].mappedFund)){
                var i = $scope.selectedDonors.indexOf(value);
                if(i != -1) {
                    $scope.selectedDonors.splice(i, 1);
                }
                $scope.matchedDonors[index].selectedDonor = false;
                swal({title:'',text:'Disburse Amount cannot be greater than Current Balance.'}); 
                return;
            }
            if(!($scope.matchedDonors[index].Mapped_Fund__c != undefined && $scope.matchedDonors[index].Mapped_Fund__c > 0)){
                
                var i = $scope.selectedDonors.indexOf(value);
                if(i != -1) {
                    $scope.selectedDonors.splice(i, 1);
                }
                $scope.matchedDonors[index].selectedDonor = false;
                swal({title:'',text:'Disburse Amount should be greater than 0.'}); 
                return;
            }
            
           
            $scope.matchedDonors[index].isReadOnly = true;
            $scope.totalEnteredAmount += value.Mapped_Fund__c;
             if($scope.totalEnteredAmount > $scope.totalScholarshipAmount){
                swal({title:'',text:'Total Amount is greater than the Scholarship amount.'}); 
                $scope.totalEnteredAmount -= value.Mapped_Fund__c;
                $scope.matchedDonors[index].isReadOnly = false;
                $scope.matchedDonors[index].selectedDonor = false;
                return;
            }
            $scope.selectedDonors.push(value);
           
        }
        else{
            
            var i = $scope.selectedDonors.indexOf(value);
            if(i != -1) {
                $scope.matchedDonors[index].isReadOnly = false;
                $scope.selectedDonors.splice(i, 1);
              
                $scope.totalEnteredAmount -= value.Mapped_Fund__c;
            }
        }
        //console.log('Selected Donors : '+JSON.stringify($scope.selectedDonors));
    }
    
    
    $scope.appList = [];
    
    $scope.save= function(){
        $scope.appList = [];
        $scope.selectedStudentsCount = 0;
        $scope.selectedStudentsTotalSum = 0;
        $scope.IsFundAmtGreater 	= false;
        $scope.IsNegativeNumber 	= false;
        $scope.selectAll.isTrue = false;
        for(var i=0;i<$scope.selectedStudents.length;i++){
            $scope.appDonorInfowrapper = {};
            $scope.appDonorInfowrapper.appId = $scope.selectedStudents[i].Id;
            if($scope.selectedStudents[i].Funding_amount__c != undefined){
                if($scope.selectedStudents[i].Funding_amount__c > 0){
                    if($scope.selectedStudents[i].Funding_amount__c > $scope.selectedStudents[i].Student__r.ScholarshipAmount__c){
                        $scope.IsFundAmtGreater = true;
                    }else{
                        $scope.appDonorInfowrapper.fundingAmount = $scope.selectedStudents[i].Funding_amount__c; 
                    } 
                }else{
                    $scope.IsNegativeNumber = true;
                }
            }            
            $scope.appDonorInfowrapper.donorRemark = $scope.selectedStudents[i].Donor_Remark__c;
            $scope.appList.push($scope.appDonorInfowrapper);
        }
        //if($scope.IsNegativeNumber){
        //  swal({title:'',text:'Funding Amount can\'t be less than zero. Please review the selected rows.'});
        //return true;
        //}
        if($scope.IsFundAmtGreater){
            swal({title:'',text:'Funding Amount can\'t be more than Approved Scholarship Amount. Please review the selected rows.'});
            return true;
        }        
        
        if($scope.selectedStudents.length>0){
            $scope.loading=true;
            DN_DonorAllocation_CTRL.createDonorStudentMapping($scope.donorID,$scope.appList,function(result,event){
                if(event.status){
                    $scope.search();
                    $scope.selectedStudents=[];
                    $scope.studentPopup=false;
                    swal({title:'',text:result});
                    //$scope.getMatchStudents();
                    $scope.loading=false;
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                    swal({title:'',text:"Oops! something went wrong."});
                }
            },{escape:false}); 
        }
        else{
            swal({title:'',text:"No row selected."});
        }
        window.reload();
    }
    
    $scope.goByDonor = function(bydonor){
        if(bydonor!=undefined && bydonor !=''){
            if(bydonor.length <2){
                swal({title:'',text:'Please enter atleast two characters.'});
                return;
            }
            $scope.matchedDonors =[];
            for(var i=0;i<$scope.donorDetails.length;i++){
                if($scope.donorDetails[i].donorInfo.Name.toLowerCase().indexOf(bydonor.toLowerCase()) == 0){
                    $scope.matchedDonors.push($scope.donorDetails[i]);
                }
            }
            if(!($scope.matchedDonors.length > 0)){
                swal({title:'',text:'No Donors found.'});
            }
        }
        else{
            $scope.matchedDonors=$scope.donorDetails;
            swal({title:'',text:'Please enter value.'})
        }
    }
    
    $scope.getCityList = function(__country){
        $scope.clear(); 
        $scope.listOfStates	= [];
        $scope.listStates	= [];
        
        $scope.loading=true;
        DN_DonorAllocation_CTRL.getStateList(__country,function(result,event){
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
});