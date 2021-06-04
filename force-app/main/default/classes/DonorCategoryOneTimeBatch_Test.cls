@isTest
public class DonorCategoryOneTimeBatch_Test {
    @isTest
    public static void testMethod1(){
        
        Contact donor  = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'js@gmail.com.com', '9090909090', 'js@gmail.com', 'js@gmail.com'); 
        donor.DN_PAN__c='327812798721';
        donor.Aadhar_number__c='123456789012';
        donor.DN_Donor_Category__c = 'Scholar';
        insert donor;
        Test.startTest();
      Database.executeBatch(new DonorCategoryOneTimeBatch(),100);
        Test.stopTest();
    }
}