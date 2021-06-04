@Istest
public class AluminiToDonorBatch_FFE_Test
{
  public static testmethod void execute()
  {
    Test.startTest();
    ID studentRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
    Contact student = Utility_Test.insertNewStudentRec('sample', 'sample1', '1234567897', 'Jayanth.b@etmarlabs.com', '3456789321', '', 'sample1@gmail.com', 80, 100, 'Karnataka Common Entrance Test (CET)', '2016');
    student.Active_Application_ID__c = '';
    student.RecordTypeId = studentRecordType;
    student.Is_Active_Alumni__c = false;
    student.Current_year__c = '4th Year';
    student.Course__c = 'BE/B.Tech';
    Insert student;
    SchedulableContext SC;
    AluminiToDonorBatch_FFE alumniBatch = new  AluminiToDonorBatch_FFE();
    alumniBatch.execute(SC);
    test.stopTest();
  }
}