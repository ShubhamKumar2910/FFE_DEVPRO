@isTest
public class StudentTrainingCreation_Test {
    
    public static testmethod void executeTest(){
        
        test.startTest();
        User testUser = Utility_Test.createUser('StudentTrainingCreation_Test@gmail.com');
        system.runAs(testUser){
        npsp__Trigger_Handler__c handlerObj = new npsp__Trigger_Handler__c(npsp__Active__c = true, npsp__Asynchronous__c = false, 
                                                                               npsp__Class__c = 'TDTM_Handler', npsp__Load_Order__c = 1, 
                                                                               npsp__Object__c = 'Contact', npsp__Trigger_Action__c= 'BeforeInsert; BeforeUpdate; BeforeDelete; AfterInsert; AfterUpdate; AfterDelete; AfterUndelete',
                                                                               npsp__User_Managed__c = true);
            insert handlerObj;
            
            Contact con = Utility_Test.insertNewStudentRec('ABC','XYZ',null,'abc@gmail.com',null,null,null,null,null,null,null);
            con.Aptitude_Analytical_Score__c = 4;
            con.English_Spoken_Score__c = 12;
            con.Aptitude_Logical_Score__c = 4;
            con.English_Written_Score__c = 12;
            con.Course__c = 'BE/B.Tech';
            con.Internal_Status__c = 'Selected';
            con.Current_year__c = '1st Year';
            insert con;
            
            Application__c App  = Utility_Test.insertNewApplication(constants.FUNDED,'Inprogress');
            app.Year__c = '1st Year';
            app.Student__c = con.id;
            insert app;
                     
            Training_Master__c trainingMaster = new Training_Master__c();
            trainingMaster.Points__c = 100;
            trainingMaster.Student_Years__c = '1st Year';
            insert trainingMaster;
            
            System_Details__c sysm  = Utility_Test.dummyCustomSetting(system.today(), system.today()+1);
            insert sysm;
            
            con.Aptitude_Analytical_Score__c = 1;
            con.English_Spoken_Score__c = 122;
            con.Aptitude_Logical_Score__c = 2;
            con.English_Written_Score__c = 2222;
            update con;
            StudentTrainingCreation.onAfterUpdate(null,null);
        }
        test.stopTest();
    }
}