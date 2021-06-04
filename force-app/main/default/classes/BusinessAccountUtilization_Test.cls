@IsTest
private class BusinessAccountUtilization_Test {
     
    private static testmethod void executeTest(){
        
        test.startTest();
        User testUser = Utility_Test.createUser('BusinessAccountUtilization_Test@gmail.com');
        system.runAs(testUser){
           Map<id,Business_Account_Utilization__c> oldMap = new Map<id,Business_Account_Utilization__c>();
             Map<id,Business_Account_Utilization__c> newMap = new Map<id,Business_Account_Utilization__c>();
            
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
            oldMap.put(bau1.id,bau1);
             bau1.Disbursement_Status__c ='Disbursed';
            update bau1;
             newMap.put(bau1.id,bau1);
            
            Business_Account_Utilization__c bau2 = new Business_Account_Utilization__c();
            bau2.Application__c = app.id;
            bau2.Disbursement_Status__c ='Disbursed';
            insert bau2;
            bau1.Disbursement_Status__c ='Disbursed';
            update bau1;
            BusinessAccountUtilizationTrigger_Helper.afterUpdate(newMap,oldMap);
            Utility.PastTenFinancialYear();
            Utility.financialYear();
            Utility.getPrevFinancialYear();
            Utility.getCountryList();
            
        }
        test.stopTest();
    }
}