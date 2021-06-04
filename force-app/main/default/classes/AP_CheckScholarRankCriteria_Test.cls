/*
* Purpose: Test class for AP_CheckScholarRankCriteria Class
*/
@isTest
private class AP_CheckScholarRankCriteria_Test {
    
    public static void createStudent(String lastName,Decimal xIIth,Decimal maximumMarks,String entranceName,String x12th_Year_Passed,Decimal annualIncome,Integer rank,String course){

        Contact con = Utility_Test.insertNewStudentRec('ABC',lastName,null,null,null,null,null,xIIth,maximumMarks,entranceName,x12th_Year_Passed);
        con.Annual_Family_Income__c = annualIncome;
        con.Entrance_Test_Rank__c = rank;
        con.Course__c = course;
        con.Entrance_Exam_Taken_In_Year__c='2020';
        insert con;
        AP_CheckScholarRankCriteria.ValidationRankCriteria(con);
    }
    public static testmethod void studentCriteria(){
        
        
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            test.startTest();
            
            insert new Scholarship_Criteria__c(HS_Year_of_Passing_Less_than__c = 1, Max_Annual_Family_Income__c = 180000, Min_12th_Percentage__c = 70);
            createStudent('XYZ',300,400,'Karnataka Common Entrance Test (CET)','2020',160000,200,'BE/B.Tech');
            createStudent('XYZ',300,400,'Karnataka Common Entrance Test (CET)','2020',160000,1000,'M.Tech');
            createStudent('XYZ',300,400,'Karnataka Common Entrance Test (CET)','2020',160000,100,'MBBS');
            createStudent('YEZ',300,400,'Karnataka Common Entrance Test (CET)','2020',190000,100,'MBBS');
            createStudent('YTZ',300,400,'Karnataka Common Entrance Test (CET)','2013',190000,100,'MBBS');
            createStudent('TZ',300,600,'Karnataka Common Entrance Test (CET)','2020',160000,200,'BE/B.Tech');
            createStudent('TRZ',300,400,'Karnataka Common Entrance Test (CET)','2020',160000,200,'BE/B.Tech');        
            test.stopTest();
        }        
    }
    
    public static testmethod void studentCriteria2(){
        
        
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            test.startTest();
            
            insert new Scholarship_Criteria__c(HS_Year_of_Passing_Less_than__c = 1, Max_Annual_Family_Income__c = 180000, Min_12th_Percentage__c = 70);
            
            createStudent('TRZ',300,400,'Karnataka Common Entrance Test (CET)','2020',160000,200,System.Label.StudentCourseBPharm);
            createStudent('TRZ',300,400,'Karnataka Common Entrance Test (CET)','2020',160000,200,System.Label.StudentCourseBALLB);          
            test.stopTest();
        }        
    }
}