public class WelcomeMentorEmail_Helper {
    
    public static boolean runOnce = false;
    public static void sendWelcomeEmailNotificationToMentor(Map<id, Contact> conNewMap){
        set<id> conId = new set<id>();
        for(Contact con : conNewMap.values()){
            if(con.Is_Mentor__c == true){
                conId.add(con.Id);
            }
        }
        SendEmailNotification.sendEmailToIndividuals(conId, 'Welcome Mentor');
    }
    public static void sendWelcomeMailAfterUpdate(Map<id, Contact> conNewMap, Map<id, Contact> conOldMap){
        set<id> conId = new set<id>();
        for(Contact con : conNewMap.values()){
            
            if(con.Is_Mentor__c == true && conOldMap.get(con.Id).Is_Mentor__c == false)
            {
                conId.add(con.Id);
            }
        }
        SendEmailNotification.sendEmailToIndividuals(conId, 'Welcome Mentor');
    }
}