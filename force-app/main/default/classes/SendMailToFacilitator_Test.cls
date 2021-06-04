/*
* Purpose: Test class for SendMailToFacilitator Class
*/
@isTest
public class SendMailToFacilitator_Test {
    
    public static Contact createStudents(string lastName, string mailingCity, string mailingState, string mailingStreet, string adate, id facilitatorId)
    {
        Contact student = Utility_Test.insertNewStudentRec('abc',lastName,null,null,null,null,null,0,0,null,null);
        student.Mailingcity = mailingCity;
        student.MailingStreet = mailingStreet;
        student.Mailingstate = mailingState;
        student.Facilitator_Assigned_Date__c = date.today();
        student.Facilitator_Name__c = facilitatorId;
        return student;
    }
    public static testmethod void checkSendMail(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            insert new System_Details__c(Facilitator_Batch_CurrentDate__c = 0);
            Contact facilitator = Utility_Test.insertFacilitator('abc','xyz');
            facilitator.email = 'abc@mail.com';
            insert facilitator;
            Contact student = createStudents('xyz', 'Bangalore', 'Karnataka', 'Rosan Street', '2017-04-',facilitator.Id);
            insert student;
            
            Contact student1 = createStudents('xxx', 'Bangalore', 'Karnataka', 'Rosan Street', '2017-04-20',facilitator.Id);
            insert student1;
            
            SchedulableContext SC;
            SendMailToFacilitator smfObj = new SendMailToFacilitator();
            smfObj.execute(SC);            
        }
        test.stopTest();
    }  
}