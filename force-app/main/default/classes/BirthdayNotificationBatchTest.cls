@isTest
public class BirthdayNotificationBatchTest {
    
    static testMethod void validateBatch() {
        
        Contact conFact= Utility_Test.insertFacilitator('Gourab','Hazra');
        conFact.Birthdate = Date.newInstance(1960, 7, 9);
        conFact.Email = 'testfact@mailinator.com';
        insert conFact;
        system.debug('FACon:::'+conFact); 
        
        Contact conStud= Utility_Test.insertSingleStudent('Jayant','B');
        conStud.Birthdate = system.today();//Date.newInstance(1960, 7, 9);
        conStud.Email = 'teststud@mailinator.com';
        insert conStud;
        system.debug('StCon::::'+conStud);
        
      //  List<EmailTemplate> emailTmpList = [SELECT id FROM EmailTemplate WHERE DeveloperName =:Student_Alumni_BdayGreeting OR DeveloperName =:Facilitator_Details];
        Test.startTest();
       /* List<Contact> stulist = [Select Id,Name,Birthdate,Email from Contact Where Name='Gourab Hazra' Limit 1];
        system.debug('#########'+stulist); */
        BirthdayNotificationBatch bn = new BirthdayNotificationBatch();
		database.executeBatch(bn);
        String sch = '0 0 23 * * ?';
        system.schedule('Test',sch, bn);
        Test.stopTest();
    }

}