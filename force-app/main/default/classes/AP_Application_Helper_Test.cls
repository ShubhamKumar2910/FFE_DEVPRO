@istest
private class AP_Application_Helper_Test {
    
    public static testmethod void studentFacilitatorDetailsVerification()
    {
        
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
            facilitator.Phone                       = '8894898899';
            facilitator.Email                       = 'facilitatortest@gmail.com';
            facilitator.MobilePhone                 = '8878898899';
            facilitator.Google_login_ID__c          = 'facilitatortest@gmail.com';
            facilitator.Facebook_login_ID__c        = 'facilitatortestfb@gmail.com';
            facilitator.Internal_Status__c 			= 'ELIGIBLE';
            insert facilitator;    
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            student.Facilitator_Name__c =  facilitator.id;   
            insert student;
            Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
            app.Student__c = student.id;
            insert app;
            
             test.startTest();
            
            AP_Application_Helper.getScholarUserDetail(student.id);   
            AP_Application_Helper.updateStudentInSFDC(student); 
            AP_Application_Helper.getFacilitatorUserDetail(facilitator.Id);   
            AP_Application_Helper.updateFacilitatorInSFDC(facilitator);
            AP_Application_Helper.getStudentAllotedToFac(facilitator.Id);
            AP_Application_Helper.updateStudentInSFDC_TYS(student);
            AP_Application_Helper.submitFinalYearMarksDetails(student);
            AP_Application_Helper.letterOfThanksForDonor(student.id);
            AP_Application_Helper.viewStudentProfile(student.id);
            AP_Application_Helper.facilitatorInbutByStudent(app);
            AP_Application_Helper.verifyStudent(app);
            AP_Application_Helper.rejectStudent(app);
            AP_Application_CTRL.RenewalWrapper rnwWrp = new AP_Application_CTRL.RenewalWrapper();
            rnwWrp.scholar = student;
            rnwWrp.ScholarAppln = app;
            AP_Application_Helper.applicationExpenseUpdate(rnwWrp);
            AP_Application_Helper.applicationExpenseUpdate(null);
            AP_Application_Helper.renewApplication(rnwWrp);
            AP_Application_Helper.displayRenewalApp();
            
            AP_Application_Helper.getAllCities('Karnataka');
            AP_Application_Helper.getPrelimFiles(); 
            AP_Application_Helper.getRenewalFiles();
            
            AP_Application_Helper.updateStudentInSFDC(new Contact(Phone='8898898899')) ;
            AP_Application_Helper.updateStudentInSFDC(new Contact(Email='studenttest@gmail.com')) ;
            AP_Application_Helper.updateStudentInSFDC(new Contact(MobilePhone='7829488975')) ;
            AP_Application_Helper.updateStudentInSFDC(new Contact(Google_login_ID__c='studenttest@gmail.com')) ;
            AP_Application_Helper.updateStudentInSFDC(new Contact(Facebook_login_ID__c='studenttestfb@gmail.com')) ;
            AP_Application_Helper.savePlacementInfo(student.id,'Others');
         AP_Application_Helper.submitOtherInfo(student.id,'Others');
            AP_Application_Helper.getBoardMaxMarks('CBSE');
            AP_Application_Helper.getAcademicDetails();
            test.stopTest();
        }
        
    }
    
    
    public static testmethod void DocumentAndUploads()
    {     
        User auser = Utility_Test.createUser('ZXYSpoo099@test123.com');
        System.runAs(auser){
            Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
            facilitator.Phone                       = '8894898899';
            facilitator.Email                       = 'facilitatortest@gmail.com';
            facilitator.MobilePhone                 = '8878898899';
            facilitator.Google_login_ID__c          = 'facilitatortest@gmail.com';
            facilitator.Facebook_login_ID__c        = 'facilitatortestfb@fb.com';
            insert facilitator;    
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            student.Facilitator_Name__c =  facilitator.id;   
            insert student;
            Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
            app.Student__c = student.id;
            insert app;
            test.startTest();
            // TO insert new Attachment
            Attachment attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=student.id;
            insert attach; 
            AP_Application_Helper.uploadProfilePic(null,attach.Name,attach.parentId,null); 
            AP_Application_Helper.uploadProfilePic('universal document testing',attach.Name,attach.parentId,null);  
            AP_Application_Helper.uploadProfilePic('universal document testing',attach.Name,attach.parentId,attach.id); 
            AP_Application_Helper.getAttachment(String.valueOf(attach.id)); AP_Application_Helper.getAttachment(null); 
            AP_Application_Helper.uploadAttachment(null,attach.Name,attach.parentId,null,'student Document attached');   
            AP_Application_Helper.uploadAttachment('universal document testing',attach.Name,attach.parentId,null,'student Document attached');
            AP_Application_Helper.uploadAttachment('universal document testing',attach.Name,attach.parentId,attach.id,'student Document attached');
            AP_Application_Helper.getAllAttachments(attach.parentId,'student Document attached');
            AP_Application_Helper.documentUploaded(app.Id);  
            
            AP_Application_Helper.updateFacilitatorInSFDC(new Contact(Phone='8894898899')) ;
            AP_Application_Helper.updateFacilitatorInSFDC(new Contact(Email='facilitatortest@gmail.com')) ;
            AP_Application_Helper.updateFacilitatorInSFDC(new Contact(MobilePhone='8878898899')) ;
            AP_Application_Helper.updateFacilitatorInSFDC(new Contact(Google_login_ID__c='facilitatortest@gmail.com')) ;
            AP_Application_Helper.updateFacilitatorInSFDC(new Contact(Facebook_login_ID__c='facilitatortestfb@fb.com')) ;
            
            test.stopTest();
        }
        
        
    }
    public static testmethod void exceptionCover()
    {
        User auser = Utility_Test.createUser('ZXYSpoo099@test123.com');
        System.runAs(auser){
            //Exception calls
            AP_Application_Helper.updateStudentInSFDC(null);
            AP_Application_Helper.updateFacilitatorInSFDC(null);
            AP_Application_Helper.facilitatorInbutByStudent(null); 
            AP_Application_Helper.verifyStudent(null);
            AP_Application_Helper.rejectStudent(null);
            AP_Application_Helper.renewApplication(null);
            AP_Application_Helper.getAllAttachments('testingWithdummyParentId','dummyDescription');
            AP_Application_Helper.getAllCities('1');
            AP_Application_Helper.documentUploaded(null);            
            AP_Application_Helper.getPrelimFiles();
            AP_Application_Helper.getRenewalFiles();
            AP_Application_Helper.uploadAttachment('dummy', 'dummy', 'dummyId', 'dummyId', 'dummy');
        }
    }
    static testmethod void testSystemDetailCustomSetting(){
        User auser = Utility_Test.createUser('ZXYSpoo099@123test.com');
        System.runAs(auser){
            System_Details__c sysm	= Utility_Test.dummyCustomSetting(system.today(), system.today());
            insert sysm;
            AP_Application_Helper.displayRenewalApp();
            
            System_Details__c dummy	= new System_Details__c();
            AP_Application_Helper.displayRenewalApp();
        }
    }
    
    static testmethod void testRenewalAppln(){
        User auser = Utility_Test.createUser('ZXYSpoo099@123test.com');
        System.runAs(auser){
           test.startTest();
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            insert student;
            Application__c app 	= Utility_Test.insertNewApplication('Selected','Submitted');
            app.Year__c			= '1st Year';
            app.Student__c = student.id;
            AP_Application_CTRL.RenewalWrapper rnwWrp = new AP_Application_CTRL.RenewalWrapper();
            rnwWrp.scholar = student;
            rnwWrp.ScholarAppln = app;
            AP_Application_Helper.renewApplication(rnwWrp);
            // duplicate Application
            AP_Application_Helper.renewApplication(rnwWrp);
           test.stopTest();
        }
    }
    
    static testmethod void negativeTesting(){
        GoogleAuthorizationClass.generateAuthCode(null, null, null, null, null);
        FacebookAuthHandler.generateFBAuthCode(null, null, null, null, null);
    }
    
     static testmethod void testGooglePublisherDetailsException(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new httpCalloutMockImpExecption());
            GooglePublicDetailsClass.getPublicDetails('asasd', 'www.test.com');    
            Test.stopTest(); 
        }        
    }
}