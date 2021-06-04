/* Description :Validating Student Info and inserting new student              
*  purpose     :Test class for StudentProfile
*/


@isTest
private class AP_Student_Application_Test{
    
    
    static testmethod void validateAndInsertNewStudent_1(){
        
        User testUser = Utility_Test.createUser('applicatestest@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            
            AP_Student_Application_CTRL appCTRL = new AP_Student_Application_CTRL();
            AP_Student_Application_CTRL.prelimWrapper pWrp = new AP_Student_Application_CTRL.prelimWrapper();
            pWrp.scholar = Utility_Test.insertNewStudentRec('sample','sample1','1234567897','sample@gmail.com','3456789321','','sample1@gmail.com',80,100,'Karnataka Common Entrance Test (CET)','2016');
            pWrp.ScholarAppln = Utility_Test.insertNewApplication('Selected','Submitted');
            AP_CheckScholarRankCriteria criteria = new AP_CheckScholarRankCriteria();
            
            AP_Student_Application_CTRL.validateStudentInfo(Utility_Test.insertNewContact('sample','sample1','1234567897','sample@gmail.com','3456789321','','sample1@gmail.com'));
            AP_Student_Application_CTRL.createStudentInSFDC(pWrp);
            AP_Student_Application_CTRL.searchCollege('amc','MBBS');
            AP_Student_Application_CTRL.getCities('dummyState');
            
            
            Test.stopTest();
        }
        
    }
    
    static testmethod void testCreateStudentInSFDC(){
        User testUser = Utility_Test.createUser('applicatestest@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            
            insert new Scholarship_Criteria__c(HS_Year_of_Passing_Less_than__c = 1, Max_Annual_Family_Income__c = 180000, Min_12th_Percentage__c = 70);
            
            List<College_Master__c> collegList	= new List<College_Master__c>();
            collegList.add(Utility_Test.createCollegeMaster('Other','Other','Other','Other'));
            collegList.add(Utility_Test.createCollegeMaster('CBIT','Bangalore','A','Karnataka'));
            insert collegList;
            
            AP_Student_Application_CTRL appCTRL = new AP_Student_Application_CTRL();
            AP_Student_Application_CTRL.prelimWrapper pWrp = new AP_Student_Application_CTRL.prelimWrapper();
            pWrp.scholar = Utility_Test.insertNewStudentRec('dummy','Student','121321312','test@test.com','323233232',null,null,300,400,'Karnataka Common Entrance Test (CET)','2016');
            pWrp.scholar.Annual_Family_Income__c 	= 160000;
            pWrp.scholar.Entrance_Test_Rank__c 	= 200;
            pWrp.scholar.Course__c 				= 'BE/B.Tech';
            pWrp.scholar.College_Name__c			= collegList[0].Id;
            pWrp.scholar.Branch_Stream__c       	= 'Other';
            pWrp.ScholarAppln = Utility_Test.insertNewApplication('Selected','Submitted');
            AP_Student_Application_CTRL.createStudentInSFDC(pWrp);
            
            // System.assertEquals(1, [Select count() from Contact where email='test@test.com'], 'Total student count');
            // System.assertEquals(System.Label.ScholarshipInternalStatusEligible, [Select Internal_Status__c from Application__c where Student__r.Email='test@test.com'].Internal_Status__c, 'Eligible Application');
            
            Test.stopTest();
        }
    }
    
    static testmethod void testCreateStudentInSFDC2(){
        User testUser = Utility_Test.createUser('applicatestest@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            
            insert new Scholarship_Criteria__c(HS_Year_of_Passing_Less_than__c = 1, Max_Annual_Family_Income__c = 180000, Min_12th_Percentage__c = 70);
            
            List<College_Master__c> collegList	= new List<College_Master__c>();
            collegList.add(Utility_Test.createCollegeMaster('Other','Other','Other','Other'));
            collegList.add(Utility_Test.createCollegeMaster('CBIT','Bangalore','A','Karnataka'));
            insert collegList;
            
            AP_Student_Application_CTRL appCTRL = new AP_Student_Application_CTRL();
            AP_Student_Application_CTRL.prelimWrapper pWrp = new AP_Student_Application_CTRL.prelimWrapper();
            pWrp.scholar = Utility_Test.insertNewStudentRec('dummy','Student','121321312','test@test.com','323233232',null,null,300,400,'Karnataka Common Entrance Test (CET)','2016');
            pWrp.scholar.Annual_Family_Income__c = 160000;
            pWrp.scholar.Entrance_Test_Rank__c   = 200000;
            pWrp.scholar.Course__c 			= 'BE/B.Tech';
            pWrp.scholar.College_Name__c		= collegList[1].Id;
            pWrp.scholar.Branch_Stream__c       = 'Computer Science';
            pWrp.ScholarAppln = Utility_Test.insertNewApplication('Selected','Submitted');
            AP_Student_Application_CTRL.createStudentInSFDC(pWrp);
            
            //  System.assertEquals(1, [Select count() from Contact where email='test@test.com'], 'Total student count');
            //  System.assertEquals(System.Label.ScholarshipInternalStatusIneligible, [Select Internal_Status__c from Application__c where Student__r.Email='test@test.com'].Internal_Status__c, 'Eligible Application');
            
            
            Test.stopTest();
        }
    }
    
