public class WelcomeMenteeEmail_Helper {
    public static void sendWelcomeEmailNotificationToMentee(Map<id, Contact> conNewMap , Map<id, Contact> conOldMap){
        Set<Id> conId = new Set<Id>(); 
        for(Contact con : conNewMap.values()){
            if(con.is_Mentee__c == true && conOldMap.get(con.Id).is_Mentee__c != true){
                conId.add(con.Id);
                System.debug('conId==>'+conId);
            }
        }
        SendEmailNotification.sendEmailToIndividuals(conId, 'Welcome Mentee');
    }
    
}