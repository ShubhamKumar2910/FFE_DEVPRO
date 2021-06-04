@isTest
public class DN_DonorProfile_Test{

    static testmethod void testDonorProfile(){
        
        User testUser = Utility_Test.createUser('donorprofile@testuser.com');
        System.runAs(testUser){
            
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
           donor.Aadhar_number__c = 'abc123211133';
            insert donor;            
            
            Test.startTest();
            
            Contact con = [Select id,AccountId,FirstName,RecordTypeId,LastName,Email,Phone,MobilePhone,
                           Google_login_ID__c,Facebook_login_ID__c
                           from Contact where Id=:donor.ID];
            
            system.assertEquals('sample@donor.com', con.Email, 'Email Match');
            system.assertEquals(donor.Id, con.Id, 'Contact record Id');
            
                        
            List<Payment_Order__c> orders   = new List<Payment_Order__c>();
            for(Integer i=0;i<10;i++){
                orders.add(Utility_Test.createPaymentOrder(con.Id,'OrderNo'+i));
            }
            insert orders;
            
            List<Opportunity> donations = new List<Opportunity>();
            for(Integer i=0;i<10;i++){
                Opportunity op  = Utility_Test.createOpportunity('Donation'+i, null,orders[i].Id,'Pledged', 20000+i, String.valueOf(Date.today()));
                op.npsp__Primary_Contact__c = con.Id;
                op.AccountId                = con.AccountId;
                op.RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(DN_ServiceConstants.GENERAL_DONATION).getRecordTypeId(); 
                donations.add(op);
            }
            
            insert donations;
            
            //Application__c app = Utility_Test.insertNewApplication('Selected', 'Submitted');
            
            id applicationRecordType   = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 
            Application__c newApp =  new Application__c();
            newApp.Internal_Status__c = 'Selected';
            newApp.External_Status__c = 'Submitted';
            newApp.Application_Type__c = Constants.APPLICATIONTYPE_NEW;
            newApp.Application_Stage__c = Constants.APP_STAGE_OPEN;
            newApp.Student__c = con.id;
            
            insert newApp;
            
            Blob b = Blob.valueOf('Test Data');
    	
        	Attachment attachment1 = new Attachment();
        	attachment1.ParentId = newApp.id;
        	attachment1.Name = 'Actual Expenses incurred for current';
        	attachment1.Description = 'Actual Expenses incurred for current';
        	attachment1.Body = b;
        	
        	insert attachment1;
        	
        	Attachment attachment2 = new Attachment();
        	attachment2.ParentId = newApp.id;
        	attachment2.Name = 'Pledge of Future';
        	attachment2.Description = 'Pledge of Future';
        	attachment2.Body = b;
        	
        	insert attachment2;
                        
            Attachment attachment3 = new Attachment();
        	attachment3.ParentId = newApp.id;
        	attachment3.Name = 'Mark Sheet for Secondary School Certificate (10th) Board Examination.pdf';
        	attachment3.Description = 'Mark Sheet for Secondary School Certificate (10th) Board Examination.pdf';
        	attachment3.Body = b;
        	
        	insert attachment3;
                        
            Attachment attachment4 = new Attachment();
        	attachment4.ParentId = newApp.id;
        	attachment4.Name = 'Actual Expenses incurred for current';
        	attachment4.Description = 'Actual Expenses incurred for current';
        	attachment4.Body = b;
        	
        	insert attachment4;
        	
        	Attachment attachment5 = new Attachment();
        	attachment5.ParentId = newApp.id;
        	attachment5.Name = 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable.pdf';
        	attachment5.Description = 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable.pdf';
        	attachment5.Body = b;
        	
        	insert attachment5;
        	
        	Attachment attachment6 = new Attachment();
        	attachment6.ParentId = newApp.id;
        	attachment6.Name = 'Statement of Estimated Expenses';
        	attachment6.Description = 'Statement of Estimated Expenses';
        	attachment6.Body = b;
        	
        	insert attachment6;
        	
        	Attachment attachment7 = new Attachment();
        	attachment7.ParentId = newApp.id;
        	attachment7.Name = 'Copy of First Sheet';
        	attachment7.Description = 'Copy of First Sheet';
        	attachment7.Body = b;
        	
        	insert attachment7;
        	
        	
        	Attachment attachment8 = new Attachment();
        	attachment8.ParentId = newApp.id;
        	attachment8.Name = 'Counselling, Admission or Seat Allotment Letter.pdf';
        	attachment8.Description = 'Counselling, Admission or Seat Allotment Letter.pdf';
        	attachment8.Body = b;
        	
        	insert attachment8;
        	
        /*	Attachment attachment9 = new Attachment();
        	attachment9.ParentId = newApp.id;
        	attachment9.Name = 'Bonafide_Student_Certificate__c';
        	attachment9.Description = 'Bonafide_Student_Certificate__c';
        	attachment9.Body = b;
        	*/
        	
        	Attachment attachment10 = new Attachment();
        	attachment10.ParentId = newApp.id;
        	attachment10.Name = 'Bonafide Student Certificate';
        	attachment10.Description = 'Bonafide Student Certificate';
        	attachment10.Body = b;
        	
        	insert attachment10;
        	
        	
        	
        	Attachment attachment11 = new Attachment();
        	attachment11.ParentId = newApp.id;
        	attachment11.Name = 'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination.pdf';
        	attachment11.Description = 'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination.pdf';
        	attachment11.Body = b;
        	
        	insert attachment11;
        	
        	Attachment attachment12 = new Attachment();
        	attachment12.ParentId = newApp.id;
        	attachment12.Name = 'Parent\'s or Guardian\'s Declaration.pdf';
        	attachment12.Description = 'Parent\'s or Guardian\'s Declaration.pdf';
        	attachment12.Body = b;
        	
        	insert attachment12;
        	
        	Attachment attachment13 = new Attachment();
        	attachment13.ParentId = newApp.id;
        	attachment13.Name = 'Entrance Test Marks';
        	attachment13.Description = 'Entrance Test Marks';
        	attachment13.Body = b;
        	
        	insert attachment13;
        	
        	Attachment attachment14 = new Attachment();
        	attachment14.ParentId = newApp.id;
        	attachment14.Name = 'Even Semester Mark Sheet';
        	attachment14.Description = 'Even Semester Mark Sheet';
        	attachment14.Body = b;
        	
        	insert attachment14;
        	
        	Attachment attachment15 = new Attachment();
        	attachment15.ParentId = newApp.id;
        	attachment15.Name = 'Odd Semester Mark Sheet';
        	attachment15.Description = 'Odd Semester Mark Sheet';
        	attachment15.Body = b;
        	
        	insert attachment15;
                        
                        
            DN_DonorProfile_CTRL ctrl   = new DN_DonorProfile_CTRL();            
            DN_DonorProfile_CTRL.displayDonorDetails(donor.id); 
            
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Actual Expenses incurred for current');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Pledge of Future');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Copy of First Sheet');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Mark Sheet for Secondary School Certificate (10th) Board Examination.pdf');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable.pdf');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Copy of First Sheet');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Statement of Estimated Expenses');
            
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Counselling, Admission or Seat Allotment Letter.pdf');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Bonafide Student Certificate');
            
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination.pdf');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Parent\'s or Guardian\'s Declaration.pdf');
            
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Entrance Test Marks');
            DN_DonorProfile_CTRL.getAllAttachmentsForDonorView(newApp.id,donor.id,'Even Semester Mark Sheet');
            
            DN_DonorProfile_CTRL.updateDonorInSFDC(con);
            DN_DonorProfile_CTRL.updateDonorInSFDC(new Contact(LastName='DummyDonor2',Email='test@test.com',RecordTypeId=con.RecordTypeId));
            
            // Duplicate test
            DN_Donorprofile_Helper.updateDonorInSFDC(new Contact(Email='sample@donor.com'));
            DN_Donorprofile_Helper.updateDonorInSFDC(new Contact(Phone='12121212'));
            DN_Donorprofile_Helper.updateDonorInSFDC(new Contact(MobilePhone='12321232'));
            DN_Donorprofile_Helper.updateDonorInSFDC(new Contact(Google_login_ID__c='sample@donor.com'));
            DN_Donorprofile_Helper.updateDonorInSFDC(new Contact(Facebook_login_ID__c='sample@donor.com'));

            
            DN_DonorProfile_CTRL.displayDonorDonationDetails(con.Id);
            DN_DonorProfile_CTRL.getPledgedDonations(con.Id);
            DN_DonorProfile_CTRL.getDonorDonationProgramDetails('INR');
            DN_DonorProfile_CTRL.getDonorStudents(con.Id,String.valueOf(Utility.financialYear()));
            System.assertNotEquals(con.Id,null);
            //DN_DonorProfile_CTRL.viewStudentProfile(con.Id);
            DN_Donorprofile_Helper.viewStudentProfile1(con.Id);
            DN_Donorprofile_Helper.getDonorScholars1(con.id,'2019-20');
            DN_Donorprofile_Helper.getTrainingRecords(con.id,'2019-20');
            DN_Donorprofile_Helper.geMentoringDetails(con.id);
            DN_Donorprofile_Helper.toDisplayStudentTab(con.id,'2019-20');
            DN_Donorprofile_Helper.getDonationsPerProgram('INR');
            string attchmentID  = DN_DonorProfile_CTRL.uploadDoc('dummyDoc', 'dummyDoc', con.Id, null);
            DN_DonorProfile_CTRL.uploadDoc('dummyDoc', 'dummyDoc', con.Id, attchmentID);
            
            system.assertEquals(10, [Select count() from Opportunity where npsp__Primary_Contact__c =:con.Id],'Total Donation count for the donor');
            system.assertEquals(10, [Select count() from Payment_Order__c where Donor__c =:con.Id],'Total Payment Order count for the donor');
            
            Test.stopTest();
        }            
    }
    
    static testmethod void testingException(){
        User testUser = Utility_Test.createUser('donorprofile@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            DN_DonorProfile_CTRL.uploadDoc(null, 'dummyDoc', null, null);
            DN_DonorProfile_CTRL.uploadDoc('dummy', 'dummyDoc', 'dummyId', null);
            DN_DonorProfile_CTRL.makeDonation(new DN_PaymentWrapper());
            DN_DonorProfile_CTRL.cancelDonation('dummyId','Cancel');
            DN_DonorProfile_CTRL.cancelDonation('dummyId',DN_ServiceConstants.PAYMENT_CANCEL);
            DN_DonorProfile_CTRL.makePedingDonation(new DN_PaymentWrapper(), 'dummyId', 'dummyOrderId');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.checkUserAuth();
            Test.stopTest();
        }
    }
    
     static testmethod void testGoogleMockAPICallForDonor(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@gmail.com', '12321232', 'abcmockuser@gmail.com', 'abcmockuser@fb.com'); 
            insert donor; 
            
            Test.startTest();
                      
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.donorgauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.redirectDonorPage();            
            Cookie googleCodeCook   = new Cookie('googleCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{googleCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'googleLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            
            system.assertEquals('abcmockuser@gmail.com',[select Email from Contact where Id=:donor.Id].Email,'Donor email Id match');
            
            Test.stopTest(); 
        }        
    
  }
    
    static testmethod void testGoogleMockAPICallNoUser(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.donorgauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.redirectDonorPage();               
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
            PageReference pageRef = Page.donorProfile;
            Test.setCurrentPage(pageRef);
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            Cookie cookiehashCode   = new Cookie('loginType', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            Cookie googleSessionId   = new Cookie('googleSessionId', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{googleSessionId});
            app.checkGoogleAuth();
        }        
    }
    
    static testmethod void testFBMockAPICallForDonor(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
            insert donor;
            
            Test.startTest();
                      
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.donorfbauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.redirectDonorPagefoFB();            
            Cookie fbCodeCook   = new Cookie('facebookCode', 'wqeqyweiy1212uyuiyequwieyqwy', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{fbCodeCook});
            Cookie cookiehashCode   = new Cookie('loginType', 'fbLogin', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            app.checkUserAuth();
            
            system.assertEquals('abcmockuser@fb.com',[select Email from Contact where Id=:donor.Id].Email,'Donor email Id match');
            
            Test.stopTest(); 
        }        
    }
        
    static testmethod void testFBMockAPICallNoUser(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            Test.setCurrentPageReference(new PageReference('Page.donorfbauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.redirectDonorPagefoFB();             
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
            Test.setCurrentPageReference(new PageReference('Page.donorfbauth')); 
            System.currentPageReference().getParameters().put('code', 'wqeqyweiy1212uyuiyequwieyqwy');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.redirectDonorPagefoFB();            
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
            PageReference pageRef = Page.donorProfile;
            Test.setCurrentPage(pageRef);
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            Cookie cookiehashCode   = new Cookie('loginType', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            Cookie fbSessionId   = new Cookie('fbSessionId', '1', null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{fbSessionId});
            app.checkFacebookAuth();
        }
    }
    
    static testmethod void testEncDonorIdRedirectUserAuth(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
            insert donor;
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.donorProfile'));
            string encyId   = DN_CCAvenue_Service.encryptString(donor.Id,DN_ServiceConstants.DN_ORDER_KEY); 
            System.currentPageReference().getParameters().put('encDonorId', encyId);
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.checkUserAuth();
            Test.stopTest();
        }
    }
    
    static testmethod void testHasCodedRedirectUserAuth(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
            donor.Login_Hash_Code__c    = 'dummyHashCode';
            insert donor;
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.donorProfile'));
            System.currentPageReference().getParameters().put('d', 'dummyHashCode');
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.checkUserAuth();
            app.logOutUser();
            Test.stopTest();
        }
    }
    
     static testmethod void testDonorLogRedirectUserAuth(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
            insert donor;
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.donorProfile'));
            Cookie donorLog   = new Cookie('encDonorLog', donor.id, null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{donorLog});
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.checkUserAuth();
            app.logOutUser();
            Test.stopTest();
        }
    }
    static testmethod void testHashLogRedirectUserAuth(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
            insert donor;
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.donorProfile'));
            Cookie donorLog   = new Cookie('hashCodeLog', donor.id, null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{donorLog});
            DN_DonorProfile_CTRL app = new DN_DonorProfile_CTRL();
            app.checkUserAuth();
            app.logOutUser();
            Test.stopTest();
        }
    }
      static testmethod void testsampleData(){
           
          User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'abcmockuser@fb.com', '12321232', 'abcmockuser@fb.com', 'abcmockuser@fb.com'); 
       insert donor;
            Test.startTest();
            PageReference pageRef = Page.StudentDataInMSWord;
           
              //pageRef.getParameters().put('studFfeId',donor.id);
            Test.setCurrentPage(pageRef);
             System.currentPageReference().getParameters().put('sid',donor.id);
             System.currentPageReference().getParameters().put('donorId',donor.id);
          
            sampleData app = new sampleData();
            
        
            test.stopTest();
          
        } 
      }
}