@isTest(seeAllData=false)
public class DeclarationFormController_Test {
        public static testmethod void insertApplications(){
             account acc = new account();
            acc.name = 'test';
            acc.RecordTypeId = '0126F000000BXXIQA4';
            insert acc;
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
        student.AccountId = acc.Id;
            insert student;
		Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
        app.Student__c = student.id;
        insert app;
        Blob b = Blob.valueOf('Test Data');	
    	Attachment attachment = new Attachment();
    	attachment.ParentId = student.id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
    	            
    	insert(attachment);
         EmailTemplate templateId = [Select id from EmailTemplate limit 1];  
            test.startTest();
            //ApexPages.currentPage().getParameters().put('id', String.valueOf(app.Id));
			//DeclarationFormController  testAccPlan = new DeclarationFormController();
            
            pageReference pager = page.UploadDeclarationForm;
			Test.setCurrentPage(pager);
            apexPages.Currentpage().getParameters().put('id',app.id);


			//testAccPlan.cancel();
			//testAccPlan.add ();
            
            DeclarationFormController cont = new DeclarationFormController();
            DeclarationFormController.sendDeclarationEmail(student.id, app.id);
            DeclarationFormController.sendDeclarationEmail(student.id, acc.id);

           // DeclarationFormController.sendEmailWithTemplateThroughCustomButton(student.id,app.id);
            DeclarationFormController.doUploadAttachment(app.id, 'hello', 'leadesassignemtpdf.pdf',attachment.id);
            DeclarationFormController.doUploadAttachment(app.id, '', 'leadesassignemtpdf.pdf',null);
            DeclarationFormController.updateApplication(app.id);

            DeclarationFormController.sendEmail(student.id, templateId.Id, acc.id);
            DeclarationFormController.sendEmail(null, null, null);

            test.stopTest();
        }
    
}