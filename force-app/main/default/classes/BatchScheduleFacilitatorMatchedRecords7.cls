global class BatchScheduleFacilitatorMatchedRecords7 implements Database.Batchable<SObject>, Database.Stateful{ 
    
    private String query;
 
    global BatchScheduleFacilitatorMatchedRecords7(String soql){
        query = soql;
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC) { 
  
        return Database.getQueryLocator(query);
        
    } 
 
    global void execute(Database.BatchableContext BC, List<SObject> scope) { 
        
        EmailTemplate EM = [SELECT Id, Name, DeveloperName, OwnerId, IsActive, TemplateType FROM EmailTemplate WHERE DeveloperName = 'Notification_to_Meet_Facilitator_1'];
        List<Id> conid = new List<Id>();
        for(SObject s : scope){
            conid.add(s.id);
        }
        List<Contact> conlist = [Select Id,Name From Contact where ID IN :conid];
        for(Contact s : conlist){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			// email Template Id
			mail.setTemplateId(EM.id); 
			mail.setTargetObjectId(s.id); 
			mail.setSenderDisplayName(s.Name);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
    } 
 
    global void finish(Database.BatchableContext BC) { 
        
	}
}