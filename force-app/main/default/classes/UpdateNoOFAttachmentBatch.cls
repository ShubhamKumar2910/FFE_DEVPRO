global class UpdateNoOFAttachmentBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id,Number_of_Attachments__c, (SELECT Id, Name FROM Attachments) FROM Application__c WHERE Number_of_Attachments__c = null OR Number_of_Attachments__c = 0';
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Application__c> appList){
        // process each batch of records
        for(Application__c app : appList){
            app.Number_of_Attachments__c = app.Attachments.size();
        }
        System.debug('--- size '+appList.size());
        update AppList;
    }
    global void finish(Database.BatchableContext bc){
        
    }
}