@isTest
public class ApplicationTriggerHelper_Test {
    
    public static testmethod void applicationTriggerTest(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            Contact facilitator =  Utility_Test.insertFacilitator('facilitator','one');
            insert facilitator;
            
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
            student.Facilitator_Name__c = facilitator.id;
            insert student;
            
            Application__c app = new Application__c();
            app.Internal_Status__c     = 'Selected';
            app.External_Status__c     = 'Submitted';
            app.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
            app.Application_Stage__c   = Constants.APP_STAGE_CLOSED;   
            app.RecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
            app.Student__c = student.id;
            insert app;
            
            List<Application__c> appList = new List<Application__c>();
            appList.add(app);
            
            ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
            appTrgHelp.applicationStageClosed(appList);
            
            
            Map<id,Application__c> oldAppMap = new Map<id,Application__c>();
            oldAppMap.put(app.id, app);
            app.College_Name__c = 'CBIT';
            app.Internal_Status__c = 'Eligible';
            update app;
            Map<id,Application__c> newAppMap = new Map<id,Application__c>();
            newAppMap.put(app.id, app);
            
            appTrgHelp.onBeforeUpdate(oldAppMap,newAppMap);
            
        }
        test.stopTest();
    }
    
    public static testmethod void onAfterApplicationCloseTest1(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '1st Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '2nd Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    public static testmethod void onAfterApplicationCloseTest2(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '2nd Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '3rd Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    
    public static testmethod void onAfterApplicationCloseTest3(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '3rd Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '4th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    
    public static testmethod void onAfterApplicationCloseTest4(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '4th Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '5th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    public static testmethod void onAfterApplicationCloseTest5(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '5th Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '6th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    public static testmethod void onAfterApplicationCloseTest6(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '6th Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '7th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    public static testmethod void onAfterApplicationCloseTest7(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '7th Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '8th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    public static testmethod void onAfterApplicationCloseTest8(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '8th Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '9th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
    
    public static testmethod void onAfterApplicationCloseTest9(){
        List<contact> conList = new List<Contact>();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX',null,'test@gmail.com',null,null,null,70,90,'cet','2016');
        student.From_IITBAA__c = true;
        insert student;
        ApplicationTriggerHelper appTrgHelp = new ApplicationTriggerHelper();
        List<Application__c> appList = new List<Application__c>();
        appList.add(new Application__c(Semester__c = '9th Semester',Application_Stage__c= 'Closed',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        appList.add(new Application__c(Semester__c = '10th Semester',Application_Stage__c= 'Open',Student__c = student.id,External_Status__c= 'Submitted',Internal_Status__c= 'Selected'));
        insert appList;
        appTrgHelp.onAfterApplicationClose(appList);   
    }
   
}