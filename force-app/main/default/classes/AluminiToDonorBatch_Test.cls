@isTest
public class AluminiToDonorBatch_Test {
    @isTest
    public static void testMethod1() {
        Contact student = Utility_Test.insertSingleStudent('jayanth','b');  
        student.Financial_year__c = '2014-2015';
        student.Course__c = 'BE/B.Tech';
        student.Current_year__c = '4th Year';
        student.Internal_Status__c='Disbursed';
        insert student;
        
        Contact student1 = Utility_Test.insertSingleStudent('varun','m');  
        student1.Financial_year__c = '2019-20';
        student1.Course__c = 'BE/B.Tech';
        student1.Current_year__c = '1st Year';
        insert student1;
        
        
        test.startTest();
        Database.executeBatch(new AluminiToDonorBatch(),100);
        test.stopTest();
    }
    
    @isTest
    public static void  testMethod2() {
         Contact student = Utility_Test.insertSingleStudent('jayanth','b');  
        student.Financial_year__c = '2014-2015';
        student.Course__c = 'BE/B.Tech';
        student.Current_year__c = '4th Year';
       
        insert student;
       
       
        test.startTest();
        Database.executeBatch(new AluminiToDonorBatch(),100);
        test.stopTest();
        
    }
    
}