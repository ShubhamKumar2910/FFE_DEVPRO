public class ApplicationAutomation {
    
    static final Decimal APPROVAL_AMMOUNT = 40000;
    static final String APPROVAL_AUTOMATION_PROCESS = 'Automated Process: submitted for an approval';
    static final String APPROVAL_PROCESS_NAME = 'Student_scholarship_status';
    
    public static List<Id> matchFacilitator(List<Id> applicationIdList) {
        //TODO Process and assign facilitator and change status of app to facilitator matched. populate Facilitator on Student record
        
        if(applicationIdList == null || applicationIdList.isEmpty()) {
            System.debug('--- please pass app Ids ');
            return null;
        }
        system.debug('applicationIdList======>'+applicationIdList);
        List<Contact> studentListToUpdate              = new List<Contact>();
        List<Application__c> applicationListToUpdate       = new List<Application__c>();
        
        Set<String> contactIdSet = new Set<String>();
        for(Application__c app : [SELECT Id,student__c  FROM Application__c where Internal_Status__c ='Selected' AND Id IN : applicationIdList AND student__c != null]) {
            contactIdSet.add(app.student__c);
        }
        
        system.debug('contactIdSet==>'+contactIdSet);
        
        for(Contact ct : [Select Id,Facilitator_Name__c,(Select id,Internal_Status__c,External_Status__c From Applications__r where RecordType.Name =:Constants.SCHOLARSHIP_APPLICATION AND Application_Stage__c =:Constants.ACTIVE_APPLICATION) 
                          From Contact where Id In: contactIdSet]) {
                              system.debug('ct===>'+ct);
                              ct.Facilitator_Name__c        = System.Label.AUTOMATED_FACILITATOR_ID;
                              ct.Internal_Status__c         = Constants.ONLINE_MATCHED_APPLICATION;
                              
                              for(Application__c ap : ct.Applications__r){
                                  
                                  ap.External_Status__c     = Constants.INPROGRESS_APPLICATION; 
                                  ap.Internal_Status__c     = Constants.ONLINE_MATCHED_APPLICATION;
                                  applicationListToUpdate.add(ap);
                              }     
                              studentListToUpdate.add(ct);   
                              
                          }
        system.debug('applicationListToUpdate===>'+applicationListToUpdate);
        system.debug('studentListToUpdate===>'+studentListToUpdate);
        List<Id> successSobjIds = new List<Id>();
        List<Id> failedSobjIds = new List<Id>();
        Database.SaveResult[] srApplicationList = Database.update(applicationListToUpdate, false);
        
        for (Database.SaveResult result : srApplicationList) {
            if(result.isSuccess()) {
                successSobjIds.add(result.getId());
            }else {
                failedSobjIds.add(result.getId());
            }
        }
        
        Database.SaveResult[] srContactList = Database.update(studentListToUpdate, false);
        for (Database.SaveResult result : srContactList) {
            if(result.isSuccess()) {
                successSobjIds.add(result.getId());
            }else {
                failedSobjIds.add(result.getId());
            }
        }     
        return failedSobjIds;
    }
    
    public static List<Id> facilitatorVerification(List<Id> applicationIdList) {
        //update student deserve checkbox = true and chage status to pending FFE staf review. / call method to process
        
        system.debug('applicationIdList====>'+applicationIdList);
        if(applicationIdList == null || applicationIdList.isEmpty()) {
            System.debug('--- please pass app Ids ');
            return null;
        }
        list<Application__c> applicationList = [SELECT Id,student__c,Has_student_provided_Justification__c,Have_you_met_the_student_s_parent_s__c,Have_you_visited_the_student_s_house__c,
                                                Student_truly_deserves_a_scholarship__c,Internal_Status__c,FacilitatorInputDone__c,Document_Verification_and_Attestation__c FROM Application__c where Internal_Status__c = 'Facilitator Matched' AND Id IN : applicationIdList];
        
        List<Id> successSobjIds = new List<Id>();
        List<Id> failedSobjIds = new List<Id>();
        if(applicationList.size() > 0){ 
            for(Application__c application : applicationList) {
                
                /*  application.Has_student_provided_Justification__c   = boolean.valueOf(application.Has_student_provided_Justification__c);
application.Have_you_met_the_student_s_parent_s__c  = boolean.valueOf(application.Have_you_met_the_student_s_parent_s__c);
application.Have_you_visited_the_student_s_house__c = boolean.valueOf(application.Have_you_visited_the_student_s_house__c); */
                application.Student_truly_deserves_a_scholarship__c = boolean.valueOf(application.Student_truly_deserves_a_scholarship__c);
                application.Internal_Status__c                      = Constants.VERIFIED_BY_FACILITATOR;
                application.FacilitatorInputDone__c                 = true;
                application.Document_Verification_and_Attestation__c  = true;
            }
            Database.SaveResult[] srList = Database.update(applicationList, false);
            
            for (Database.SaveResult result : srList) {
                if(result.isSuccess()) {
                    successSobjIds.add(result.getId());
                }else {
                    failedSobjIds.add(result.getId());
                }
            }
            
        }
        return failedSobjIds;
    }
    
    public static List<Id> submitForApproval(List<Id> applicationIdList) {
        //Set total amount to be disbursed and submit for approval
        if(applicationIdList == null || applicationIdList.isEmpty()) {
            System.debug('--- please pass app Ids ');
            return null;
        }
        
        List<Application__c> submitForApprovalAppList = new List<Application__c>();
        for(Id appId : applicationIdList) {
            submitForApprovalAppList.add(new Application__c(Id = appId, Amount_Requested__c = APPROVAL_AMMOUNT));
        }
        list<application__c> appList = [select name,id,student__c from Application__c where id IN: applicationIdList];
        list<string> contactId = new list<string> ();
        for(application__c app:appList){
            contactId.add(app.student__c);
        }
        system.debug('contactId===>'+contactId);
        list<contact> conList = [select name,id,Internal_Status__c from contact where Id IN: contactId ];
        for(contact con:conList){
            con.Internal_Status__c = 'Pending_Approval';
            
        }
        system.debug(conList);

        List<Database.SaveResult> dmlContactResult = Database.update(conList, false);
        List<Id> submitForApprovalConIdSet = new List<Id>();
        List<Id> failedConIdSet = new List<Id>();
         for(Database.SaveResult result : dmlContactResult) {
            if(result.isSuccess()) {
                submitForApprovalConIdSet.add(result.getId());
            }else {
                failedConIdSet.add(result.getId());
            }
         }


        
        
        List<Database.SaveResult> dmlResult = Database.update(submitForApprovalAppList, false);
        List<Id> submitForApprovalAppIdSet = new List<Id>();
        List<Id> failedAppIdSet = new List<Id>();
        for(Database.SaveResult result : dmlResult) {
            if(result.isSuccess()) {
                submitForApprovalAppIdSet.add(result.getId());
            }else {
                failedAppIdSet.add(result.getId());
            }
            
        }
        
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        Approval.ProcessSubmitRequest approvalRequest;
        if(!submitForApprovalAppIdSet.isEmpty()) {
            //another for here
            for(Id appId : submitForApprovalAppIdSet) {
                approvalRequest = new Approval.ProcessSubmitRequest();        
                approvalRequest.setObjectId(appId);
                approvalRequest.setComments(APPROVAL_AUTOMATION_PROCESS);
                approvalRequest.setProcessDefinitionNameOrId(APPROVAL_PROCESS_NAME);
                approvalRequest.setSkipEntryCriteria(true);
                approvalRequestList.add(approvalRequest);
            }
        }
        if(!submitForApprovalAppList.isEmpty())
            Approval.process(approvalRequestList);
        
        return failedAppIdSet;
    }
    
    public static List<String> processAdditionalExpense(List<Id> applicationIDs) {
        //query additional expense along with all req fields.
        //populate internal approved ammount, which will be summation of 6 fields, add null check properly
        Decimal totalAmount = 0;
        list<Application__c> appList = [select name,id,College_Fees__c,Books_Expenses__c,Transportation_Expenses__c,Hostel_Mess_Expenses__c,Uniform_Expenses__c,Others__c from Application__c where RecordType.Name = 'Additional Expense' AND Id IN: applicationIDs];  
		system.Debug(appList);
        for(Application__c app:appList){
            totalAmount = 0;
            if(app.College_Fees__c != null){
                totalAmount += app.College_Fees__c; 
            }
            if(app.Books_Expenses__c != null){
			    totalAmount += app.Books_Expenses__c;                 
            } if(app.Transportation_Expenses__c != null){
                totalAmount += app.Transportation_Expenses__c;  
            } if(app.Hostel_Mess_Expenses__c != null){
                totalAmount += app.Hostel_Mess_Expenses__c;   
            } if(app.Uniform_Expenses__c != null){
                totalAmount += app.Uniform_Expenses__c;  
            } if(app.Others__c != null){
                totalAmount += app.Others__c;  
            }
            system.debug('totalAmount===>'+totalAmount);
            if(totalAmount > 0)
                app.Amount_Requested__c = totalAmount;
            
        }
        update appList;
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        Approval.ProcessSubmitRequest approvalRequest;
        if(!applicationIDs.isEmpty()) {
            //another for here
            for(Id appId : applicationIDs) {
                approvalRequest = new Approval.ProcessSubmitRequest();        
                approvalRequest.setObjectId(appId);
                approvalRequest.setComments(APPROVAL_AUTOMATION_PROCESS);
                approvalRequest.setProcessDefinitionNameOrId(APPROVAL_PROCESS_NAME);
                approvalRequest.setSkipEntryCriteria(true);
                approvalRequestList.add(approvalRequest);
            }
        }
        if(!applicationIDs.isEmpty())
            Approval.process(approvalRequestList);
        
        
        list<application__c> applicationList = [select name,id,student__c from Application__c where id IN: applicationIDs];
        list<string> contactId = new list<string> ();
        for(application__c app:applicationList){
            contactId.add(app.student__c);
        }
        system.debug('contactId===>'+contactId);
        list<contact> conList = [select name,id,Internal_Status__c from contact where Id IN: contactId ];
        for(contact con:conList){
            con.Internal_Status__c = 'Pending_Approval';
            
        }
        system.debug(conList);

        List<Database.SaveResult> dmlContactResult = Database.update(conList, false);
        
        return null;



    }

    public static list<String> getAppIdsFromCSV(Integer startIndex, Integer numberOfItems) {
        StaticResource staticResourceFile = [SELECT Id, Body FROM StaticResource WHERE Name = 'Application_Stage_Automation' LIMIT 1];
        if(staticResourceFile != null) {
            
            String contactDataAsString = staticResourceFile.Body.toString();
            system.debug(contactDataAsString);
            list<String> applicaitonIdRow = contactDataAsString.split('\n');
            list<String> csvFieldNames = applicaitonIdRow[0].split(',');
            list<String> applicationIdList = new list<String>();
            Integer endIndex = startIndex + numberOfItems;
            system.debug('applicaitonIdRow.size()'+applicaitonIdRow.size());
            if(applicaitonIdRow != null ) {      //&& applicaitonIdRow.size() <= endIndex
                system.debug('applicaitonIdRow != null');
                for (Integer i = startIndex; i < endIndex; i++) {
                    String[] csvRecordData = applicaitonIdRow[i].split(',');
                    system.debug('--- csvRecordData'+csvRecordData+'csvRecordData');
                    csvRecordData[csvRecordData.size()-1] = (csvRecordData[csvRecordData.size()-1]).replace('\r','');
                    applicationIdList.addAll(csvRecordData);
                }
            }
            system.debug('applicationId====>'+applicationIdList);
            return applicationIdList;
        }
        return null;
    }
}