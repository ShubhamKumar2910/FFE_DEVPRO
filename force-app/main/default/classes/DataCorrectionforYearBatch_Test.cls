@isTest
public class DataCorrectionforYearBatch_Test {
    
    @isTest
    public static void testMethod1() {
        
        Contact student = Utility_Test.insertSingleStudent('jayanth','b');  
        student.Financial_year__c = '2014-15';
        student.Course__c = 'BE/B.Tech';
        student.Current_year__c = '1st Year';
        insert student;
        Test.startTest();
         Database.executeBatch(new DataCorrectionforYear_Batch(),100);
        Test.stopTest();
    }

}