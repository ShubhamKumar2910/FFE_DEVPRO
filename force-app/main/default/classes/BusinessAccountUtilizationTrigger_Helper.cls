/* @ purpose : updates Application Internal status = Disbursed and External status = Scholarship Transferred
*              when all the BusinessAccountUtilization of Application is "Disbursed" and Updates student internal status with the same
*              and sends email and SMS to student and Facilitator
*  Sending mail and SMS has been cancelled 
*/ 
public class BusinessAccountUtilizationTrigger_Helper {
    
    /* @Purpose   : updates Application Internal status = Disbursed and External status = Scholarship Transferred
    *              when all the BusinessAccountUtilization of Application is "Disbursed"
    * @Parameter : Trigger.OldMap , Trigger.NewMap
    */ 
    public static Messaging.SingleEmailMessage[] studentEmailMessageList = new Messaging.SingleEmailMessage[]{};
    public static Messaging.SingleEmailMessage[] facilitatorEmailMessageList = new Messaging.SingleEmailMessage[]{};    
        public static void afterUpdate(Map<id,Business_Account_Utilization__c> oldMap,Map<id,Business_Account_Utilization__c> newMap){
            try{
                Set<ID> applicationIDs                =  new Set<ID>();
                
                for(Business_Account_Utilization__c bau : newMap.values()){
                    if(oldMap.get(bau.id).Disbursement_Status__c != newMap.get(bau.id).Disbursement_Status__c && oldMap.get(bau.id).Disbursement_Status__c == Constants.Disbursed){
                        applicationIDs.add(bau.Application__c);
                    }
                }
                if(!applicationIDs.isEmpty()){
                    List<Application__c> applicationList        =  [SELECT ID,Internal_Status__c,RecordTypeId,External_Status__c,Student__c,Student__r.Facilitator_Name__r.MobilePhone,Student__r.MobilePhone,Student__r.Facilitator_Name__r.Email,Student__r.Facilitator_Email__c,Student__r.Email,NEFT_Transfer_Date__c,(SELECT id,Disbursement_Status__c FROM Business_Account_Utilizations__r) FROM Application__c where ID=:applicationIDs];
                    boolean status                              =  false;
                    List<Application__c> appList                =  new List<Application__c>();
                    String facilitator = '';
                    String student = '';
                    List<EmailTemplate> emailTemplateIdForFacilitatorandStudent = [Select id,Developername from EmailTemplate where Developername =: Constants.Email_to_facilitator_after_Scholarship_is_Transferred_to_Student OR Developername =: Constants.Email_to_Student_after_Scholarship_Transferred_to_Account order by name LIMIT 2];
                    for(EmailTemplate e : emailTemplateIdForFacilitatorandStudent){
                        if(e.Developername == Constants.Email_to_facilitator_after_Scholarship_is_Transferred_to_Student){
                            facilitator  = String.valueof(e.id);
                        }  
                        if(e.Developername == Constants.Email_to_Student_after_Scholarship_Transferred_to_Account){
                            student = String.valueof(e.id);
                        }
                    }
                    List<String> facilitatorMobileNumbers       = new List<String>();
                    List<String> studentMobileNumbers           = new List<String>();    
                    Set<ID> studentIDs              = new Set<ID>();
                    Id applictaionAdditionalExpenseRecordType   =  Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.ADDITIONAL_APPLICATION).getRecordTypeId(); 
                    
                    //
                    List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
                    owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.FFE_Account Limit 1];
                    //
                    
                    for(Application__c app : applicationList){
                        for(Business_Account_Utilization__c bau :app.Business_Account_Utilizations__r){
                            if(bau.Disbursement_Status__c == Constants.Disbursed){
                                status = true;
                            }else{
                                status = false;
                                break;
                            }
                        }
                        if(status){
                            app.Internal_Status__c = Constants.Disbursed;
                            app.External_Status__c = Constants.Scholarship_Transferred;
                            app.NEFT_Transfer_Date__c = System.Today();        
                            appList.add(app);     
                            if(app.RecordTypeId != applictaionAdditionalExpenseRecordType){
                                studentIDs.add(app.Student__c);
                            }
                            if(app.Student__r.Email != null){
                                studentEmailMessageList.add(Utility.sendMailWithTemplateforBusinessAccountUtilization(String.valueOf(Student),String.valueOf(app.Student__c),String.valueOf(app.id),new String[]{String.valueOf(app.Student__r.Email)},owa));
                            }
                            if(app.Student__r.Facilitator_Name__r.Email != null){
                                facilitatorEmailMessageList.add(Utility.sendMailWithTemplateforBusinessAccountUtilization(String.valueOf(facilitator),String.valueOf(app.Student__c), String.valueOf(app.id),new String[]{String.valueOf(app.Student__r.Facilitator_Name__r.Email)},owa));
                            }
                            if(app.Student__r.Facilitator_Name__r.MobilePhone != null){
                                facilitatorMobileNumbers.add(app.Student__r.Facilitator_Name__r.MobilePhone);//adding facilitator numbers to list to send SMS
                            }
                            if(app.Student__r.MobilePhone != null){
                                studentMobileNumbers.add(app.Student__r.MobilePhone);//adding students numbers to list to send SMS
                            }
                        }
                    }
                    
                    
                    if(!appList.isEmpty()){
                        Constants.APPLICATION_TRIGGER_RUNNING = true;
                        update appList;
                        // to send email
                        try{//Uncommented the email sending code and added a recursive check to ensure email triggers only once -- Sumit Gaurav - 09-June-2020
                            system.debug('Email_sent_to_Student_Facilitator_after_disbursement=='+Constants.Email_sent_to_Student_Facilitator_after_disbursement);
                            if(!Constants.Email_sent_to_Student_Facilitator_after_disbursement){
                                if(studentEmailMessageList != null){
                                    Messaging.sendEmail(studentEmailMessageList);
                                } 
                                if(facilitatorEmailMessageList != null){
                                    Messaging.sendEmail(facilitatorEmailMessageList);
                                }
                                Constants.Email_sent_to_Student_Facilitator_after_disbursement=true;
                            }
                        }Catch(Exception e){
                            HandleBusinessException.captureError('BusinessAccountUtilizationTrigger_Helper', 'afterUpdate-EmailError', e);
                        }
                        //sends sms for students and facilitators in the list
                        try{
                           /* if(facilitatorMobileNumbers != null)
                                SMS_Service_CTRL.scholarshipTransferredSMSToFacilitator(facilitatorMobileNumbers);
                            if(studentMobileNumbers != null)
                                SMS_Service_CTRL.scholarshipTransferredSMSToStudent(studentMobileNumbers);*/
                        }Catch(Exception e){
                            HandleBusinessException.captureError('BusinessAccountUtilizationTrigger_Helper', 'afterUpdate-SMSError', e);
                        }
                        //Student internal status updating as "Disbursed"
                        try{
                            List<Contact> studentList = [SELECT id,Internal_Status__c from Contact where id=:studentIDs];
                            List<Contact> updateContactInternalStatus = new List<Contact>();
                            for(Contact con : studentList){
                                con.Internal_Status__c = Constants.Disbursed;
                                updateContactInternalStatus.add(con);
                            }
                            
                            if(!updateContactInternalStatus.isEmpty()){
                                Constants.Contact_TRIGGER_RUNNING = true;
                                update updateContactInternalStatus;
                            }
                        }Catch(Exception e){
                            HandleBusinessException.captureError('BusinessAccountUtilizationTrigger_Helper', 'afterUpdate-contactUpdateError', e);
                            
                        }
                    }
                    
                    
                }   
            }Catch(Exception e){
                HandleBusinessException.captureError('BusinessAccountUtilizationTrigger_Helper', 'afterUpdate', e);
                system.debug(e.getMessage());
            }
        }    
}