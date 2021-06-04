@IsTest
public class AutomaticCIBTransactionCalloutTest {

     private static testmethod void executeTest(){
        
        test.startTest();
        User testUser = Utility_Test.createUser('BusinessAccountUtilization_Test@gmail.com');
        system.runAs(testUser){
            Contact con = new Contact();
            con.FirstName = 'jayanth';
            con.LastName = 'test';
            con.Email='jayanth@gmail.com';
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
            insert con;
            Application__c app = new Application__c();
            app.Student__c = con.id;
            app.Internal_Status__c = 'Awaiting for Fund';
            app.External_Status__c = 'Approved';
            app.Application_Stage__c = 'Active';
            insert app;
            Business_Account__c ba = new Business_Account__c(Account_No__c='213698',Name='ICICI');
            insert ba;
            Business_Account_Utilization__c bau1 = new Business_Account_Utilization__c();
            bau1.Application__c = app.id;
            bau1.Disbursement_Status__c ='Ready for Disbursement';
            bau1.Sender_Account_No__c = ba.id;
            bau1.APITXNStatus__c = System.label.automatic_CIB_Batch_Status;
            insert bau1;
            
            SchedulableContext SC;
            AutomaticCIBTransactionCallout CibBatch = new AutomaticCIBTransactionCallout();
            CibBatch.execute(SC);
            
        }
        test.stopTest();
    }
}