/*
 * @purpose : This class is used as a helper for DN_FundAllocation_CTRL
 * @Auhtor  : Amritesh
 */ 
public class DN_FundAllocation_Helper {
    
    static string currentFiscalYear;
    public static boolean isMultiDonorFlag;
    
    
     /*
     * @purpose     : Get Filtered student records
     * @returnType  : List<Contact>
    */ 
    Public static List<Contact> getAllFilteredStudents(DN_FundAllocation_CTRL.searchFilterWrapper searchWrp){
        
        currentFiscalYear           = Utility.financialYear();
        List<Contact> awaitingCons  = new List<Contact>();
        
        if(searchWrp.studentType == Constants.ALL_AWAITING_STUDENT){
            awaitingCons    = getAllAwaitingStudents(searchWrp.applType);system.debug(awaitingCons);
            return getAwatingingApplications(searchWrp.applType,awaitingCons);
        }else if(searchWrp.studentType == Constants.ALL_MAPPED_STUDENT){
            awaitingCons    = getAllMappedStudents(searchWrp.applType);
            return getAwatingingApplications(searchWrp.applType,awaitingCons);
        }else if(searchWrp.studentType == Constants.ALL_UNMAPPED_STUDENT){
            return getAllUnMappedStudents(searchWrp.applType);
        }else{
            return new List<Contact>();
        }        
    }
        Public static List<Contact> getAllFilteredStudents_multi(DN_FundAllocation_CTRL.searchFilterWrapper searchWrp){
        
        currentFiscalYear           = Utility.financialYear();
        List<Contact> awaitingCons  = new List<Contact>();
        
        if(searchWrp.studentType == Constants.ALL_MULTI_DONOR_MAPPED_STUDENT){
            awaitingCons    = getAllStudents_multiDonor(searchWrp.applType);system.debug(awaitingCons);
            return getAwatingingApplications(searchWrp.applType,awaitingCons);
        }
            else{
            return new List<Contact>(); 
        }        
    }
      
