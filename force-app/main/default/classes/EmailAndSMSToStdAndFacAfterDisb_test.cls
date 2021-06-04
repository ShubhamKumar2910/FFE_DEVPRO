@IsTEst
public class EmailAndSMSToStdAndFacAfterDisb_test {
    
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
            Business_Account_Utilization__c bau1 = new Business_Account_Utilization__c();
            bau1.Application__c = app.id;
            bau1.Disbursement_Status__c ='Ready for Disbursement';
            insert bau1;
            Business_Account_Utilization__c bau2 = new Business_Account_Utilization__c();
            bau2.Application__c = app.id;
            bau2.Disbursement_Status__c ='Disbursed';
            insert bau2;
            bau1.Disbursement_Status__c ='Disbursed';
            update bau1;
            
            SchedulableContext SC;
            EmailAndSMSToStdAndFacAfterDisbursment disbrsemail = new EmailAndSMSToStdAndFacAfterDisbursment();
            disbrsemail.execute(SC);
            
        }
        test.stopTest();
    }
}