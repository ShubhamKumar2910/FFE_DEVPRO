@isTest public class SessionStatusNotify_Test {
    @isTest public static void sendWhatsappTest(){
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
        
        Mentor_Mentee_Association__c mmaStatusChange = new Mentor_Mentee_Association__c();
        mmaStatusChange.Id = mma.Id;
        mmaStatusChange.Status__c = 'Completed';
        update mmaStatusChange;
        
        
        map<id,Mentor_Mentee_Association__c> mmaOldMap = new map<id,Mentor_Mentee_Association__c>();
        mmaOldMap.put(mma.Id, mma);
        map<id,Mentor_Mentee_Association__c> mmaNewMap = new map<id,Mentor_Mentee_Association__c>();
        mmaNewMap.put(mmaStatusChange.Id, mmaStatusChange);
        SessionStatusNotify.sendWhatsapp(mmaNewMap, mmaOldMap);
    }
}