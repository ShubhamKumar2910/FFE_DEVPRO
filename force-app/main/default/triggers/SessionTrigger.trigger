trigger SessionTrigger on Session__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        // 4- to send whatsapp status to mentor and mentee after insert
        //NotifyAboutSession.sendNotificationToMentorMentee(Trigger.newMap);
        // 6- to send email to mentee after insert
        NotifyMenteeAboutSessionCreation.sendEmailToMentee(Trigger.newMap);
    }
    
}