/*
* Purpose: Test class for ApplicationStudentInfoController Class
*/
@isTest
public class ApplicationStudentInfoController_Test {
    
    public static testmethod void getPDF(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact con = Utility_Test.insertNewStudentRec('ABC','XYZ',null,null,null,null,null,300,400,'Karnataka Common Entrance Test (CET)','2016');
            insert con;
            
            Application__c ap = Utility_Test.insertNewApplication('Selected', 'Submitted');
            ap.Student__c = con.id;
            insert ap;
            
            PageReference pageRef = Page.scholar_profile;
            Test.setCurrentPage(pageRef);
            //ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(con);
            ApexPages.currentPage().getParameters().put('ScholarId',con.id);
            
            ApplicationStudentInfoController apclass = new ApplicationStudentInfoController();
        }
        test.stopTest();
    }
}