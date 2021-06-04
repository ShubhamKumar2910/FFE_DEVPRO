global class SendBulkITCertificate implements Database.Batchable<sObject>, Database.Stateful{
        
        private String opportunityId;
        
        public SendBulkITCertificate(String oppID) {
            opportunityId = oppID;
        }
        
        global Database.QueryLocator start(Database.BatchableContext BC){
            
            return Database.getQueryLocator('SELECT id,Name,Cheque_No__c,Donation__r.Payment_Order__c,Donation__r.Payment_Order__r.Donor__c,Email__c,MobileNo__c,PAN__c,PostalCode__c,State__c,Street__c,Donation_Amount__c,Country__c,City__c,Cheque_DD_Bank_Name__c,Payment_Method__c,Payment_Date__c FROM Contributor__c WHERE Donation__c =:opportunityId');    
            
        }
        
        global void execute(Database.BatchableContext BC, List<Contributor__c> contributorsList){
            SavePoint sp = Database.setSavepoint();
            //This flag is introduced to generate bulk 80G without sending email.
            boolean flag=(BypassTrigger__c.getInstance('SendBulkITCertificate')!=null ?BypassTrigger__c.getInstance('SendBulkITCertificate').Bypass__c :false);
            try{
                List<String> toEmail                  = new List<String> ();
                List<Attachment> attachmentList       = new List<Attachment>();
                
                EmailTemplate et                      = [select Id from EmailTemplate where DeveloperName =:System.Label.Sendcontributors_bulk_sms Limit 1];
                
                
                
                for(Contributor__c contributor : contributorsList){
                    
                    //generate and attach the PDF document
                    PageReference pdfPage = Page.BulkTaxExceptionForm;
                    pdfPage.getParameters().put('id',contributor.id);
                    
                    //get the output of the page, as displayed to a user in a browser
                    Blob  pdfBlob;
                    if(test.isRunningTest()){
                        pdfBlob=Blob.valueOf('UNIT.TEST');
                        
                    }else{
                        pdfBlob = pdfPage.getContent();   
                    }
                    
                    attachmentList.add(new Attachment(parentId = contributor.id, Name = contributor.Name+'_80gform.pdf', body = pdfBlob)); 
                    
                } 
                
                if(!attachmentList.isEmpty())
                    insert attachmentList;
                
                
                Map<id,Attachment> attachmentMap = new Map<id,Attachment>();//contains contributors ID as key and there attachment as value
                for(Attachment att : attachmentList){
                    attachmentMap.put(att.parentId,att);
                }
                
                Messaging.SingleEmailMessage[] EmailMessageList = new Messaging.SingleEmailMessage[]{};
                    
                    for(Contributor__c contributor : contributorsList){
                        
                        
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setSaveAsActivity(false);
                        email.setTemplateId(et.Id);
                        email.setWhatId(contributor.Id);
                        email.setTargetObjectId(contributor.Donation__r.Payment_Order__r.Donor__c);
                        email.setTreatTargetObjectAsRecipient(false);
                        if(contributor.Email__c != null || contributor.Email__c != '')
                            email.setToAddresses(new List<String>{contributor.Email__c});
                        
                        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                        
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        efa.setFileName(attachmentMap.get(contributor.id).Name);
                        efa.setBody(attachmentMap.get(contributor.id).Body);
                        fileAttachments.add(efa);
                        email.setFileAttachments(fileAttachments);
                        EmailMessageList.add(email);
                    }
                
                if(!EmailMessageList.isEmpty() && !flag){
                    Messaging.sendEmail(EmailMessageList);
                }
            }catch(Exception e){
                database.rollback(sp);
                HandleBusinessException.captureError('SendBulkITCertificate', 'execute batch', e);
            }
        }   
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}