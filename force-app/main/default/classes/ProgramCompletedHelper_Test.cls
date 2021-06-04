@isTest public class ProgramCompletedHelper_Test {
    @testSetup public static void allTestData(){
        Contact conMentee = new Contact();
        Contact conMentor = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        
        conMentee.FirstName = 'Aawkash';
        conMentee.LastName = 'Jain';
        conMentee.is_Mentee__c = true;
        conMentee.Email = 'aakash.jain@utilitarianlab.com';
        insert conMentee;
        conMentor.FirstName = 'Ajewet';
        conMentor.LastName = 'Kumar';
        conMentor.Is_Mentor__c = True;
        conMentor.Email = 'aakash.jain@utilitarianlab.com';
        insert conMentor;
        
        mma.Mentor__c = conMentor.Id;
        mma.mentee_del__c = conMentee.Id;
        mma.Modules__c = 'Communication Skills';
        mma.Status__c = 'Requested';
        insert mma;
    }
    
    @isTest public static void notifyMentorAboutPrgrmCmpltionTest(){
        String mmaId = [Select id from Mentor_Mentee_Association__c].Id;
        
        Mentor_Mentee_Association__c mmaRec = new Mentor_Mentee_Association__c();
        mmaRec.Id = mmaId;
        mmaRec.Status__c = 'Completed';
        update mmaRec;
        
    }
}