@isTest
public class FFE_OpportunityTriggerHandler_Test
{
    static testmethod void test1()
    {
        List<Contact> conList = new  List<Contact>();
        Contact Con = new  Contact();
        Con.FirstName = 'Test';
        Con.LastName = 'Demo ' + '\n';
        Con.email = 'test@test.com';
        Con.X11_character_IFSC_Code_of_the_Branch__c = 'asdsaddsadasda';
        Con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        conList.add(con);
        Insert conList;
        System.assertNotEquals(conList[0].Id, null);

        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'test2';
        objOpp.npsp__Primary_Contact__c = con.Id;
        objOpp.StageName = 'Closed Won';
        objOpp.CloseDate = date.today();
        objOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
        Insert objOpp;
        System.assertNotEquals(objOpp.Id, null);

        Test.startTest();
        Opportunity objOpp1 = new Opportunity();
        objOpp1.Name = 'test1';
        objOpp1.StageName = 'Closed Won';
        objOpp1.CloseDate = date.today();
        objOpp1.npsp__Primary_Contact__c = con.Id;
        objOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
        Insert objOpp1;
        System.assertNotEquals(objOpp1.Id, null);
        Test.stopTest();
    }
}