    /*
     * @Purpose:  Check if any Additional Expensne Application is available for selected recordType. 
     *            if Yes: add those contacts to List to awaitingContacts 
     *              else: return same awaitingContacts list
     * @param: recordTypeIds : Selected Application RecordType Ids
     * @param: awaitingContacts: All contains whose application are in awaiting for fund for current year 
     */ 
    public static List<Contact> getAwatingingApplications(List<String> recordTypeIds ,List<Contact> awaitingContacts){
        try{
            Set<String> appRecordIDs    = new Set<String>(recordTypeIds);
            String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
            String addAppRecordType     = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.ADDITIONAL_APPLICATION).getRecordTypeId(); 
            
            if(recordTypeIds.size() > 0 && (appRecordIDs != null && appRecordIDs.contains(addAppRecordType))){
                Map<Id,Contact> addnExpnsConts  = new Map<Id,Contact>();
                addnExpnsConts  = getAdditionalExpnsAppln(addAppRecordType,studentRecordType); 
                
                if(awaitingContacts.size() > 0 && addnExpnsConts.size() > 0){
                    for(String s: addnExpnsConts.keySet()){
                        for(Contact c: awaitingContacts){
                            if(!addnExpnsConts.containsKey(s)){
                                awaitingContacts.add(addnExpnsConts.get(s));
                            }
                        }
                    } 
                }else{
                    return awaitingContacts;                    
                }                
            }else{                
                return awaitingContacts;
            }            
        }catch(Exception ex){           
            awaitingContacts    = new List<Contact>();           
        }       
        return awaitingContacts;
    }
    
    /*
     * @purpose     : Get Application mapped donors with their GAU balance and funding Amount from donor 
     *                application mapping
     * @returnType  : List<Contact>
    */
    public static List<Contact> getDonorDetails(String applicationId){
        String donorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
        string appId            = getAppParentID(applicationId);
        
        Map<Id,Donor_Application_Mapping__c> donorMappng;
        donorMappng = new Map<Id,Donor_Application_Mapping__c>([Select Id,Donor__c,Student__c,Application__c,Funding_amount__c,
                                                                Donor_Remark__c from Donor_Application_Mapping__c
                                                                where Application__c =:appId]);
        
        Map<string,Donor_Application_Mapping__c> donorWiseMapping   = new Map<string,Donor_Application_Mapping__c>();
        for(String s : donorMappng.keySet()){
            donorWiseMapping.put(donorMappng.get(s).Donor__c, donorMappng.get(s));
        }
        
       /* Map<Id,Contact> mappedDonors  = new Map<Id,Contact>([Select id,Name,Current_Balance__c,Blocked_Funds__c,FFE_ID__c,Email,
                                                              (Select id,Current_Balance__c, GAU_Name__c,GAU_Name__r.Name, Blocked_Funds__c,
                                                               Last_Instalment_Amount__c,Total_Instalment_Amount__c,Donor_Name__c,Donor_Name__r.Name,
                                                               Donor_Name__r.FFE_ID__c from Donor_Balances__r) from Contact 
                                                              where RecordTypeId =:donorRecordType AND ID IN :donorWiseMapping.keySet()]); */
         Map<Id,Contact> mappedDonors   = new Map<Id,Contact>([Select id,Name,Current_Balance__c,Blocked_Funds__c,FFE_ID__c,Email,
                                                              (Select id,Current_Balance__c, GAU_Name__c,GAU_Name__r.Name, Blocked_Funds__c,
                                                               Last_Instalment_Amount__c,Total_Instalment_Amount__c,Donor_Name__c,Donor_Name__r.Name,
                                                               Donor_Name__r.FFE_ID__c from Donor_Balances__r),(Select Id,GAU_Information__c FROM Donor_Application_Mappings__r) from Contact 
                                                              where RecordTypeId =:donorRecordType AND ID IN :donorWiseMapping.keySet()]);
        
        for(String donorId : mappedDonors.keySet()){
            if(donorWiseMapping.containsKey(donorId)){
                mappedDonors.get(donorId).Temp_Funding_Amount__c    = donorWiseMapping.get(donorId).Funding_amount__c;
                mappedDonors.get(donorId).Temp_Donor_Remark__c      = donorWiseMapping.get(donorId).Donor_Remark__c;
            }
        }
        
        return mappedDonors.values();
    }
    
        public static List<Contact> getDonorDetails_multi(String applicationId){
        String donorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
        string appId            = getAppParentID(applicationId);
        
        Map<Id,Donor_Application_Mapping__c> donorMappng;
        donorMappng = new Map<Id,Donor_Application_Mapping__c>([Select Id,Donor__c,Student__c,Application__c,Funding_amount__c,
                                                                Donor_Remark__c from Donor_Application_Mapping__c
                                                                where Application__c =:appId]);
        
        Map<string,Donor_Application_Mapping__c> donorWiseMapping   = new Map<string,Donor_Application_Mapping__c>();
        for(String s : donorMappng.keySet()){
            donorWiseMapping.put(donorMappng.get(s).Donor__c, donorMappng.get(s));
        }
        
       /* Map<Id,Contact> mappedDonors  = new Map<Id,Contact>([Select id,Name,Current_Balance__c,Blocked_Funds__c,FFE_ID__c,Email,
                                                              (Select id,Current_Balance__c, GAU_Name__c,GAU_Name__r.Name, Blocked_Funds__c,
                                                               Last_Instalment_Amount__c,Total_Instalment_Amount__c,Donor_Name__c,Donor_Name__r.Name,
                                                               Donor_Name__r.FFE_ID__c from Donor_Balances__r) from Contact 
                                                              where RecordTypeId =:donorRecordType AND ID IN :donorWiseMapping.keySet()]); */
         Map<Id,Contact> mappedDonors   = new Map<Id,Contact>([Select id,Name,Current_Balance__c,Blocked_Funds__c,FFE_ID__c,Email,
                                                              (Select id,Current_Balance__c, GAU_Name__c,GAU_Name__r.Name, Blocked_Funds__c,
                                                               Last_Instalment_Amount__c,Total_Instalment_Amount__c,Donor_Name__c,Donor_Name__r.Name,
                                                               Donor_Name__r.FFE_ID__c from Donor_Balances__r),(Select Id,Application__r.Name,Application__c,Student__r.Name,Student__c,GAU_Information__c,Donor__r.FFE_ID__c,Donor_Remark__c,Donor__c,Donor__r.Name, Funding_amount__c  FROM Donor_Application_Mappings__r where Created_from_Multi_Donor_Feature__c = true AND Application__c =:appId ) from Contact 
                                                              where RecordTypeId =:donorRecordType AND ID IN :donorWiseMapping.keySet()]);
        
        for(String donorId : mappedDonors.keySet()){
            if(donorWiseMapping.containsKey(donorId)){
                mappedDonors.get(donorId).Temp_Funding_Amount__c    = donorWiseMapping.get(donorId).Funding_amount__c;
                mappedDonors.get(donorId).Temp_Donor_Remark__c      = donorWiseMapping.get(donorId).Donor_Remark__c;
            }
        }
        
        return mappedDonors.values();
    }
    
    // Return Parent application Id if Application is for Additiona Expense else return current Application Id
    public static String getAppParentID(string applicationId){
        Application__c app = getAppicationFromSFDB(applicationId);
        if(app.RecordType.Name == Constants.ADDITIONAL_APPLICATION){
            return app.Parent_Application__c;
        }else{
            return applicationId;
        }
    }
           
    /*
    * @purpose      : Get donor's balance
    * @returnType   : List<Contact>
    */
    public static List<Donor_Balance__c> getDonorBalances(string donorId){
        return [Select id,Blocked_Funds__c,Current_Balance__c,Donor_Name__c,Total_Instalment_Amount__c,
                GAU_Name__c,Total_Available_Fund__c,Last_Instalment_Amount__c,Mapped_Fund__c   
                from Donor_Balance__c
                where Donor_Name__c =: donorId];
    }
    
    /*
    * @purpose      : Get donor's balance by GAU
    * @returnType   : List<Contact>
    */
    public static List<Donor_Balance__c> getGAUWiseBalance(string gauId,String DonorCategory){
        
        /*return [Select id,Blocked_Funds__c,Current_Balance__c,Donor_Name__c,Donor_Name__r.FFE_ID__c,Total_Instalment_Amount__c,
                GAU_Name__c,Total_Available_Fund__c,Last_Instalment_Amount__c,Donor_Name__r.Name,Donor_Name__r.DN_Donor_Category__c,GAU_Name__r.Name
                from Donor_Balance__c
                where GAU_Name__c =: gauId Order by Current_Balance__c desc];
*/
        String query = '';
        query                           = 'Select id,Blocked_Funds__c,Mapped_Fund__c,Current_Balance__c,Donor_Name__c,Donor_Name__r.FFE_ID__c,Total_Instalment_Amount__c,'+
                                            ' GAU_Name__c,Total_Available_Fund__c,Last_Instalment_Amount__c,Donor_Name__r.Name,Donor_Name__r.DN_Donor_Category__c,GAU_Name__r.Name'+
                                            ' from Donor_Balance__c ';
        
        if(gauId != null && gauId != '' && DonorCategory != null && DonorCategory != ''){ 
            query+=' where GAU_Name__c =: gauId AND Donor_Name__r.DN_Donor_Category__c=:DonorCategory';
        }else if((gauId != null || gauId != '') && (DonorCategory == null || DonorCategory == '')){
            query+=' where GAU_Name__c =: gauId';
        }else if((gauId == null || gauId == '') && (DonorCategory != null || DonorCategory != '')){
            query+=' where Donor_Name__r.DN_Donor_Category__c=:DonorCategory';
        }
        query+=' Order by Current_Balance__c desc';    
        system.debug(query);
        List<Donor_Balance__c> donorBalances = Database.query(query);
        return donorBalances;
    }
    
    /*
    * @purpose: Disburse fund to the student's Application. Disbursment of amount happens from Donor Balace records
    *            and creates fund Utilization record for each disbursment for Donor Balace. Student Application
    *            also gets updated with the funded Amount
    * @param : fundWrp;
    * @returnType: string
    * 
    */
    public static string doFundDisburment(FundDisburseWrapper fundWrp){     
        Savepoint sp = Database.setSavepoint();
       
        try{
         
            Map<String,Donor_Balance__c> dBalanceToUpdate           = new Map<String,Donor_Balance__c>();
            Map<string,Fund_Utilization__c> amtDisbursedMap         = new Map<string,Fund_Utilization__c>();
            List<Donor_Application_Mapping__c> newDonorMapping      = new List<Donor_Application_Mapping__c>();
            Map<String,Donor_Application_Mapping__c> applnMapping   = new Map<String,Donor_Application_Mapping__c>();
            
            fundWrp.appln                                           = getAppicationFromSFDB(fundWrp.appln.Id);
            Map<Id,Donor_Balance__C> donorBalances                  = getDonorBalanceFromSFDB(fundWrp.donorBalanceIds);
            
            string appRecordType                                    = fundWrp.appln.RecordType.Name;
            
            String currentAppId                                     = fundWrp.appln.Id;
            // if Application Record Type is "Additional Expense" then create donor-Application mapping for 
            // parent application
            if(appRecordType == Constants.ADDITIONAL_APPLICATION && fundWrp.appln.Parent_Application__c != null){
                currentAppId    = fundWrp.appln.Parent_Application__c;
            }
            
            try{
                
                applnMapping  = getApplicationMaping(currentAppId);
            }catch(Exception qr){
                HandleBusinessException.captureError('DN_FundAllocation_Helper', 'doFundDisburment', qr);
            } 
                        
            if(fundWrp.amtFunded.Size() > 0){
                
                for(FundDisburseWrapper.fundedAmtByGAU gauWrp   : fundWrp.amtFunded){
                   
                    if(gauWrp != null && Double.valueOf(gauWrp.extraFunds) > 0){
                        Donor_Balance__c db             = new Donor_Balance__c();
                        if(donorBalances.containsKey(gauWrp.donorbalance.Id)){
                            db.Id                           = gauWrp.donorbalance.Id;
                            
                            // If multiple donor balace came from Page for same donor and GAU (duplicate donor balance)
                            // then check for duplicate and add the sum/calculation for any one donor balance
                            if(dBalanceToUpdate.containsKey(db.Id)){
                                dBalanceToUpdate.get(db.Id).Current_Balance__c = dBalanceToUpdate.get(db.Id).Current_Balance__c - Double.valueOf(gauWrp.extraFunds);
                                if(DN_FundAllocation_Helper.isMultiDonorFlag == true){
                                  dBalanceToUpdate.get(db.Id).Mapped_Fund__c  = dBalanceToUpdate.get(db.Id).Mapped_Fund__c  - Double.valueOf(gauWrp.extraFunds);    
                                }
                                dBalanceToUpdate.get(db.Id).Last_Instalment_Amount__c = dBalanceToUpdate.get(db.Id).Last_Instalment_Amount__c + Double.valueOf(gauWrp.extraFunds);
                                dBalanceToUpdate.get(db.Id).Total_Instalment_Amount__c = dBalanceToUpdate.get(db.Id).Total_Instalment_Amount__c + Double.valueOf(gauWrp.extraFunds);
                            }else{
                                db.Current_Balance__c           = donorBalances.get(gauWrp.donorbalance.Id).Current_Balance__c - Double.valueOf(gauWrp.extraFunds);
                                 if(DN_FundAllocation_Helper.isMultiDonorFlag == true){
                                   db.Mapped_Fund__c           = donorBalances.get(gauWrp.donorbalance.Id).Mapped_Fund__c - Double.valueOf(gauWrp.extraFunds);
                                   
                                 }
                                db.Last_Instalment_Amount__c    = Double.valueOf(gauWrp.extraFunds);
                                
                                if(gauWrp.donorbalance.Total_Instalment_Amount__c > 0){
                                    db.Total_Instalment_Amount__c   = donorBalances.get(gauWrp.donorbalance.Id).Total_Instalment_Amount__c + Double.valueOf(gauWrp.extraFunds); 
                                }else{
                                    db.Total_Instalment_Amount__c   = Double.valueOf(gauWrp.extraFunds);  
                                }
                                dBalanceToUpdate.put(db.Id,db);
                            }
                                                      
                            
                            Fund_Utilization__c dUtilization        = new Fund_Utilization__c();
                            dUtilization.Application__c             = fundWrp.appln.Id;
                            dUtilization.General_Accounting_Unit__c = gauWrp.donorbalance.GAU_Name__C;
                            dUtilization.Donor__c                   = gauWrp.donorbalance.Donor_Name__c;
                            dUtilization.Donor_Balance__c           = gauWrp.donorbalance.Id;
                            
                            string mapKey   = string.valueOf(dUtilization.General_Accounting_Unit__c)+string.valueOf(dUtilization.Donor__c);
                                
                            if(amtDisbursedMap.containsKey(mapKey)){
                                amtDisbursedMap.get(mapKey).Disbursed_Amount__c += Double.valueOf(gauWrp.extraFunds); 
                            }else{
                                dUtilization.Disbursed_Amount__c    = Double.valueOf(gauWrp.extraFunds);
                                amtDisbursedMap.put(mapKey,dUtilization);
                            }
                             
                            // Creating new Donor mapping for application                            
                            if(applnMapping != null){
                                if(!applnMapping.containsKey(currentAppId+'@@@'+gauWrp.donorbalance.Donor_Name__c)){
                                    newDonorMapping.add(new Donor_Application_Mapping__c(Donor__c=gauWrp.donorbalance.Donor_Name__c,Student__c=fundWrp.student.Id,Application__c=currentAppId));  
                                }
                            }else{
                                newDonorMapping.add(new Donor_Application_Mapping__c(Donor__c=gauWrp.donorbalance.Donor_Name__c,Student__c=fundWrp.student.Id,Application__c=currentAppId));    
                            }
                        }                        
                    }                    
                }
                
                if(fundWrp.totalFundedAmt > 0){
                    if(fundWrp.appln.Amount_Funded__c > 0){
                        fundWrp.appln.Amount_Funded__c += fundWrp.totalFundedAmt;
                    }else{
                        fundWrp.appln.Amount_Funded__c = fundWrp.totalFundedAmt;
                    }
                    
                    if(fundWrp.appln.Amount_Funded__c == fundWrp.appln.Amount_Requested__c){
                        fundWrp.appln.Internal_Status__c    = Constants.AMOUNT_FUNDED;
                        fundWrp.appln.Application_Stage__c  = Constants.APP_STAGE_CLOSED;
                        fundWrp.appln.External_Status__c    = Constants.APPROVED_STATUS;
                    }                        
                }
            }
                        
            Map<String,String> gauAndBusinessAccountID        = new Map<String,String>();
            Set<Id> gauIDs                                    = new Set<Id>();
            
            //to get GAU ids
            for(Fund_Utilization__c fundUtilization : amtDisbursedMap.values()){
               gauIDs.add(fundUtilization.General_Accounting_Unit__c);
            }
            
            //List<npsp__General_Accounting_Unit__c> gauValues  = [SELECT ID,Business_Account__c,Business_Account__r.name,FFE_Account_Number__c,Program__c FROM npsp__General_Accounting_Unit__c WHERE ID=:gauIDs];

            //to get the Business account connected to GAU
            for(npsp__General_Accounting_Unit__c gau : getGeneralAccountUnit(gauIDs)){
               gauAndBusinessAccountID.put(gau.Id,gau.Business_Account__c);
            }

            Map<String,Business_Account_Utilization__c> businessAccountUtilizationMap = new Map<String,Business_Account_Utilization__c>();
           
            //To create BusinessAccountUtilization
            for(Fund_Utilization__c fundUtilization : amtDisbursedMap.values()){
                      Business_Account_Utilization__c baU = new Business_Account_Utilization__c();
                
                     if(!businessAccountUtilizationMap.containsKey(String.valueOf(fundUtilization.Application__c)+'-'+String.valueOf(gauAndBusinessAccountID.get(fundUtilization.General_Accounting_Unit__c)))){

                         baU.Application__c = fundUtilization.Application__c;
                         baU.Sender_Account_No__c = gauAndBusinessAccountID.get(fundUtilization.General_Accounting_Unit__c);
                         businessAccountUtilizationMap.put(String.valueOf(fundUtilization.Application__c)+'-'+String.valueOf(gauAndBusinessAccountID.get(fundUtilization.General_Accounting_Unit__c)),baU);
                     }
            }
            
            if(!businessAccountUtilizationMap.isEmpty()) 
                insert businessAccountUtilizationMap.values(); 

            //to link Business account utilization to FundUtilization
            for(Fund_Utilization__c fundUtilization : amtDisbursedMap.values()){
                 fundUtilization.Business_Account_Utilization__c = businessAccountUtilizationMap.get(String.valueOf(fundUtilization.Application__c)+'-'+String.valueOf(gauAndBusinessAccountID.get(fundUtilization.General_Accounting_Unit__c))).id;
            }
                                
            //Constants.APPLICATION_TRIGGER_RUNNING = true;
            Constants.Stop_SMS = true;
            
            //Update Application donor mapping status also            
            fundWrp.appln.IsMapped__c   = true;
            update fundWrp.appln;               // Update Student Application with Disbursed Amount
            update dBalanceToUpdate.values();   // Update Donor Balance after amount disbursment 
            insert amtDisbursedMap.values();    // Create Fund Utilization Record
            
            if(newDonorMapping.size() > 0) insert newDonorMapping; // Create new Donor-Student Mapping
            DN_FundAllocation_Helper.isMultiDonorFlag = false;
            return Constants.DISBURMENT_SUCCESS;
        }catch(Exception ex){
            Database.rollback(sp);
            HandleBusinessException.captureError('DN_FundAllocation_Helper', 'doFundDisburment', ex);            
            system.debug('Exception::'+ex.getMessage());  
            DN_FundAllocation_Helper.isMultiDonorFlag = false;
            return Constants.ERROR_MSG;
        }
        
    }
    
    private static Application__c getAppicationFromSFDB(string applId){
        return [select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,RecordType.DeveloperName,Parent_Application__c,
                 Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                 from Application__c where Id =:applId];
    }
    
    private static Map<Id,Donor_Balance__C> getDonorBalanceFromSFDB(List<string> donorbalancelIds){
        return new Map<Id,Donor_Balance__c>([Select id,Blocked_Funds__c,Current_Balance__c,Donor_Name__c,
                                             Total_Instalment_Amount__c,Mapped_Fund__c,GAU_Name__c,Total_Available_Fund__c,
                                             Last_Instalment_Amount__c
                                            from Donor_Balance__c where Id IN: donorbalancelIds]);
    }
    
    private static Map<String,Donor_Application_Mapping__c> getApplicationMaping(string applicationId){
        Map<String,Donor_Application_Mapping__c> applnMapping = new Map<String,Donor_Application_Mapping__c>();
        Map<Id,Donor_Application_Mapping__c> donorMapping   = new Map<Id,Donor_Application_Mapping__c>([Select Id,Donor__c,Student__c,
                                                                Application__c from Donor_Application_Mapping__c where Application__c =:applicationId]);
        for(string s : donorMapping.keySet()){
            applnMapping.put(donorMapping.get(s).Application__c+'@@@'+donorMapping.get(s).Donor__c,donorMapping.get(s));
        }
        
        return applnMapping;
    }
    
    public static List<RecordType> getApplicationType(){
        return [Select id,Name from RecordType where sObjectType = 'Application__c'];
    }
    
    public static List<String> getStudentSeachFilterType(){
        return new List<String>{Constants.ALL_AWAITING_STUDENT,Constants.ALL_MAPPED_STUDENT,Constants.ALL_UNMAPPED_STUDENT};
    }
      public static List<String> getMultiDonorStudentSeachFilterType(){
        return new List<String>{Constants.ALL_MULTI_DONOR_MAPPED_STUDENT};
    }
    
    private static List<npsp__General_Accounting_Unit__c> getGeneralAccountUnit(Set<Id> gauIDs){
                return [SELECT ID,Business_Account__c,Business_Account__r.name,Program__c FROM npsp__General_Accounting_Unit__c WHERE ID=:gauIDs];
    }
    
    public static List<Contact> getDonors(string dname){
        try{
            String donorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            return Database.query('select id,Name from Contact where RecordTypeId   =: donorRecordType AND (Name like \'%' + String.escapeSingleQuotes(dname) + '%\') ORDER BY Name');
        }catch(Exception ex){
            HandleBusinessException.captureError('DN_FundAllocation_Helper', 'getDonors', ex);
            return new List<Contact>();
        }
    }
    
    
    /*
     * @purpose     : Get all student with Awaiting for Fund Status
     * @returnType  : List<Contact>
    */ 
    public static List<Contact> getAllAwaitingStudents(List<Id> recordTypes){        
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId IN : recordTypes
                    AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType 
                    AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) order by Name];
            
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND 
                    (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) order by Name];
            
        }
    }
        public static List<Contact> getAllStudents_multiDonor(List<Id> recordTypes){        
String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 

        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId IN : recordTypes
                    AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                               where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                                OR Student__r.Internal_Status__C =:Constants.AWAITING_FUND_STATUS_API)
                              AND Financial_Year__c =:currentFiscalYear AND Created_from_Multi_Donor_Feature__c = true ) 
                    order by Name];
        
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                    AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                               where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                               OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                              AND Financial_Year__c =:currentFiscalYear AND Created_from_Multi_Donor_Feature__c  = true)
                    order by Name]; 
        }
    }
    
    /*
     * @purpose     : Get all student with Awaiting for Fund Status, who are 
     *                mapped to donor
     * @returnType  : List<Contact>
    */
    public static List<Contact> getAllMappedStudents(List<Id> recordTypes){
        
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 

        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId IN : recordTypes
                    AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                               where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                                OR Student__r.Internal_Status__C =:Constants.AWAITING_FUND_STATUS_API)
                              AND Financial_Year__c =:currentFiscalYear ) 
                    order by Name];
        
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                    AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                               where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                               OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                              AND Financial_Year__c =:currentFiscalYear)
                    order by Name];
        }
    }
    
    /*
     * @purpose     : Get all student with Awaiting for Fund Status, who are not
     *                mapped to any donor
     * @returnType  : List<Contact>
    */
    public static List<Contact> getAllUnMappedStudents(List<Id> recordTypes){
        
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId =: recordTypes
                     AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID NOT IN (Select Student__c from Donor_Application_Mapping__c 
                                   where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                                  AND Financial_Year__c =:currentFiscalYear)
                    order by Name];
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID NOT IN (Select Student__c from Donor_Application_Mapping__c 
                                   where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                                  AND Financial_Year__c =:currentFiscalYear) order by Name];
        }
        
    }
    
    public static Map<Id,Contact> getAdditionalExpnsAppln(String addExpnsRecordTypeId, string studentRecordType){
        return new Map<Id,Contact>([Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity ,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId =: addExpnsRecordTypeId
                     AND RPT_Financial_Year__c =:currentFiscalYear)
                    from Contact where RecordTypeId =: studentRecordType
                    AND ID IN (Select Student__c from Application__c 
                                   where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId =: addExpnsRecordTypeId
                     AND RPT_Financial_Year__c =:currentFiscalYear)
                    order by Name]); 
    } 
    
    // Get All Students mapped to Donor    
    public static List<Contact> getStudentsByDonor(string donorId){
        currentFiscalYear   = Utility.financialYear();
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                 Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                 from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                 AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                           where Donor__c =:donorId AND (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                           OR Student__r.Internal_Status__C =:Constants.AWAITING_FUND_STATUS_API)
                        AND Financial_Year__c =:currentFiscalYear  )
                order by Name];
        
    }
       
}