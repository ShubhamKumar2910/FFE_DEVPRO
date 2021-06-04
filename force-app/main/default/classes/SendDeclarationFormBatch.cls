/**
 * Author : Prithvi
 */
global class SendDeclarationFormBatch implements Database.Batchable<SObject>, Database.stateful {
    
    static final String INVALID_DONOR_ID_MESSAGE = 'Error: Donor id cannot be blank.';
    static final String APPLICATIONS_NOT_FOUND_MESSAGE = 'No applications found for fiscal year: ';
    static final String JOB_CREATED_SUCCESSFULL_MESSAGE = 'Sending declaration form email to';
    Set<Id> declarationAppIdSet;
    List<OrgWideEmailAddress> owaList = [SELECT id,displayName,Address FROM OrgWideEmailAddress WHERE displayName=:System.label.Foundation_For_Excellence LIMIT 1];
    List<EmailTemplate> emailTemplateList = [SELECT id FROM EmailTemplate WHERE Developername = 'Student_Declaration_Form'];

    public SendDeclarationFormBatch(Set<Id> declarationAppIdSet) {
        this.declarationAppIdSet = declarationAppIdSet;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        if(emailTemplateList.isEmpty())
            throw new DeclarationFormBatchException('Couldn\'t find Email template');
        return Database.getQueryLocator([SELECT Id, Student__c, Declaration_Document_Sent__c FROM Application__c WHERE Id IN: declarationAppIdSet]);
    }
    
    public void execute(Database.BatchableContext BC, List<Application__c> applicationList) {
        
        List<Messaging.SingleEmailMessage> mailList = new List<MEssaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage singleMail;

        for(Application__c app : applicationList) {
            singleMail = new Messaging.SingleEmailMessage();
            if(!owaList.isEmpty())
                singleMail.setOrgWideEmailAddressId(owaList[0].Id);
            else
                singleMail.setSenderDisplayName(Constants.FFE_NAME);
            singleMail.setTargetObjectId(app.Student__c); 
            singleMail.setTemplateId(emailTemplateList[0].Id); 
            singleMail.setWhatId(app.Id);
            singleMail.setSaveAsActivity(true);
            mailList.add(singleMail);
            app.Declaration_Document_Sent__c = true;
        }
        if(!mailList.isEmpty()) {
            try{
                Messaging.sendEmail(mailList);
                update applicationList;
            }catch(Exception e) {
                HandleBusinessException.captureError('SendDeclarationFormBatch', 'execute', e);
            }

        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
    webservice static String initiateDeclarationBatch(Id donorId, String fiscalYear) {
        
        if(String.isBlank(donorId) || String.isBlank(fiscalYear)) {
            return INVALID_DONOR_ID_MESSAGE;
        }

        Set<Id> declarationAppIdSet = new Set<Id>();
        Set<Id> studentIdSet = new Set<Id>();
        for(Donor_Application_Mapping__c dam : [SELECT Id, Application__c, Application__r.Student__c FROM Donor_Application_Mapping__c WHERE Donor__c =:donorId AND Application__r.RPT_Financial_Year__c = :fiscalYear AND Application__r.Student__c != null]) {
            declarationAppIdSet.add(dam.Application__c);
            studentIdSet.add(dam.Application__r.Student__c);
        }

        if(declarationAppIdSet.isEmpty())
            return APPLICATIONS_NOT_FOUND_MESSAGE+fiscalYear;
        
        Database.executeBatch(new SendDeclarationFormBatch(declarationAppIdSet), 20);
        return JOB_CREATED_SUCCESSFULL_MESSAGE+' '+ (studentIdSet.size() > 1 ? studentIdSet.size()+' students' : studentIdSet.size()+' student');
    }

    Webservice static List<String> getFiscalYears(){
        List<String> PreviousTenfinancialYear = new List<String>();
        
        for(integer i=1;i<=10;i++){
            if(system.today().month() > = 1 && system.today().month()<=3){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year()) - i) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1) - i).substring(2, 4)); 
            }else if(system.today().month() > = 4 && system.today().month()<=12){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year()) - i + 1) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1) - i + 1).substring(2, 4)); 
            } 
        }
        return PreviousTenfinancialYear;
    }
    
    class DeclarationFormBatchException extends Exception{}
}