@isTest
private class AP_Application_CTRL_Test {
     
    @TestSetup
    static void insertAPICustomSettings(){
        Google_API_Details__c googleApi	= new Google_API_Details__c(Application_Redirect_URL__c='www.test123.com',
                                                                   Auth_Endpoint_URL__c='www.test.com',Client_Id__c='gtest12345',
                                                                   Client_Secret__c='gSecret12345',Redirect_URI__c='www.test123.com',
                                                                   Endpoint_URL__c='www.123Test.com');
        insert googleApi;
        
        Facebook_API_Details__c fbApi	= new Facebook_API_Details__c(Application_Redirect_URL__c='www.test123.com',
                                                                   Auth_Endpoint_URL__c='www.test.com',App_Id__c='ftest12345',
                                                                   App_Secret__c='fSecret12345',Redirect_URL__c='www.test123.com',
                                                                   Endpoint_URL__c='www.123Test.com');
        insert fbApi;
    }
    
    //Cover Verification part of Student and details of facilitator and student
    static testmethod void remoteActionMethodCalls()
    {
        
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
            facilitator.Phone       				= '8894898899';
            facilitator.Email       				= 'facilitatortest@gmail.com';
            facilitator.MobilePhone 				= '8878898899';
            facilitator.Google_login_ID__c		    = 'facilitatortest@gmail.com';
            facilitator.Facebook_login_ID__c		= 'facilitatortestfb@gmail.com';
            insert facilitator;    
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            student.Facilitator_Name__c =  facilitator.id;   
            student.Login_hash_Code__c  = '65487237462';
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
            
            AP_Application_CTRL appCtrl = new AP_Application_CTRL();
            AP_Application_CTRL.RenewalWrapper rnwWrp = new AP_Application_CTRL.RenewalWrapper();
            rnwWrp.scholar = student;
            rnwWrp.ScholarAppln = app;
            
            AP_Application_CTRL.getStudentUserDetail(student.id);
            AP_Application_CTRL.updateStudentInSFDC(student);   
            AP_Application_CTRL.getFacilitatorUserDetail(facilitator.id);     
            AP_Application_CTRL.updateFacilitatorInSFDC(student); 
            AP_Application_CTRL.getFacilitatorStudents(facilitator.id); 
            AP_Application_CTRL.viewStudentProfile(student.id);
            AP_Application_CTRL.verifyStudent(app);
            AP_Application_CTRL.rejectStudent(app);
            AP_Application_CTRL.renewApplication(rnwWrp);
            AP_Application_CTRL.applicationExpenseUpdate(rnwWrp);
            AP_Application_CTRL.facilitatorInbutByStudent(app);
            AP_Application_CTRL.getAllTrainings('MBBS', '1st year',30,30,30,30,'FFEUID200153');
            appCtrl.logOutUser();
            test.stopTest();
            
        }
    }

    //Covers state and city
    static testmethod void StateAndCitySearch(){
        AP_Application_CTRL.getCities('Karnataka');
        AP_Application_CTRL.searchCollege('CBIT');
    }   
    
    //covers redirecting to profile page using google login or Facebook login
    static testmethod void redirectGoogleFacebookPage(){
        
        Contact facilitator = Utility_Test.insertFacilitator('facilitator1','test1');
        facilitator.Phone       				= '8894008899';
        facilitator.Email       				= 'facilitatortest@gmail.com';
        facilitator.MobilePhone 				= '8878892299';
        facilitator.Google_login_ID__c		    = 'facilitatortest@gmail.com';
        facilitator.Facebook_login_ID__c		= 'facilitatortestfb@gmail.com';
        insert facilitator;    
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
        student.Facilitator_Name__c =  facilitator.id;   
        student.Login_hash_Code__c  = '65487237462';
        insert student;
        AP_Application_CTRL appCtrl = new AP_Application_CTRL();
        PageReference pageRef = Page.redirectProfilePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('code',student.Google_login_ID__c);
        appCtrl.redirectProfilePage();
        
        ApexPages.currentPage().getParameters().put('code',student.Facebook_login_ID__c);
        appCtrl.redirectProfilePagefoFB();
        
        PageReference pg    = new PageReference('/');
        ApexPages.currentPage().getParameters().put('d',student.Login_Hash_Code__c);
        
        appCtrl.checkUserAuth();
        
    }
    
    //covers Attachments and Documents
    static testmethod void DocumentsAndAttachments(){
        
        Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
        facilitator.Phone       				= '8894898899';
        facilitator.Email       				= 'facilitatortest@gmail.com';
        facilitator.MobilePhone 				= '8878898899';
        facilitator.Google_login_ID__c		    = 'facilitatortest@gmail.com';
        facilitator.Facebook_login_ID__c		= 'facilitatortestfb@gmail.com';
        insert facilitator;    
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
        student.Facilitator_Name__c =  facilitator.id;   
        student.Login_hash_Code__c  = '65487237462';
        insert student;
        Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
        app.Student__c = student.id;
        insert app;
        
        // TO insert new Attachment
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=student.id;
        insert attach;
        
        AP_Application_CTRL appCtrl = new AP_Application_CTRL();
        
        AP_Application_CTRL.uploadProfilePic(String.valueOf(attach.body),attach.Name,attach.parentId,attach.id);
        AP_Application_CTRL.uploadDoc(String.valueOf(attach.body),attach.Name,attach.parentId,attach.id,'universal attachment to delete',attach.id);
        AP_Application_CTRL.getAllAttachments(attach.parentId,'student Document attached');
        AP_Application_CTRL.missingDocumentUplaoded(app.id);
        
    }
    
    static testmethod void testCookies(){
        
        contact con	=  new Contact (LastName='test');
        insert con;
        
        PageReference pageRef = Page.studentProfile;
        Test.setCurrentPage(pageRef);
        AP_Application_CTRL ap = new AP_Application_CTRL();
        Cookie cookiehashCode   = new Cookie('hashCodeLog', con.Id, null, 1800, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
        ap.checkUserAuth();
        
    }
    
     static testmethod void testGoogleMockAPICallForStudent(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','abcMockuser@gmail.com','7829488975','abcMockuser@gmail.com','abcMockuser@gmail.com',70,90,'cet','2016');
            insert student;
            
            Test.startTest();
                      
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie googleCodeCook   = new Cookie('googleCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{googleCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'googleLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            
            system.assertEquals('abcmockuser@gmail.com',[select Email from Contact where Id=:student.Id].Email,'Student email Id match');
            
            Test.stopTest(); 
        }        
    }
    
    static testmethod void testGoogleMockAPICallForFacilitator(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
            facilitator.Email       				= 'abcmockuser@gmail.com';
            facilitator.Google_login_ID__c		    = 'abcmockuser@gmail.com';
            insert facilitator;  
            
            Test.startTest();
                      
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie googleCodeCook   = new Cookie('googleCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{googleCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'googleLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            
            system.assertEquals('abcmockuser@gmail.com',[select Email from Contact where Id=:facilitator.Id].Email,'Facilitator email Id match');
            
            Test.stopTest(); 
        }        
    }
    
    static testmethod void testGoogleMockAPICallNoUser(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie googleCodeCook   = new Cookie('googleCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
        	ApexPages.currentPage().setCookies(new Cookie[]{googleCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'googleLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            Test.stopTest(); 
        }        
    }
    static testmethod void testGoogleMockAPICallException(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new httpCalloutMockImpExecption());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie googleCodeCook   = new Cookie('googleCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
        	ApexPages.currentPage().setCookies(new Cookie[]{googleCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'googleLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();           
            Test.stopTest(); 
        }        
    }
    
    static testmethod void testcheckGoogleAuthCookies(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){
            PageReference pageRef = Page.studentProfile;
            Test.setCurrentPage(pageRef);
            AP_Application_CTRL ap = new AP_Application_CTRL();
            Cookie cookiehashCode   = new Cookie('loginType', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            Cookie googleSessionId   = new Cookie('googleSessionId', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{googleSessionId});
            ap.checkGoogleAuth();
        }        
    }
    
    static testmethod void testFBMockAPICallForStudent(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','abcmockuser@fb.com','7829488975','abcmockuser@fb.com','abcmockuser@fb.com',70,90,'cet','2016');
            insert student;
            
            Test.startTest();
                      
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie fbCodeCook   = new Cookie('facebookCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{fbCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'fbLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            
            system.assertEquals('abcmockuser@fb.com',[select Email from Contact where Id=:student.Id].Email,'Student email Id match');
            
            Test.stopTest(); 
        }        
    }
    
    static testmethod void testFBMockAPICallForFacilitator(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
            facilitator.Email       				= 'abcmockuser@fb.com';
            facilitator.Facebook_login_ID__c		= 'abcmockuser@fb.com';
            insert facilitator;  
            
            Test.startTest();
                      
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie fbCodeCook   = new Cookie('facebookCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{fbCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'fbLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            
            system.assertEquals('abcmockuser@fb.com',[select Email from Contact where Id=:facilitator.Id].Email,'Facilitator email Id match');
            
            Test.stopTest(); 
        }        
    }
    
    static testmethod void testFBMockAPICallNoUser(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie fbCodeCook   = new Cookie('facebookCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
        	ApexPages.currentPage().setCookies(new Cookie[]{fbCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'fbLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            Test.stopTest(); 
        }        
    }
    static testmethod void testFBMockAPICallException(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new httpCalloutMockImpExecption());
            Test.setCurrentPageReference(new PageReference('Page.gauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            AP_Application_CTRL app = new AP_Application_CTRL();
            app.redirectProfilePage();            
            Cookie facebookCode   = new Cookie('facebookCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
        	ApexPages.currentPage().setCookies(new Cookie[]{facebookCode});
            Cookie cookiehashCode   = new Cookie('loginType', 'fbLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();           
            Test.stopTest(); 
        }        
    }
    
    static testmethod void testcheckFBAuthCookies(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            PageReference pageRef = Page.studentProfile;
            Test.setCurrentPage(pageRef);
            AP_Application_CTRL ap = new AP_Application_CTRL();
            Cookie cookiehashCode   = new Cookie('loginType', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            Cookie fbSessionId   = new Cookie('fbSessionId', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{fbSessionId});
            ap.checkFacebookAuth();
        }
    }
    @isTest static void registerMentorFromGoogleTest(){
        AP_Application_CTRL.registerMentorFromGoogle('Aakash', 'Jain', 'aakash2510Jain@gmail.com', 'aakash@123');
        AP_Application_CTRL.registerMentorFromFacebook('Aakash Jain','aakash2510jain@gmail.com','aakash@123');
        
    }
    @isTest static void updateStudentInSFDC_TYSTest(){
        Contact studentInfo = new Contact();
        studentInfo.FirstName = 'Aakash';
        studentInfo.LastName = 'Jain';
        insert studentInfo;
        AP_Application_CTRL.updateStudentInSFDC_TYS(studentInfo);
    }
    @isTest static void uploadDoc_newTest(){
        AP_Application_CTRL.uploadDoc_new('expenseDet', '0031e000003TF5c', 'certificateExpDate', 'attachmentBody', 'attachmentName', 'a0n1e000000Ly8Z', '00P1e000000zrfd', 'description', '00P1e000000zrQ9');
        AP_Application_CTRL.updateDocMissing('a0n1e000000Ly8Z', 'Migration Certificate');
    }
    @isTest static void ifscCodeResponseTest(){
        AP_Application_CTRL.checkIFSCCode('1232132121321', '0031e000003TF5c');
        AP_Application_CTRL.ifscCodeResponse('1232132121321', '0031e000003TF5c');
        AP_Application_CTRL appCtrl = new AP_Application_CTRL();
        appCtrl.alreadyRegistered();
    } 
    
}