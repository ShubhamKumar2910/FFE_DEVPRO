@isTest public class EachModuleCompleted_Test {
    @TestSetup public static void allTestData(){
        Contact conMentee = new Contact();
        Contact conMentor = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        
        conMentee.FirstName = 'Aawkash';
        conMentee.LastName = 'Jain';
        conMentee.is_Mentee__c = true;
        conMentee.Email = 'aakash.jain@utilitarianlab.com';
        insert conMentee;
        conMentor.FirstName = 'Ajeet';
        conMentor.LastName = 'Kumar';
        conMentor.Is_Mentor__c = True;
        conMentor.Email = 'aakash.jain@utilitarianlab.com';
        insert conMentor;
        
        Program__c pr = new Program__c();
        pr.Name = 'Communication Skills';
        pr.Skills__c = 'Communication Skills';
        pr.Hours_Required__c = 3.0;
        insert pr;
         
        Program__c pr1 = new Program__c();
        pr1.Name = 'Career Development';
        pr1.Skills__c = 'Career Development';
        pr1.Hours_Required__c = 3.0;
        insert pr1;
        
        Program__c pr2 = new Program__c();
        pr2.Name = 'Problem Solving and Decision Making';
        pr2.Skills__c = 'Problem Solving and Decision Making';
        pr2.Hours_Required__c = 3.0;
        insert pr2;
         
      
        mma.Mentor__c = conMentor.Id;
        mma.mentee_del__c = conMentee.Id;
        mma.Modules__c = 'Communication Skills';
        mma.Modules__c  = 'Career Development';
        mma.Modules__c = 'Problem Solving and Decision Making';
        mma.Status__c = 'Approved';
        insert mma;
       
    }    
    @isTest public static void insertSession1(){
        test.startTest();
        Mentor_Mentee_Association__c mmaRec = [Select id from Mentor_Mentee_Association__c];
        
        Session__c ss = new Session__c();
        ss.Status__c = 'Completed';
        ss.Date__c = System.today();
        ss.Time__c = Time.newInstance(1, 2, 3, 0);
        ss.End_time__c = Time.newInstance(5, 0, 0, 0);
        ss.Module__c = 'Communication Skills';
        ss.Mentor_Mentee_Association__c = mmaRec.id;
        insert ss;
        test.stopTest();
    }
    @isTest public static void insertSession2(){
        test.startTest();
        Mentor_Mentee_Association__c mmaRec = [Select id from Mentor_Mentee_Association__c];
        
        Session__c ss1 = new Session__c();
        ss1.Status__c = 'Completed';
        ss1.Date__c = System.today();
        ss1.Time__c = Time.newInstance(1, 2, 3, 0);
        ss1.End_time__c = Time.newInstance(5, 0, 0, 0);
        ss1.Module__c = 'Career Development';
        ss1.Mentor_Mentee_Association__c = mmaRec.id;
        insert ss1;
        test.stopTest();
    }
    
    @isTest public static void insertSession3(){
        test.startTest();
        Mentor_Mentee_Association__c mmaRec = [Select id from Mentor_Mentee_Association__c];
        
        Session__c ss1 = new Session__c();
        ss1.Status__c = 'Completed';
        ss1.Date__c = System.today();
        ss1.Time__c = Time.newInstance(1, 2, 3, 0);
        ss1.End_time__c = Time.newInstance(5, 0, 0, 0);
        ss1.Module__c = 'Problem Solving and Decision Making';
        ss1.Mentor_Mentee_Association__c = mmaRec.id;
        insert ss1;
        test.stopTest();
    }
}