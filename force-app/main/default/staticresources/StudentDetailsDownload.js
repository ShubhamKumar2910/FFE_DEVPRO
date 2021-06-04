var app = angular.module('StudentResumeDetailsForDonor', ['ngRoute','ngAnimate','ngMaterial','rzModule']);

app.controller('studentResumeController', function($scope, $timeout, $window, $location,$element  ) {
    
    
    window.onload = function(){
        $scope.getGauDetails();
        $scope.getfinancilaYearDetails();
        debugger;
    }
    $scope.studentResumeList =[];
    $scope.display = false;
    $scope.gauNames = [];
    $scope.finYears = [];
    $scope.StudentData = [];
    $scope.studentResumeList =[];
    $scope.Fyear ='';
    $scope.getGauDetails = function(){
        ViewStudentHelper.getGauNames(function(result,event){
            if(event.status){
                $scope.gauNames = result;
                $scope.$apply();
            }
        },{escape:false});
    }
    $scope.getfinancilaYearDetails = function(){
        ViewStudentHelper.getfinancilaYearDetails(function(result,event){
            if(event.status){
                $scope.finYears = result;
                $scope.$apply();
            }
        },{escape:false});
    }
    
    $scope.searchStudents = function(gauSelected,finYearSelected){
        if(gauSelected == undefined || gauSelected == ''){
            swal({title:'',
                          text:'Please Select GAU'});return;
        }
        if(finYearSelected == undefined || finYearSelected == ''){
            swal({title:'',
                          text:'Please Select Financial Year'});return;
        }
        $scope.loading = true;
        $scope.Fyear = finYearSelected;
        var url = new URL(window.location.href);
        var donorId = url.searchParams.get("id");
        ViewStudentHelper.stdentData(finYearSelected,gauSelected,donorId,function(result,event){
            if(event.status){
                $scope.studentResumeList = JSON.parse(result);
                $scope.display = true;
                $scope.loading = false;
                $scope.$apply();
                
            }
        },{escape:false});
        
    }
    
    
    $scope.attchIDsList = [];
    $scope.selectAttachments = function(attchLinkIds,isSelected){
        if(isSelected){
            $scope.attchIDsList.push(attchLinkIds);
            if($scope.attchIDsList.length == $scope.studentResumeList.length){
                $scope.selectAll=true;
            }
        }else{
            $scope.selectAll=false;
            const index = $scope.attchIDsList.indexOf(attchLinkIds);
            $scope.attchIDsList.splice(index, 1);
        }
    }
    
    $scope.selectAllAttachment = function(isAllSelected){
        $scope.attchIDsList = [];
        
        for(var i=0;i<$scope.studentResumeList.length;i++){
            if(isAllSelected){
                $scope.attchIDsList.push($scope.studentResumeList[i].AttachmentLink);
                $scope.studentResumeList[i].isSelected = true;
            }else{
                $scope.attchIDsList = [];
                $scope.studentResumeList[i].isSelected = false;
            }
        }
    }
    
    
    $scope.downloadSelectedAttchments = function(){
        debugger;
        if($scope.attchIDsList.length>0){
            
            $scope.selectStudentResumes = [];
            for(var i=0;i<$scope.studentResumeList.length;i++){
                if($scope.attchIDsList.includes($scope.studentResumeList[i].AttachmentLink)){
                    $scope.selectStudentResumes.push($scope.studentResumeList[i]);
                }
            }
            console.log($scope.selectStudentResumes);
            var initial_url = window.location.href;
            var url = initial_url .split( 'StudentDataDownloadInWord?id=' );
            for(var j=0;j<$scope.selectStudentResumes.length;j++){       
                var anchorTagA=document.createElement('a');
                anchorTagA.href = url[0]+'StudentDataInMSWord?sid='+$scope.selectStudentResumes[j].AttachmentLink+'&donorId='+url[1]+'&donatedamount='+$scope.selectStudentResumes[j].donatedAmt+'&fyear='+$scope.Fyear+'&schamt='+$scope.selectStudentResumes[j].scholarshipamt;
                anchorTagA.download = $scope.selectStudentResumes[j].Name;
                document.body.appendChild(anchorTagA);  
                anchorTagA.click();
                document.body.removeChild(anchorTagA);
            }
        }else{
            swal({title:'',
				text:'Please select a student to download the profile.'});//Message change -- Sumit Gaurav -- 26-05-2020
        }
        
    }

    
});
