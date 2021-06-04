@isTest
public class NotifyStudentOnFacilitatorMatched_Test {
    
    @isTest
    public static void testMethod1() {
        Contact con = new Contact();
        con.FirstName = 'jayanth';
        con.LastName = 'test';
        con.Email='jayanth@testinvalid.com';
        con.Internal_Status__c = 'Selected';
        con.Active_Application_ID__c='Test';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        insert con;
        Set<Id> conIdSet=new Set<Id> ();
        conIdSet.add(con.id);
         List<ContactHistory> conHistoryList=new List<ContactHistory>();
         ContactHistory history = new ContactHistory();
          history.ContactId = con.id;
          history.Field = 'Internal_Status__c';
          //history.OldValue='Selected';
          //History.NewValue='Facilitator Matched';
          conHistoryList.add(history);
          //insert history;
       
         
        Test.startTest();
        NotifyStudentOnFacilitatorMatched_Batch  obj1 = new NotifyStudentOnFacilitatorMatched_Batch();
        obj1.contactIdSet=conIdSet;
        obj1.execute(null);
        
        Test.stopTest();
        
        
        
    }
    
    @isTest
    public static void testMethod2() {
        Contact con = new Contact();
        con.FirstName = 'jayanth';
        con.LastName = 'test';
        con.Email='jayanth@testinvalid.com';
        con.Internal_Status__c = 'Selected';
        con.Active_Application_ID__c='Test';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        insert con;
        Set<Id> conIdSet=new Set<Id> ();
        conIdSet.add(con.id);
         List<ContactHistory> conHistoryList=new List<ContactHistory>();
         ContactHistory history = new ContactHistory();
          history.ContactId = con.id;
          history.Field = 'Internal_Status__c';
          //history.OldValue='Selected';
          //History.NewValue='Facilitator Matched';
          conHistoryList.add(history);
          //insert history;
       
         
        Test.startTest();
        NotifyStudentOnFacilitatorMatched_Batch  obj = new NotifyStudentOnFacilitatorMatched_Batch();
        Database.executeBatch(obj);
        NotifyStudentOnFacilitatorMatched_Batch  obj1 = new NotifyStudentOnFacilitatorMatched_Batch();
        obj1.contactIdSet=conIdSet;
        obj1.execute(null,conHistoryList);
        
        Test.stopTest();
        
        
        
    }
}