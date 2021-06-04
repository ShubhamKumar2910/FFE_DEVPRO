var app = angular.module('StudentResumeDetailsForDonor', ['ngRoute','ngAnimate','ngMaterial','rzModule']);

app.controller('studentResumeController', function($scope, $timeout, $window, $location,$element  ) {
    
    
    window.onload = function(){
        $scope.getResumeDetails();
        debugger;
    }
    $scope.studentResumeList =[];
    $scope.getResumeDetails = function(){
        
        StudentResumeDetailsForDon.getResumeDetails(function(result,event){
            if(event.status){
                $scope.studentResumeList = JSON.parse(result);
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
            
            for(var j=0;j<$scope.selectStudentResumes.length;j++){       
                var anchorTagA=document.createElement('a');
                //anchorTagA.href = '/servlet/servlet.FileDownload?file='+$scope.selectStudentResumes[j].AttachmentLink;
                 //anchorTagA.href = '{!URLFOR($Action.Attachment.Download,'+$scope.selectStudentResumes[j].AttachmentLink+')}';
                //above tow lines if inside salesforce, but through site use below code
                anchorTagA.href = '/application/servlet/servlet.FileDownload?file='+$scope.selectStudentResumes[j].AttachmentLink;
                anchorTagA.download = $scope.selectStudentResumes[j].Name;
                document.body.appendChild(anchorTagA);  
                anchorTagA.click();
                document.body.removeChild(anchorTagA);
            }
        }else{
            swal({title:'',
                          text:'Requesting you to Select some resumes for downloading.'});
        }
        
    }
    
    
    
});