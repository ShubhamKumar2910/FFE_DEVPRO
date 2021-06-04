var app = angular.module('TrainingAndSkillDevelopment', ['ngRoute','ngAnimate','ngMaterial','rzModule']);

app.filter('true_false', function() {
    return function(text, length, end) {
        if (text) {
            return 'Yes';
        }
        return 'No';
    }
});

app.controller('trainingSkillDevelopment', function($scope, $timeout, $window, $location,$element  ) {
    
    $scope.CourseBEBTechYear = [];  
    for(var i=0; i<CourseBEBTechYear.length ; i++)
        $scope.CourseBEBTechYear.push({uKey:i,value:CourseBEBTechYear[i]});
    //$scope.yearSelected = $scope.CourseBEBTechYear[0].value; 
    
    $scope.selected = 0;
    $scope.displaySecondYearEnglishData = false; 
    $scope.displaySecondYearAptitudeData = false; 
    $scope.displaySecondYearAllData = false;
    $scope.preandpostAsses = false;
    $scope.preandpostAsses_midline = false;
    $scope.mocktable = false; 
    $scope.preandpostAsses_endline = false;
    
    $scope.secondyear = false;
    $scope.thirdyear = false;
    $scope.thirdYearEng = false;
    $scope.tgirdYearIT = false;
    $scope.fourthyear = false;
    $scope.fourthYearTechandHR = false;
    $scope.isemptyMessage = true;
    $scope.secondYearAmcatPreandPostLenght = 0;
    $scope.secondYearEnglishLength = 0;
    $scope.secondYearAptitudeLength = 0;
    $scope.secondYearAspiringLength = 0;
    $scope.getThirdYearDataEnglish = 0;
    $scope.getThirdYearDataIT = 0;
    $scope.getfourthYearDataHR =0;
    $scope.getfourthYearDataTech =0;
    $scope.getfourthYearDataHRAndTech = 0;
    $scope.yearIsSelected = true;
    $scope.placedStudentsCount = 0;
    $scope.mockInterViewCount = 0;
    $scope.showcourses='';
    $scope.midline = 0;
    $scope.endline = 0;
    
    window.onload = function(){
        debugger;
        $scope.getPlacementInformation();
        $scope.getSecondYearData();
        $scope.getThirdYearApirationalLength();
        $scope.getThirdYearMockInterview();
        $scope.englishAndAptitudeAppData('English');
        $scope.englishAndAptitudeAppData('Aptitude');
        $scope.englishAndAptitudeAppData('Aspiring Program');
        
        $scope.getfourthYearData('Mock Interview HR');
        $scope.getfourthYearData('Mock Interview Tech');
        $scope.getfourthYearData('All');
        $scope.getThirdYearData_length();
        $scope.getThirdYearDataEnglishValue();
        $scope.getfourthYearData_length();
        
        $scope.isemptyMessage = true;
    }
    
    
    
    $scope.backToSummary = function(){
        $scope.loading=true;
        $scope.secondyear = false;
        $scope.thirdyear = false;
        $scope.fourthyear = false;
        $scope.yearIsSelected = true;
        $scope.isemptyMessage = true;
        $scope.yearSelected = '';
        $scope.loading=false;
    }
    
    $scope.selectYear = function(){
        debugger;
        if($scope.yearSelected == '2nd Year'){
            $scope.thirdyear = false;
            $scope.fourthyear = false;
            $scope.secondyear = true;
            $scope.selected = 0;
            $scope.yearIsSelected = false;
            $scope.getSecondYearData_1();
            
        }else if($scope.yearSelected == '3rd Year'){
            
            $scope.secondyear = false;
            $scope.fourthyear = false;
            $scope.thirdyear = true;
            $scope.selected = 0;
            $scope.yearIsSelected = false;
            $scope.getThirdYearData_new();
            // $scope.getThirdYearData('English');
            
        }else if($scope.yearSelected == '4th Year'){
            
            $scope.secondyear = false;
            $scope.thirdyear = false;
            $scope.fourthyear = true;
            $scope.selected = 0;
            $scope.yearIsSelected = false;
            $scope.getfourthYearData_new();
            // $scope.getfourthYearData('Mock Interview HR');
        }
    }
    
    $scope.getThirdYearMockInterview = function() {
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getMockinterViewRecordForThirdYear(function(result,event){
            if(event.status){
                console.log(result);
                if(result != null ) {
                    $scope.mockInterViewCount = result;
                    $scope.preandpostAsses = true; 
                    $scope.isemptyMessage = true;
                }
                else {
                    $scope.isemptyMessage = false;
                }
                
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    $scope.getThirdYearData_length = function() {
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getThirdYearDataLength(function(result,event){
            if(event.status){
                console.log(result);
                if(result != null ) {
                    $scope.midline = result;
                    $scope.preandpostAsses = true; 
                    $scope.isemptyMessage = true;
                }
                else {
                    $scope.isemptyMessage = false;
                }
                
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    $scope.getfourthYearData_length = function() {
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getFourthYearDataLength(function(result,event){
            if(event.status){
                console.log(result);
                if(result != null ) {
                    $scope.endline = result;
                    $scope.preandpostAsses = true; 
                    $scope.isemptyMessage = true;
                }
                else {
                    $scope.isemptyMessage = false;
                }
                
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    $scope.getThirdYearApirationalLength = function() {
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getThirdYearApirationalLength(function(result,event){
            if(event.status){
                console.log(result);
                if(result != null ) {
                    $scope.getThirdYearDataIT =result;
                    $scope.tgirdYearIT = true; 
                    $scope.preandpostAsses = true; 
                    $scope.isemptyMessage = true;
                }
                else {
                    $scope.isemptyMessage = false;
                }
                
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    
    
    $scope.getThirdYearMockInterviewDetail = function(){
        //$scope.displaySecondYearEnglishData = false; 
        //$scope.displaySecondYearAptitudeData = false;
        //$scope.displaySecondYearAllData = false;
        debugger;
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getMockInterViewRecordDetailForThirdYear(function(result,event){
            if(event.status){
                 $scope.tgirdYearIT = false;
                    $scope.thirdYearEng = false;
                    $scope.preandpostAsses_midline = false;
                $scope.mockList	= JSON.parse(result);
                if($scope.mockList.length > 0){
                    $scope.mocktable = true; 
                   
                    
                    $scope.isemptyMessage = true;
                    
                    
                }else{
                    $scope.isemptyMessage = false;
                }
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    $scope.getSecondYearData = function(){
        debugger;
        $scope.displaySecondYearEnglishData = false; 
        $scope.displaySecondYearAptitudeData = false;
        $scope.displaySecondYearAllData = false;
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getSecondYearDataLength(function(result,event){
            if(event.status){
                console.log(result);
                if(result != null ) {
                    $scope.secondYearAmcatPreandPostLenght = result;
                    $scope.preandpostAsses = true; 
                    $scope.isemptyMessage = true;
                }
                else {
                    $scope.isemptyMessage = false;
                }
                
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    $scope.getSecondYearData_1 = function(){
        $scope.displaySecondYearEnglishData = false; 
        $scope.displaySecondYearAptitudeData = false;
        $scope.displaySecondYearAllData = false;
        $scope.loading=true;
        TrainingAndSkillDevelopment_CTRL.getSecondYearData(function(result,event){
            if(event.status){
                $scope.studentList	= JSON.parse(result);
                if($scope.studentList.length > 0){
                    // $scope.secondYearAmcatPreandPostLenght = $scope.studentList.length;
                    $scope.preandpostAsses = true; 
                    $scope.isemptyMessage = true;
                }else{
                    $scope.isemptyMessage = false;
                }
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    $scope.getThirdYearData_new = function(){
        //$scope.displaySecondYearEnglishData = false; 
        //$scope.displaySecondYearAptitudeData = false;
        //$scope.displaySecondYearAllData = false;
        $scope.loading=true;
        $scope.tgirdYearIT = false;
        TrainingAndSkillDevelopment_CTRL.getThirdYearData_1(function(result,event){
            if(event.status){
                $scope.studentList	= JSON.parse(result);
                if($scope.studentList.length > 0){
                    
                    $scope.midline = $scope.studentList.length;
                    $scope.preandpostAsses_midline = true; 
                    $scope.isemptyMessage = true;
                    $scope.tgirdYearIT = false;
                    $scope.thirdYearEng = false;
                    $scope.mocktable = false;
                }else{
                    $scope.isemptyMessage = false;
                }
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    $scope.getfourthYearData_new = function(){
        //$scope.displaySecondYearEnglishData = false; 
        //$scope.displaySecondYearAptitudeData = false;
        //$scope.displaySecondYearAllData = false;
        $scope.loading=true;
        $scope.tgirdYearIT = false;
        $scope.fourthYearTechandHR = false;
        $scope.displayPlacementData = false;
        TrainingAndSkillDevelopment_CTRL.getfourthYearData_1(function(result,event){
            if(event.status){
                $scope.studentList	= JSON.parse(result);
                console.log($scope.studentList);
                if($scope.studentList.length > 0){
                    
                    $scope.endline = $scope.studentList.length;
                    $scope.preandpostAsses_endline = true; 
                    $scope.isemptyMessage = true;
                    $scope.tgirdYearIT = false;
                }else{
                    $scope.isemptyMessage = false;
                }
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    $scope.getThirdYearData = function(trainingType){
        $scope.loading=true;
        $scope.preandpostAsses_midline = false;
        TrainingAndSkillDevelopment_CTRL.getThirdYearData(trainingType,function(result,event){
            if(event.status){
                
                if(trainingType == 'Aspiring English'){
                    $scope.studentThirdYearEngList	= JSON.parse(result);
                    $scope.tgirdYearIT = false;
                    if($scope.studentThirdYearEngList.length>0){
                        $scope.getThirdYearDataEnglish = $scope.studentThirdYearEngList.length;
                        $scope.thirdYearEng = true;
                        $scope.mocktable = false;
                        $scope.isemptyMessage = true;
                        $scope.$apply();
                    }else{
                        $scope.isemptyMessage = false;
                    }
                }else if(trainingType == 'IT'){
                    $scope.thirdYearEng = false;
                    $scope.studentThirdYearIT	= JSON.parse(result); 
                    if($scope.studentThirdYearIT.length>0){
                        $scope.getThirdYearDataIT = $scope.studentThirdYearIT.length;
                        $scope.mocktable = false; 
                        $scope.tgirdYearIT = true;
                        $scope.isemptyMessage = true;
                        $scope.$apply();
                    }else{
                        $scope.isemptyMessage = false;
                    }
                }
                
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
        
    }
    
    
    $scope.getThirdYearDataEnglishValue = function(){
        $scope.loading=true;
        $scope.preandpostAsses_midline = false;
        TrainingAndSkillDevelopment_CTRL.getThirdYearDataEnglisLength(function(result,event){
            if(event.status){
                
                if(result != null){
                    
                    $scope.tgirdYearIT = false;
                    
                    $scope.getThirdYearDataEnglish = result;
                    $scope.thirdYearEng = true;
                    $scope.isemptyMessage = true;
                    $scope.$apply();
                }else{
                    $scope.isemptyMessage = false;
                }
                
                
                
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
        
    }
    
    
    
    
    $scope.getfourthYearData = function(trainingType){
        console.log('trainingType : '+trainingType);
        $scope.loading=true;$scope.displayPlacementData = false;
        $scope.preandpostAsses_endline = false; 
        TrainingAndSkillDevelopment_CTRL.getfourthYearData(trainingType,function(result,event){
            if(event.status){
                console.log('result : '+JSON.parse(result));
                if(trainingType == 'Mock Interview HR'){
                    $scope.studentfourthYearHRList	= JSON.parse(result);
                    $scope.fourthYearTech = false;
                    $scope.fourthYearTechandHR = false;
                    if($scope.studentfourthYearHRList.length>0){
                        $scope.getfourthYearDataHR =$scope.studentfourthYearHRList.length;
                        $scope.fourthYearHR = true;
                        $scope.isemptyMessage = true;
                        $scope.$apply();
                    }else{
                        $scope.isemptyMessage = false;
                    }
                }else if(trainingType == 'Mock Interview Tech'){
                    $scope.fourthYearHR = false;
                    $scope.fourthYearTechandHR = false;
                    $scope.studentfourthYearTechList	= JSON.parse(result);
                    if($scope.studentfourthYearTechList.length>0){
                        $scope.getfourthYearDataTech =$scope.studentfourthYearTechList.length;
                        $scope.fourthYearTech = true;
                        $scope.isemptyMessage = true;
                        $scope.$apply();
                    }else{
                        $scope.isemptyMessage = false;
                    }
                }else if(trainingType == 'All'){
                    $scope.studentfourthYearHRTechList	= JSON.parse(result);
                    $scope.fourthYearHR = false;
                    $scope.fourthYearTech = false;
                    if($scope.studentfourthYearHRTechList.length>0){
                        $scope.getfourthYearDataHRAndTech = $scope.studentfourthYearHRTechList.length;
                        $scope.fourthYearTechandHR = true;
                        $scope.isemptyMessage = true;
                        $scope.$apply();
                    }else{
                        $scope.isemptyMessage = false;
                    }
                }
                
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
        
    }
    $scope.displayPlacementData = false;
    $scope.getPlacementInformation = function(){
        TrainingAndSkillDevelopment_CTRL.getPlacementStudentData(function(result,event){
            if(event.status){
                $scope.studentPlacementList	= JSON.parse(result);
                $scope.displayPlacementData = true;
                $scope.fourthYearTechandHR = false;
                $scope.fourthYearTech = false;
                $scope.fourthYearHR = false;
                $scope.isemptyMessage = true;
                $scope.placedStudentsCount = $scope.studentPlacementList.length;
                if($scope.studentPlacementList.length <= 0){
                    $scope.displayPlacementData = false;
                    $scope.isemptyMessage = false;
                }
                $scope.$apply();
            }
            $scope.loading=false;
            $scope.$apply();
        },{escape:false}); 
    }
    
    
    
    
    $scope.englishAndAptitudeAppData = function(trainingType){
        debugger;
        $scope.loading=true;
        $scope.preandpostAsses = false;
        if(trainingType != 'Aspiring Program'){
            TrainingAndSkillDevelopment_CTRL.englishAndAptitudeAppData(trainingType,function(result,event){
                if(event.status){
                    if(trainingType == 'English'){
                        $scope.studentwithTrainingList	= JSON.parse(result);
                        $scope.displaySecondYearAptitudeData = false;
                        $scope.displaySecondYearAllData = false;
                        
                        if($scope.studentwithTrainingList.length>0){
                            $scope.secondYearEnglishLength = $scope.studentwithTrainingList.length;
                            $scope.displaySecondYearEnglishData = true;
                            $scope.isemptyMessage = true;
                            $scope.$apply();
                        }else{
                            $scope.isemptyMessage = false;
                        }
                    }else if(trainingType == 'Aptitude'){
                        $scope.studentwithTrainingListAptitude	= JSON.parse(result);
                        $scope.displaySecondYearEnglishData = false;
                        $scope.displaySecondYearAllData = false;
                        
                        if($scope.studentwithTrainingListAptitude.length>0){
                            $scope.secondYearAptitudeLength = $scope.studentwithTrainingListAptitude.length;
                            $scope.displaySecondYearAptitudeData = true;
                            $scope.isemptyMessage = true;
                            $scope.$apply();
                        }else{
                            $scope.isemptyMessage = false;
                        }
                    }else if(trainingType == 'Aspiring Program'){
                        $scope.studentwithTrainingListAll	= JSON.parse(result);
                        $scope.displaySecondYearEnglishData = false;
                        $scope.displaySecondYearAptitudeData = false;
                        if($scope.studentwithTrainingListAll.length>0){
                            $scope.secondYearAspiringLength = $scope.studentwithTrainingListAll.length;
                            $scope.displaySecondYearAllData = true;
                            $scope.isemptyMessage = true;
                            $scope.$apply();
                        }else{
                            $scope.isemptyMessage = false;
                        }
                    }
                    
                    $scope.$apply();
                }
                $scope.loading=false;
                $scope.$apply();
            },{escape:false}); 
            
            
        }else{
            TrainingAndSkillDevelopment_CTRL.getSecondAspiringStdYearData(function(result,event){
                if(event.status){
                    if(trainingType == 'Aspiring Program'){
                        $scope.studentwithTrainingListAll	= JSON.parse(result);
                        $scope.displaySecondYearEnglishData = false;
                        $scope.displaySecondYearAptitudeData = false;
                        if($scope.studentwithTrainingListAll.length>0){
                            $scope.secondYearAspiringLength = $scope.studentwithTrainingListAll.length;
                            $scope.displaySecondYearAllData = true;
                            $scope.isemptyMessage = true;
                            $scope.$apply();
                        }else{
                            $scope.isemptyMessage = false;
                        }
                    }
                    
                    $scope.$apply();
                }
                $scope.loading=false;
                $scope.$apply();
            },{escape:false});
        }
        
        
    }
    
    
    
    $scope.showTabcontent=function(value){
        $scope.selected=value;
    }
    
    $scope.showCoursesList =[];
    
    $scope.showCoursesdetails = function(courseslist){
        $scope.showcourses = courseslist;
        var showCoursesList = $scope.showcourses.split(";");
        $scope.showCoursesList = showCoursesList;
        // alert($scope.showcourses);
        
        
    }
    
    
    
});