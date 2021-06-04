@isTest public class MSigninHelper_Test {
    @isTest public static void checkStudentDetailsTest(){
        Contact conMentor = new Contact();
        conMentor.FirstName = 'Aakash';
        conMentor.LastName = 'Jain';
        conMentor.Is_Mentor__c = true;
        conMentor.password__c = 'ash@123';
        insert conMentor;
        MSigninHelper.checkStudentDetails('Aakash Jain', 'ash@123', 'Mentor');
        MSigninHelper.checkStudentDetails('Aakash Jain', 'dash@123', 'Mentor');
        MSigninHelper.checkStudentDetails('Aakash Jain', 'dash@123', 'Mentee');
        MSigninHelper.checkStudentDetails('Aakashh Jain', 'dash@123', 'Mentee');
    }
    @isTest public static void menteeLoginTest(){
        Contact conMentee = new Contact();
        conMentee.FirstName = 'Aakash';
        conMentee.LastName = 'Jain';
        conMentee.Email = 'aakash@gmail.com';
        conMentee.is_Mentee__c = true;
        insert conMentee;
        String ffeUIDmentee = [Select FFE_ID__c from Contact Where FirstName = 'Aakash' limit 1].FFE_ID__c;
        
        Contact conMentor = new Contact();
        conMentor.FirstName = 'Ajeet';
        conMentor.LastName = 'Kumar';
        conMentor.Email = 'ajeet@gmail.com';
        conMentor.Is_Mentor__c = true;
        conMentor.password__c = '1233';
        insert conMentor;
        
        String ffeUIDmentor = [Select FFE_ID__c from Contact Where FirstName = 'Ajeet' limit 1].FFE_ID__c;
        
       /* Contact con = new Contact();
        con.Id = conMentor.Id;
        con.password__c = ffeUIDmentor;
        update con;*/
        
        Contact con1 = new Contact();
        con1.Id = conMentee.Id;
        con1.password__c = ffeUIDmentee;
        update con1;
        
        MSigninHelper.mentorRegistration(conMentor.Id, conMentor.Email);
        MSigninHelper.mentorRegistration(conMentor.Id, '');  // for else
        MSigninHelper.menteeLogin('aakash@gmail.com', ffeUIDmentee);
       // MSigninHelper.mentorLogin('ajeet@gmail.com','1233');
    }
    @isTest public static void menteeRegistrationTest(){
        Contact conMentee = new Contact();
        conMentee.FirstName = 'Aakash';
        conMentee.LastName = 'Jain';
        conMentee.Email = 'aakash@gmail.com';
        conMentee.is_Mentee__c = true;
        insert conMentee; 
        
        String ffeUIDmentee = [Select FFE_ID__c from Contact Where FirstName = 'Aakash' limit 1].FFE_ID__c;
        
        MSigninHelper.menteeRegistration(ffeUIDmentee, 'aakash@gmail.com');
       
        Contact conMentee1 = new Contact();
        conMentee1.FirstName = 'Aakashs';
        conMentee1.LastName = 'Jain';
        conMentee1.Email = 'aakash@gmail.com';
        insert conMentee1; 
        
        String ffeUIDmentee1 = [Select FFE_ID__c from Contact Where FirstName = 'Aakashs' limit 1].FFE_ID__c;
        
        MSigninHelper.menteeRegistration(ffeUIDmentee1, 'aakash@gmail.com');
        MSigninHelper.menteeRegistration(conMentee1.Id, 'aakash@gmail.com');
        MSigninHelper.generateLoginURL(ffeUIDmentee1, 'Mentee');
        MSigninHelper.generateLoginURLForEmail('aakash@gmail.com','Mentee');
        
    }
    
    @isTest public static void mentorLoginTest(){
        Contact conMentor = new Contact();
        conMentor.FirstName = 'Ajeet';
        conMentor.LastName = 'Kumar';
        conMentor.Email = 'ajeet@gmail.com';
        conMentor.Is_Mentor__c = true;
        conMentor.password__c = '1233';
        insert conMentor;
        MSigninHelper.mentorLogin('ajeet@gmail.com', '1233');
    }
    
}