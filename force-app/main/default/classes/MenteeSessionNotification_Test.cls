@isTest public class MenteeSessionNotification_Test {
    @isTest public static void sendNotificationToMentorMenteeTest(){
        List<Contact> conList = new List<Contact>();
        
        Contact conMentor = new Contact();
        conMentor.FirstName =  'Ajeet';
        conMentor.LastName =  'Kumar';
        conMentor.Whatsapp_opting__c = true;
        conMentor.Phone = '+917042458620';
        conMentor.RecordTypeId =  '0121e000000L5TF';
        conList.add(conMentor) ;
        
        Contact conMentee = new Contact();
        conMentee.FirstName =  'Aakash';
        conMentee.LastName =  'Jain';
        conMentee.is_Mentee__c = true;
        conMentee.Whatsapp_opting__c = true;
        conMentee.Phone = '+917042458620';
        conList.add(conMentee);
        
        insert conList;
        
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        mma.mentee_del__c = conMentee.Id;
        mma.Mentor__c = conMentor.Id;
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        insert mma;
        
        Session__c ss = new Session__c();
        ss.Agenda__c = 'Test';
        ss.Date__c = system.today();
        ss.Description__c = 'test';
        ss.Meeting_Link__c = 'www.Salesforce.com';
        ss.Mentor_Mentee_Association__c = mma.Id;
        ss.Status__c = 'Created';
        insert ss;
        
        map<id,Session__c> sessionMap = new map<id,Session__c>();
        sessionMap.put(ss.Id, ss);
        MenteeSessionNotification.sendNotificationToMentorMentee(sessionMap);
    }
}