/************************************************************************************************************
Apex ClassName - NotifyStudentOnFacilitatorMatched_Batch
Version - 1.0 
Created Date - 08-June-2020  
Developed By - Sumit Gaurav
Function -  The purpose of this class to send email notification to students whose Intenal Status changed to selected to Facilitator Matched.
            This batch is scheduled at 8pm daily. 
Modification Log :
-----------------------
* Developers                   Date                   Description
* ----------                  -----                  ------------------------*/
global class NotifyStudentOnFacilitatorMatched_Batch implements Database.Batchable<sObject>,Schedulable {
    
    public Set<Id> contactIdSet;
    //Start method of Batch class
    global Database.queryLocator start(Database.BatchableContext bc) {
        String query ='select id,OldValue, NewValue,ContactId from ContactHistory where Field =\'Internal_Status__c\' and CreatedDate =TODAY';                            
        return Database.getQueryLocator(query);
    }
    
    //Execute method of Batch Class
    global void execute(Database.BatchableContext bc, List<ContactHistory> conHistoryList) {
        system.debug('test----');
        if(!Test.IsRunningTest()){
            contactIdSet=new Set<Id>();
        }
        
        Id TemplateId;
        Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
        try{
            for(ContactHistory conHistory :conHistoryList){
                if(conHistory.OldValue=='Selected' && conHistory.NewValue=='Facilitator Matched'){
                    contactIdSet.add(conHistory.ContactId);
                }
            }
            if(contactIdSet.size()>0 ){
                for(EmailTemplate et :[SELECT Id,Name FROM EmailTemplate WHERE name ='Automatic Batch Notifications_To_Student_On_FacilitatorMatched' limit 1]){
                    TemplateId=et.id;
                }
                if(TemplateId!=null){
                    for(Contact con : [Select id,Email,Active_Application_ID__c from Contact where id IN:contactIdSet]){
                        List<String> EmailList = new List<String>();
                        if(con.Email!=null){
                           EmailList.add(con.Email); 
                        }
                        if(!String.IsBlank(con.Active_Application_ID__c) && con.Email!=null){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTemplateID(TemplateId);//Template id
                            mail.setTargetObjectId(con.id);//contact id
                            mail.setWhatId(con.Active_Application_ID__c);//Application id
                            mail.setToAddresses(EmailList);//email to
                            mailList.add(mail); 
                        }
                    }
                }
            }
            if(mailList.size()>0){
            system.debug('I am here');
                Messaging.sendEmail(mailList);
            }
        }
        catch(Exception e){
            HandleBusinessException.captureError('NotifyStudentOnFacilitatorMatched_Batch', 'excutemethod', e);
        } 

    }
    //Finish method of Batch Class
    global void finish(Database.BatchableContext bc) {
        System.debug('Finish Method');
    }
    
    //Execute method of schedular Class
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new NotifyStudentOnFacilitatorMatched_Batch()); 
    }
}