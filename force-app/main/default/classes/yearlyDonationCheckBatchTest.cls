@isTest
public class yearlyDonationCheckBatchTest {
    
    static testMethod void validateBatch() {
        
        Contact con= Utility_Test.insertNewDonorId('Gourab','Hazra');
        con.Has_Donated_First_Time_Donor__c=true;
        insert con;     
        test.startTest();
        yearlyDonationCheckBatch yd = new yearlyDonationCheckBatch();
        database.executeBatch(yd);
        String sch = '0 0 23 * * ?';
        system.schedule('Test', sch, yd);
        test.stopTest();
    }


}