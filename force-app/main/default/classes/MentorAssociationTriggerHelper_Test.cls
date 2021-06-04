@isTest public class MentorAssociationTriggerHelper_Test {
    @isTest public static void getInstanceTest(){
        MentorAssociationTriggerHelper.getInstance();
    
    }
    @isTest public static void updateHourTest(){
         
        Program__c pr = new Program__c();
        pr.Name = 'Communication Skills';
        pr.Skills__c = 'Communication Skills';
        pr.Hours_Required__c = 15;
        insert pr;
        
        Program__c pr1 = new Program__c();
        pr1.Name = 'Stress Management';
        pr1.Skills__c = 'Stress Management';
        pr1.Hours_Required__c = 15;
        insert pr1;   
        List<Contact> conList = new List<Contact>();
        
        Contact conMentor = new Contact();
        conMentor.FirstName =  'Ajeet';
        conMentor.LastName =  'Kumar';
        conMentor.RecordTypeId =  '0121e000000L5TF';
        conList.add(conMentor) ;
        
        Contact conMentee = new Contact();
        conMentee.FirstName =  'Aakash';
        conMentee.LastName =  'Jain';
        conMentee.is_Mentee__c = true;
        conList.add(conMentee);
        
        insert conList;
        
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        mma.mentee_del__c = conMentee.Id;
        mma.Mentor__c = conMentor.Id;
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        insert mma;
        
        List<Mentor_Mentee_Association__c> newMmaList = new List<Mentor_Mentee_Association__c>();
        newMmaList.add(mma);
        
    }
    
}