@isTest
public class ApplicationAutomation_Test {
    
    @isTest static void myTest() {
        list<contact> conList = new List<contact>();
        contact student1 = Utility_Test.insertSingleStudent('Kishan','Panchal');
		contact student2 = Utility_Test.insertSingleStudent('Kishan','Panchal');
		conList.add(student1);
        conList.add(student2);
		insert conList;
        
        list<Application__c> appList = new List<Application__c>();
        Application__c newApplication1 = Utility_Test.insertNewApplication('Facilitator Matched','Submitted');
        newApplication1.Student__c = student1.Id;
         
        Application__c newApplication2 = Utility_Test.insertNewApplication('Selected','Submitted');
        newApplication2.Student__c = student2.Id;
        appList.add(newApplication1);
        appList.add(newApplication2);
        insert appList;
        
        list<string> appIdList = new list<string>();
        appIdList.add(newApplication1.Id);
        appIdList.add(newApplication2.Id);
        system.debug('appIdList====>'+appIdList);
        
        
      /*  contact con = [select name,id from contact where recordType.Name = 'student' limit 1];
 Application__c newApp     =  new Application__c();
        newApp.Internal_Status__c     = 'Disbursed';
        newApp.External_Status__c     = 'Submitted';
        newApp.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        newApp.Application_Stage__c   = Constants.APP_STAGE_OPEN;
		newApp.student__c =  con.id;
insert newApp;
           Application__c app = [select name,id,Student__c,Internal_Status__c   from Application__c limit 1];
        system.debug('app==>'+app);
        app.Internal_Status__c = 'Disbursed';
        update app;
        
        Application__c additionalExpenseApplication = new Application__c ();
         additionalExpenseApplication.Internal_Status__c     = 'Selected';
        additionalExpenseApplication.External_Status__c     = 'Submitted';
        additionalExpenseApplication.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        additionalExpenseApplication.Application_Stage__c   = Constants.APP_STAGE_OPEN;
        additionalExpenseApplication.Parent_Application__c = app.Id;
		additionalExpenseApplication.Student__c = newApp.Student__c;
        insert additionalExpenseApplication;   */
        
        
        contact con = Utility_Test.insertSingleStudent('Aditya','Kamat');
        insert con;
        Application__c newApp     =  new Application__c();
        newApp.Internal_Status__c     = 'Disbursed';
        newApp.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        newApp.Application_Stage__c   = Constants.APP_STAGE_OPEN;
		newApp.student__c =  con.id;
		insert newApp;
        
        Application__c additionalExpenseApplication = new Application__c ();
        additionalExpenseApplication.Internal_Status__c     = 'Selected';
        additionalExpenseApplication.External_Status__c     = 'Submitted';
        additionalExpenseApplication.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        additionalExpenseApplication.Application_Stage__c   = Constants.APP_STAGE_OPEN;
        additionalExpenseApplication.Parent_Application__c = newApp.Id;
		additionalExpenseApplication.Student__c = newApp.Student__c;
        insert additionalExpenseApplication;
            
            
         list<Application__c> applicationList = [SELECT Id,student__c,Has_student_provided_Justification__c,Have_you_met_the_student_s_parent_s__c,Have_you_visited_the_student_s_house__c,
                                                Student_truly_deserves_a_scholarship__c,Internal_Status__c,FacilitatorInputDone__c,Document_Verification_and_Attestation__c FROM Application__c where Internal_Status__c = 'Facilitator Matched' AND Id IN : appIdList];
        system.debug('applicationList======>'+applicationList);
        
        ApplicationAutomation.matchFacilitator(appIdList);
        ApplicationAutomation.facilitatorVerification(appIdList);   
        ApplicationAutomation.submitForApproval(appIdList);
        ApplicationAutomation.processAdditionalExpense(new List<Id> {additionalExpenseApplication.Id});
        ApplicationAutomation.getAppIdsFromCSV(1,10);
    }

}