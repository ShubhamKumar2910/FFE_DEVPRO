var app=angular.module('DonorProfile', ['ngRoute','ngAnimate','textAngular']);

var sitePrefix = '/donor';
if (sitePrefix=='') sitePrefix='/donor';
app.config( function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(false).hashPrefix('');
    $routeProvider
    
    .when('/donorViewProfile', {templateUrl: sitePrefix+'/donorViewProfile',
                               })
    .when('/donationHistory', {templateUrl: sitePrefix+'/donationHistory',
                              })
    .when('/donorStudents', {templateUrl: sitePrefix+'/donorStudents',
                            })
    .when('/makeDonation', {templateUrl: sitePrefix+'/makeDonation',
                           })
    .when('/studentProfile', {templateUrl: sitePrefix+'/studentProfile',
                             })
    .when('/viewStudentByDonor', {templateUrl: sitePrefix+'/viewStudentByDonor',
                                 })
    // by gourab
    .when('/StudentDataInMSWord', {templateUrl: sitePrefix+'/StudentDataInMSWord',
                                  })
    
    .otherwise({redirectTo: '/donorViewProfile'});
});

app.controller('donorProfile', function($scope, $timeout, $window, $location,$element  ) {
    
    $scope.scholarResidenstilPickValues	= scholarResidenstilPickValues;
    $scope.paymentWrpString				= paymentWrpString;
    var olddata							= {};
    $scope.donor						= {};
    $scope.makeDonations				= {};
    $scope.formInvalid					= false;
    $scope.currencyIS					= false;
    $scope.editRead						= true;
    $scope.donorId						= userId;
    $scope.selectedtabs					= 0;
    $scope.indexValue					= 0;
    $scope.allFrequencyEM				= [];
    $scope.allFrequencyNonEM			= [];
    $scope.allFrequencyTotalAmount		= [];
    $scope.selectedPrograms				= [];
    $scope.pendingPaymentLine			= [];
    $scope.indian						= CitizenIndian;
    $scope.nonindian					= CitizenNonIndian;
    $scope.successMessage				= successMsg;
    $scope.medical						= medical;
    $scope.engg							= engg;
    $scope.totalAmountForDonate			= false;
    $scope.maxStringSize 				= 6000000;
    $scope.maxFileSize	 				= 4350000;
    $scope.chunkSize 	 				= 950000;
    $scope.passportUploadMsg			= passportReqMsg;
    $scope.siteLoginURL					= siteLogin;
    $scope.amountFixed					= [];
    $scope.currency						= donorCurrencType;
    $scope.minAmountReq					= [];
    $scope.deletePayment				= paymentDelete;
    $scope.abortPayment					= paymentAborted;
    $scope.donorCategory				= JSON.parse(donorCategory);
    $scope.tenthTwelthDetails           = true;
    $scope.familyInformation 			= true;
    $scope.branchDetails 				= true;
    $scope.collegeNameDetails 			= true;
    $scope.collegeInformation  			= true;
    $scope.entranceExamInformation      = true;
    $scope.entranceTestName 			= true;
    $scope.renderSkillDev = false;
    $scope.semesterInformation 			= true;
    $scope.MbbsScoreInformation         = true;
    $scope.FinancialYear                = FinancialYear;
    $scope.financialYear                = FinancialYear[0];
    $scope.displayAmcatTaken                = false;
    $scope.amcatTakenValue = 'No';
    $scope.disableEditandMakeDonationForLiveImpact = false;
    $scope.displayYearOfGraduation = false;
    $scope.displayFFEScholarID = false;
    $scope.displayDonoCategory = false;
    $scope.AadharMandatory              = false;
    $scope.showCategoryForNonScholarDonor      = true;
    
    $scope.studentTrainingList = [];
    $scope.studentMentoringList = [];
    $scope.mentorName = '';
    $scope.mentorOrg = '';
    
    
    $scope.displayDonor =function(){
        $scope.loading=true;
        debugger;
        DN_DonorProfile_CTRL.displayDonorDetails($scope.donorId,function(result,event){            
            if(event.status){
                $scope.donor=JSON.parse(result);
                
                $scope.residential($scope.donor.DN_Citizenship__c);
                $scope.currencyType();
                $scope.splitPassportDetails($scope.donor.Passport_file__c);
                
                if($scope.donor.LIV_ID__c != undefined && $scope.donor.LIV_ID__c != 'null'){
                    $scope.disableEditandMakeDonationForLiveImpact = true;
                }else{
                    $scope.disableEditandMakeDonationForLiveImpact = false;
                }
                if($scope.donor.LIV_ID__c != undefined && $scope.donor.LIV_ID__c != 'null'){
                    $scope.donationListStatus = false;
                }
                if($scope.donor.DN_Year_Of_Graduation__c !=undefined){
                    $scope.displayYearOfGraduation = true;
                }
                
                if($scope.donor.DN_FFE_Scholar_ID__c !=undefined){
                    $scope.displayFFEScholarID = true;
                }
                
                if($scope.donor.DN_Donor_Category__c !=undefined){
                    $scope.displayDonoCategory = true;
                }
                
                if($scope.donor.DN_Donor_Category__c == 'Scholar'){
                    $scope.showCategoryForNonScholarDonor = false;
                }
                
                $scope.loading=false;
                $scope.$apply();
            }else{
                $scope.loading=false;
                swal({title:'',text:"Oops! No data found for your login."});
                window.location.replace($scope.siteLoginURL);
            }
        },{escape:false});
        $scope.loading 	= false;
    }
    window.onload = function(){
        $scope.displayDonor();
        $scope.getDonorSpecifiedYearStudents($scope.financialYear);
    }
    
    $scope.splitPassportDetails	= function(_passpt){
        if(_passpt != undefined && _passpt != null){
            $scope.passportFileName	= (_passpt).toString().split('/')[0];
            $scope.passportFileId	= (_passpt).toString().split('/')[1]; 
        }
    }
    
    $scope.donationListStatus = false;
    $scope.donationList = [];
    $scope.loadDonationHistory	= function(){
        $scope.loading=true;
        DN_DonorProfile_CTRL.displayDonorDonationDetails($scope.donorId,function(result,event){
            if(event.status){
                $scope.donationList	= JSON.parse(result);
                if($scope.donationList.length > 0){
                    $scope.donationListStatus = true; 
                }
                if($scope.donor.LIV_ID__c != undefined && $scope.donor.LIV_ID__c != 'null'){
                    $scope.donationListStatus = false;
                }
                $scope.loading=false;
                $scope.$apply();
            }
            $scope.loading=false;
        },{escape:false}); 
        $scope.loading=false;
    };
    
    $scope.pledgedDonationList = [];
    $scope.pledgedDonationHistory	= function(){
        $scope.loading=true;
        DN_DonorProfile_CTRL.getPledgedDonations($scope.donorId,function(result,event){
            if(event.status){
                $scope.pledgedDonationList	= JSON.parse(result);
                $scope.loading=false;
                $scope.$apply();
            }
            $scope.loading=false;
        },{escape:false}); 
        $scope.loading=false;
    };
    
    $scope.loadProgramInfo = function(){
        $scope.allFrequency	= [];
        $scope.loading=true;
        $scope.totalAmountForDonate=false;
        //making make donation tab visible on all condition but only not when liv id has values
        $scope.currency="INR";
        DN_DonorProfile_CTRL.getDonorDonationProgramDetails($scope.currency,function(result,event) {
            if(event.status) {
                if(result!=null){	
                    $scope.empty={};
                    $scope.makeDonations=result;
                    for(var i=0; i<$scope.makeDonations.length;i++){
                        $scope.makeDonations[i].totalLineAmount=0;
                        $scope.makeDonations[i].nstudents=0;
                    }
                    $scope.amountFixed.length=$scope.makeDonations.length;
                    /*  $scope.makeDonationsNonEM=[];
                        $scope.makeDonationsEM=[];
                       for(var i=0; i<$scope.makeDonations.length;i++){
                            if($scope.makeDonations[i].Program__c== medical || $scope.makeDonations[i].Program__c== engg || $scope.makeDonations[i].Program__c=="Mentorship Program" || $scope.makeDonations[i].Program__c=="Skills Training Program"){
                                $scope.makeDonationsEM.push($scope.makeDonations[i]);
                            }
                            else{
                                $scope.makeDonationsNonEM.push($scope.makeDonations[i]);
                            }
                        }*/
                    $scope.loading=false;
                    $scope.$apply();
                }
                $scope.loading=false;
            }
        },{escape:false});
        $scope.loading=false;
    };
    
    $scope.updateInfo = function(){
        if($scope.donor.DN_Citizenship__c == CitizenIndian && ($scope.donor.Aadhar_number__c == '' || $scope.donor.Aadhar_number__c == undefined)){
            $scope.AadharMandatory = true;
            $scope.loading=false;
            swal({title:'',text:"Please fill all mandatory (*) fields"});  
        }else{
            $scope.AadharMandatory = false;
            var attachFile	= document.getElementById('passportfile').files[0];
            if($scope.donor.DN_Citizenship__c == $scope.nonindian && (attachFile == undefined || attachFile == 'undefined')
               && ($scope.donor.IsPassportUploaded__c == false || $scope.donor.IsPassportUploaded__c == undefined)){
                $scope.Nofile=true;
                swal({title:'',text:$scope.passportUploadMsg})
                return;
            }else{
            }
            if(this.regForm.$invalid || this.emailvalidation.$invalid || this.gmailvalidation.$invalid){
                $scope.formInvalid=true;
                $scope.Nofile=false;
                swal({title:'',text:"Please fill all mandatory (*) fields"});
            }        
            else if($scope.emailValidation($scope.donor.Email) && $scope.emailValidation($scope.donor.Facebook_login_ID__c) && $scope.emailValidation($scope.donor.Google_login_ID__c)){ 
                
                if($scope.donor != undefined)
                    delete $scope.donor["attributes"];
                if($scope.donor.DN_Special_Request_Comments__c== undefined){
                    $scope.donor.DN_Special_Request_Comments__c='';
                }
                $scope.notGmail=false;
                $scope.invalidGmail = false;
                $scope.invalidFEmail = false;
                $scope.invalidEmail = false;
                $scope.formInvalid=false;
                $scope.Nofile=false;
                if(attachFile != undefined && attachFile != 'undefined'){
                    $scope.uploadDonorFiles(attachFile);
                }else{
                    $scope.updateDonorProfile();
                }            
            }
        }
    };
    
    $scope.updateDonorProfile = function(){
        $scope.loading=true; 
        DN_DonorProfile_CTRL.updateDonorInSFDC($scope.donor,function(result,event){ 
            if(event.status){ 
                swal({title:'',text:result});
                if($scope.successMessage == result)
                    $scope.editRead=true;
                $scope.loading=false;
                $scope.$apply();
                
            }else{
                swal({title:'',text:'Oops! Somthing went wrong.Please try again.'});
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false});
    }
    
    $scope.paymentProcess = function(result,amount, orderStatus){
        if(result.errorMsg != undefined && result.errorMsg != null){ 
            swal({title:'',text:result.errorMsg,type:"error"});
        }
        else{  
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
                         $scope.allFrequency	= [];
                         $scope.loading=true;
                         DN_DonorProfile_CTRL.cancelDonation(result.orderInfo.Id,orderStatus,function(result,event){
                             if(event.status){
                                 $scope.loadProgramInfo();
                                 $scope.loading=false;
                                 if(orderStatus	== $scope.abortPayment){
                                     $location.path('/donationHistory');
                                     $scope.switch(0,0);
                                     $scope.loadDonationHistory();
                                     $scope.pledgedDonationHistory();
                                 }else{
                                     $location.path('/makeDonation');  
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
    $scope.currencyType = function(){
        if($scope.donor.DN_Citizenship__c==$scope.indian){
            $scope.currency="INR";
        }
        else if($scope.donor.DN_Citizenship__c==$scope.nonindian){
            $scope.currency="USD";
        }        
        
    }
    $scope.showTabcontent=function(value){
        $scope.selected=value;
        $scope.isemptyStudents = false;
    }
    $scope.moveToTop = function(){
        var myDiv = document.getElementById('myContainerDiv');
        myDiv.scrollTop = 0;
    }
    $scope.continue = function(){
        if($scope.currency !='undefined'){
            $scope.currencyIS=true;
            if($scope.currency=='INR'){
                $scope.currencyINR=true;
                $scope.currencyUSD=false;
            }
            else{
                $scope.currencyINR=false;
                $scope.currencyUSD=true;
            }
        }
    }
    $scope.edit = function(){
        $scope.editRead=false; 
    }
    $scope.cancelChanges = function(){
        $scope.displayDonor();
        $scope.editRead=true;
        $scope.invalidFEmail=false;
        $scope.invalidGmail=false;
        $scope.notGmail=false;
        $scope.invalidEmail=false;
        $scope.formInvalid=true;
    }
    $scope.switch = function(switchvalue, tabvalue){
        $scope.selectedtabs=tabvalue;
        $scope.indexValue=switchvalue;
    }
    /*  $scope.selectedSt = function(switchvalue, tabvalue){
        $scope.selectedStudent=tabvalue;
        $scope.indexValueStudent=switchvalue;
    }*/
    $scope.displayPan = true;
    $scope.displayPassport = true;
    $scope.residential = function(value){
        
        if($scope.donor.DN_PAN__c == undefined && value==$scope.indian){
            $scope.displayPan = true;
            $scope.displayPassport = false; 
        }else{
            if(value==$scope.indian){
                $scope.displayPan = true;
                $scope.displayPassport = true; 
            }
        }
        if($scope.donor.DN_Passport_Number__c == undefined && value==$scope.nonindian){
            $scope.displayPassport = true;
            $scope.displayPan = false;
        }else{
            if(value==$scope.nonindian){
                $scope.displayPassport = true;
                $scope.displayPan = true;  
            }
        }
        
        if(value==$scope.indian){
            $scope.pan=true;
            $scope.passport=false;
        }
        else if(value==$scope.nonindian){
            $scope.passport=true;
            $scope.pan=false;
        }
    }
    
    $scope.calc = function(students,amount,index){
        // amount=JSON.parse(amount);
        if(amount=='' || amount==undefined){
            $scope.makeDonations[index].totalLineAmount=0;
            $scope.makeDonations[index].nstudents=0;
            return 0;
        }
        students=parseInt(students);
        $scope.makeDonations[index].totalLineAmount=(students*amount.Amount__c);
        var totalLineamount=$scope.makeDonations[index].totalLineAmount;       
        //$scope.allFrequencyTotalAmount[position].totalLineAmount=totalLineamount;
        if(isNaN(totalLineamount)){
            return 0;
        }
        else{
            return totalLineamount;
        }
        
    }
    $scope.minAmountValidation= function(){
        for(var j=0;j<=$scope.minAmountReq.length;j++){
            if($scope.minAmountReq[j] !=undefined)
            {
                if(!$scope.minAmountReq[j]){
                    return false;
                }
            }
        }
        return true;
    }
    
    $scope.amtEM = function(amt,index){
        $scope.amt=amt;
        if($scope.amt=='' || $scope.amt==undefined){
            $scope.minAmountReq[index] =undefined;
            $scope.minAmountRequired=$scope.minAmountValidation();
            $scope.makeDonations[index].totalLineAmount=0;
            return;
        }
        $scope.amount=parseInt($scope.amt.Amount__c);
        $scope.minAmount=$scope.amount;
        $scope.makeDonations[index].totalLineAmount=$scope.amount;
        $scope.minAmountReq[index]=true;
        $scope.minAmountRequired=$scope.minAmountValidation();
        for(var i = 0; i < $scope.makeDonations[index].Program_Frequencys__r.length; i++){
            if($scope.makeDonations[index].Program_Frequencys__r[i].Amount__c==$scope.amount){
                $scope.allFrequency[index]=$scope.makeDonations[index].Program_Frequencys__r[i];
                $scope.amountFixed[index]=$scope.makeDonations[index].Program_Frequencys__r[i].Amount_Fixed__c;
            }
        }
    }
    $scope.amtNonEM=function(amt,donNonamount,index){
        $scope.amount=parseInt(amt);
        if($scope.amount>=donNonamount.Amount__c){
            $scope.minAmountReq[index]=true;
            $scope.minAmountRequired=$scope.minAmountValidation();            
            for(var i = 0; i < $scope.makeDonations[index].Program_Frequencys__r.length; i++){
                if($scope.makeDonations[index].Program_Frequencys__r[i].Name==donNonamount){
                    $scope.makeDonations[index].Program_Frequencys__r[i].Amount__c=$scope.amount;
                    $scope.allFrequency[index]=$scope.makeDonations[index].Program_Frequencys__r[i];
                }
            }
        }
        else{
            $scope.minAmountReq[index]=false;
            $scope.minAmountRequired=$scope.minAmountValidation();
        }
    }
    $scope.getTotalAmount = function(){
        var total = 0;
        for(var i = 0; i < $scope.makeDonations.length; i++){
            if(!isNaN($scope.makeDonations[i].totalLineAmount)){
                total += (parseInt($scope.makeDonations[i].totalLineAmount));
            }
        }
        /*for(var i = 0; i < $scope.makeDonations.length; i++){
            if(!isNaN(parseInt($scope.makeDonations[i].totalLineAmount))){
                total += parseInt($scope.makeDonations[i].totalLineAmount);
            }
        }*/
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
        var totalstudents = 0;
        for(var i = 0; i < $scope.makeDonations.length; i++){
            if(!isNaN($scope.makeDonations[i].nstudents)){
                totalstudents += ($scope.makeDonations[i].nstudents);
            }
        }
        /* for(var i = 0; i < $scope.makeDonationsNonEM.length; i++){
            if(!isNaN($scope.makeDonationsNonEM[i].nstudents)){
                totalstudents += ($scope.makeDonationsNonEM[i].nstudents);
            }
        }*/
        return totalstudents;
    }
    $scope.donate= function(amount,students,currencytype){
        if($scope.donor != undefined)
            delete $scope.donor["attributes"];
        
        var orderwrp			= {};        
        orderwrp.donorRecord	= angular.copy($scope.donor);
        $scope.studentCount		= students;
        
        if(currencytype == 'INR'){
            orderwrp.totalOrderAmountINR	= amount;
        }
        if(currencytype	== 'USD'){
            orderwrp.totalOrderAmountUSD	= amount;
        }        
        orderwrp.currencyType				= currencytype;
        $scope.selectedPrograms				= [];
        for(var i = 0; i < $scope.allFrequency.length; i++){
            if($scope.allFrequency[i] != undefined){
                $scope.allFrequency[i].Amount__c=parseInt($scope.allFrequency[i].Amount__c);
                delete $scope.allFrequency[i]["Amount_Fixed__c"];
                var frequencyVal	= removeAngularjsKey($scope.allFrequency[i]);
                if($scope.makeDonations[i].totalLineAmount>0){
                    if(currencytype == 'INR'){
                        $scope.selectedPrograms.push({frequency:frequencyVal,studentCount:$scope.makeDonations[i].nstudents, programAmountINR:parseInt($scope.makeDonations[i].totalLineAmount)});
                    }
                    if(currencytype	== 'USD'){
                        $scope.selectedPrograms.push({frequency:frequencyVal,studentCount:$scope.makeDonations[i].nstudents, programAmountUSD:parseInt($scope.makeDonations[i].totalLineAmount)});
                    }                    
                }
            }
        }
        /*for(var i = 0; i < $scope.allFrequencyNonEM.length; i++){
            if($scope.allFrequencyNonEM[i] != undefined){
                var frequencyVal	= removeAngularjsKey($scope.allFrequencyNonEM[i]);
                if($scope.makeDonationsNonEM[i].totalLineAmount>0){
                    $scope.selectedPrograms.push({frequency:frequencyVal,studentCount:$scope.makeDonationsNonEM[i].nstudents, programAmountINR:$scope.makeDonationsNonEM[i].totalLineAmount});
                }
            }
        }*/
        orderwrp.programs = angular.copy($scope.selectedPrograms);
        $scope.loading=true;
        DN_DonorProfile_CTRL.makeDonation(orderwrp,function(result,event){           
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
    
    var removeAngularjsKey = function(targetData) {
        
        var toJson = angular.toJson(targetData);
        var fromJson = angular.fromJson(toJson);
        
        return fromJson;
        
    };
    
    $scope.pendingFilter = function(pendDonation){      
        return pendDonation.Payment_Status__c != 'Confirmed' ;
    };
    
    $scope.pastFilter = function(pastDonation){      
        return pastDonation.Payment_Status__c == 'Confirmed' ;
    };
    $scope.redsFirst = function(record){
        return record.Payment_Status__c !== 'Pending Confirmation';
    }
    $scope.reDonate =function(object){
        var __orderNo=null;
        $scope.pendingOrder=object;
        if($scope.pendingOrder != undefined && $scope.pendingOrder){
            delete $scope.pendingOrder["attributes"];
            
            if($scope.pendingOrder.Program_Frequency__r != undefined && $scope.pendingOrder.Program_Frequency__r)
                delete $scope.pendingOrder.Program_Frequency__r["attributes"];
            if($scope.pendingOrder["Payment_Order__r"] != undefined && $scope.pendingOrder["Payment_Order__r"])
                __orderNo	= $scope.pendingOrder.Payment_Order__r.Id;
            delete $scope.pendingOrder["Payment_Order__r"];
            if($scope.pendingOrder["npsp__Primary_Contact__r"] != undefined && $scope.pendingOrder["npsp__Primary_Contact__r"])
                delete $scope.pendingOrder["npsp__Primary_Contact__r"];
            if($scope.pendingOrder["CloseDate"])
                delete $scope.pendingOrder["CloseDate"];
            if($scope.pendingOrder.Program_Frequency__r != undefined && $scope.pendingOrder.Program_Frequency__r.Program__r != undefined)
                delete $scope.pendingOrder.Program_Frequency__r.Program__r["attributes"];            
        }
        
        $scope.pendingOrder		= removeAngularjsKey($scope.pendingOrder);
        var orderwrp			= {};        
        orderwrp.donorRecord	= $scope.donor;
        $scope.studentCount		= $scope.pendingOrder.No_of_Student__c;
        
        orderwrp.currencyType				= $scope.pendingOrder.Currency__c;
        $scope.pendingPaymentLine			= [];
        
        if($scope.pendingOrder.Currency__c == 'INR'){
            orderwrp.totalOrderAmountINR	= $scope.pendingOrder.Amount;
            $scope.pendingPaymentLine.push({frequency:$scope.pendingOrder.Program_Frequency__r,studentCount:$scope.pendingOrder.No_of_Student__c, programAmountINR:$scope.pendingOrder.Amount});
        }
        if($scope.pendingOrder.Currency__c	== 'USD'){
            orderwrp.totalOrderAmountUSD	= $scope.pendingOrder.Amount;
            $scope.pendingPaymentLine.push({frequency:$scope.pendingOrder.Program_Frequency__r,studentCount:$scope.pendingOrder.No_of_Student__c, programAmountUSD:$scope.pendingOrder.Amount});
        }  
        
        orderwrp.programs = $scope.pendingPaymentLine;
        
        if(orderwrp.donorRecord)
            delete orderwrp.donorRecord["attributes"];
        
        $scope.loading=true;
        DN_DonorProfile_CTRL.makePedingDonation(orderwrp,$scope.pendingOrder.Id,__orderNo,function(result,event){
            if(event.status){    
                $scope.paymentProcess(result,$scope.pendingOrder.Amount,$scope.abortPayment);
                $scope.loading=false;
                $scope.$apply();
            }else{  
                $scope.loading=false;
            }
        },{escape:false});
    }
    
    // Future Pending Donation
    $scope.futureDonation =function(object){
        
        $scope.pendingOrder=object;
        if($scope.pendingOrder != undefined && $scope.pendingOrder){
            delete $scope.pendingOrder["attributes"];
            
            if($scope.pendingOrder.npe03__Recurring_Donation__r != undefined && $scope.pendingOrder.npe03__Recurring_Donation__r)
                delete $scope.pendingOrder.npe03__Recurring_Donation__r["attributes"];
            if($scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r != undefined && $scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r)
                delete $scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r["attributes"];
            if($scope.pendingOrder["Payment_Order__r"] != undefined && $scope.pendingOrder["Payment_Order__r"])
                delete $scope.pendingOrder["Payment_Order__r"];
            if($scope.pendingOrder["npsp__Primary_Contact__r"] != undefined && $scope.pendingOrder["npsp__Primary_Contact__r"])
                delete $scope.pendingOrder["npsp__Primary_Contact__r"];
            if($scope.pendingOrder["CloseDate"])
                delete $scope.pendingOrder["CloseDate"];
            if($scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r != undefined && $scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r.Program__r != undefined)
                delete $scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r.Program__r["attributes"];            
        }
        
        $scope.pendingOrder=removeAngularjsKey($scope.pendingOrder);
        var orderwrp			= {};        
        orderwrp.donorRecord	= $scope.donor;
        $scope.studentCount		= $scope.pendingOrder.npe03__Recurring_Donation__r.No_of_Student__c;
        
        if($scope.pendingOrder.Currency__c == 'INR'){
            orderwrp.totalOrderAmountINR	= $scope.pendingOrder.Amount;
        }
        if($scope.pendingOrder.Currency__c	== 'USD'){
            orderwrp.totalOrderAmountUSD	= $scope.pendingOrder.Amount;
        }        
        orderwrp.currencyType				= $scope.pendingOrder.npe03__Recurring_Donation__r.Currency__c;
        $scope.pendingPaymentLine			= [];
        
        $scope.pendingPaymentLine.push({frequency:$scope.pendingOrder.npe03__Recurring_Donation__r.Program_Frequency__r,studentCount:$scope.pendingOrder.npe03__Recurring_Donation__r.No_of_Student__c, programAmountINR:$scope.pendingOrder.Amount});
        
        orderwrp.programs = $scope.pendingPaymentLine;
        
        if(orderwrp.donorRecord)
            delete orderwrp.donorRecord["attributes"];
        
        $scope.loading=true;
        DN_DonorProfile_CTRL.makePedingDonation(orderwrp,$scope.pendingOrder.Id,null,function(result,event){
            if(event.status){    
                $scope.paymentProcess(result,$scope.pendingOrder.Amount, $scope.abortPayment);
                $scope.loading=false;
                $scope.$apply();
            }else{  
                $scope.loading=false;
            }
        },{escape:false});
    }
    
    
    $scope.emailValidation = function(value){
        if(value!=undefined && value!=""){
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
    };
    
    $scope.uploadDonorFiles	= function(attachFile){		
        
        $scope.filebody;
        $scope.fileSize;
        $scope.fileName;        
        $scope.positionIndex;
        $scope.doneUploading;
        var reader 		= new FileReader();
        
        if(attachFile != undefined && attachFile != null){
            
            var _isDocCorrect	= $scope.validateDocType();
            if(_isDocCorrect){
                if(attachFile.size < $scope.maxFileSize){
                    
                    reader.onload = function(e) {
                        $scope.fileName = attachFile.name;          
                        $scope.filebody = window.btoa(e.target.result).toString();           
                        $scope.fileSize	= $scope.filebody.length;
                        $scope.positionIndex=0;
                        $scope.doneUploading = false;
                        
                        if($scope.fileSize < $scope.maxStringSize){
                            $scope.loading=true;
                            $scope.uploadDocument(null);                   
                        }else {
                            swal({title:'',
                                  text:'Base 64 Encoded file is too large.  Maximum size is '+ $scope.maxStringSize + ' your file is '+ $scope.savefileSize + '.'});
                        }
                    };  
                    
                    reader.readAsBinaryString(attachFile);
                }else{
                    $scope.tabsValidSs=true;
                    $scope.tabsValidBlueSs=false;
                    swal({title:'',
                          text:'File should be under 4.3 MB. Please upload a smaller file'});
                }
            }else{
            }
        }else{
            swal({title:'',text:'Please select file'});
        }
    };
    
    
    $scope.uploadDocument = function(fileId){
        
        var attachmentBody = "";
        if($scope.fileSize <= $scope.positionIndex + $scope.chunkSize) {
            attachmentBody = $scope.filebody.substring($scope.positionIndex);
            $scope.doneUploading = true;
        }else {
            attachmentBody = $scope.filebody.substring($scope.positionIndex, $scope.positionIndex + $scope.chunkSize);
        }
        
        DN_DonorProfile_CTRL.uploadDoc(attachmentBody,$scope.fileName,$scope.donorId,fileId, function(result, event){
            if(event.type === 'exception') {
                swal({title:'',
                      text:'There is some problem while uploading your file.Please try again.'});
                $scope.loading=false;
            } else if(event.status) {
                if(result.substring(0,3) == '00P') {
                    if($scope.doneUploading == true) { 
                        $scope.donor.IsPassportUploaded__c = true;
                        $scope.donor.Passport_file__c	   = $scope.fileName+'/'+result;
                        $scope.splitPassportDetails($scope.donor.Passport_file__c);
                        attachmentBody='';
                        $scope.fileName='';                          
                        $scope.updateDonorProfile();
                        $scope.$apply();
                    }else {
                        $scope.positionIndex += $scope.chunkSize;
                        $scope.uploadDocument(result);
                        $scope.$apply();
                    }
                }                
            } else {
                swal({title:'',
                      text:event.message});
                $scope.loading=false;
            }
        }, {buffer: true, escape: true, timeout: 120000}); 
    };
    
    
    $scope.validateDocType = function (){
        var _validFileExtensions = [".pdf",".png", ".jpeg",".gif",".jpg"];    
        var arrInputs = document.getElementsByTagName("input");
        for (var i = 0; i < arrInputs.length; i++) {
            var oInput = arrInputs[i];
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
                        swal({title:'',
                              text:"Sorry, " + sFileName + " is invalid, allowed extensions are: " + _validFileExtensions.join(", ")});
                        return false;
                    }
                }
            }
        }        
        return true;
    }; 
    
    $scope.studentListStatus = false;
    $scope.studentList = [];
    $scope.toDisplayStudentTab = function(){
        DN_DonorProfile_CTRL.toDisplayStudentTab($scope.donorId,null, function (result, event){
            if(event.status){                
                $scope.isstudentPresentList	= JSON.parse(result);   
                if($scope.isstudentPresentList.length > 0){
                    $scope.studentListStatus =true;
                }
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape: false});
    }
    
    $scope.isemptyStudents = false;
    $scope.AlumniStudentList = [];
    $scope.currentStudentList = [];
    $scope.getDonorStudents = function(){
      
        $scope.AlumniStudentList = [];
        $scope.currentStudentList = [];
        $scope.loading=true;
        DN_DonorProfile_CTRL.getDonorStudents($scope.donorId,null, function (result, event){
            if(event.status){                
                $scope.studentList	= JSON.parse(result);   
                if($scope.studentList.length > 0){
                    
                    for(var i=0;i<$scope.studentList.length;i++){
                        if($scope.studentList[i].Is_Active_Alumni__c == true){
                            $scope.AlumniStudentList.push($scope.studentList[i]);
                        }else{
                            $scope.currentStudentList.push($scope.studentList[i]);
                        }
                    }
                    //$scope.studentListStatus =true;
                    $scope.isemptyStudents = false;
                }else{		
                    $scope.isemptyStudents = true;
                }
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape: false});
    };
    
    
    $scope.getDonorSpecifiedYearStudents = function(Year){
        $scope.AlumniStudentList = [];
        $scope.currentStudentList = [];
        $scope.loading=true;
        $scope.financialYear = Year;
        DN_DonorProfile_CTRL.getDonorStudents($scope.donorId,Year, function (result, event){
            if(event.status){                
                $scope.studentList	= JSON.parse(result);   
                if($scope.studentList.length > 0){
                    
                    for(var i=0;i<$scope.studentList.length;i++){
                        if($scope.studentList[i].Is_Active_Alumni__c == true){
                            $scope.AlumniStudentList.push($scope.studentList[i]);
                        }else{
                            $scope.currentStudentList.push($scope.studentList[i]);
                        }
                    }
                    //$scope.studentListStatus =true;
                    $scope.isemptyStudents = false;
                }else{
                    $scope.isemptyStudents = true;
                    //swal({title:'',text:"No Students for current Financial Year!!"}); 
                }
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape: false});
    };
    
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
    /*  $scope.studentDetails = function(Id){
        $scope.studentprofileTab=true;
        $scope.showTabcontent(4);
        $scope.selected=4;
        $scope.selectedSt(0,0);
    }*/
    $scope.displayPlacementData = false;
    $scope.displayNotPlacedTab = false;
    $scope.displayOtherTextTab = false;
    $scope.currentStudent = function(studentId,stuId,finYear){
           
        $scope.studentTrainingList = [];
        $scope.renderSkillDev = false;
        $scope.displayPlacementData = false;
        $scope.displayNotPlacedTab = false;
        $scope.displayOtherTextTab = false;
        $scope.loading=true;
        DN_DonorProfile_CTRL.getTrainingRecords(stuId,finYear, function (result1, event1){
            if(event1.status){
                console.log('result : '+JSON.stringify(result1));
                console.log('studentTrainingList : '+JSON.stringify($scope.studentTrainingList));
                
                for(var i=0;i<result1.length;i++){
                    $scope.studentTrainingList.push(result1[i]);
                    $scope.renderSkillDev = true;
                }
                
            }
        });
        DN_DonorProfile_CTRL.geMentoringDetails(stuId, function (result1, event1){
            $scope.studentMentoringList = [];
            if(event1.status){
                for(var i=0;i<result1.length;i++){
                    $scope.studentMentoringList.push(result1[i]);
                   	$scope.mentorName = result1[i].Mentor_Name__c;
                    $scope.mentorOrg = result1[i].Mentor_Organisation__c;
                }
                
                
            }
        });
        if(studentId!=undefined && studentId!=''){
            $scope.contantId	= studentId;
            $scope.viewStudent = true;
           
            DN_DonorProfile_CTRL.viewStudentProfile($scope.contantId, function (result, event){
                if(event.status){                
                    $scope.studentDetails= JSON.parse(result);
                    //
                    //console.log('$scope.contantId : '+$scope.studentDetails.Student__c);
           
                    
                    //
                    
                    var studentCourse = $scope.studentDetails.Student__r.Course__c;
                    if(studentCourse != undefined && studentCourse != '' && (studentCourse === "BE/B.Tech" || studentCourse === "Integrated MTech" )){
                        $scope.displayAmcatTaken = true;
                       //console.log('$scope.studentDetails.Student__r.English_Spoken_Score__c :'+$scope.studentDetails.Student__r.English_Spoken_Score__c);
                        if( 
                            (($scope.studentDetails.Student__r.Aptitude_Analytical_Score__c != undefined && $scope.studentDetails.Student__r.Aptitude_Analytical_Score__c != null && $scope.studentDetails.Student__r.Aptitude_Analytical_Score__c != '') ||  $scope.studentDetails.Student__r.Aptitude_Analytical_Score__c === 0)
                            || 
                            (($scope.studentDetails.Student__r.Aptitude_Logical_Score__c != undefined && $scope.studentDetails.Student__r.Aptitude_Logical_Score__c != null && $scope.studentDetails.Student__r.Aptitude_Logical_Score__c != '') ||  $scope.studentDetails.Student__r.Aptitude_Logical_Score__c === 0)
                            || 
                            (($scope.studentDetails.Student__r.English_Written_Score__c != undefined && $scope.studentDetails.Student__r.English_Written_Score__c != null && $scope.studentDetails.Student__r.English_Written_Score__c != '') ||  $scope.studentDetails.Student__r.English_Written_Score__c === 0)
                            ||
                            (($scope.studentDetails.Student__r.English_Spoken_Score__c != undefined && $scope.studentDetails.Student__r.English_Spoken_Score__c != null && $scope.studentDetails.Student__r.English_Spoken_Score__c != '') ||  $scope.studentDetails.Student__r.English_Spoken_Score__c === 0)
                        )
                        {
                            $scope.amcatTakenValue = 'Yes';
                            
                        }
                        else
                        {
                            $scope.amcatTakenValue = 'No';
                            
                        }
                        
                        
                    }
                    else
                    {
                        $scope.displayAmcatTaken = false;
                    }
                    
                   /*var studentTrainingList = [];
                    var studentTraingingRecord = {};
                    studentTraingingRecord.trainingName = 'Test 1';
                    studentTraingingRecord.year = '2018';
                    studentTraingingRecord.status = 'Completed';
                    studentTraingingRecord.specialization = 'Java';
                    studentTrainingList.push(studentTraingingRecord);*/
                   // $scope.studentTrainingList = studentTrainingList;
                    if($scope.studentDetails.Student__r.X10th_Year_Passed__c==null && $scope.studentDetails.Student__r.X12th_Year_Passed__c==null && 
                       $scope.studentDetails.Student__r.X10th__c==null && $scope.studentDetails.Student__r.X12th__c==null && 
                       $scope.studentDetails.Student__r.X10th_Marks_Obtained__c==null && $scope.studentDetails.Student__r.X12th_Marks_Obtained__c==null && 
                       $scope.studentDetails.Student__r.X10th_Maximum_Marks__c==null && $scope.studentDetails.Student__r.X12th_Maximum_Marks__c==null && 
                       $scope.studentDetails.Student__r.X10th_Medium_Of_Instruction__c==null && $scope.studentDetails.Student__r.X12th_Medium_Of_Instruction__c==null && 
                       $scope.studentDetails.Student__r.X10th_Type__c==null && $scope.studentDetails.Student__r.X12th_Type__c==null){
                        $scope.tenthTwelthDetails = false;
                    }
                    
                    if($scope.studentDetails.Student__r.Semester1__c == null && $scope.studentDetails.Student__r.Semester2__c == null && $scope.studentDetails.Student__r.Semester3__c == null && $scope.studentDetails.Student__r.Semester4__c == null && $scope.studentDetails.Student__r.Semester5__c == null && $scope.studentDetails.Student__r.Semester6__c == null && $scope.studentDetails.Student__r.Semester7__c == null && $scope.studentDetails.Student__r.Semester8__c == null){
                        $scope.semesterInformation = false;
                    }
                    if($scope.studentDetails.Student__r.MBBS_Year_1__c == null && $scope.studentDetails.Student__r.MBBS_Year_2__c ==null && $scope.studentDetails.Student__r.MBBS_Year_3_Part_1__c==null && $scope.studentDetails.Student__r.MBBS_Year_3_Part_2__c==null){
                        $scope.MbbsScoreInformation = false;
                    }
                    if($scope.studentDetails.Student__r.Other_Entrance_Test__c==null && $scope.studentDetails.Student__r.Entrance_Test_Name__c=='Other'){
                        $scope.entranceTestName = false;
                    }
                    
                    if($scope.studentDetails.Student__r.Other_Entrance_Test__c==null && $scope.studentDetails.Student__r.Entrance_Test_Name__c=='Other' && $scope.studentDetails.Student__r.Entrance_Exam_Taken_In_Year__c==null && $scope.studentDetails.Student__r.Entrance_Exam_Maximum_Marks__c==null && $scope.studentDetails.Student__r.Entrance_Test_Marks__c==null && $scope.studentDetails.Student__r.Entrance_Test_Rank__c==null){
                        $scope.entranceExamInformation = false;
                    }
                    
                    if($scope.studentDetails.Student__r.Father_Name__c==null && $scope.studentDetails.Student__r.Mother_Name__c==null && $scope.studentDetails.Student__r.Father_Age__c==null && $scope.studentDetails.Student__r.Mother_Age__c==null && $scope.studentDetails.Student__r.Father_Education__c==null && $scope.studentDetails.Student__r.Mother_Education__c==null && $scope.studentDetails.Student__r.Father_Occupation__c==null && $scope.studentDetails.Student__r.Mother_Occupation__c==null && $scope.studentDetails.Student__r.Annual_Family_Income__c==null){
                        $scope.familyInformation = false;
                    }
                    if($scope.studentDetails.Student__r.Branch_Stream__c == 'Other'  && $scope.studentDetails.Student__r.Branch_Other__c==null){
                        $scope.branchDetails = false;
                    }
                    if($scope.studentDetails.Student__r.College_Name__c=='Other' && $scope.studentDetails.Student__r.College_Other__c== null){
                        $scope.collegeNameDetails = false;
                        if($scope.studentDetails.Student__r.College_City__c==null && $scope.studentDetails.Student__r.Course__c==null && $scope.studentDetails.Student__r.College_State__c==null && $scope.studentDetails.Student__r.Type__c==null && $scope.studentDetails.Student__r.Branch_Stream__c == null  && $scope.studentDetails.Student__r.Branch_Other__c==null){
                            $scope.collegeInformation  = false;
                        }
                        
                    }
                    
                    if($scope.studentDetails.Student__r.Placement_Info__c=='Placed'){
                        $scope.displayPlacementData = true;
                        
                    }else if($scope.studentDetails.Student__r.Placement_Info__c=='Not Placed'){
                        $scope.displayNotPlacedTab = true;
                        
                    }else if($scope.studentDetails.Student__r.Placement_Info__c!=undefined && $scope.studentDetails.Student__r.Placement_Info__c!=''){
                        $scope.displayOtherTextTab = true;
                    }
                    debugger;
                    
                    if($scope.studentDetails.Student__r.Attachments!=undefined){
                        $scope.resumeLink = $scope.studentDetails.Student__r.Attachments.records[0].Id;
                    }
                    
                    
                    
                    if($scope.studentDetails.Student__r.Profile_Pic_Attachment_Id__c != undefined && $scope.studentDetails.Student__r.Profile_Pic_Attachment_Id__c !=''){
                        $scope.imageSFIdURL= "/application/servlet/servlet.FileDownload?file="+$scope.studentDetails.Student__r.Profile_Pic_Attachment_Id__c;
                        $scope.noImage = false;
                    }
                    else{
                        $scope.noImage = true;
                    }
                    $scope.loading=false;
                    $scope.$apply();
                }
                else{
                    $scope.loading=false;
                }
            },{escape: false});
            //+++++++++++++=
            debugger;
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView($scope.contantId,$scope.donorId,'Uploaded for Scholar',function(result,event){
                if(event.status){
                    
                    $scope.allAttachments   =[];
                    $scope.allAttachments = JSON.parse(result);
                    console.log('Attachments : '+JSON.stringify($scope.allAttachments));
					$scope.$apply();
                }
            },{escape:false});
            
            //++++++++++++
        }
        else{
            $scope.loading=false;
            $scope.previous();
        }
    }
    
    $scope.applicationAttachments =[];
    $scope.letterofThanks = function(studentID){
        DN_DonorProfile_CTRL.letterOfThanksForDonor($scope.contantId, function (result, event){
            if(event.status){ 
                $scope.applicationAttachments = JSON.parse(result);
            }
            $scope.$apply();
        },{escape: false});
    }
    
    $scope.loadStudentProfile = function(){
        if($scope.contantId!=undefined && $scope.contantId!=''){
            $scope.currentStudent($scope.contantId);
            $scope.letterofThanks($scope.contantId);
        }
        else{
            $scope.viewStudent = false;
            $location.path('/donorStudents');
            
        }
    }
    $scope.previous = function(){
        $scope.viewStudent = false;
        $location.path('/donorStudents');
        //$scope.getDonorSpecifiedYearStudents($scope.financialYear);
    }
    $scope.showDesc = function(descObject){
        console.log(descObject);
        $scope.description=descObject;
        $scope.descPop =true;
    }
    $scope.closeDesc = function(){
        $scope.descPop =false;
    }
    //gourab
    /* $scope.studDataDownload = function(studentID){
      DN_DonorProfile_CTRL.getFFEId(studentID);
    } */
});