    static testmethod void testDuplicateScrenario(){
        User testUser = Utility_Test.createUser('applicatestest@testuser.com');
        System.runAs(testUser){
            
            Contact dummyStudent = Utility_Test.insertNewStudentRec('sample','sample1','1234567897','sample@gmail.com','3456789321','sample@gmail.com','sample@fb.com',80,100,'Karnataka Common Entrance Test (CET)','2016');
            insert dummyStudent;        
            
            Test.startTest();
            
            AP_Student_Application_helper.validateStudent(new Contact(Email='sample@gmail.com'));
            AP_Student_Application_helper.validateStudent(new Contact(Phone='1234567897'));
            AP_Student_Application_helper.validateStudent(new Contact(MobilePhone='3456789321'));
            AP_Student_Application_helper.validateStudent(new Contact(Google_login_ID__c='sample@gmail.com'));
            AP_Student_Application_helper.validateStudent(new Contact(Facebook_login_ID__c='sample@fb.com'));
            
            ///  System.assertEquals(1, [Select count() from Contact where email='sample@gmail.com'], 'Total student count');
            //   System.assertEquals('sample@gmail.com', [Select Email from Contact where Id=:dummyStudent.Id].Email, 'Student Email Id matching');
            
            List<College_Master__c> collegList	= new List<College_Master__c>();
            collegList.add(Utility_Test.createCollegeMaster('Other','Other','Other','Other'));
            collegList.add(Utility_Test.createCollegeMaster('CBIT','Bangalore','A','Karnataka'));
            insert collegList;
            contact fac = Utility_test.insertFacilitator('jay','b');
            insert fac;
            AP_Student_Application_CTRL appCTRL = new AP_Student_Application_CTRL();
            AP_Student_Application_CTRL.prelimWrapper pWrp = new AP_Student_Application_CTRL.prelimWrapper();
            pWrp.scholar =   Utility_Test.insertNewStudentRec('sample','sample1','1234567897','sample@gmail.com','3456789321','sample@gmail.com','sample@fb.com',80,100,'Karnataka Common Entrance Test (CET)','2016');
            pWrp.scholar.Annual_Family_Income__c = 160000;
            pWrp.scholar.Entrance_Test_Rank__c   = 200000;
            pWrp.scholar.Course__c 			= 'BE/B.Tech';
            pWrp.scholar.College_Name__c		= collegList[1].Id;
            pWrp.scholar.Branch_Stream__c       = 'Computer Science';
            pWrp.scholar.Refered_by_Facilitator_Id__c=fac.FFE_ID__c;
            pWrp.scholar.Refered_by_Facilitator_Name__c=fac.Name;  
            pWrp.scholar.Facilitator_Name__c = fac.id;
            pWrp.ScholarAppln = Utility_Test.insertNewApplication('Selected','Submitted');
            AP_Student_Application_CTRL.createStudentInSFDC(pWrp);
            AP_Student_Application_helper.validateFacilitator(dummyStudent);
            Utility.generateRandomString();
            Utility.temporaryDonorLoginURL(dummyStudent.FFE_ID__c,dummyStudent.Email,'Student');
            Utility.returnNextCurrentYear('1st Year','BE/B.Tech');
            Utility.returnNextCurrentYear('Year I, Sem 1','MBBS');
            Utility.returnNextCurrentYear('1st Year','Integrated MTech');
            Utility.getCorrectData('BE/B.Tech','1st Year','2014-15',2019);
            Utility.sessionEndYear('2019-20');
            Utility.getAttachment('abc');
            Utility.uploadAttachment('abc','abc',dummyStudent.id,'');
            Utility.checkIsOne(1);
            Utility.getSystemDetails();
            Utility.getTrainingDetails();
            Utility.getSmsDetails();
            Utility.getUSDtoINRConvertedAmt(100);
            Utility.PastTenFinancialYear();
            Utility.financialYear();
            Utility.getPrevFinancialYear();
            Utility.getCountryList();
            Utility.InsertSMSStatus('abc','abc','abc','abc','abc',1234567,'abc');
            Utility.sendEmailWithTemplateThroughCustomButton('abc','abc','abc');
            Utility.sendEmailWithTemplateBulk('abc','abc');
            Utility.testCoverage();
            
            Test.stopTest();             
        }
    } 
}