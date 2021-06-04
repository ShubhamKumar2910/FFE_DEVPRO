/*
* @Purpose      : Helper Class for DN_DoonorAllocation_CTRL
* @Author       : Amritesh
*/ 

global class DN_DonorAllocation_Helper { 
    
    /*@purpose                      : Inserting donor and relatedstudents
* @param                        : donorID,listofStudent
* @returnType                   : String
*/   
    public static String createDonorStudentMapping(String donorId, List<ApplicationDonorMappingWrapper> appDonorMappingWrp){
        
        Set<String> lstApplicationIds = new Set<String>();
        Map<String,Integer> fundingAmtMap = new Map<String,Integer>();
        Map<String,String> donorRemarksMap = new Map<String,String>();
        
        for(ApplicationDonorMappingWrapper adm : appDonorMappingWrp){
            lstApplicationIds.add(adm.appId);
            if(adm.fundingAmount != null){
                fundingAmtMap.put(adm.appId,Integer.valueOf(adm.fundingAmount));
            }else{
                fundingAmtMap.put(adm.appId,0);    
            }    
            donorRemarksMap.put(adm.appId,adm.donorRemark);
        }
        SavePoint sp = Database.setSavepoint();
        try{
            List<Donor_Application_Mapping__c> lstDonorStudentsApplication =new List<Donor_Application_Mapping__c>();
            List<Application__c> ApplicationInfo = [Select id,IsMapped__c,Student__c,Donor_Remarks__c,Student__r.Donor_Name__c,Amount_Funded__c from Application__c where id in:lstApplicationIds];
            Donor_Application_Mapping__c  donorStudentMapping ;
            List<Application__c> updateAppList = new List<Application__c>();
            if(!lstApplicationIds.isEmpty()){
                for(Application__c str:ApplicationInfo){
                    lstDonorStudentsApplication.add(new Donor_Application_Mapping__c(Application__c=str.id,Donor__c=donorId,Student__c = str.Student__c,Funding_amount__c=fundingAmtMap.get(str.Id),Donor_Remark__c=donorRemarksMap.get(str.Id)));
                    str.IsMapped__c                 = true;                                    
                    updateAppList.add(str);
                }
            }
            system.debug('updateAppList:::::::'+updateAppList);
            system.debug('lstDonorStudentsApplication:::::::'+lstDonorStudentsApplication);
            
            // Insert new Donor-Application Mapping
            if(!lstDonorStudentsApplication.isEmpty()) insert lstDonorStudentsApplication;
            update updateAppList;
            return Constants.MAPPING_SUCCESS_MSG;
        }catch(Exception e){
            Database.rollback(sp);
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'createDonorStudentMapping', e);            
            return Constants.ERROR_MSG;
        }
        
        
    }
    @RemoteAction    
    public static string save_multiDonor(List<Map<String,String>> donorBalanceList,List<Map<String,String>> donorAppList){
       SavePoint sp = Database.setSavepoint();
        try{
            
        System.debug('donorBalanceList : ' + JSON.serialize(donorBalanceList));
        System.debug('donorAppList : ' + JSON.serialize(donorAppList));
        List<Id> listIds = new List<Id>();
        Map<String,String> mappedFund = new  Map<String,String>();
        for(Map<String,String> donorBalances : donorBalanceList){
            listIds.add(donorBalances.get('donorBalanceId'));
            System.debug('Id: '+donorBalances.get('donorBalanceId'));
            System.debug('Mapped_Fund__c: '+donorBalances.get('Mapped_Fund__c'));
            mappedFund.put(donorBalances.get('donorBalanceId'),donorBalances.get('Mapped_Fund__c'));
        }
        List<Donor_Balance__c> listDonorBalances = [Select Id, Mapped_Fund__c, Donor_Name__r.Name,GAU_Name__r.Name,Current_Balance__c , GAU_Name__c ,Donor_Name__c, Donor_GAU__c   FROM Donor_Balance__c where Id in :  listIds] ;
        for(Donor_Balance__c objDonBal :listDonorBalances ){
            objDonBal.Mapped_Fund__c = (objDonBal.Mapped_Fund__c != null ?objDonBal.Mapped_Fund__c:0) + Decimal.valueOf(mappedFund.get(objDonBal.Id));
            if(objDonBal.Mapped_Fund__c > objDonBal.Current_Balance__c ){
                return 'Amount Exhausted. Donor: '+objDonBal.Donor_Name__r.Name +' : GAU : '+ objDonBal.GAU_Name__r.Name  ;
            }
            System.debug('objDonBal: '+objDonBal);
            System.debug('Break: *****************');
        }
        Update listDonorBalances;    
        
        //System.debug('listDonorBalances: '+JSON.serialize(listDonorBalances));
        Set<Id> setAppIds = new Set<Id>();
        Map<String,String> mapFundAmt = new  Map<String,String>();
        Map<String,String> mapDonorRemarks = new  Map<String,String>();
        Map<String,String> gaus = new  Map<String,String>();
        Map<String,Map<String,String>> mapActual = new Map<String,Map<String,String>>();
        for(Map<String,String> donorAppMappings : donorAppList){
            /*System.debug('Change Application__c: '+donorAppMappings.get('Application__c'));
System.debug('Donor__c: '+donorAppMappings.get('Donor__c'));
System.debug('Funding_amount__c: '+donorAppMappings.get('Funding_amount__c'));
System.debug('Student__c: '+donorAppMappings.get('Student__c'));
System.debug('gauName: '+donorAppMappings.get('gauName'));
System.debug('Donor_Remark__c: '+donorAppMappings.get('Donor_Remark__c'));*/
            mapActual.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),donorAppMappings);
            if(mapFundAmt.get(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c')) != null){
                mapFundAmt.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),String.valueOf(Integer.valueOf(mapFundAmt.get(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'))) +Integer.valueOf(donorAppMappings.get('Funding_amount__c'))) );
            }
            else{
                mapFundAmt.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),donorAppMappings.get('Funding_amount__c'));
            }
            if(mapDonorRemarks.get(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c')) != null){
                mapDonorRemarks.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),String.valueOf((mapDonorRemarks.get(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'))) +Label.GAUs_delimiter+(String.isBlank(string.valueOf(donorAppMappings.get('Donor_Remark__c'))) ? 'No Remarks':donorAppMappings.get('Donor_Remark__c'))) );
            }
            else{
                mapDonorRemarks.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),String.isBlank(string.valueOf(donorAppMappings.get('Donor_Remark__c'))) ? 'No Remarks':donorAppMappings.get('Donor_Remark__c'));
            }
            if(gaus.get(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c')) != null){
                gaus.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),String.valueOf((gaus.get(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'))) +Label.GAUs_delimiter+(donorAppMappings.get('gauName') + Label.GAU_Amount_delimiter + donorAppMappings.get('Funding_amount__c'))) );
            }
            else{
                gaus.put(donorAppMappings.get('Application__c') + donorAppMappings.get('Donor__c') + donorAppMappings.get('Student__c'),donorAppMappings.get('gauName') + Label.GAU_Amount_delimiter + donorAppMappings.get('Funding_amount__c'));
            }
            
        }
        
        List<Donor_Application_Mapping__c> listDonorMappings = new List<Donor_Application_Mapping__c> ();
        for(String keyStr : mapFundAmt.keySet()){
            Donor_Application_Mapping__c objDonorAppMapping = new Donor_Application_Mapping__c ();
            objDonorAppMapping.Application__c = mapActual.get(keyStr).get('Application__c');
            setAppIds.add(objDonorAppMapping.Application__c);
            objDonorAppMapping.Donor__c = mapActual.get(keyStr).get('Donor__c');
            objDonorAppMapping.Student__c = mapActual.get(keyStr).get('Student__c');
            objDonorAppMapping.Funding_amount__c = mapFundAmt != null && mapFundAmt.get(keyStr) != null ? Decimal.valueOf(mapFundAmt.get(keyStr)):0 ;
            objDonorAppMapping.Donor_Remark__c = mapDonorRemarks != null && String.isNotBlank(mapDonorRemarks.get(keyStr)) ? mapDonorRemarks.get(keyStr):'' ;
            objDonorAppMapping.Created_from_Multi_Donor_Feature__c = true;
            objDonorAppMapping.GAU_Information__c = gaus != null && String.isNotBlank(gaus.get(keyStr)) ? gaus.get(keyStr):'' ;
            System.debug('objDonorAppMapping: '+objDonorAppMapping);
            System.debug('Break: *****************');
            listDonorMappings.add(objDonorAppMapping);
        }
            List<Application__c> listApps = new List<Application__c>();
            Insert listDonorMappings;
            for(Id appId : setAppIds){
                Application__c objApp = new Application__c();
                objApp.Id = appId;
                objApp.IsMapped__c = true;
                listApps.add(objApp);
            }  
            if(listApps != null && listApps.size() > 0){
                update listApps;
            }   
        return Constants.MAPPING_SUCCESS_MSG;
        }catch(Exception e){
            Database.rollback(sp);
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'save_multiDonor', e);            
            return Constants.ERROR_MSG;
        }
    
        // System.debug('mapFundAmt: '+JSON.serialize(mapFundAmt.values()));
        // System.debug('mapDonorRemarks: '+JSON.serialize(mapDonorRemarks.values()));
        // System.debug('gaus: '+JSON.serialize(gaus.values()));
        //System.debug('listDonorMappings: '+listDonorMappings);
        return 'Work In Progress';
    }
    
    /*@purpose     : Get Donor Details
* @returnType  : String
*/
    Public static List<DonorSearchResultWrapper> getDonorDetails(){
        List<DonorSearchResultWrapper> returnList   = new List<DonorSearchResultWrapper>();
        try{
            Id donorRecordTypeId          = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            List<Contact> lstDonordetails = [SELECT Name,FFE_ID__c,DN_Donor_Type__c,Mailingcity,MailingState,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,Recordtype.id 
                                             from Contact where recordtype.id=:donorRecordTypeId];
            for(Contact con : lstDonordetails){
                returnList.add(getWrapperObject(con, Double.valueOf(con.Current_Balance__c), Double.valueOf(con.Blocked_Funds__c),0,0,0));
            }
        }catch(exception e){
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'getDonorDetails', e);
            returnList  = new List<DonorSearchResultWrapper>();
        }
        return returnList;
    }
    
    /*
* @purpose                      : Get All Student Details based on filters
* @param                        : searchFilter
* @param                        : donorId
* @returnType                   : List<Contact>
*/    
    public static List<Application__c> getFilteredStudents(CollegeFilterWrpper  searchFilter, string DonorId){
        try{
            List<String> studentState                   =  new List<String>();
            studentState                                =  searchFilter.studentState; 
            List<String> collegStates                   =  new List<String>();
            collegStates                                =  searchFilter.collegStates;
            List<string> collegeCity                    =  new List<String>();
            collegeCity                                 =  searchFilter.collegeCity;
            List<string> collegeName                    =  new List<String>();
            collegeName                                 =  searchFilter.collegeName;
            List<string> Course                         =  new List<String>();
            Course                                      =  searchFilter.Course;
            List<string> courseYear                     =  new List<String>();
            courseYear                                  =  searchFilter.courseYear;
            List<string> collegeRating                  =  new List<String>(); 
            collegeRating                               =  searchFilter.collegeRating;
            List<string> genderList                     =  new List<String>();
            genderList                                  =  searchFilter.genderList;
            List<string> branchList                     =  new List<String>();
            branchList                                  =  searchFilter.branchList;
            // string examNameList                      =  searchFilter.examNameList;
            // examNameList                             =  searchFilter.examNameList;
            //  String examRankList                     =  searchFilter.examRankList;   
            String scholarshipAmountList                =  searchFilter.scholarshipAmountList;   
            String FFEUID                               =  searchFilter.FFEUId;
            double minIncome                            =  searchFilter.minIncome;
            double maxIncome                            =  searchFilter.maxIncome;
            //gourab    
            String priority                             =  searchFilter.priorityList;   
            
            string query                                = '';
            string awaitingStatus                       = Constants.AWAITING_FUND_STATUS;
            string awaitingStatusApi                    = Constants.AWAITING_FUND_STATUS_API;
            String activeApplication                    = Constants.ACTIVE_APPLICATION;
            String financialYear                        = utility.financialYear();
            List<Integer> rList                         = new List<Integer>();
            Id StudentRecordType                        = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            
            query                                       ='SELECT Id,Student__r.Name,Donor_Remarks__c,RPT_Financial_Year__c,Student__c,Student__r.Gender__c,Application_Stage__c,Student__r.FFE_ID__c,toLabel(Student__r.Internal_Status__c),Student__r.Annual_Family_Income__c,Student__r.ScholarshipAmount__c,'+
                'Student__r.MailingState,Student__r.College_Name__r.College_State__c,Student__r.College_Name__r.College_City__c,Student__r.College_Name__r.Name,'+
                'Student__r.Course__c,Approval_Date__c,Amount_Funded__c,Student__r.College_Name__r.College_Rating__c'+
                ' FROM Application__c where Student__r.RecordTypeId =:StudentRecordType AND (Student__r.Internal_Status__c=:awaitingStatus OR Student__r.Internal_Status__c=:awaitingStatusApi) ';
            
            if(FFEUID != null){ 
                query+='AND Student__r.FFE_ID__c=:FFEUID';
            }else{    
                if(studentState.size() >0){
                    query+=' AND Student__r.MailingState IN:studentState';
                }
                if(collegStates.size() >0){
                    query+=' AND Student__r.College_Name__r.College_State__c IN:collegStates';
                }
                if(collegeCity.size() >0){
                    query+=' AND Student__r.College_Name__r.College_City__c IN:collegeCity';
                }
                if(collegeName.size() >0){
                    query+=' AND Student__r.College_Name__r.Name IN:collegeName';
                }
                if(Course.size()>0){
                    query+='  AND Student__r.Course__c IN:Course';
                }  
                if(courseYear.size()>0){
                    query+='  AND Year__c IN:courseYear';
                }
                if(collegeRating.Size()>0){
                    query+='  AND Student__r.College_Name__r.College_Rating__c  IN:collegeRating';
                }
                if(genderList.size() >0){
                    query+='  AND Student__r.Gender__c IN:genderList';
                }
                if(branchList.size() > 0){
                    query+='  AND Student__r.Branch_Stream__c IN:branchList';
                }
                // gourab   
                /*  if(ExamNameList!=null && ExamNameList!=''){
query+='  AND Student__r.Entrance_Test_Name__c =:examNameList';
}

//gourab   
if(examRankList!=null && examRankList!=''){
String stringToRemove = 'upto ';
Integer result = Integer.valueOf(examRankList.remove(stringToRemove));
query+='  AND Student__r.Entrance_Test_Rank__c <=:result';

} */
                
                // gourab
                if(priority != null && priority !=''){
                    query+='  AND Student__r.Priority__c =:priority';     
                }    
                
                if(scholarshipAmountList!=null && scholarshipAmountList!=''){
                    Integer amount = Integer.valueof(System.label.Amount40000);
                    Integer amount1 = Integer.valueof(System.label.Amount_35000);
                    Integer amount2 = Integer.valueof(System.label.Amount_30000);
                    
                    if(scholarshipAmountList == System.label.Greater_than_40000){
                        query+='  AND Student__r.ScholarshipAmount__c>:amount'; 
                    }
                    else if(scholarshipAmountList == System.label.Equal_40000){
                        query+='  AND Student__r.ScholarshipAmount__c=:amount';
                    }
                    else if(scholarshipAmountList == System.label.From_35000_to_40000){
                        query+='  AND Student__r.ScholarshipAmount__c>=:amount1 AND Student__r.ScholarshipAmount__c <=:amount';
                    }
                    else if(scholarshipAmountList == System.label.From_30000_to_35000){
                        query+='  AND Student__r.ScholarshipAmount__c>=:amount2 AND Student__r.ScholarshipAmount__c <=:amount1';
                    } 
                } 
                
                if(minIncome != null && maxIncome != null){
                    query+=' AND (Student__r.Annual_Family_Income__c >= :minIncome AND Student__r.Annual_Family_Income__c <=:maxIncome)';
                }
                
                
            }      
            
            query += ' AND Application_Stage__c=:activeApplication AND RPT_Financial_Year__c=:financialYear AND  Id NOT IN (SELECT Application__c FROM Donor_Application_Mapping__c) Order By Approval_Date__c ASC';
            
            system.debug(activeApplication + ':'+StudentRecordType + ':' + awaitingStatus + ':' + awaitingStatusApi + ':' + minIncome + ':' + maxIncome + ':' + activeApplication + ':' + financialYear);
            system.debug(JSON.serialize(query.split('Rating__c FROM A')[1]));
            
            List<Application__c> studentApplicationList   = new List<Application__c>();
            
            studentApplicationList = Database.query(query);
            system.debug('studentApplicationList:::::::::'+studentApplicationList);
            
            //for(Application__c app : studentApplicationList){
            //app.Funding_amount__c = app.Student__r.ScholarshipAmount__c;
            //}
            
            if(studentApplicationList.size()>0){
                return studentApplicationList;
            }else{
                return new List<Application__c>();
            }
            
        }catch(Exception ex){
            system.debug(ex.getLineNumber());
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'getFilteredStudents', ex);
            return new List<Application__c>();
        }
    }
    
    
    /*
* @purpose                      : Get DonorCitis based on search character
* @param                        : donorCity
* @returnType                   : List<String>
*/    
    public static List<String> getDonorLocation(String  donorCity, string donorCountry){
        Id donorRecordTypeId             = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();   
        String Query                     ='SELECT Id,Mailingcity From Contact where RecordTypeId =:donorRecordTypeId AND Mailingcity LIKE \'%' +donorCity+'%\' AND MailingCountry LIKE \'%' +donorCountry+'%\'';
        
        List<String> listOfCitys         = new List<String>(); 
        listOfCitys.add(JSON.serializePretty(Database.query(query)));               
        return  listOfCitys; 
    }      
    
    /*
* @purpose                      : Get  Student CollegeState based on search character
* @param                        : collegeState
* @returnType                   : List<String>
*/    
    public static List<String> getStudentCollegeState(String  collegeState){
        Id studentRecordTypeId            = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        String Query                      ='SELECT Id,College_Name__r.College_State__c From Contact where RecordTypeId =:studentRecordTypeId AND College_State__c LIKE \'%' +collegeState+'%\'';
        
        List<String> listOfStates         = new List<String>();
        listOfStates.add(JSON.serializePretty(Database.query(Query)));
        return  listOfStates;        
    }
    
    /*
* @purpose                      : Get  Student College Cities based on search character
* @param                        : @collegeCity
* @returnType                   : List<String>
*/    
    public static List<String> getStudentCollegeCity(String  collegeCity){
        Id studentRecordTypeId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();             
        
        string Query            = 'Select Id, College_City__c from College_Master__c where College_City__c != null AND  (College_City__c like \'%' + String.escapeSingleQuotes(collegeCity) + '%\') ORDER BY College_City__c';
        
        List<String> listOfColzCitis        = new List<String>();
        listOfColzCitis.add(JSON.serializePretty(Database.query(query)));
        return  listOfColzCitis; 
        
    }
    
    /*
* @purpose                          : Get  Student CollegeName Details based on filters
* @param                            : collegeName
* @returnType                       : List<String>
*/    
    public static List<String> getStudentCollegeName(String  collegeName){
        Id studentRecordTypeId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();                         
        string Query            = 'Select Id, Name,College_City__c,College_Rating__c,College_State__c from College_Master__c where Name != null AND  (Name like \'%' + String.escapeSingleQuotes(collegeName) + '%\') ORDER BY Name';
        
        List<String> listOfColzNames        = new List<String>();
        listOfColzNames.add(JSON.serializePretty(Database.query(Query)));            
        return  listOfColzNames; 
    }
    
    
    /*
* @purpose                      : Get All generalAccountUnit Names 
* @param                        : @None
* @returnType                   : List<String>
*/    
    public static List<String> getGeneralAccountUnit(){
        String Query                  ='SELECT Id,name From npsp__General_Accounting_Unit__c order by Name';            
        List<String> lstString        = new List<String>();
        lstString.add(JSON.serializePretty(database.query(Query)));
        return  lstString;        
    } 
    
    /*
* @purpose                      : Get All Donation Program
* @param                        : @None
* @returnType                   : List<String>
*/    
    public static List<String> getPrograms(){
        String Query                  ='SELECT Id,name From Donation_Program__c Order By name';            
        List<String> lstString        = new List<String>();
        lstString.add(JSON.serializePretty(database.query(Query)));
        return  lstString;
        
    } 
    
    /*
* @purpose : To get donors from the SF database by their location, Program & Current Balance.
*             Condition 1: Get all donors by their location
*             Condition 2: Get all donor by their location whose current balance > 0
*             Condition 3: Get all donors by their location with their balance for selected Program
*             Condition 4: Get all donors by their location with balance > 0 for selected Program
*             condition 5: Get all donors by selected Program  
*             condition 6: Get all donors by Program and current balance >0
*             condition 7: Get all donors with current balance >0
*             Condition 8: Get all donors
* @param: donorFilter
* @returnType : List<DonorSearchResultWrapper>
*/
    public static List<DonorSearchResultWrapper> getFileredDonorList(DonorFilterWrapper donorFilter){
        
        List<DonorSearchResultWrapper> finalWrpList =  new List<DonorSearchResultWrapper>();
        
        try{
            string donorRtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            string sObjquery;
            string aggQuery;
            system.debug('jc'+donorFilter.countryName);
            List<String> locations  = donorFilter.locations;
            List<String> gauIds     = donorFilter.gaus;
            String ffeUID           = donorFilter.ffeUID;
            string countryName = '';
            if(donorFilter.countryName == System.Label.Country_New_Zealand){
                countryName     = 'New Zealand'; //   System.Label.Country_Withoutspace_New_Zealand
            }else if(donorFilter.countryName == System.Label.Country_Bosnia_and_Herzegovina){
                countryName     = 'Bosnia and Herzegovina';   // System.Label.Country_Withoutspace_Bosnia_and_Herzegovina
            }else if(donorFilter.countryName == System.Label.Country_Hong_Kong){
                countryName     = 'Hong Kong';   // System.Label.Country_Withoutspace_Hong_Kong 
            }else{
                countryName     = donorFilter.countryName;    
            }
            
            system.debug(countryName);
            
            if(locations.size() > 0 && gauIds.size() == 0 ){
                if(donorFilter.isDonorBalance){
                    sObjquery   = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                        'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingState IN :locations '+
                        'AND Current_Balance__c > 0 AND MailingCountry=:countryName';
                    
                }else{
                    sObjquery   = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                        'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingState IN :locations AND MailingCountry=:countryName';                               
                    
                }
                sObjquery = sObjquery + ' Order By Name'; // FFE_ID__c
            }
            
            if(locations.size() == 0 && gauIds.size() == 0){
                if(donorFilter.isDonorBalance){
                    if(ffeUID=='' || ffeUID == null){
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND Current_Balance__c > 0 AND MailingCountry=:countryName';
                    }else{
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND Current_Balance__c > 0 AND FFE_ID__c=:ffeUID AND MailingCountry=:countryName'; 
                    }
                }else{
                    if(ffeUID=='' || ffeUID == null){
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingCountry=:countryName';
                    }else{
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND FFE_ID__c=:ffeUID AND MailingCountry=:countryName';  
                    }
                }
                sObjquery = sObjquery + ' Order By Name'; // FFE_ID__c
            }
            
            // Construct aggregate query to get sum of current balance & Sum of Blocked balance for 
            // group by each donor within the GAU 
            if(gauIds.size() > 0 ){              
                aggQuery    = 'Select Donor_Name__c,SUM(Current_Balance__C),SUM(Blocked_Funds__c)'+
                    'from Donor_Balance__c where GAU_Name__r.Program__c IN :gauIds AND '+ 
                    'Donor_Name__r.RecordTypeId =:donorRtypeId';
                
                if(donorFilter.locations.size() > 0){
                    aggQuery    += ' AND Donor_Name__r.MailingState IN :locations';
                    
                }
                aggQuery += ' Group By Donor_Name__c';
                
            }           
            
            // This block will execute if location get selected or Donor Balance checkbox get checked 
            // or both on Page but Program not selected
            if(sObjquery != null & sObjquery != ''){
                Map<Id,Contact> donors  = new Map<Id,Contact>((List<Contact>)Database.query(sObjquery));
                
                Map<id,AggregateResult> studentMapping          = new Map<id,AggregateResult>(getDonorStudentMappingResult(donors.keySet())); 
                Map<String,Integer> studentsbyCourse            = getStudentCountByCourse(donors.keySet());system.debug(studentsbyCourse);
                List<AggregateResult> studentsbyProgram         = new List<AggregateResult>(getDonorStudentsbyProgram(donors.keySet()));
                Map<id,AggregateResult> studentsbyEngg          = getStudentsbyProgram(studentsbyProgram,System.Label.Engineering);
                Map<id,AggregateResult> studentsbyMed           = getStudentsbyProgram(studentsbyProgram,System.Label.Medical);
                
                // to get the count of current financial year students mapped to donors
                Map<String,Integer> studentCountMap = Utility.getCurrentDonor_Student_Mapping(donors.keySet());
                
                for(Contact con : donors.Values()){
                    
                    double currentBalance   = Double.valueOf(con.Current_Balance__c);
                    Integer enggCount       = getStudentCountbyProgram(con.Id,System.Label.Engineering,studentsbyEngg,studentsbyCourse);
                    Integer medCount        = getStudentCountbyProgram(con.Id,System.Label.Medical,studentsbyMed,studentsbyCourse);
                    double availBalance     = currentBalance;
                    Integer currentYearStudentCount = studentCountMap.get(con.id);
                    
                    
                    if(studentMapping != null){
                        if(studentMapping.containsKey(con.id)){
                            availBalance    = currentBalance - Double.valueOf(studentMapping.get(con.Id).get('amtSum'));                            
                        }
                    }
                    //finalWrpList.add(getWrapperObject(con, currentBalance, Double.valueOf(con.Blocked_Funds__c),availBalance,enggCount,medCount));
                    DonorSearchResultWrapper wrpObj =  getWrapperObject(con, currentBalance, Double.valueOf(con.Blocked_Funds__c),availBalance,enggCount,medCount);
                    wrpObj.currentYearStudentCount = currentYearStudentCount;
                    finalWrpList.add(wrpObj);
                }
            }
            
            // This block will execute when Program gets selected on Page
            if(aggQuery != null & aggQuery != ''){
                List<AggregateResult> aggrResult        = Database.query(aggQuery);
                finalWrpList                            = getAggregateQueryResult(getListResultInMap(aggrResult),donorFilter.isDonorBalance);
                
            }            
            
        }catch(Exception ex){
            system.Debug(ex.getStackTraceString());
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'getFileredDonorList', ex);
            finalWrpList    = new List<DonorSearchResultWrapper>(); 
        }
        return finalWrpList;
    }    
    
    public static List<DonorSearchResultWrapper> getFileredDonorList_multiDonor(DonorFilterWrapper donorFilter,String strDonorCategory){
        
        List<DonorSearchResultWrapper> finalWrpList =  new List<DonorSearchResultWrapper>();
        
        try{
            if(strDonorCategory == 'Alumni'){
                       strDonorCategory = 'Scholar'; 
                    }
            string donorRtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            string sObjquery;
            string aggQuery;
            system.debug('jc'+donorFilter.countryName);
            List<String> locations  = donorFilter.locations;
            List<String> gauIds     = donorFilter.gaus;
            String ffeUID           = donorFilter.ffeUID;
            string countryName = '';
            if(donorFilter.countryName == System.Label.Country_New_Zealand){
                countryName     = 'New Zealand'; //   System.Label.Country_Withoutspace_New_Zealand
            }else if(donorFilter.countryName == System.Label.Country_Bosnia_and_Herzegovina){
                countryName     = 'Bosnia and Herzegovina';   // System.Label.Country_Withoutspace_Bosnia_and_Herzegovina
            }else if(donorFilter.countryName == System.Label.Country_Hong_Kong){
                countryName     = 'Hong Kong';   // System.Label.Country_Withoutspace_Hong_Kong 
            }else{
                countryName     = donorFilter.countryName;    
            }
            
            system.debug(countryName);
            
            /*if(locations.size() > 0 && gauIds.size() == 0 ){
                if(donorFilter.isDonorBalance){
                    sObjquery   = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                        'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingState IN :locations '+
                        'AND Current_Balance__c > 0 AND MailingCountry=:countryName';
                    
                }else{
                    sObjquery   = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                        'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingState IN :locations AND MailingCountry=:countryName';                               
                    
                }
                sObjquery = sObjquery + ' Order By Name'; // FFE_ID__c
            } */
            
          /* if(locations.size() == 0 && gauIds.size() == 0){
                if(donorFilter.isDonorBalance){
                    if(ffeUID=='' || ffeUID == null){
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND Current_Balance__c > 0 AND MailingCountry=:countryName';
                    }else{
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND Current_Balance__c > 0 AND FFE_ID__c=:ffeUID AND MailingCountry=:countryName'; 
                    }
                }else{
                    if(ffeUID=='' || ffeUID == null){
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingCountry=:countryName';
                    }else{
                        sObjquery ='Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND FFE_ID__c=:ffeUID AND MailingCountry=:countryName';  
                    }
                }
                sObjquery = sObjquery + ' Order By Name'; // FFE_ID__c
            }*/
            
            // Construct aggregate query to get sum of current balance & Sum of Blocked balance for 
            // group by each donor within the GAU 
            List<String> listGauNames = new List<String>();
            List<Multi_Donor_Gau_Configuration__mdt> listGaus = [Select Id,Gau_Name__c from Multi_Donor_Gau_Configuration__mdt where isActive__c = true];
            for(Multi_Donor_Gau_Configuration__mdt obj: listGaus){
                listGauNames.add(obj.Gau_Name__c);
            }
            //if(gauIds.size() > 0 ){              
               /* aggQuery    = 'Select Id,Donor_Name__c,SUM(Current_Balance__C),SUM(Blocked_Funds__c),SUM(Mapped_Fund__c),GAU_Name__r.Name '+
                    'from Donor_Balance__c where GAU_Name__r.Program__c IN :gauIds AND '+ 
                    'Donor_Name__r.RecordTypeId =:donorRtypeId AND GAU_Name__r.Name in :listGauNames'; */
            
             aggQuery    = 'Select Id,Donor_Name__c,SUM(Current_Balance__C),SUM(Blocked_Funds__c),SUM(Mapped_Fund__c),GAU_Name__r.Name,GAU_Name__r.Program__c  '+
                    'from Donor_Balance__c where '+ 
                    'Donor_Name__r.RecordTypeId =:donorRtypeId AND GAU_Name__r.Name in :listGauNames';
                
                
                if(donorFilter.locations.size() > 0){
                    aggQuery    += ' AND Donor_Name__r.MailingState IN :locations';
                    
                }
                if(string.isNotBlank(strDonorCategory)){
                    
                    aggQuery    += ' AND Donor_Name__r.DN_Donor_Category__c  =: strDonorCategory';
                    
                }
            	if(gauIds != null && gauIds.size() > 0){
                    aggQuery    += ' AND GAU_Name__r.Program__c   in: gauIds';
            	}
                aggQuery += ' Group By Id,Donor_Name__c,GAU_Name__r.Name,GAU_Name__r.Program__c Order By Donor_Name__c';
                
            //}           
            
            // This block will execute if location get selected or Donor Balance checkbox get checked 
            // or both on Page but Program not selected
            if(sObjquery != null & sObjquery != ''){
                Map<Id,Contact> donors  = new Map<Id,Contact>((List<Contact>)Database.query(sObjquery));
                
                Map<id,AggregateResult> studentMapping          = new Map<id,AggregateResult>(getDonorStudentMappingResult(donors.keySet())); 
                Map<String,Integer> studentsbyCourse            = getStudentCountByCourse(donors.keySet());system.debug(studentsbyCourse);
                List<AggregateResult> studentsbyProgram         = new List<AggregateResult>(getDonorStudentsbyProgram(donors.keySet()));
                Map<id,AggregateResult> studentsbyEngg          = getStudentsbyProgram(studentsbyProgram,System.Label.Engineering);
                Map<id,AggregateResult> studentsbyMed           = getStudentsbyProgram(studentsbyProgram,System.Label.Medical);
                
                // to get the count of current financial year students mapped to donors
                Map<String,Integer> studentCountMap = Utility.getCurrentDonor_Student_Mapping(donors.keySet());
                
                for(Contact con : donors.Values()){
                    
                    double currentBalance   = Double.valueOf(con.Current_Balance__c);
                    Integer enggCount       = getStudentCountbyProgram(con.Id,System.Label.Engineering,studentsbyEngg,studentsbyCourse);
                    Integer medCount        = getStudentCountbyProgram(con.Id,System.Label.Medical,studentsbyMed,studentsbyCourse);
                    double availBalance     = currentBalance;
                    Integer currentYearStudentCount = studentCountMap.get(con.id);
                    
                    
                    if(studentMapping != null){
                        if(studentMapping.containsKey(con.id)){
                            availBalance    = currentBalance - Double.valueOf(studentMapping.get(con.Id).get('amtSum'));                            
                        }
                    }
                    //finalWrpList.add(getWrapperObject(con, currentBalance, Double.valueOf(con.Blocked_Funds__c),availBalance,enggCount,medCount));
                    DonorSearchResultWrapper wrpObj =  getWrapperObject(con, currentBalance, Double.valueOf(con.Blocked_Funds__c),availBalance,enggCount,medCount);
                    wrpObj.currentYearStudentCount = currentYearStudentCount;
                    finalWrpList.add(wrpObj);
                }
            }
            
            // This block will execute when Program gets selected on Page
            if(aggQuery != null & aggQuery != ''){
                System.debug('******aggQuery****** : '+aggQuery);
                List<AggregateResult> aggrResult        = Database.query(aggQuery);
                System.debug('******aggrResult****** : '+aggrResult);
                finalWrpList                            = getAggregateQueryResult_multiDonor(getListResultInMap_multiDonor(aggrResult),donorFilter.isDonorBalance);
                
            }            
            
        }catch(Exception ex){
            system.Debug(ex.getStackTraceString());
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'getFileredDonorList', ex);
            finalWrpList    = new List<DonorSearchResultWrapper>(); 
        }
        return finalWrpList;
    }    
    
    private static Map<Id,AggregateResult> getListResultInMap(List<AggregateResult> aggrResult){
        Map<Id,AggregateResult> resultMap   =  new Map<Id,AggregateResult>();
        if(aggrResult.size() > 0){
            for(AggregateResult a : aggrResult){
                resultMap.put(String.valueOf(a.get('Donor_Name__c')),a);
            }
        }
        return resultMap;
    }
    private static Map<String,AggregateResult> getListResultInMap_multiDonor(List<AggregateResult> aggrResult){
        Map<String,AggregateResult> resultMap   =  new Map<String,AggregateResult>();
        if(aggrResult.size() > 0){
            for(AggregateResult a : aggrResult){
                resultMap.put(String.valueOf(a.get('Donor_Name__c')) + String.valueOf(a.get('Name')),a);
            }
        }
        return resultMap;
    }
    
    private static List<DonorSearchResultWrapper> getAggregateQueryResult(Map<Id,AggregateResult> aggrResult, boolean hasBalance){
        
        List<DonorSearchResultWrapper> resultWrpList    = new List<DonorSearchResultWrapper>(); 
        Map<id,AggregateResult> studentMapping          = new Map<id,AggregateResult>(getDonorStudentMappingResult(aggrResult.keySet())); 
        Map<String,Integer>  studentsbyCourse           = getStudentCountByCourse(aggrResult.keySet());
        List<AggregateResult> studentsbyProgram         = new List<AggregateResult>(getDonorStudentsbyProgram(aggrResult.keySet()));
        Map<id,AggregateResult> studentsbyEngg          = getStudentsbyProgram(studentsbyProgram,System.Label.Engineering);
        Map<id,AggregateResult> studentsbyMed           = getStudentsbyProgram(studentsbyProgram,System.Label.Medical);
        
        Set<String> conIds  =  new Set<String>();        
        for(AggregateResult ar  : aggrResult.values()){
            
            string donorId          = String.ValueOf(ar.get('Donor_Name__c'));
            double currentBalance   = ar.get('expr0')!=null?Double.valueOf(ar.get('expr0')):0;
            double blockedBalance   = ar.get('expr1')!=null?Double.valueOf(ar.get('expr1')):0; 
            double availBalance     = currentBalance;
            Integer enggCount       = getStudentCountbyProgram(donorId,System.Label.Engineering,studentsbyEngg,studentsbyCourse);
            Integer medCount        = getStudentCountbyProgram(donorId,System.Label.Medical,studentsbyMed,studentsbyCourse);
            
            Contact donorInfo       = new Contact();
            if(studentMapping != null && studentMapping.containsKey(donorId)){
                if(studentMapping.get(donorId).get('amtSum') != null){
                    availBalance = currentBalance - Double.valueOf(studentMapping.get(donorId).get('amtSum')); 
                }                
            }
            
            if(hasBalance){
                if(currentBalance > 0){
                    conIds.add(donorId);
                    donorInfo               = new Contact(Id=donorId);                                      
                }
            }else{
                conIds.add(donorId);
                donorInfo               = new Contact(Id=donorId);
            }              
            resultWrpList.add(getWrapperObject(donorInfo,currentBalance,blockedBalance,availBalance,enggCount,medCount));
        }
        
        Map<Id,Contact> donorMap                    = getContacts(conIds);
        List<DonorSearchResultWrapper> finalWrpList = new List<DonorSearchResultWrapper>();
        
        // to get the count of current financial year students mapped to donors
        Map<String,Integer> studentCountMap = Utility.getCurrentDonor_Student_Mapping(donorMap.keySet());
        
        
        for(DonorSearchResultWrapper sw : resultWrpList){
            if(donorMap.ContainsKey(sw.donorInfo.Id)){     
                // finalWrpList.add(getWrapperObject(donorMap.get(sw.donorInfo.Id),sw.currentBalance,sw.blockedBalance,sw.availableBalance,sw.enggCount,sw.medicalCount));
                Integer currentYearStudentCount = studentCountMap.get(sw.donorInfo.Id);    
                DonorSearchResultWrapper wrpObj =  getWrapperObject(donorMap.get(sw.donorInfo.Id),sw.currentBalance,sw.blockedBalance,sw.availableBalance,sw.enggCount,sw.medicalCount);
                wrpObj.currentYearStudentCount = currentYearStudentCount;
                finalWrpList.add(wrpObj);
            }
        } 
        return finalWrpList;
    }
    
    private static List<DonorSearchResultWrapper> getAggregateQueryResult_multiDonor(Map<String,AggregateResult> aggrResult, boolean hasBalance){
        
        List<DonorSearchResultWrapper> resultWrpList    = new List<DonorSearchResultWrapper>(); 
        //Map<id,AggregateResult> studentMapping          = new Map<id,AggregateResult>(getDonorStudentMappingResult(aggrResult.keySet())); 
        // Map<String,Integer>  studentsbyCourse           = getStudentCountByCourse(aggrResult.keySet());
        //List<AggregateResult> studentsbyProgram         = new List<AggregateResult>(getDonorStudentsbyProgram(aggrResult.keySet()));
        //  Map<id,AggregateResult> studentsbyEngg          = getStudentsbyProgram(studentsbyProgram,System.Label.Engineering);
        //  Map<id,AggregateResult> studentsbyMed           = getStudentsbyProgram(studentsbyProgram,System.Label.Medical);
        
        Set<String> conIds  =  new Set<String>();        
        for(AggregateResult ar  : aggrResult.values()){
            
            System.debug(String.ValueOf(ar.get('Name')) + ' : '+ String.ValueOf(ar.get('Donor_Name__c')) + ' : ');
            string donorId          = String.ValueOf(ar.get('Donor_Name__c'));
            string gauName          = String.ValueOf(ar.get('Name'));
            double currentBalance   = ar.get('expr0')!=null?Double.valueOf(ar.get('expr0')):0;
            string donorBalId = String.ValueOf(ar.get('Id'));
            double mappedFund = ar.get('expr2')!=null?Double.valueOf(ar.get('expr2')):0;
            // double blockedBalance   = ar.get('expr1')!=null?Double.valueOf(ar.get('expr1')):0; 
            // double availBalance     = currentBalance;
            // Integer enggCount       = getStudentCountbyProgram(donorId,System.Label.Engineering,studentsbyEngg,studentsbyCourse);
            // Integer medCount        = getStudentCountbyProgram(donorId,System.Label.Medical,studentsbyMed,studentsbyCourse);
            
            Contact donorInfo       = new Contact();
            /*  if(studentMapping != null && studentMapping.containsKey(donorId)){
if(studentMapping.get(donorId).get('amtSum') != null){
availBalance = currentBalance - Double.valueOf(studentMapping.get(donorId).get('amtSum')); 
}                
}*/
            
            
            if(currentBalance > 0){
                conIds.add(donorId);
                donorInfo               = new Contact(Id=donorId);                                      
            }
            if(donorInfo != null && donorInfo.Id != null)            
            {
                System.debug('getWrapperObject_multiDonor(donorInfo,currentBalance,0,0,0,0,gauName) : '+JSON.serialize(getWrapperObject_multiDonor(donorInfo,currentBalance,0,0,0,0,gauName,donorBalId,mappedFund)));
                resultWrpList.add(getWrapperObject_multiDonor(donorInfo,currentBalance,0,0,0,0,gauName,donorBalId,mappedFund));
            }
            
        }
        
        
        Map<Id,Contact> donorMap                    = getContacts(conIds);
        List<DonorSearchResultWrapper> finalWrpList = new List<DonorSearchResultWrapper>();
        
        // to get the count of current financial year students mapped to donors
        Map<String,Integer> studentCountMap = Utility.getCurrentDonor_Student_Mapping(donorMap.keySet());
        
        
        for(DonorSearchResultWrapper sw : resultWrpList){
            if(donorMap.ContainsKey(sw.donorInfo.Id)){     
                // finalWrpList.add(getWrapperObject(donorMap.get(sw.donorInfo.Id),sw.currentBalance,sw.blockedBalance,sw.availableBalance,sw.enggCount,sw.medicalCount));
                // Integer currentYearStudentCount = studentCountMap.get(sw.donorInfo.Id);    
                DonorSearchResultWrapper wrpObj =  getWrapperObject_multiDonor(donorMap.get(sw.donorInfo.Id),sw.currentBalance,sw.blockedBalance,sw.availableBalance,sw.enggCount,sw.medicalCount,sw.gauName,sw.donorBalanceId,sw.mappedFund);
                //wrpObj.currentYearStudentCount = currentYearStudentCount;
                finalWrpList.add(wrpObj);
            }
        } 
        return finalWrpList;
    }
    
    
    /*
* Get total available student count for donor by Program. If donor already has student mapping then student count
* will be (total engineering/Medical student  - mapped engineering/Medical student)
*/ 
    private static integer getStudentCountbyProgram(String donorId,string program,Map<id,AggregateResult> studentsbyProgram,Map<String,Integer> studentsbyCourse){
        Integer scholarCount    = 0;
        
        if(studentsbyProgram != null  && studentsbyProgram.get(donorId) != null 
           && studentsbyProgram.get(donorId).get('Name') == program){
               Integer existingCount    = 0;
               if(studentsbyCourse != null && studentsbyCourse.containsKey(donorId+'@@@'+program) != null){
                   if(studentsbyCourse.get(donorId+'@@@'+program) != null){
                       existingCount = studentsbyCourse.get(donorId+'@@@'+program);                  
                   }                      
               } 
               if(studentsbyProgram.get(donorId).get('totalStudent') != null){
                   scholarCount = Integer.ValueOf(studentsbyProgram.get(donorId).get('totalStudent')) - existingCount;     
               }
           }   
        return scholarCount;
    }
    
    private static Map<id,AggregateResult> getDonorStudentMappingResult (Set<Id> donorIds){
        String financialYear = Utility.financialYear();
        return new Map<id,AggregateResult>([Select donor__c Id,SUM(Funding_amount__c) amtSum
                                            from Donor_Application_Mapping__c where donor__c IN:donorIds AND Financial_Year__c=:financialYear group by donor__c]);
    }
    
    /*
* Bind BTech/MTech course under Engineering Program & MBBS course under Medical Program
*/ 
    private static Map<String,Integer> getStudentCountByCourse (Set<Id> donorIds){
        List<AggregateResult> aggResult = new List<AggregateResult>([Select donor__c, student__r.Course__c, count(Application__c) 
                                                                     from Donor_Application_Mapping__c where donor__c IN:donorIds  group by student__r.Course__c, student__c, donor__c]);
        
        
        Map<String,Integer> resultMap   = new Map<String,Integer>(); 
        for(AggregateResult ar : aggResult){
            if(ar.get('Course__c') == System.label.StudentCourseBEBTECH 
               || ar.get('Course__c') == System.label.StudentCourseMTech){
                   if(resultMap.containsKey(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Engineering)){
                       Integer totalSum  = resultMap.get(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Engineering) + 1;
                       resultMap.put(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Engineering,totalSum);
                   }else{
                       resultMap.put(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Engineering,1); 
                   }
                   
               }
            if(ar.get('Course__c') == System.label.StudentCourseMBBS){
                if(resultMap.containsKey(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Medical)){
                    Integer totalSum  = resultMap.get(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Medical) + 1;
                    resultMap.put(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Medical,totalSum);
                }else{
                    resultMap.put(String.ValueOf(ar.get('donor__c'))+'@@@'+System.Label.Medical,1);  
                }               
            }
        }
        // this map contains key as "donorId+Program" and value as student Count 
        return resultMap;
    }
    
    private static Map<id,AggregateResult> getStudentsbyProgram (List<AggregateResult> aggResult, string program){
        Map<id,AggregateResult> resultMap   = new Map<id,AggregateResult>();
        for(AggregateResult ar : aggResult){
            if(ar.get('Name') == program){
                resultMap.put(string.ValueOf(ar.get('npsp__Primary_Contact__c')),ar);
            }
        }
        return resultMap;
    }
    
    
    
    private static List<AggregateResult> getDonorStudentsbyProgram(Set<Id> donorIds){
        return new List<AggregateResult>([Select npsp__Primary_Contact__c,Program_Frequency__r.Program__r.Name,SUM(No_of_Student__c) totalStudent 
                                          from opportunity where npsp__Primary_Contact__c in:donorIds AND
                                          Payment_Order__c != null AND (Program_Frequency__r.Program__r.Name =: System.Label.Engineering
                                                                        OR Program_Frequency__r.Program__r.Name =: System.Label.Medical)                              
                                          Group By npsp__Primary_Contact__c,Program_Frequency__r.Program__r.Name]);
    }
    
    private static DonorSearchResultWrapper getWrapperObject(contact donor, double cBalance, double bBalance, double aBalance, integer ecount, integer mcount){
        DonorSearchResultWrapper wrpObj = new DonorSearchResultWrapper();
        wrpObj.donorInfo                = donor;
        wrpObj.currentBalance           = cBalance;
        wrpObj.blockedBalance           = bBalance;
        wrpObj.availableBalance         = aBalance;
        wrpObj.enggCount                = ecount;
        wrpObj.medicalCount             = mcount;
        return wrpObj;
    }
    private static DonorSearchResultWrapper getWrapperObject_multiDonor(contact donor, double cBalance, double bBalance, double aBalance, integer ecount, integer mcount, String gauName, String donorBalanceId, double mappedFund ){
        DonorSearchResultWrapper wrpObj = new DonorSearchResultWrapper();
        wrpObj.donorInfo                = donor;
        wrpObj.currentBalance           = cBalance;
        //wrpObj.blockedBalance           = bBalance;
        //wrpObj.availableBalance         = aBalance;
        //wrpObj.enggCount                = ecount;
        //wrpObj.medicalCount             = mcount;
        
        wrpObj.gauName = gauName;
        wrpObj.mappedFund = mappedFund;
        wrpObj.donorBalanceId = donorBalanceId;
        return wrpObj;
    }
    
    
    private static Map<Id,Contact> getContacts(Set<String> conIds){
        return new Map<Id,Contact>([Select id,Name,FFE_ID__c,Email,Phone,MailingCity,MailingState,Current_Balance__c,
                                    Blocked_Funds__c,DN_Special_Request_Comments__c from Contact where Id IN: conIds]);
    }
    
    global class ApplicationDonorMappingWrapper{
        global  String donorRemark ;
        global  String fundingAmount ;
        global String appId ;
        public ApplicationDonorMappingWrapper(){
            this.donorRemark = '';
            this.fundingAmount = '';
            this.appId = '';
        }
    }
    
    /*
* Get previous year application mapping for donor with active application
* in current year 
*/
    public static List<prevWrapper> getPreviousYearAppln(String donorId){
        List<prevWrapper> prevMapping   = new List<prevWrapper>();
        
        try{
            
            List<Donor_Application_Mapping__c> prevAppMap   = new List<Donor_Application_Mapping__c>();             
            String PrevfinancialYear                        = Utility.getPrevFinancialYear();
            prevAppMap                                      = getPrevYearMapping(donorId);
            Set<Id> studentIds  = new Set<Id>();
            for(Donor_Application_Mapping__c da : prevAppMap){
                studentIds.add(da.Student__c);
            }            
            
            // Get Current Year active application for students
            List<Application__c> currentAppln               = getActiveApplnForStudents(studentIds);
            
            for(Application__c appln : currentAppln){
                for(Donor_Application_Mapping__c mapping : prevAppMap){
                    if(appln.Student__c == mapping.Student__c){
                        prevWrapper pr  = new prevWrapper();
                        pr.currentApp   = new Application__c();
                        pr.preMapp      = new Donor_Application_Mapping__c();
                        pr.currentApp   = appln;
                        pr.preMapp      = mapping;
                        prevMapping.add(pr);
                    } 
                } 
            }
        }catch(exception e){
            prevWrapper pr  = new prevWrapper();
            pr.errorMsg     = Constants.ERROR_MSG;
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'getPreviousYearAppln', e);
        }
        return prevMapping;
    }
    
    // Get previous year student mapping records for the donor 
    private static List<Donor_Application_Mapping__c> getPrevYearMapping(String donorId){
        String PrevfinancialYear    = Utility.getPrevFinancialYear();
        String currentForIITBAfinancialYear = Utility.financialYear();
        List<Donor_Application_Mapping__c> damList= [Select Student__c,Donor_Remark__c,Funding_amount__c,Financial_Year__c,Application__c, 
                                                     Donor__c from Donor_Application_Mapping__c where Donor__c = :donorId 
                                                     AND (Financial_Year__c =:PrevfinancialYear OR (Financial_Year__c =:currentForIITBAfinancialYear and Student__r.From_IITBAA__c =:true)) Order by CreatedDate];
        
        
        Map<String,String> alreadyexistingval = new Map<String,String>();
        List<Donor_Application_Mapping__c> damnewList = new List<Donor_Application_Mapping__c>();
        for(Donor_Application_Mapping__c dam : damList){ 
            if(!alreadyexistingval.containsKey(dam.Donor__c+'-'+dam.Student__c)){
                damnewList.add(dam);
                alreadyexistingval.put(dam.Donor__c+'-'+dam.Student__c,dam.Donor__c+'-'+dam.Student__c);
            }else{
                 
            }
        } 
         
        return damnewList;
        
        
    } 
    
    // Get Student's active application for current financial Year
    private static List<Application__c> getActiveApplnForStudents(Set<Id> studentIds){
        Id StudentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        String financialYear    = Utility.financialYear();
        return [Select Id,Donor_Remarks__c,RPT_Financial_Year__c,Student__c,Student__r.FFE_ID__c,Student__r.Name,Course_Name__c,
                Student__r.ScholarshipAmount__c,Student__r.Course__c from Application__c 
                where Student__c IN : studentIds AND Student__r.RecordTypeId =:StudentRecordType
                AND (Student__r.Internal_Status__c=:Constants.AWAITING_FUND_STATUS OR Student__r.Internal_Status__c=:Constants.AWAITING_FUND_STATUS_API)
                AND Application_Stage__c=:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c=:financialYear AND  Id NOT IN (SELECT Application__c FROM Donor_Application_Mapping__c)];          
        
    }
    
    public class prevWrapper{
        public Application__c currentApp;
        public Donor_Application_Mapping__c preMapp; 
        public string errorMsg;
    }
}