
var app=angular.module('Facilitator', ['ngRoute','ngAnimate','ngMaterial']);

app.controller('FacilitatorAssign', function($scope, $timeout, $window, $location,$element) {
    
    $scope.listOfStates = listOfStates;
    $scope.isStudents = false;
    $scope.facilitators=[];
    $scope.facilitatorStudent=[];
    
    
  
    $scope.getCities = function(state){
        $scope.city='';
        $scope.loading=true;
        AP_FacilitatorAssignment_CTRL.getCities(state,function(result,event){
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
    
    $scope.search = function(inputText){
        var addressType ='';
        
        if(inputText == '1'){
            addressType = 'Mailing';
        }else{
            addressType = 'Current';
        }
        
        if($scope.state !=undefined && $scope.state !=''){
            if($scope.city == undefined ){
                $scope.city ='';
            }
            $scope.loading=true;
            AP_FacilitatorAssignment_CTRL.getStudentDetails($scope.state,$scope.city,addressType,function(result,event){
                if(event.status){
                    $scope.listofstudents = JSON.parse(result);
                    console.log($scope.listofstudents);
                    if($scope.listofstudents.length > 0)
                        $scope.isStudents = true;
                    else{
                        $scope.isStudents = false;
                        swal({title:'', text:'No students available for assignment.'});
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
        else{
            swal({title:'', text:'Please select "State" filter to search.'});               
        }
        
    }
    
    $scope.clear = function(){
        $scope.state ='';
        $scope.city ='';
        $scope.isStudents = false;
        $scope.listOfCities	= [];
    }
    
    $scope.matchFacilitator = function(state,city,list){
        $scope.selectedFacilitator='';
        $scope.student=list;
        $scope.facilitatorMap =true;
        $scope.cityValue =city;
        $scope.loading=true;
        AP_FacilitatorAssignment_CTRL.getFacilitatorDetails(state,city,function(result,event){
                if(event.status){
                    $scope.listofFacilitators = JSON.parse(result);
                    console.log($scope.listofFacilitators);
                    if($scope.listofFacilitators.length > 0)
                        $scope.isFacils = true;
                    else{
                        $scope.isFacils = false;
                        swal({title:'', text:'No Facilitators available.'});
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
    
     $scope.closePopup = function(){
        $scope.facilitatorMap =false;
         $scope.selectedFacilitator='';
    }
     
     $scope.selectedRow = function(list){
         $scope.selectedFacilitator = list;
     }
     
     $scope.createMapping = function(){
         if($scope.selectedFacilitator != undefined && $scope.selectedFacilitator != ''){
         $scope.facilitatorStudent.push({facilitatorId:$scope.selectedFacilitator.Id,studentId:$scope.student.Id});
         $scope.loading=true;
         AP_FacilitatorAssignment_CTRL.createFacilitatorMapping($scope.facilitatorStudent, function(result,event){
             if(event.status){
                 $scope.loading = false;
                 swal({title:'', text:result},
                      function(isConfirm){
                          $scope.search();
                          $scope.facilitatorMap =false;
                      });
                 $scope.$apply();
             }
             else{
                 $scope.loading = false;
                 $scope.$apply();
             }
         })
         }
         else{
             swal({title:'', text:'Please select Facilitator to create mapping.'});
         }
     }
});
