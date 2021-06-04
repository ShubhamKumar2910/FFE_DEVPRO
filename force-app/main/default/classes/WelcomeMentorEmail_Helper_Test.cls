@isTest public class WelcomeMentorEmail_Helper_Test {
    @isTest public static void sendWelcomeEmailNotificationToMentorTest(){
        Contact con = new Contact();
        con.FirstName = 'Aakash';
        con.LastName = 'Jain';
        con.Is_Mentor__c = true;
        insert con;
        
        String conId = [Select Id from Contact].id;
        Contact con1 = new Contact();
        con1.Id = conId;
        con1.Is_Mentor__c = false;
        update con1;
        
        Contact con2 = new Contact();
        con2.Id = conId;
        con2.Is_Mentor__c = true;
        update con2;
        
        Contact con3 = new Contact();
        con3.Id = conId;
        con3.is_Mentee__c = true;
        update con3;
        
        
    }
    
}