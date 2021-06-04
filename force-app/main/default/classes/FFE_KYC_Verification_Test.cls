@isTest
public class FFE_KYC_Verification_Test {
    
    @isTest
    public static void testMethod1() {
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
            donor.Aadhar_number__c = 'abcd124abc';
            donor.Active_Application_ID__c = 'abcdefg';    
            insert donor;
            Test.startTest();
            FFE_KYC_Verification.kycVerification(donor.id);
            DecryptHashValue_CTLR a = new DecryptHashValue_CTLR();
            String decodevalue =FFE_KYC_Verification.generateHashCode('abcd4356');
            a.hashValue = decodevalue;
            a.decodeString();
            
            DecryptHashValue_CTLR b = new DecryptHashValue_CTLR();
            
            b.hashValue = '2445435';
            b.decodeString();
            
            
            DecryptHashValue_CTLR c = new DecryptHashValue_CTLR();
            
            c.hashValue = '';
            c.decodeString();
            HashAadharNumber_OneTime_Batch obj = new HashAadharNumber_OneTime_Batch();
            DataBase.executeBatch(obj); 
            Test.stopTest();
            
            
        }
    }
    
    
}