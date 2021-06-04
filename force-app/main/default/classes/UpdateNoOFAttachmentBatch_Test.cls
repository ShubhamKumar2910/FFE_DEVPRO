@isTest
public class UpdateNoOFAttachmentBatch_Test {
    
    @testSetup
    static void setup() {
        Contact facilitator =  Utility_Test.insertFacilitator('facilitator','one');
        insert facilitator;
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.Facilitator_Name__c = facilitator.id;
        insert student;
        
        Application__c app = new Application__c();
        app.Internal_Status__c     = 'Selected';
        app.External_Status__c     = 'Submitted';
        app.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        app.Application_Stage__c   = Constants.APP_STAGE_CLOSED;   
        app.RecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
        app.Student__c = student.id;
        insert app;   
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = app.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        insert(attachment);        // insert 10 accounts
        
        Application__c appUpdate = [select name,id,Number_of_Attachments__c from Application__c where id =:app.Id];
        appUpdate.Number_of_Attachments__c = null;
        update appUpdate;
        
        
         Application__c app1 = new Application__c();
        app1.Internal_Status__c     = 'Selected';
        app1.External_Status__c     = 'Submitted';
        app1.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        app1.Application_Stage__c   = Constants.APP_STAGE_CLOSED;   
        app1.RecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
        app1.Student__c = student.id;
        insert app1;   
        
    }
    @isTest static void test() {
        Test.startTest();
        UpdateNoOFAttachmentBatch myBatchObject = new UpdateNoOFAttachmentBatch();
        Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
        
    }
    
}