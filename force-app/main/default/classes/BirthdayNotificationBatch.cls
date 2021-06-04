global class BirthdayNotificationBatch implements Database.Batchable<sObject>,Schedulable {
    
    Id studId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
    Id faciId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
    List<OrgWideEmailAddress> ot =  [Select id,DisplayName,Address from OrgWideEmailAddress Where Address =:'crm@ffe.org'];
    List<EmailTemplate> emailTmpList = [SELECT Id,Name FROM EmailTemplate WHERE name =:Label.StudentBirthday OR name =:Label.FacilatorBirthday];
    
    global Database.queryLocator start(Database.BatchableContext bc) {
        
        Date tody = system.today();
        String query ='SELECT Id, Name,Email,Birthdate,RecordTypeId FROM Contact WHERE  DAY_IN_MONTH(Birthdate) ='+ 
                      tody.day() + 'AND CALENDAR_MONTH(Birthdate) = ' + tody.month() + 'AND (RecordTypeId =:studId OR RecordTypeId =:faciId)';                            
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList) {
        try{
        String studTempId = '';
        String factTempId = '';      
        Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
        //List<String> EmailList = new List<String>(); 
        for(EmailTemplate et :emailTmpList){
            
             if(et.Name == Label.StudentBirthday){
                studTempId  =  et.id;
             }else{
               factTempId =  et.id;
             } 
        }
        
        for(Contact con : conList){
            List<String> EmailList = new List<String>();
            if(con.RecordTypeId == studId && (con.Email!='' && con.Email!=null)){
               EmailList.add(con.Email); 
               Messaging.SingleEmailMessage mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(studTempId,con.Id,null,EmailList,ot);
               mailList.add(mail);  
            }

            if(con.RecordTypeId == faciId && (con.Email!='' && con.Email!=null)){
               EmailList.add(con.Email);
               Messaging.SingleEmailMessage mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(factTempId,con.Id,null,EmailList,ot);
               mailList.add(mail);
            }
        }
        Messaging.sendEmail(mailList);
        }
        catch(Exception e){
            HandleBusinessException.captureError('BirthdayNotificationBatch', 'excutemethod', e);
        } 

    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Finish Method');
    }
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new BirthdayNotificationBatch()); 
    }
}