@isTest
private class DocumentUploadCLsTest {

	private static testMethod void test() {
	    
	    User testUser = Utility_Test.createUser('donorprofile@testuser.com');
        System.runAs(testUser){
            
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor; 
            
            donor.Receipts_for_Actual_Expenses__c = True;
            donor.Applicant_s_Pledge_of_Future_Support__c = True;
            donor.Marks_Sheet_for_10th_Standard__c = True;
            donor.Income_Salary_Certificate__c = True;
            donor.Admission_or_Seat_Allotment_Letter__c = True;
            donor.Bonafide_Student_Certificate__c = True;
            donor.PUC_12th_Marks_Sheet__c = True;
            donor.Parents_or_Guardians_Declaration__c = True;
            
            donor.Even_Semester_Mark_Sheet_of_the_previous__c = True;
            donor.Odd_Semester_Mark_Sheet_of_the_previous__c = True;
            donor.Oath_Pledge_and_Declaration_Form_signed__c = True;
            
            update donor;
            
            
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
        	
        	Attachment attachment9 = new Attachment();
        	attachment9.ParentId = newApp.id;
        	attachment9.Name = 'Bonafide_Student_Certificate__c';
        	attachment9.Description = 'Bonafide_Student_Certificate__c';
        	attachment9.Body = b;
        	
        	insert attachment9;
        	
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
        
        	
            Donor_Application_Mapping__c dap =  new Donor_Application_Mapping__c();
            dap.Student__c = donor.id;
            dap.Donor__c = con.id;
            dap.Application__c = newApp.id;
            
            insert dap;
        	
        	
        	
        	apexpages.currentpage().getparameters().put('id' , donor.Id);
        	
            DocumentUploadCLs docupcls =  new DocumentUploadCLs();
            
            docupcls.Submit();
        }
	}

}