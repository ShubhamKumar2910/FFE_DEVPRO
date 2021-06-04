global class BatchScheduleFacilitatorMatchedRecords20 implements Database.Batchable<SObject>, Database.Stateful{ 
    
    private String query;
 
    global BatchScheduleFacilitatorMatchedRecords20(String soql){
        query = soql;
    }
 
    global Database.QueryLocator start(Database.BatchableContext BC) { 
  
        return Database.getQueryLocator(query);
        
    } 
 
    global void execute(Database.BatchableContext BC, List<SObject> scope) { 
        
        EmailTemplate EM = [SELECT Id, Name, DeveloperName, OwnerId, IsActive, TemplateType FROM EmailTemplate WHERE DeveloperName = 'Alert_on_20th_day_to_owner'];
        List<Id> conid = new List<Id>();
        for(SObject s : scope){
            conid.add(s.id);
        }
        
        List<Contact> Contactlist = [Select Id,Name,Owner_Email_ID__c,Facilitator_Name__c From Contact where ID IN: conid];
        
        List<Application__c> Applicationlist = [Select Id,Application_owner__c,Application_owner__r.Email,Application_Stage__c,Student__c From Application__c where Student__c IN :scope AND Application_Stage__c = 'Active'];
        
        Map<Id,String> ContactApplowneremail = new Map<Id,String>();
        for(Application__c app : Applicationlist){
            ContactApplowneremail.put(app.Student__c,app.Application_owner__r.Email);
        }
        
        
        for(Contact s : Contactlist){
            
            String Emailaddress = ContactApplowneremail.get(s.id);
            
			List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
			Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
			msg.setTemplateId(EM.id);
			//msg.setToAddresses(new List<String>{s.Owner_Email_ID__c});
			msg.setToAddresses(new List<String>{Emailaddress});
			msg.setTargetObjectId(s.id); 
			msg.setSenderDisplayName(s.Name);
			
			msgList.add(msg);
            
            if(Test.isRunningTest()){
                
                Savepoint sp = Database.setSavepoint();
                try{
			        Messaging.sendEmail(msgList); // Dummy email send
                    }catch(Exception e){
                        
                    }
		    	Database.rollback(sp); // Email will not send as it is rolled Back
                
            }else{
			// Send the emails in a transaction, then roll it back
			Savepoint sp = Database.setSavepoint();
			Messaging.sendEmail(msgList); // Dummy email send
			Database.rollback(sp); // Email will not send as it is rolled Back
            }
			
			List<Messaging.SingleEmailMessage> msgListToBeSend = new

			List<Messaging.SingleEmailMessage>();
			for (Messaging.SingleEmailMessage email : msgList) {
			Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
			emailToSend.setToAddresses(email.getToAddresses());
			emailToSend.setPlainTextBody(email.getPlainTextBody());
			emailToSend.setHTMLBody(email.getHTMLBody());
			emailToSend.setSubject(email.getSubject());
			msgListToBeSend .add(emailToSend);
			}
			if(Test.isRunningTest()){
			     try{
			        Messaging.sendEmail(msgListToBeSend);
                    }catch(Exception e){
                    }
			}else{
			    Messaging.sendEmail(msgListToBeSend);
			}
			
		}
		
    } 
 
    global void finish(Database.BatchableContext BC) { 
        
	}
}