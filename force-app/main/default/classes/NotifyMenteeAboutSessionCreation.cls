public class NotifyMenteeAboutSessionCreation {
    // method will be called from trigger when new session is created and send email to menteee only
    // including the session date, time and agenda
    public static void sendEmailToMentee(Map<id, Session__c> newSessionMap){
        system.debug('newSessionMap::'+newSessionMap);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        String emailTempName = 'Mentorship_session_creation';
        // getting email template
        EmailTemplate emailTempRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTempName];
        for(Session__c sessionRec : newSessionMap.values()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> recipients = new List<String>();
            recipients.add(sessionRec.Mentee_Email__c);
            system.debug('recipients------'+recipients);
            mail.setToAddresses(recipients);
            mail.setSenderDisplayName('FFE Mentoring Team');
            
            String subject = emailTempRec.Subject;
            system.debug('subject==>'+subject);
            String htmlBody = emailTempRec.HtmlValue;
            if( sessionRec.Mentee_Name__c != null){
                htmlBody = htmlBody.replace('{!Mentee.Name}', sessionRec.Mentee_Name__c);
            }
            if( sessionRec.Agenda__c != null){
                htmlBody = htmlBody.replace('{!session.agenda}', sessionRec.Agenda__c );
            }
            if( sessionRec.Date__c != null){
                String stringDate = string.valueof(sessionRec.Date__c);
                htmlBody = htmlBody.replace('{!session.date}', stringDate);
            }
            if( sessionRec.Time__c != null){
                String stringTime = string.valueOf(sessionRec.Time__c);
                String processedTime = stringTime.substring(0, 5);
                htmlBody = htmlBody.replace('{!session.time}', processedTime);
            }
            
            system.debug('subject==>'+subject);
            system.debug('htmlBody==>'+htmlBody);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            
            mails.add(mail);
        }
        System.debug('mails==>'+mails);
        system.debug('mails.size()==>'+mails.size());
        Messaging.sendEmail(mails);
    }
}