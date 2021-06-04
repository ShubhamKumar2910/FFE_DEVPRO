public class SendEmailNotification {
    // method will accept Set of contact id and email template name
    public static void sendEmailToIndividuals(set<Id> conId, String emailTempName) { 
        try{
            list<Contact> contactList = new list<Contact>();
            EmailTemplate emailTempRec = new EmailTemplate();
            system.debug('emailTempName'+emailTempName);
            system.debug('conId'+conId);
            if(conId != null){
                contactList = [select name,id,FirstName,Email,Phone,Employer_Name__c,Is_Mentor__c,Designation__c,is_Mentee__c,RecordTypeId,Location__c,College_Name__c,College_Location__c,Branch_Stream__c from Contact where Id in :conId];
                system.debug('contactList==>'+contactList);            
            }
            if(emailTempName != null && emailTempName != ''){
                emailTempRec=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTempName];
                system.debug('emailTempRec==>'+emailTempRec);
                
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (Contact contact : contactList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(contact.Email);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('FFE Mentoring Team');
                
                String subject = emailTempRec.Subject;
                system.debug('subject==>'+subject);
                String htmlBody = emailTempRec.HtmlValue;
                if(contact.is_Mentee__c == true){
                    if( contact.Name != null){
                        htmlBody = htmlBody.replace('{!Mentee.Name}', contact.Name);
                    }
                }
                else if(contact.Is_Mentor__c == True){
                    if( contact.Name != null){
                        htmlBody = htmlBody.replace('{!Mentor.Name}', contact.name); 
                    }
                }
                
                system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                
                mails.add(mail);
            }
            System.debug('mails==>'+mails);
            system.debug('mails.size()==>'+mails.size());
            Messaging.sendEmail(mails);
        }catch(Exception e){
            System.debug('Error Line==>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
        }
        
    }
}