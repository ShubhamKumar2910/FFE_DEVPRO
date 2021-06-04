global class EmailAndSMSToStdAndFacAfterDisbursment implements Database.Batchable<sObject>, Database.Stateful,Schedulable,Database.AllowsCallouts{
    
    public static Messaging.SingleEmailMessage[] studentEmailMessageList     = new Messaging.SingleEmailMessage[]{};
        public static Messaging.SingleEmailMessage[] facilitatorEmailMessageList = new Messaging.SingleEmailMessage[]{}; 
            public List<String> facilitatorMobileNumbers                      = new List<String>();
    public List<String> studentMobileNumbers                          = new List<String>(); 
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        Date DisbursedDate = System.today()-1;
        String internalStatus = System.Label.Application_Internal_Status;
        ID studentRecordType =  Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();     
        
        return Database.getQueryLocator('SELECT id,Student__c,Student__r.Facilitator_Name__r.MobilePhone,Student__r.MobilePhone,Student__r.Facilitator_Name__r.Email,Student__r.Email From Application__c where NEFT_Transfer_Date__c=:DisbursedDate and Internal_Status__c=:internalStatus');    
    }
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new EmailAndSMSToStdAndFacAfterDisbursment(), 20); 
    }
    
    global void execute(Database.BatchableContext BC, List<Application__c> newList){
        system.debug(newList);
        try{
            String facilitator = '';
            String student = '';
            List<EmailTemplate> emailTemplateIdForFacilitatorandStudent = [Select id,Developername from EmailTemplate where Developername =: Constants.Email_to_facilitator_after_Scholarship_is_Transferred_to_Student OR Developername =: Constants.Email_to_Student_after_Scholarship_Transferred_to_Account order by name LIMIT 2];
            for(EmailTemplate e : emailTemplateIdForFacilitatorandStudent){
                if(e.Developername == Constants.Email_to_facilitator_after_Scholarship_is_Transferred_to_Student)
                    facilitator  = String.valueof(e.id);
                if(e.Developername == Constants.Email_to_Student_after_Scholarship_Transferred_to_Account)
                    student = String.valueof(e.id);
            }
            
            //
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.FFE_Account Limit 1];
            //
            
            for(Application__c app : newList){
                if(app.Student__r.Email != null)
                    studentEmailMessageList.add(Utility.sendMailWithTemplateforBusinessAccountUtilization(String.valueOf(Student),String.valueOf(app.Student__c),String.valueOf(app.id),new String[]{String.valueOf(app.Student__r.Email)},owa));
                if(app.Student__r.Facilitator_Name__r.Email != null)
                    facilitatorEmailMessageList.add(Utility.sendMailWithTemplateforBusinessAccountUtilization(String.valueOf(facilitator),String.valueOf(app.Student__c), String.valueOf(app.id),new String[]{String.valueOf(app.Student__r.Facilitator_Name__r.Email)},owa));
                if(app.Student__r.Facilitator_Name__r.MobilePhone != null)
                    facilitatorMobileNumbers.add(app.Student__r.Facilitator_Name__r.MobilePhone);//adding facilitator numbers to list to send SMS
                if(app.Student__r.MobilePhone != null)
                    studentMobileNumbers.add(app.Student__r.MobilePhone);//adding students numbers to list to send SMS
            }
        }catch(Exception e){
            
        }
        // to send email
        try{
            if(studentEmailMessageList != null)
                Messaging.sendEmail(studentEmailMessageList);
            if(facilitatorEmailMessageList != null)
                Messaging.sendEmail(facilitatorEmailMessageList);
        }Catch(Exception e){
            HandleBusinessException.captureError('EmailAndSMSToStdAndFacAfterDisbursment', 'execute', e);
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        List<SMS_Status__c> smsDetailsInsert = new List<SMS_Status__c>();
        
        //sends sms for students and facilitators in the list
        try{
            String contactNumber1 = '';
            if(facilitatorMobileNumbers.size() > 1){
                contactNumber1  = facilitatorMobileNumbers[0];
            }
            else{
                contactNumber1 = string.join(facilitatorMobileNumbers,'');
            } 
            String contactNumber2 = '';
            if(studentMobileNumbers.size() > 1){
                contactNumber2  = studentMobileNumbers[0];
            }
            else{
                contactNumber2 = string.join(studentMobileNumbers,'');
            } 
            
            
            
            if(facilitatorMobileNumbers != null)
                smsDetailsInsert.add(SMS_Service_Helper.sendSingleSMSFromBatch(contactNumber1,constants.On_transfer_of_Scholarship_to_Students_text));
            if(studentMobileNumbers != null)
                smsDetailsInsert.add(SMS_Service_Helper.sendSingleSMSFromBatch(contactNumber2,constants.On_transfer_of_Scholarship_to_Student_text));
        }Catch(Exception e){
            HandleBusinessException.captureError('EmailAndSMSToStdAndFacAfterDisbursment', 'execute', e);
        }
        
        try{
            if(!smsDetailsInsert.isEmpty()){
                insert smsDetailsInsert;
            }
        }
        catch(Exception ex){system.debug(ex.getMessage());
            HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS::::SMS StatusObject Creation', ex);
        }
        
    }
}