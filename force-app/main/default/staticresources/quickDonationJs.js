    var app=angular.module('quickDonation', ['ngRoute','ngAnimate','textAngular','ngMaterial','rzModule']);
    
    var sitePrefix = '/donor';
    if (sitePrefix=='') sitePrefix='/donor';
    app.config( function($routeProvider, $locationProvider) {
        $locationProvider.html5Mode(false).hashPrefix('');
        $routeProvider
        
        
    });
    

    app.config(['$qProvider', function ($qProvider) {
        $qProvider.errorOnUnhandledRejections(false);
    }]);

    app.filter('fromMap', function() {
        return function(input) {
            var out = {};
            if(input != undefined) {
                input.forEach((v, k) => out[k] = v);
            }
            return out;
        }
    });

    app.controller('quickDonationCtrl', function($scope, $timeout, $window, $location, $element) {
        
        
        if($location.absUrl().includes("quickdonation")) {
            baseURL = baseURL + '/quickdonation'
        }
        $scope.imageURL = baseURL + '/resource/';
        $scope.amountFixed =[];
        $scope.donor						= {};
        $scope.formInvalid					= false;
        $scope.editRead						= true;
        $scope.selectedPrograms				= [];
        $scope.pendingPaymentLine			= [];
        $scope.deletePayment				= paymentDelete;
        $scope.minAmountReq=[];
        $scope.allFrequency =[];
        $scope.totalAMount ='';
        $scope.scholarResidenstilPickValues =scholarResidenstilPickValues;
        $scope.countryList						= countryList;
        //$scope.countrySelected                  = $scope.countryList[0].DeveloperName;
        $scope.countrySelected                  = 'India';
        $scope.listStates						= listOfStates;
        $scope.listOfStates						= [];
        $scope.indianStates						= [];
        $scope.CitizenIndian = CitizenIndian;
        $scope.CitizenNonIndian = CitizenNonIndian;
        $scope.otherCity = '';
        $scope.allDonationsMap  = new Map();
        document.getElementById('popUpDesc').style.display='none';
        for(var i=0;i<$scope.listStates.length;i++){
            $scope.listOfStates.push($scope.listStates[i].Label);
            $scope.indianStates.push($scope.listStates[i].Label);
        }
        
        $scope.onloadRemote =function(){
            $scope.loading=true;
            DN_QuickDonation.getDonationPrograms(function(result,event){ //Prithvi: changed getDonationPrograms
                if(event.status){
                    //$scope.makeDonations =result;
                    console.log(result);

                    $scope.makeDonations = new Map();
                    let onlyFirstDonation = true;
                    angular.forEach(result, function(program, key) {
                        for(var i=0; i < program.length; i++) {
                            $scope.allDonationsMap.set(program[i].Id.toString(), program[i]);
                            if(onlyFirstDonation) {
                                onlyFirstDonation = false;
                                $scope.currentDonation = program[i];
                                if(program[i].Program_Frequencys__r) {
                                    $scope.frequencies = program[i].Program_Frequencys__r;
                                    $scope.currentFrequency = program[i].Program_Frequencys__r[0];
                                }
                                    
                            }
                            if(i == 0) {
                                program[i].checked = true;
                            }else {
                                program[i].checked = false;
                            }
                            program[i].totalLineAmount=0;
                            program[i].nstudents=0;
                            
                            if(program[i].Program_Frequencys__r) {
                                $scope.allFrequency = $scope.allFrequency.concat(program[i].Program_Frequencys__r);
                                program[i].Program_Frequencys__r.forEach(function (frequency, index) {
                                    if(index == 0) {
                                        frequency.checked = true;
                                    }else {
                                        frequency.checked = false;
                                    }
                                    
                                });
                            }
                            
                        } 
                        $scope.makeDonations.set(key.toString(),program);
                    });
                    console.log($scope.allDonationsMap);
                    //console.log($scope.programFrequencies);
                }
                $scope.loading=false;
                $scope.$apply();
            },{escape:false})
        }
        
        $scope.onloadRemote();
        
        $scope.minAmountRequired = false;
        
        $scope.minAmountValidation = function(){
            console.log('minAmountValidation called');
            
            for (const frequency of $scope.allFrequency) {
                const donation = $scope.allDonationsMap.get(frequency.Program__c);
                const amount = parseInt(donation.totalLineAmount);
                if(amount >= frequency.Amount__c || amount == 0 || isNaN(amount)) {
                    $scope.minAmountRequired = false;
                }else if(frequency.checked == true){
                    $scope.minAmountRequired = true;
                    return;
                }
            }
            
        }
        
        //Prithvi : Changed
        $scope.onmouseoutpopup = function(){
            $scope.amount = parseInt($scope.currentDonation.totalLineAmount);
            if($scope.amount >= $scope.currentFrequency.Amount__c || $scope.amount == 0 || isNaN($scope.amount)){
            }else{
              //alert('Minimum donation amount for this program is::'+donNonamount.Amount__c);  
                swal({title:'',
                      text:'Minimum donation amount for this program is INR '+$scope.currentFrequency.Amount__c+''});
                
            }
        }
        
        
        $scope.tltamount = 0;
        $scope.getTotalAmount = function(){
            //
            var total = 0;

            for (let donations of $scope.makeDonations.values()) {
                angular.forEach(donations,function(donation){
                    if(!isNaN(donation.totalLineAmount) && donation.totalLineAmount != ""){
                        total += (parseInt(donation.totalLineAmount));
                    }
                });
            }

            $scope.tltamount = total;
            $scope.totalAMount = total.toLocaleString('en-IN');
            if(total>0){
                $scope.totalAmountForDonate=true;
            }
            else{
                $scope.totalAmountForDonate=false;
            }
            if(isNaN(total)){
                return 0;
            }
            else{
                return total;
            }
        }

        $scope.getNoOfstudents = function(){
            //
            var totalstudents = 0;
            for (let donations of $scope.makeDonations.values()) {
                angular.forEach(donations,function(donation){
                    if(!isNaN(donation.nstudents)){
                        const noOfStds = (parseInt(donation.nstudents));
                        if(!isNaN(noOfStds)) {
                            totalstudents += noOfStds;
                        }
                        
                    }
                });
            }
            return totalstudents;
        }
        
        
        $scope.othercityvalues = function(val){
            $scope.otherCity ='';
            $scope.otherCity = val;
            //alert($scope.otherCity);
        }
        
        $scope.donate= function(amount,students,currencytype){
            $scope.loading=true;
            if(this.donorDetails.$invalid) {
                $scope.loading=false;
                $scope.formInvalid=true;
                swal({title:'',text:"Please fill all mandatory (*) fields"});
            }
            else if($scope.emailValidation($scope.donor.Email)){
                if($scope.donor != undefined)
                    delete $scope.donor["attributes"];
                
                var orderwrp			= {};        
                $scope.cityNamee = '';
                if($scope.dislpayOtherCity == false){
                    $scope.cityNamee = $scope.locationCitySelected;
                }else{
                    $scope.cityNamee = $scope.otherCity;    
                }
                $scope.donor.MailingCity = $scope.cityNamee;
                orderwrp.donorRecord	= angular.copy($scope.donor);
                $scope.studentCount		= students;
                
              // if($scope.donor.DN_Citizenship__c == 'Indian'){
                orderwrp.totalOrderAmountINR	= $scope.tltamount;
            //}
            //if($scope.donor.DN_Citizenship__c	== 'Non-Indian'){
           //     orderwrp.totalOrderAmountUSD	= $scope.tltamount;
           // }      
           
                if($scope.donor.DN_Citizenship__c == 'Indian'){
                    currencytype				= 'INR';
                }
                if($scope.donor.DN_Citizenship__c	== 'Non-Indian'){
                    currencytype				= 'INR';
                }   
                
                
                orderwrp.currencyType				= currencytype;
                
                $scope.selectedPrograms				= [];
                for(var i = 0; i < $scope.allFrequency.length; i++){
                    if($scope.allFrequency[i] != undefined && $scope.allFrequency[i].checked){
                        $scope.allFrequency[i].Amount__c=parseInt($scope.allFrequency[i].Amount__c);
                        delete $scope.allFrequency[i]["Amount_Fixed__c"];
                        delete $scope.allFrequency[i]["checked"];
                        
                        var frequencyVal	= removeAngularjsKey($scope.allFrequency[i]);
                        
                        const donation = $scope.allDonationsMap.get($scope.allFrequency[i].Program__c);
                        if(donation.totalLineAmount>0){ //TODO
                            $scope.selectedPrograms.push({frequency:frequencyVal,studentCount:donation.nstudents, programAmountUSD:parseInt(donation.totalLineAmount)});
                        }
                    }
                }
                
                orderwrp.programs = angular.copy($scope.selectedPrograms);
                $scope.loading=true;
                console.log(orderwrp);
                orderwrp.donorRecord.MailingCountry=$scope.countrySelected;
                orderwrp.donorRecord.MailingState=$scope.locationSelected;
                $scope.cityNamee = '';
                //orderwrp.donorRecord.MailingCity = '';
                if($scope.dislpayOtherCity == false){
                $scope.cityNamee = $scope.locationCitySelected;
                }else{
                $scope.cityNamee = $scope.otherCity;    
                }
                
                //orderwrp.donorRecord.MailingCity = $scope.cityNamee;
                
                console.log(orderwrp);
                DN_QuickDonation.makeDonation(orderwrp,function(result,event){           
                    if(event.status){                
                        $scope.loading=false;                
                        $scope.paymentProcess(angular.copy(result),amount,$scope.deletePayment);
                        $scope.$apply();
                    }else{
                        $scope.loading=false;
                        swal({title:'',text:'Oops! Somthing went wrong.Please try again.'});
                        $scope.loadProgramInfo();
                        $scope.$apply();
                    }
                },{escape:false});
            }
            
        }
        
        
        $scope.paymentProcess = function(result,amount, orderStatus){
            
            if(result.errorMsg != undefined && result.errorMsg != null){ 
                swal({title:'',text:result.errorMsg,type:"error"});
            }
            else{  
                $scope.donorDetailsPopup =false;
                swal({ 
                    title: "<span style='font-size:16px;color:#ff793c'> Transaction Details</span><br/>",
                    text: "<b align='left' style='float:left;color:#ff793c'>Order No: &nbsp;</b>"+"<span align='left' style='float:left;'>"+result.orderInfo.Order_No__c+"</span><br/><br/><b align='left' style='float:left;color:#ff793c'>Total Amount:&nbsp;</b>"+"<span align='left' style='float:left'>"+amount+"</span>",
                    showCancelButton: true,                        
                    cancelButtonText: "Cancel",
                    cancelButtonColor: '#ff793c',
                    confirmButtonColor: "#ff793c",
                    confirmButtonText: "Proceed for Payment ...",
                    closeOnConfirm: false,
                    closeOnCancel: false,
                    allowEscapeKey:false,
                    html:true
                }, 
                     function(isConfirm){ 
                         if (isConfirm) {
                             window.location.replace(result.redirectURL);
                         }else {
                             swal.close();
                             //$scope.allFrequency	= [];
                             $scope.loading=true;
                             DN_QuickDonation.cancelDonation(result.orderInfo.Id,orderStatus,function(result,event){
                                 if(event.status){
                                     // $scope.loadProgramInfo();
                                     $scope.loading=false;
                                     if(orderStatus	== $scope.abortPayment){
                                         $scope.loadDonationHistory();
                                         $scope.pledgedDonationHistory();
                                     }                                
                                     $scope.$apply();
                                 }
                                 else{
                                     $scope.loading=false;
                                     $scope.$apply();
                                 }
                             });
                         }
                     });
            }
        }
        
        
        $scope.calculatedAmount = 0;
        $scope.calc = function() {
            $scope.calculatedAmount = 0;
            console.log('calc called');
            if($scope.currentFrequency && $scope.currentFrequency.Amount_Fixed__c != undefined && $scope.currentFrequency.Amount_Fixed__c) {
                // amount=JSON.parse(amount);
                let students = $scope.currentDonation.nstudents;
                let amount = $scope.currentFrequency;

                if(amount=='' || amount==undefined){
                    $scope.currentDonation.totalLineAmount=0;
                    $scope.currentDonation.nstudents=0;
                    return 0;
                }
                students=parseInt(students);
                if(amount.Amount__c != undefined) {
                    debugger;
                    $scope.currentDonation.totalLineAmount=(students*amount.Amount__c);
                }
                var totalLineamount=$scope.currentDonation.totalLineAmount;
                $scope.minAmountValidation();
                if(isNaN(totalLineamount)){
                    $scope.calculatedAmount = 0;
                }
                else{
                    $scope.calculatedAmount = totalLineamount;
                }
            }
        }
        $scope.descPop = false;
        $scope.showDesc = function(descObject){
            console.log(descObject);
            $scope.description=descObject;
           // $scope.descPop =true;
        }
        $scope.closeDesc = function(){
            //$scope.descPop =false;
        }

        
        $scope.proceed =function(){
            $scope.donorDetailsPopup =true;
        }
        
        $scope.closeDetails =function(){
            $scope.donorDetailsPopup =false;
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
        
        //$scope.passport = false;
        //$scope.pan=false;
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
        
        var removeAngularjsKey = function(targetData) {
            
            var toJson = angular.toJson(targetData);
            var fromJson = angular.fromJson(toJson);
            
            return fromJson;
            
        };
        
        
     $scope.clear =function(){
        $scope.locationSelected	= [];
    }   
        
        $scope.enterCountryData = false;
     $scope.getstateList = function(__country){
         if(__country == 'Other'){
             $scope.enterCountryData = true;
         }else{
             $scope.enterCountryData = false;
         $scope.clear(); 
        $scope.listOfStates	= [];
        $scope.listStates	= [];
        $scope.listOfCities	= [];
        $scope.loading=true;
        DN_QuickDonation.getStateList(__country,function(result,event){
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
    }
            
    $scope.listOfCities	= [];
    $scope.dislpayOtherCity = false;
        $scope.otherCityCheck = function(cityName){
            if(cityName == 'Other'){
               $scope.dislpayOtherCity = true; 
            }else{
                $scope.dislpayOtherCity = false;
            }
        }   
        
     $scope.getcityList = function(__state){
        $scope.listOfCities	= [];
         $scope.listcities	= [];
        $scope.loading=true;
        DN_QuickDonation.getCityList(__state,function(result,event){
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
    
    //Prithvi 12,Nov
    $scope.frequencies = [];
    $scope.currentDonation;
    $scope.currentFrequency;
    
    $scope.donationClick = function(donation, donations) {
        if(donation.checked == true)
            return;
        /* $scope.currentDonation = null;
        $scope.currentFrequency = null; */
        if(donation.checked == false) {
            $scope.currentDonation = donation;
            if(donation.Program_Frequencys__r != undefined && donation.Program_Frequencys__r.length > 0) {
                if(donation.only_1_frequency__c == true) {
                    $scope.currentFrequency = donation.Program_Frequencys__r[0];
                    $scope.currentFrequency.checked = true;
                }else {
                    angular.forEach(donation.Program_Frequencys__r,function(frequency) {
                        if(frequency.checked) {
                            $scope.currentFrequency = frequency;
                        }
                    });
                }
                $scope.minAmountValidation();
            }
            angular.forEach(donations, function(otherDonation) {
                
                if(donation.Id != otherDonation.Id && otherDonation.checked) {
                    otherDonation.checked = false;
                }
                
            });
            donation.checked = !donation.checked;
        }
        if(donation.checked)
            $scope.frequencies = donation.Program_Frequencys__r;
        else
            $scope.frequencies = [];
        $scope.calculatedAmount = 0;
    };
    
    $scope.tabChange = function(program){
        
        $scope.currentDonation = null;
        $scope.currentFrequency = null;
        $scope.frequencies = [];
        const donations = $scope.makeDonations.get(program);
        angular.forEach(donations, function(donation) {
            
            if(donation.checked) {
                $scope.currentDonation = donation;
                $scope.frequencies = donation.Program_Frequencys__r;
                if($scope.frequencies) {
                    angular.forEach($scope.frequencies,function(frequency) {
                        if(frequency.checked) {
                            $scope.currentFrequency = frequency;
                            $scope.calc();
                        }
                    });
                }
                
            }
        }); 
    };

    $scope.frequencyClick = function(frequency, frequencies) {
        if(frequency.checked == true)
            return;
        $scope.calculatedAmount = 0;
        if(frequency.checked == false) { 
            $scope.currentFrequency = frequency;
            $scope.minAmountValidation();
            $scope.currentDonation.nstudents = 0;
            $scope.currentDonation.totalLineAmount = 0;
            angular.forEach(frequencies, function(otherFrequency) {
                if(frequency.Id != otherFrequency.Id && otherFrequency.checked) {
                    otherFrequency.checked = false;
                    $scope.minAmountValidation();
                }
            });
            frequency.checked = !frequency.checked;
        }
    }


    $scope.addStudent = function() {
        $scope.currentDonation.nstudents+=1;
        $scope.calc();
    }

    $scope.removeStudent = function() {
        if($scope.currentDonation.nstudents > 0) {
            $scope.currentDonation.nstudents-=1;
            $scope.calc();
        }
    }
});