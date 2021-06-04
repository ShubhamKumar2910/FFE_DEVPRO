@isTest
public class emailNotificationForUsDonorHelperTest {
    
    static testMethod void donorNotification() {
        
        Contact conDonor = Utility_Test.insertNewDonorId('Test','Donor');
        conDonor.Email ='test@mailinator.com';
        conDonor.MobilePhone = '8888888';
        insert conDonor;
        
        College_Master__c cm = Utility_Test.createCollegeMaster('Test','Bangalore','AA','KA');
        insert cm;
        
        Contact conStudent = Utility_Test.insertSingleStudent('Test','Student');
        conStudent.MailingState = 'Karnataka';
        conStudent.Course__c = 'BE/B.Tech';
        conStudent.College_Name__c = cm.Id;
        insert conStudent;
        
        Application__c ap = Utility_Test.insertNewApplication('Selected','Submitted');
        ap.Student__c = conStudent.Id;
        ap.DM_Financial_Year__c = '2017-18';
        insert ap;
  
        Donor_Application_Mapping__c dam = new Donor_Application_Mapping__c();
        dam.Donor__c = conDonor.Id;
        //dam.Prev_Financial_Year__c = '2017-18';
        dam.Application__c = ap.Id;
        dam.Student__c = conStudent.Id;
        insert dam;
        
        List<String> fyList = Utility.PastTenFinancialYear();
        
        Test.startTest();
        emailNotificationForUsDonorHelper.sendMailtodonors(fyList,'test@mailinator.com','Donor Notification','Hello Donor');
        Test.stopTest();
    }
}