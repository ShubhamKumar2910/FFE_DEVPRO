@isTest
public class contactNameFormatTest
{
    static testmethod void test1()
    {
        List<Contact> conList = new  List<Contact>();
        Contact Con = new  Contact();
        Con.FirstName = 'Test';
        Con.LastName = 'Demo ' + '\n';
        Con.email = 'test@test.com';
        Con.X11_character_IFSC_Code_of_the_Branch__c = 'asdsaddsadasda';
        conList.add(con);
        Test.startTest();
        Insert conList;
        System.assertNotEquals(conList[0].Id, null);
        contactNameFormat.NameFormat(conList);
        Test.stopTest();
    }
    static testmethod void test2()
    {
        Document document;
        document = new  Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'APPLICANTSTEST';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = [SELECT
            id
        FROM
            folder
        WHERE
            name = 'NPSP Documents'].id;
        Insert document; 
        System.assertNotEquals(document.Id, null);
        List<Contact> conList = new  List<Contact>();
        Contact Con = new  Contact();
        Con.FirstName = 'Test';
        Con.LastName = 'Demo';
        Con.email = 'test@test.com';
        Con.X11_character_IFSC_Code_of_the_Branch__c = 'asdsaddsadasda';
        conList.add(con);
        Insert conList;
        System.assertNotEquals(conList[0].Id, null);
        Test.startTest();
        FFE_ContactTriggerHandler.sendStudentApplicationAsAttachment(conList[0].Id, 'test', 'test', 'UAT12312TEST', 'test@test.com');
        Test.stopTest();
    }
}