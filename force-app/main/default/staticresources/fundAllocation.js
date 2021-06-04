var app=angular.module('FundAllocation', ['ngRoute','ngAnimate','ngMaterial']);
app.controller('fundAllocation', function($scope, $timeout, $window, $location,$element){
    
     
    $scope.applnType=applnType;
    $scope.studentFilterOption= studentFilterOption;
    $scope.multiDonor_studentFilterOption= multiDonor_studentFilterOption;
    $scope.gauList=JSON.parse(gauList);
    $scope.DonorCategory = DonorCategory;
    $scope.gauDelim= gauDelim;
    $scope.gauAmtDelim= gauAmtDelim;
    $scope.studentPopup=false;
    $scope.donorBalance='false';
    $scope.searchArray ={};
    $scope.show=[];
    $scope.showDonor=[];
    $scope.extraFunds='';
    $scope.disburseDisabled=[];
    $scope.disburseDis=false;
    $scope.showResults=false;
    $scope.indexArray=[];
    $scope.savedArrayDonors=[];
    $scope.totalIndexAmount=[];
    var totalIndexAmountIndividual=0;
    $scope.disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
    $scope.studentsMatch ={Amount_Funded__c:'0',Amount_Requested__c:'0',ApplName:'',Remaining_Fund__c:'0',currentlyFunded:'0'};
    $scope.valuesForExtraDonor={Current_Balance__c:'0',Blocked_Funds__c:'0',GAU_Name__r:{Name:'',Id:''},extraFunds:'0',Donor_Name__r:{Name:'',Id:''},Donor_Name__c:'',GAU_Name__c:''};
    $scope.extraFundsRecords=[];
    $scope.NODonorMappingresults=[];
    $scope.isSelectedAppl=true;
    $scope.AppType=[];
    $scope.Gauid = [];
    $scope.DonorCategoryselected = '';
    $scope.totalFundedAmt = 0;    
    $scope.donorBalanceIds = [];
    $scope.amtFunded = [];
    $scope.donorRecs =[];
    
    $element.find('input').on('keydown', function(ev) {
        ev.stopPropagation();
    });
    
    $scope.cours = function(){
        if ($scope.isSelectedAppl) {
            for(var i=0;i<$scope.applnType.length;i++){
                $scope.AppType.push($scope.applnType[i].Id);
                $scope.isSelectedAppl=false;
            }
        }
        else if(!$scope.isSelectedAppl){
            $scope.AppType = [];
            $scope.isSelectedAppl=true;
        }
    }
    
    $scope.clearDonor = function(){
        $scope.searchDonor ='';
    }
    
    $scope.getDonors = function(donor){
        if(donor.length >=2){
            DN_FundAllocation_CTRL.getDonorByName(donor,function(result,event){
                if(event.status){
                    $scope.donors = JSON.parse(result);
                    console.log($scope.donors);
                    $scope.$apply();
                }
            },{escape:false});
        }
        else{
            $scope.donors ='';
        }
    }
    
    $scope.search = function(stud, apptype){
        $scope.loading=true;
        $scope.searchArray ={};
        if(stud==undefined){
            $scope.searchArray.studentType='';
        }
        else{
            $scope.searchArray.studentType=stud;
        }
        if(apptype==undefined){
            $scope.searchArray.applType=[];
        }
        else{
            $scope.searchArray.applType=apptype;
        }
        if((stud != undefined && stud !='' && $scope.bydonor != undefined && $scope.bydonor !='') || (apptype != undefined && apptype.length!=0 && $scope.bydonor != undefined && $scope.bydonor !='')){
            $scope.loading=false;
            swal({title:'',text:'Please select only one filter to query.'});
            return;
        }
        else if((stud == undefined || stud =='') &&  apptype.length==0 && ($scope.bydonor == undefined || $scope.bydonor =='')){
            $scope.loading=false;
            swal({title:'',text:'Please select any filter to query.'});
            return;
        }
            else if(!($scope.bydonor != undefined && $scope.bydonor !='')){
                console.log('Test 1: '+JSON.stringify($scope.searchArray));
                DN_FundAllocation_CTRL.getStudentswithApplication($scope.searchArray,function(result,event){
                    if(event.status){
                        $scope.studentMappingresults= JSON.parse(result);
                        $scope.show.length=$scope.studentMappingresults.length;
                        for(var i=0;i<$scope.studentMappingresults.length;i++){
                            $scope.show[i]=false;
                        }
                        $scope.hideHeader= true;
                        for(var i=0;i<$scope.studentMappingresults.length;i++){
                            $scope.show[i]=false;
                            if($scope.studentMappingresults[i].Applications__r !=undefined){
                                if($scope.studentMappingresults[i].Applications__r.records.length>0){
                                    $scope.hideHeader= false;
                                    break;
                                }
                            }
                        }
                        if($scope.hideHeader== true){
                            $scope.showResults=false;
                            swal({title:'',text:'No application available for funding.'})
                        }
                        if($scope.studentMappingresults.length>0){
                            $scope.showResults=true;
                        }
                        else{
                            $scope.showResults=false;
                            swal({title:'',text:'No application available for funding.'})
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
                    DN_FundAllocation_CTRL.getStudentsByDonorName($scope.bydonor,function(result,event){
                        var showFlag = false;
                        // console.log('Test 2: '+JSON.stringify($scope.searchArray));
                        if(event.status){
                            $scope.studentMappingresults= JSON.parse(result);
                            // console.log('Test 2: '+JSON.stringify($scope.studentMappingresults));
                            $scope.show.length=$scope.studentMappingresults.length;
                            for(var i=0;i<$scope.studentMappingresults.length;i++){
                                $scope.show[i]=false;
                                if($scope.studentMappingresults[i].Applications__r != undefined && $scope.studentMappingresults[i].Applications__r != null && $scope.studentMappingresults[i].Applications__r.records.length>0 ){
                                    showFlag = true;
                                } 
                            }
                            //if($scope.studentMappingresults.length>0){
                            if(showFlag){
                                $scope.showResults=true;
                            }
                            else{
                                $scope.showResults=false;
                                swal({title:'',text:'No results found.'})
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
    $scope.search_multi = function(stud, apptype){
        $scope.loading=true;
        $scope.searchArray ={};
        if(stud==undefined){
            $scope.searchArray.studentType='';
        }
        else{
            $scope.searchArray.studentType=stud;
        }
        if(apptype==undefined){
            $scope.searchArray.applType=[];
        }
        else{
            $scope.searchArray.applType=apptype;
        }
        if((stud != undefined && stud !='' && $scope.bydonor != undefined && $scope.bydonor !='') || (apptype != undefined && apptype.length!=0 && $scope.bydonor != undefined && $scope.bydonor !='')){
            $scope.loading=false;
            swal({title:'',text:'Please select only one filter to query.'});
            return;
        }
        else if((stud == undefined || stud =='') &&  apptype.length==0 && ($scope.bydonor == undefined || $scope.bydonor =='')){
            $scope.loading=false;
            swal({title:'',text:'Please select any filter to query.'});
            return;
        }
            else if(!($scope.bydonor != undefined && $scope.bydonor !='')){
                console.log('Test 1: '+JSON.stringify($scope.searchArray));
                DN_FundAllocation_CTRL.getStudentswithApplication_multi($scope.searchArray,function(result,event){
                    if(event.status){
                        $scope.studentMappingresults= JSON.parse(result);
                        $scope.show.length=$scope.studentMappingresults.length;
                        for(var i=0;i<$scope.studentMappingresults.length;i++){
                            $scope.show[i]=false;
                        }
                        $scope.hideHeader= true;
                        for(var i=0;i<$scope.studentMappingresults.length;i++){
                            $scope.show[i]=false;
                            if($scope.studentMappingresults[i].Applications__r !=undefined){
                                if($scope.studentMappingresults[i].Applications__r.records.length>0){
                                    $scope.hideHeader= false;
                                    break;
                                }
                            }
                        }
                        if($scope.hideHeader== true){
                            $scope.showResults=false;
                            swal({title:'',text:'No application available for funding.'})
                        }
                        if($scope.studentMappingresults.length>0){
                            $scope.showResults=true;
                        }
                        else{
                            $scope.showResults=false;
                            swal({title:'',text:'No application available for funding.'})
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
                    DN_FundAllocation_CTRL.getStudentsByDonorName($scope.bydonor,function(result,event){
                        var showFlag = false;
                        // console.log('Test 2: '+JSON.stringify($scope.searchArray));
                        if(event.status){
                            $scope.studentMappingresults= JSON.parse(result);
                            // console.log('Test 2: '+JSON.stringify($scope.studentMappingresults));
                            $scope.show.length=$scope.studentMappingresults.length;
                            for(var i=0;i<$scope.studentMappingresults.length;i++){
                                $scope.show[i]=false;
                                if($scope.studentMappingresults[i].Applications__r != undefined && $scope.studentMappingresults[i].Applications__r != null && $scope.studentMappingresults[i].Applications__r.records.length>0 ){
                                    showFlag = true;
                                } 
                            }
                            //if($scope.studentMappingresults.length>0){
                            if(showFlag){
                                $scope.showResults=true;
                            }
                            else{
                                $scope.showResults=false;
                                swal({title:'',text:'No results found.'})
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
    
    $scope.clear = function(){
        $scope.isSelectedAppl=true;
        $scope.loading=true;
        $scope.student='';
        $scope.AppType=[];
        //$scope.search($scope.student,$scope.AppType);
        $scope.loading=false;
        $scope.studentMappingresults =[];
        $scope.bydonor='';
        $scope.showResults =false;
        $scope.donors ='';
    }
    $scope.studnetApps = function(index){
        for(var i=0;i<$scope.studentMappingresults.length;i++){
            if(i==index){
                $scope.show[index] = !$scope.show[index];
            }
            else{
                $scope.show[i]=false;
            }
        }
    }
    $scope.donorsShow = function(index){
        for(var i=0;i<$scope.DonorMappingresults.length;i++){
            if(i==index){
                $scope.showDonor[index] = !$scope.showDonor[index];
            }
            else{
                $scope.showDonor[i]=false;
            }
        }
    }
    $scope.match = function(students,apps){
        if(apps.Amount_Funded__c!=undefined){
            $scope.studentsMatch.Amount_Funded__c=apps.Amount_Funded__c;
        }
        else{
            $scope.studentsMatch.Amount_Funded__c=0;
        }
        if(apps.Amount_Requested__c!=undefined){
            $scope.studentsMatch.Amount_Requested__c=apps.Amount_Requested__c;
        }
        else{
            $scope.studentsMatch.Amount_Requested__c=0;
        }
        if(apps.Remaining_Fund__c!=undefined){
            $scope.studentsMatch.Remaining_Fund__c=apps.Remaining_Fund__c;
        }
        else{
            $scope.studentsMatch.Remaining_Fund__c=0;
        }
        $scope.studentsMatch.ApplName	= apps.RecordType.Name;
        $scope.studentsMatch.currentlyFunded =0;
        $scope.studentContact = students;
        $scope.loading=true;
        $scope.studentPopup=true;
        $scope.studentFundsDetails=apps;
        $scope.recordsOfGau=[];
        $scope.totalIndexAmount=[];
        $scope.indexArray=[];
        console.log('Here: ');
        DN_FundAllocation_CTRL.getDonorStudentMapping(apps.Id,function(result,event){
            if(event.status){
                $scope.DonorMappingresults= JSON.parse(result);
                console.log('Result: '+result);
                $scope.showDonor.length=$scope.DonorMappingresults.length;
                if($scope.DonorMappingresults.length > 0){
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        $scope.showDonor[i]=false;
                    }
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        if($scope.DonorMappingresults[i].Donor_Balances__r != undefined && 
                           $scope.DonorMappingresults[i].Donor_Balances__r.records != undefined)
                            for(var j=0;j<$scope.DonorMappingresults[i].Donor_Balances__r.records.length;j++){
                                $scope.DonorMappingresults[i].Donor_Balances__r.records[j].extraFunds=0;
                            }        
                    }
                }
                console.log('Result: Final '+result);
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
    }
    $scope.match_multi = function(students,apps){
        console.log('GAUs_delimiter : '+$scope.gauDelim);       
        if(apps.Amount_Funded__c!=undefined){
            $scope.studentsMatch.Amount_Funded__c=apps.Amount_Funded__c;
        }
        else{
            $scope.studentsMatch.Amount_Funded__c=0;
        }
        if(apps.Amount_Requested__c!=undefined){
            $scope.studentsMatch.Amount_Requested__c=apps.Amount_Requested__c;
        }
        else{
            $scope.studentsMatch.Amount_Requested__c=0;
        }
        if(apps.Remaining_Fund__c!=undefined){
            $scope.studentsMatch.Remaining_Fund__c=apps.Remaining_Fund__c;
        }
        else{
            $scope.studentsMatch.Remaining_Fund__c=0;
        }
        $scope.studentsMatch.ApplName	= apps.RecordType.Name;
        $scope.studentsMatch.currentlyFunded =0;
        $scope.studentContact = students;
        $scope.loading=true;
        $scope.studentPopup=true;
        $scope.studentFundsDetails=apps;
        $scope.recordsOfGau=[];
        $scope.totalIndexAmount=[];
        $scope.indexArray=[];
        console.log('Here: ');
        DN_FundAllocation_CTRL.getDonorStudentMapping_multi(apps.Id,function(result,event){
            if(event.status){
                $scope.DonorMappingresults= JSON.parse(result);
                console.log('Result: '+result);
                $scope.showDonor.length=$scope.DonorMappingresults.length;
                if($scope.DonorMappingresults.length > 0){
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        $scope.showDonor[i]=false;
                    }
                    var fundingAmt = 0;
                    var donorBalanceIds = [];
                    var gausName = [];
                    var amtFunded = [];
                    var gauNameAmnt = [];
                    var donorRecs = [];
                    /*    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        if($scope.DonorMappingresults[i].Donor_Balances__r != undefined && 
                           $scope.DonorMappingresults[i].Donor_Balances__r.records != undefined)
                            for(var j=0;j<$scope.DonorMappingresults[i].Donor_Balances__r.records.length;j++){
                                $scope.DonorMappingresults[i].Donor_Balances__r.records[j].extraFunds=0;
                            }        
                    }*/
                    
                    
                    
                    //*****
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        var recordsToAdd = [];
                        if($scope.DonorMappingresults[i].Donor_Application_Mappings__r != undefined && 
                           $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records != undefined)
                            for(var j=0;j<$scope.DonorMappingresults[i].Donor_Application_Mappings__r.records.length;j++){
                                var gaus=  $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].GAU_Information__c;
                                var donRem =  $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].Donor_Remark__c;
                                var indvGau = gaus.split($scope.gauDelim);
                                 var indvDonRem = [];
                                if(donRem != '' && donRem != undefined && donRem != null){
                                   indvDonRem  = donRem.split($scope.gauDelim);
                                }
                               
                                console.log('indvGau '+JSON.stringify(indvGau));
                                for(var jj=0;jj<indvGau.length;jj++){
                                    if(indvGau[jj] != null && indvGau[jj] != '' && indvGau[jj] != undefined){
                                        var rec = [];
                                        rec = Object.assign({}, $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j]);
                                        rec.GAU_Information__c = indvGau[jj].trim();
                                        rec.Funding_amount__c = indvGau[jj].trim().split($scope.gauAmtDelim)[1].trim();
                                        if(indvDonRem != '' && indvDonRem != undefined && indvDonRem != null)
                                        rec.Donor_Remark__c = indvDonRem[jj].trim().replace("No Remarks","");
                                        console.log('indvGau rec '+JSON.stringify(rec));
                                        recordsToAdd.push(rec);
                                    }
                                }
                                
                                //GAU_Information__c
                                // fundingAmt += parseInt($scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].Funding_amount__c);
                            }
                        console.log('indvGau rec Data Subham changed : '+ JSON.stringify(recordsToAdd));
                        var donorRec = Object.assign({}, $scope.DonorMappingresults[i]);
                        donorRec.Donor_Application_Mappings__r.records = recordsToAdd;
                        donorRec.Donor_Application_Mappings__r.totalSize = recordsToAdd.length;
                        donorRecs.push(donorRec);
                       
                        
                    }
                     $scope.donorRecs = donorRecs;
                     console.log('indvGau rec Data Subham changed donorRec : '+ JSON.stringify($scope.donorRecs));
                    //****
                        
                    $scope.DonorMappingresults = $scope.donorRecs;
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        
                        

                        
                        var recOG = [];
                        if($scope.DonorMappingresults[i].Donor_Application_Mappings__r != undefined && 
                           $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records != undefined)
                            for(var j=0;j<$scope.DonorMappingresults[i].Donor_Application_Mappings__r.records.length;j++){
                                recOG.push($scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j]);
                                var gaus=  $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].GAU_Information__c;
                                if(gaus != null && gaus != '' && gaus != undefined){
                                    //var n = gaus.indexOf(":-");
                                    var n = gaus.split($scope.gauAmtDelim);
                                    //if(n != -1){
                                    if(n != undefined && n!=null && n.length > 0){
                                        //gaus = gaus.substring(0,n).trim();
                                        gaus = n[0].trim();
                                        gausName.push(gaus+$scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].Donor__c);
                                        //donorIds.push($scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].Donor__c);
                                        var gauNameAmntRec = {"Name":"","Amount":"","DonorId":""};
                                        gauNameAmntRec.Name = gaus;
                                        gauNameAmntRec.Amount = n[1].trim();
                                        gauNameAmntRec.DonorId = $scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].Donor__c;
                                        gauNameAmnt.push(gauNameAmntRec);
                                        //$scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].GAU_Information__c=gaus;
                                    }
                                }
                                //GAU_Information__c
                                fundingAmt += parseInt($scope.DonorMappingresults[i].Donor_Application_Mappings__r.records[j].Funding_amount__c);
                            } 
                        
						 console.log('Data Subham OG : '+ JSON.stringify(recOG));                        
                    }
                }
                console.log('Result: gausName '+gausName);
                console.log('Result: gauNameAmnt '+JSON.stringify(gauNameAmnt));
                if($scope.DonorMappingresults.length > 0){
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        if($scope.DonorMappingresults[i].Donor_Balances__r != undefined && 
                           $scope.DonorMappingresults[i].Donor_Balances__r.records != undefined)
                            for(var j=0;j<$scope.DonorMappingresults[i].Donor_Balances__r.records.length;j++){
                                //$scope.DonorMappingresults[i].Donor_Balances__r.records[j].extraFunds=0;
                                if(gausName.includes($scope.DonorMappingresults[i].Donor_Balances__r.records[j].GAU_Name__r.Name+$scope.DonorMappingresults[i].Donor_Balances__r.records[j].Donor_Name__c)
                                   ){
                                    donorBalanceIds.push($scope.DonorMappingresults[i].Donor_Balances__r.records[j].Id);
                                    var rec = $scope.DonorMappingresults[i].Donor_Balances__r.records[j];
                                    delete rec["attributes"];
                                    delete rec.Donor_Name__r["attributes"];
                                    delete rec.GAU_Name__r["attributes"];
                                    delete rec["extraFunds"];
                                    delete rec["$$hashKey"];
                                    delete rec["attributes"];
                                    delete rec.Donor_Name__r["attributes"];
                                    delete rec.GAU_Name__r["attributes"];
                                    var extraFunds="";
                                    for(var a=0;a<gauNameAmnt.length;a++){
                                        if(gauNameAmnt[a].Name.trim() == $scope.DonorMappingresults[i].Donor_Balances__r.records[j].GAU_Name__r.Name.trim()
                                          &&
                                          gauNameAmnt[a].DonorId.trim() == $scope.DonorMappingresults[i].Donor_Balances__r.records[j].Donor_Name__c.trim() 
                                          ){
                                            extraFunds = gauNameAmnt[a].Amount;
                                            break;
                                        }
                                    }
                                    amtFunded.push({donorbalance:rec,extraFunds:extraFunds});
                       
                                    //amtFunded.push(rec);
                                }
                                
                            }
                    }
                }
                
                
                console.log('Result: Final '+result);
                console.log('Result: fundingAmt '+fundingAmt);
                console.log('Result: donorBalanceIds '+donorBalanceIds);
                console.log('Result: amtFunded '+JSON.stringify(amtFunded));
                $scope.totalFundedAmt = fundingAmt;
                $scope.donorBalanceIds = donorBalanceIds;
                $scope.amtFunded = amtFunded;
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
    }
    $scope.matchNodonor = function(students,apps){
        $scope.showNoresults=false;
        if(apps.Amount_Funded__c!=undefined){
            $scope.studentsMatch.Amount_Funded__c=apps.Amount_Funded__c;
        }
        else{
            $scope.studentsMatch.Amount_Funded__c=0;
        }
        if(apps.Amount_Requested__c!=undefined){
            $scope.studentsMatch.Amount_Requested__c=apps.Amount_Requested__c;
        }
        else{
            $scope.studentsMatch.Amount_Requested__c=0;
        }
        if(apps.Remaining_Fund__c!=undefined){
            $scope.studentsMatch.Remaining_Fund__c=apps.Remaining_Fund__c;
        }
        else{
            $scope.studentsMatch.Remaining_Fund__c=0;
        }
        $scope.remainingFromDonor=$scope.studentsMatch.Remaining_Fund__c;
        $scope.studentsMatch.ApplName=apps.RecordType.Name;
        $scope.studentsMatch.currentlyFunded =0;
        $scope.studentContact = students;
        $scope.studentFundsDetails=apps;
        $scope.DonorExtraFunds=true;
        $scope.DonorPopup=true;
        $scope.extraDonors=[];
        $scope.NODonorMappingresults=[];
        $scope.totalIndexAmount=[];
        $scope.indexArray=[];
    }
    $scope.checkValidation = function(extrafunds, Current_Balance__c,index,parentIndex){
        for(var i=0;i<$scope.DonorMappingresults.length;i++){
            for(var j=0;j<$scope.DonorMappingresults[i].Donor_Balances__r.records.length;j++){
                if($scope.DonorMappingresults[i].Donor_Balances__r.records[j].extraFunds >0){
                    if($scope.DonorMappingresults[i].Donor_Balances__r.records[j].extraFunds > $scope.DonorMappingresults[i].Donor_Balances__r.records[j].Current_Balance__c){
                        $scope.disburseDisValidation=true;
                        return; 
                    }
                }
            }
            $scope.disburseDisValidation=false;
        }
        
    }
    $scope.getTotalDisburse = function(currentlyFunded,Remaining_Fund__c,records,index){
        $scope.addFundPop=false;//jj
        var totalAmount=0;
        var total=0;
        
        // if(records == undefined){
        //     records = [];
        // }
        for(var j=0;j<records.length;j++){
            if(records[j].extraFunds != undefined && records[j].extraFunds !=''){
                total = total+parseInt(records[j].extraFunds)
            }
        }
        if(total > (parseInt($scope.studentsMatch.Amount_Requested__c)- parseInt($scope.studentsMatch.Amount_Funded__c))){
            $scope.disburseDis=true;
            $scope.addFundPop=false;
        }
        else{
            $scope.disburseDis=false;
            $scope.addFundPop=true;
        }
        if(total == (parseInt(currentlyFunded)+ parseInt(Remaining_Fund__c))){
            $scope.addFundPop=false;
        }
        $scope.indexArray[index] = total;
        for(var i=0;i<$scope.indexArray.length;i++){
            if($scope.indexArray[i]!=undefined && $scope.indexArray[i]!=''){
                totalAmount = totalAmount+parseInt($scope.indexArray[i]);
            }
        }
        if(totalAmount > (parseInt($scope.studentsMatch.Amount_Requested__c)- parseInt($scope.studentsMatch.Amount_Funded__c))){
            $scope.disburseDis=true;
            $scope.addFundPop=false;
        }
        if(totalAmount == (parseInt(Remaining_Fund__c)+ parseInt(currentlyFunded))){
            $scope.addFundPop=false;
        }
        return total;
    }
    
    
    $scope.checkisEmpty = function(nodonors){
        
        if(nodonors.extraFunds == undefined || nodonors.extraFunds == ''){
            swal({title:'',text:'The Funding amount cannot be empty either make it 0'});
            
        }
    }
    
    $scope.getTotalDisburseNodonors = function(nodonors){
        $scope.notAllow= true;
        
        
        for(var k=0;k<nodonors.length;k++){
            if(nodonors[k].Current_Balance__c < nodonors[k].extraFunds){
                //if(nodonors[k].extraFunds == ''){
                //    swal({title:'',text:'The Funding amount cannot be empty either make it 0'});
                //}
                $scope.disburseDis=true;
                $scope.addFundPop=true;
                $scope.notAllow= false;
            }
        }
        if($scope.notAllow){
            $scope.totalAmountNodonors=0;
            $scope.addFundPop=false;
            var totalAmount=0;
            var total=0;
            for(var j=0;j<$scope.NODonorMappingresults.length;j++){
                if($scope.NODonorMappingresults[j].extraFunds != undefined && $scope.NODonorMappingresults[j].extraFunds !=''){
                    total = total+parseInt($scope.NODonorMappingresults[j].extraFunds)
                }
            }
            if(total > ($scope.studentsMatch.Remaining_Fund__c+$scope.studentsMatch.Amount_Requested__c)){
                $scope.disburseDis=true;
                $scope.addFundPop=true;
                swal({title:'',text:'The Amount Funded should be less than or equal to Amount Requested.'});
                $scope.totalAmountNodonors=parseInt(total);
                return;
            }
            $scope.studentsMatch.currentlyFunded = total;
            $scope.studentsMatch.Remaining_Fund__c= $scope.studentsMatch.Amount_Requested__c- $scope.studentsMatch.currentlyFunded-$scope.studentsMatch.Amount_Funded__c;
            if($scope.studentsMatch.currentlyFunded > $scope.studentsMatch.Amount_Requested__c || $scope.studentsMatch.Remaining_Fund__c < 0){
                $scope.disburseDis=true;
                $scope.addFundPop=true;
            }
            else{
                $scope.disburseDis=false;
                $scope.addFundPop=false;
            }
            $scope.totalAmountNodonors=parseInt(total);
        }
    }
    
    $scope.save = function(){
        $scope.studentPopup=false;
    }
    $scope.cancel = function(){
        $scope.studentPopup=false;
    }
    $scope.addExtraDonors = function(total,RemainingFund,index,records){
        //$scope.studentsMatch.currentlyFunded =0;
        $scope.showNoresults=false;
        var totalCurrentlyfunded = 0;
        $scope.recordsOfGau=records;
        $scope.DonorExtraFunds= true;
        $scope.DonorPopup=true;
        $scope.extraDonors=[];
        for(var i=0;i<$scope.indexArray.length;i++){
            if($scope.indexArray[i]!=undefined && $scope.indexArray[i]!=''){
                totalCurrentlyfunded = totalCurrentlyfunded+parseInt($scope.indexArray[i]);
            }
        }
        $scope.remainingFromDonor = parseInt($scope.studentsMatch.Amount_Requested__c)-parseInt($scope.studentsMatch.Amount_Funded__c)-parseInt(totalCurrentlyfunded);
        $scope.DonorIndex=index;
    }
    $scope.addFundsNoDonors =function(){
        $scope.studentsMatch.currentlyFunded =0;
        $scope.recordsOfGau=$scope.NODonorMappingresults;
        $scope.DonorExtraFunds= true;
        $scope.DonorPopup=true;
        $scope.showNoresults=false;
        $scope.extraDonors=[];
        $scope.remainingFromDonor=parseInt($scope.studentsMatch.Remaining_Fund__c);
    }
    // $scope.Gauid = [];
    //$scope.DonorCategoryselected = '';
    $scope.addFundObj ={};
    $scope.clearDonorByGau = function(){console.log($scope.addFundObj);
                                        $scope.addFundObj.Gauid = '';
                                        $scope.addFundObj.DonorCategoryselected = '';
                                        $scope.extraDonors.length = 0;
                                        $scope.showNoresults = false;
                                       }
    
    $scope.searchDonorByGau =function(gauId,DonorCategorydata){
        $scope.loading=true;
        $scope.showNoresults = false;
        if(gauId == null || gauId == '' || DonorCategorydata == null || DonorCategorydata == ''){
            $scope.loading=false;
            swal({title:'',text:'Please select both Donor Category and GAU.'});
            return;
        }
        
        DN_FundAllocation_CTRL.getGAUWiseDonorBalance(gauId,DonorCategorydata,function(result,event){
            if(event.status){
                $scope.extraDonors=JSON.parse(result);
                for(var i=0;i<$scope.extraDonors.length;i++){
                    $scope.extraDonors[i].extraFunds=0;
                    if($scope.extraDonors[i].Current_Balance__c==undefined || $scope.extraDonors[i].Current_Balance__c==''){
                        $scope.extraDonors[i].Current_Balance__c =0;
                    }
                    if($scope.extraDonors[i].Blocked_Funds__c==undefined || $scope.extraDonors[i].Blocked_Funds__c==''){
                        $scope.extraDonors[i].Blocked_Funds__c =0;
                    }
                    if($scope.extraDonors[i].Total_Available_Fund__c==undefined || $scope.extraDonors[i].Total_Available_Fund__c==''){
                        $scope.extraDonors[i].Total_Available_Fund__c =0;
                    }
                    if($scope.extraDonors[i].Last_Instalment_Amount__c==undefined || $scope.extraDonors[i].Last_Instalment_Amount__c==''){
                        $scope.extraDonors[i].Last_Instalment_Amount__c =0;
                    }
                    
                }
                if($scope.extraDonors.length > 0){
                    $scope.showNoresults = false;
                }
                else{
                    $scope.showNoresults = true;
                }
                if($scope.studentFundsDetails.IsMapped__c){
                    if($scope.recordsOfGau !=undefined){
                        for(var i=0;i<$scope.extraDonors.length;i++){
                            for(var j=0;j<$scope.recordsOfGau.length;j++){
                                if(($scope.recordsOfGau[j].Donor_Name__r.Id==$scope.extraDonors[i].Donor_Name__r.Id) && ($scope.recordsOfGau[j].GAU_Name__r.Id==$scope.extraDonors[i].GAU_Name__r.Id)){
                                    if($scope.recordsOfGau[j].extraFunds!=undefined){
                                        $scope.extraDonors[i].Current_Balance__c = $scope.extraDonors[i].Current_Balance__c-$scope.recordsOfGau[j].extraFunds;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (!$scope.studentFundsDetails.IsMapped__c){
                    for(var m=0;m<$scope.NODonorMappingresults.length;m++){
                        for(var i=0;i<$scope.extraDonors.length;i++){
                            if(($scope.NODonorMappingresults[m].Donor_Name__r.Id==$scope.extraDonors[i].Donor_Name__r.Id) && ($scope.NODonorMappingresults[m].GAU_Name__r.Id==$scope.extraDonors[i].GAU_Name__r.Id)){
                                if($scope.NODonorMappingresults[m].extraFunds!=undefined){
                                    $scope.extraDonors[i].Current_Balance__c = $scope.extraDonors[i].Current_Balance__c-$scope.NODonorMappingresults[m].extraFunds;                    
                                }
                            }
                        }
                    }
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
    $scope.getTotalFromExtraDonors = function(value,records){
        var total=0;
        for(var j=0;j<records.length;j++){
            if(records[j].extraFunds != undefined && records[j].extraFunds !=''){
                total = total+parseInt(records[j].extraFunds)
            }
        }
        if(total > parseInt(value)){
            $scope.isMatchExtraFunds=true;
            swal({title:'',text:'The total amount should be less than or equal to Remaining Fund'})
        }
        else{
            $scope.isMatchExtraFunds=false;
        }
        return total;
    }
    $scope.cancelExtraDonor = function(){
        $scope.DonorExtraFunds= false;
        $scope.DonorPopup=false;
        $scope.extraDonors=[];
        if($scope.totalAmountNodonors !=undefined)
            $scope.studentsMatch.currentlyFunded=parseInt($scope.totalAmountNodonors);
    }
    $scope.validAmountExtradonor = function(extraDonors){
        for(var i=0;i<extraDonors.length;i++){
            if(parseInt(extraDonors[i].extraFunds) > parseInt(extraDonors[i].Current_Balance__c)){
                $scope.disableSave=true;
                return; 
            }
        }
        $scope.disableSave=false;
    }
    $scope.saveExtraDonor = function(extraDonors){
        if($scope.studentFundsDetails.IsMapped__c){
            var k=0;
            var lengthOfDonor=$scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records.length;
            for(var j=0;j<extraDonors.length;j++){
                $scope.isRecord=false;
                if(extraDonors[j].extraFunds != undefined && extraDonors[j].extraFunds !=''){
                    if(parseInt(extraDonors[j].extraFunds) > 0){                    
                        
                        $scope.valuesForExtraDonor =extraDonors[j];
                        for(var m=0;m<$scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records.length;m++){
                            if(($scope.valuesForExtraDonor.Donor_Name__r.Id==$scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records[m].Donor_Name__r.Id) && ($scope.valuesForExtraDonor.GAU_Name__r.Id==$scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records[m].GAU_Name__r.Id)){
                                $scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records[m].extraFunds =parseInt($scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records[m].extraFunds)+parseInt($scope.valuesForExtraDonor.extraFunds);
                                $scope.isRecord=true;
                            }
                        }
                        if(!$scope.isRecord){
                            $scope.DonorMappingresults[$scope.DonorIndex].Donor_Balances__r.records[lengthOfDonor+k]=$scope.valuesForExtraDonor;
                            k++;
                        }
                        
                        $scope.DonorExtraFunds= false;
                        $scope.DonorPopup=false;
                    }
                }
            }
        }
        else if(!$scope.studentFundsDetails.IsMapped__c){
            if($scope.NODonorMappingresults.length==0){
                var k=0;
                for(var i=0;i<$scope.extraDonors.length;i++){
                    if( $scope.extraDonors[i].extraFunds!=0 && $scope.extraDonors[i].extraFunds!=undefined){                      
                        $scope.NODonorMappingresults[k]= $scope.extraDonors[i];
                        k++
                    }
                }
            }else {
                var length=$scope.NODonorMappingresults.length;
                var m=0;
                for(var i=0;i<$scope.extraDonors.length ;i++){
                    $scope.isNodonor = true;
                    for(var j=0;j<$scope.NODonorMappingresults.length;j++){
                        if(($scope.NODonorMappingresults[j].Donor_Name__r.Id==$scope.extraDonors[i].Donor_Name__r.Id) && ($scope.NODonorMappingresults[j].GAU_Name__r.Id==$scope.extraDonors[i].GAU_Name__r.Id)){
                            if($scope.extraDonors[i].extraFunds>0){
                                $scope.NODonorMappingresults[j].extraFunds = parseInt($scope.NODonorMappingresults[j].extraFunds)+parseInt($scope.extraDonors[i].extraFunds);
                                $scope.isNodonor = false;
                                break;
                            }
                        }
                    }
                    if($scope.isNodonor){
                        if( $scope.extraDonors[i].extraFunds!=0 && $scope.extraDonors[i].extraFunds!=undefined){
                            $scope.NODonorMappingresults[$scope.NODonorMappingresults.length]= $scope.extraDonors[i];
                        }
                    }
                }
            }
            if($scope.NODonorMappingresults.length>0){
                $scope.DonorExtraFunds= false;
                $scope.DonorPopup=false;
                $scope.studentAllocationPopUp =true;
                $scope.studentPopup=true;
                $scope.getTotalDisburseNodonors($scope.NODonorMappingresults);
            }
            
        }
    }
    $scope.saveDonors = function(records,index){
        var totalIndexAmount=0;
        totalIndexAmountIndividual=0;
        $scope.totalIndexAmount[index]=0;
        $scope.savedArrayDonors[index]=records;
        for(var i=0;i<$scope.indexArray.length;i++){
            if($scope.indexArray[i]!=undefined && $scope.indexArray[i]!=''){
                totalIndexAmountIndividual = totalIndexAmountIndividual+parseInt($scope.indexArray[i]);
            }
        }
        for(var i=0;i<$scope.savedArrayDonors[index].length;i++){
            if($scope.savedArrayDonors[index][i].extraFunds!=undefined && $scope.savedArrayDonors[index][i].extraFunds!=''){
                $scope.totalIndexAmount[index] = parseInt($scope.totalIndexAmount[index])+parseInt($scope.savedArrayDonors[index][i].extraFunds);
            }
        }
        for(var i=0;i<$scope.totalIndexAmount.length;i++){
            if($scope.totalIndexAmount[i]!=undefined && $scope.totalIndexAmount[i]!=''){
                totalIndexAmount = parseInt($scope.totalIndexAmount[i])+parseInt(totalIndexAmount);
            }
        }
        if($scope.studentsMatch.Amount_Requested__c < totalIndexAmount || $scope.studentsMatch.Remaining_Fund__c <0){
            $scope.disburseDis=true;
            swal({title:'',text:'The Amount Funded For Current Application should be less than or equal to the Student Requested Amount.'});
            return;
        }
        $scope.studentsMatch.currentlyFunded=totalIndexAmount;
        $scope.studentsMatch.Remaining_Fund__c=$scope.studentsMatch.Amount_Requested__c-$scope.studentsMatch.currentlyFunded-$scope.studentsMatch.Amount_Funded__c;
        $scope.disburseDis=false;
    }
    
    $scope.disburse = function(){
        $scope.disburseWrapper={};
        if($scope.studentFundsDetails.IsMapped__c){
            if(($scope.studentsMatch.currentlyFunded > 0 && $scope.studentsMatch.currentlyFunded ==totalIndexAmountIndividual)){
                if($scope.studentsMatch.Remaining_Fund__c==0){
                    $scope.disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
                    var k=0;
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        for(var m=0;m<$scope.DonorMappingresults[i].Donor_Balances__r.records.length;m++){
                            if( parseInt($scope.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) !=undefined && parseInt($scope.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) !='' && parseInt($scope.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) != 0)
                            {
                                $scope.extraFundsRecords[k] =$scope.DonorMappingresults[i].Donor_Balances__r.records[m];
                                delete $scope.extraFundsRecords[k]["attributes"];
                                delete $scope.extraFundsRecords[k].Donor_Name__r["attributes"];
                                delete $scope.extraFundsRecords[k].GAU_Name__r["attributes"];
                                $scope.disburseWrapper.donorBalanceIds[k]=$scope.DonorMappingresults[i].Donor_Balances__r.records[m].Id;
                                k++;
                            }
                        }
                    }
                    $scope.disburseWrapper.student=$scope.studentContact;
                    delete $scope.disburseWrapper.student["attributes"];
                    delete $scope.disburseWrapper.student["Applications__r"];
                    delete $scope.disburseWrapper.student["$$hashKey"];
                    $scope.disburseWrapper.appln=$scope.studentFundsDetails;
                    delete $scope.disburseWrapper.appln["attributes"];
                    delete $scope.disburseWrapper.appln["RecordType"];
                    delete $scope.disburseWrapper.appln["$$hashKey"];
                    for(var r=0;r<$scope.extraFundsRecords.length;r++){
                        $scope.disburseWrapper.amtFunded.push({donorbalance:$scope.extraFundsRecords[r],extraFunds:$scope.extraFundsRecords[r].extraFunds});
                        delete $scope.disburseWrapper.amtFunded[r].donorbalance["extraFunds"];
                        delete $scope.disburseWrapper.amtFunded[r].donorbalance["$$hashKey"];
                    }
                    $scope.disburseWrapper.totalFundedAmt=$scope.studentsMatch.currentlyFunded;
                    $scope.disburseFundMethod($scope.disburseWrapper);
                }
                else{
                    swal({title:'',text:'Please make sure you are disbursing full amount.'})
                }
                
            }
            else{
                swal({title:'',text:'Please make sure you have saved your selections.'});
                return;
            }
        }
        else if(!$scope.studentFundsDetails.IsMapped__c){
            if($scope.studentsMatch.Remaining_Fund__c==0){
                $scope.disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
                $scope.disburseWrapper.student=$scope.studentContact;
                delete $scope.disburseWrapper.student["attributes"];
                delete $scope.disburseWrapper.student["Applications__r"];
                delete $scope.disburseWrapper.student["$$hashKey"];
                $scope.disburseWrapper.appln=$scope.studentFundsDetails;
                delete $scope.disburseWrapper.appln["attributes"];
                delete $scope.disburseWrapper.appln["RecordType"];
                delete $scope.disburseWrapper.appln["$$hashKey"];
                for(var r=0;r<$scope.NODonorMappingresults.length;r++){
                    $scope.disburseWrapper.amtFunded.push({donorbalance:$scope.NODonorMappingresults[r],extraFunds:$scope.NODonorMappingresults[r].extraFunds});
                    $scope.disburseWrapper.donorBalanceIds[r]=$scope.NODonorMappingresults[r].Id;
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance["extraFunds"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance["$$hashKey"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance["attributes"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance.Donor_Name__r["attributes"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance.GAU_Name__r["attributes"];
                }
                $scope.disburseWrapper.totalFundedAmt=$scope.studentsMatch.currentlyFunded;
                $scope.disburseFundMethod($scope.disburseWrapper);
            }
            else{
                swal({title:'',text:'Please make sure you are disbursing full amount.'});
            }
        }
    }
    
    $scope.disburse_multi = function(){
        console.log('$scope.studentFundsDetails.IsMapped__c : '+$scope.studentFundsDetails.IsMapped__c);
        console.log('$scope.studentsMatch.currentlyFunded : '+$scope.studentsMatch.currentlyFunded);
        console.log('totalIndexAmountIndividual : '+totalIndexAmountIndividual);
        
        var studentJSON = $scope.studentContact;
        delete studentJSON["attributes"];
        delete studentJSON["Applications__r"];
        delete studentJSON["$$hashKey"];
        console.log('student ' +JSON.stringify(studentJSON));
        
        var appJSON = $scope.studentFundsDetails;
        delete appJSON["attributes"];
        delete appJSON["RecordType"];
        delete appJSON["$$hashKey"];
        console.log('app ' +JSON.stringify(appJSON));
        
        console.log('totalFundedAmt ' +$scope.totalFundedAmt);
        $scope.disburseWrapper={};
        $scope.disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
        $scope.disburseWrapper.student = studentJSON;
        $scope.disburseWrapper.appln = appJSON;
        $scope.disburseWrapper.amtFunded = $scope.amtFunded;
        $scope.disburseWrapper.totalFundedAmt = $scope.totalFundedAmt;
        $scope.disburseWrapper.donorBalanceIds = $scope.donorBalanceIds;
        
        console.log('disburseWrapper  ' +JSON.stringify($scope.disburseWrapper));
        debugger;
        $scope.disburseFundMethod_multi($scope.disburseWrapper);
       // return;
      /*  
       // if($scope.studentFundsDetails.IsMapped__c){
         //   if(($scope.studentsMatch.currentlyFunded > 0 && $scope.studentsMatch.currentlyFunded ==totalIndexAmountIndividual)){
           //     if($scope.studentsMatch.Remaining_Fund__c==0){
        if(true){
            if(true){
                if(true){
                    
                    var k=0;
                    for(var i=0;i<$scope.DonorMappingresults.length;i++){
                        for(var m=0;m<$scope.DonorMappingresults[i].Donor_Balances__r.records.length;m++){
                            if( parseInt($scope.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) !=undefined && parseInt($scope.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) !='' && parseInt($scope.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) != 0)
                            {
                                $scope.extraFundsRecords[k] =$scope.DonorMappingresults[i].Donor_Balances__r.records[m];
                                delete $scope.extraFundsRecords[k]["attributes"];
                                delete $scope.extraFundsRecords[k].Donor_Name__r["attributes"];
                                delete $scope.extraFundsRecords[k].GAU_Name__r["attributes"];
                                $scope.disburseWrapper.donorBalanceIds[k]=$scope.DonorMappingresults[i].Donor_Balances__r.records[m].Id;
                                k++;
                            }
                        }
                    }
                    $scope.disburseWrapper.student=$scope.studentContact;
                    delete $scope.disburseWrapper.student["attributes"];
                    delete $scope.disburseWrapper.student["Applications__r"];
                    delete $scope.disburseWrapper.student["$$hashKey"];
                    $scope.disburseWrapper.appln=$scope.studentFundsDetails;
                    delete $scope.disburseWrapper.appln["attributes"];
                    delete $scope.disburseWrapper.appln["RecordType"];
                    delete $scope.disburseWrapper.appln["$$hashKey"];
                    for(var r=0;r<$scope.extraFundsRecords.length;r++){
                        $scope.disburseWrapper.amtFunded.push({donorbalance:$scope.extraFundsRecords[r],extraFunds:$scope.extraFundsRecords[r].extraFunds});
                        delete $scope.disburseWrapper.amtFunded[r].donorbalance["extraFunds"];
                        delete $scope.disburseWrapper.amtFunded[r].donorbalance["$$hashKey"];
                    }
                    $scope.disburseWrapper.totalFundedAmt=$scope.studentsMatch.currentlyFunded;
                    $scope.disburseFundMethod($scope.disburseWrapper);
                }
                else{
                    swal({title:'',text:'Please make sure you are disbursing full amount.'})
                }
                
            }
            else{
                swal({title:'',text:'Please make sure you have saved your selections.'});
                return;
            }
        }
        else if(!$scope.studentFundsDetails.IsMapped__c){
            if($scope.studentsMatch.Remaining_Fund__c==0){
                $scope.disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
                $scope.disburseWrapper.student=$scope.studentContact;
                delete $scope.disburseWrapper.student["attributes"];
                delete $scope.disburseWrapper.student["Applications__r"];
                delete $scope.disburseWrapper.student["$$hashKey"];
                $scope.disburseWrapper.appln=$scope.studentFundsDetails;
                delete $scope.disburseWrapper.appln["attributes"];
                delete $scope.disburseWrapper.appln["RecordType"];
                delete $scope.disburseWrapper.appln["$$hashKey"];
                for(var r=0;r<$scope.NODonorMappingresults.length;r++){
                    $scope.disburseWrapper.amtFunded.push({donorbalance:$scope.NODonorMappingresults[r],extraFunds:$scope.NODonorMappingresults[r].extraFunds});
                    $scope.disburseWrapper.donorBalanceIds[r]=$scope.NODonorMappingresults[r].Id;
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance["extraFunds"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance["$$hashKey"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance["attributes"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance.Donor_Name__r["attributes"];
                    delete $scope.disburseWrapper.amtFunded[r].donorbalance.GAU_Name__r["attributes"];
                }
                $scope.disburseWrapper.totalFundedAmt=$scope.studentsMatch.currentlyFunded;
                $scope.disburseFundMethod($scope.disburseWrapper);
            }
            else{
                swal({title:'',text:'Please make sure you are disbursing full amount.'});
            }
        } */
    }
    
        $scope.disburseFundMethod_multi = function(wrapper){
        console.log('Wrapper is: '+JSON.stringify(wrapper));
        $scope.loading=true;
        DN_FundAllocation_CTRL.disburseFund_multi(wrapper,function(result,event){
            if(event.status){
                $scope.DonorExtraFunds = false;
                $scope.studentPopup =false;
                $scope.studentPopup=false;
                $scope.DonorPopup=false;
                swal({title:'',text:result});
                $scope.search($scope.student,$scope.AppType);
                $scope.loading=false;
                $scope.studentsMatch.currentlyFunded =0;
                $scope.$apply();
                
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false});
    }
    
    $scope.disburseFundMethod = function(wrapper){
        console.log('Wrapper is: '+JSON.stringify(wrapper));
        $scope.loading=true;
        DN_FundAllocation_CTRL.disburseFund(wrapper,function(result,event){
            if(event.status){
                $scope.DonorExtraFunds = false;
                $scope.studentPopup =false;
                $scope.studentPopup=false;
                $scope.DonorPopup=false;
                swal({title:'',text:result});
                $scope.search($scope.student,$scope.AppType);
                $scope.loading=false;
                $scope.studentsMatch.currentlyFunded =0;
                $scope.$apply();
                
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false});
    }
    
});
