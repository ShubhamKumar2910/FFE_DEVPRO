@isTest  public class EmailMergeFieldParserTest {
    @isTest public static void parseModuleCompletedTemplatesTest(){
        
        Contact conMentee = new Contact();
        Contact conMentor = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        map<string, Mentor_Mentee_Association__c> mmaRecMap = new map<string, Mentor_Mentee_Association__c>();
        
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
        
        Program__c pr = new Program__c();
        pr.Name = 'Communication Skills';
        pr.Skills__c = 'Communication Skills';
        pr.Hours_Required__c = 3.0;
        insert pr;
        
        mma.Mentor__c = conMentor.Id;
        mma.mentee_del__c = conMentee.Id;
        mma.Modules__c = 'Communication Skills';
        mma.Status__c = 'Approved';
        insert mma;
        
        mmaRecMap.put('Approved',mma);
        EmailMergeFieldParser.parseModuleCompletedTemplates('menteeAssigned','mentorAssigned',mmaRecMap);
    }
}