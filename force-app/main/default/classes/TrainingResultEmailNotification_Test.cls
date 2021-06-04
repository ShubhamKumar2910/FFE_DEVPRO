@isTest
public class TrainingResultEmailNotification_Test {
    
    public static testmethod void executeTest(){
        
        test.startTest();
        User testUser = Utility_Test.createUser('TrainingResultEmailNotification_Test@gmail.com');
        system.runAs(testUser){
            
            Contact con = Utility_Test.insertNewStudentRec('ABC','XYZ',null,'abc@gmail.com',null,null,null,null,null,null,null);
            
            insert con;   

            Training_Master__c trainingMaster = new Training_Master__c();
            String previousMonth= datetime.now().addMonths(-1).format('MMMMM');
            trainingMaster.Milestone_2__c = previousMonth;
            trainingMaster.Min_Time_on_App_30__c = 30;
            trainingMaster.Student_Years__c = '1st year';
            trainingMaster.Points__c = 100;
            trainingMaster.Start_Month__c = 'March';
            trainingMaster.End_Month__c = 'April';
            insert trainingMaster;
            
            Student_Training__c studentTraining = new Student_Training__c();
            studentTraining.Student_ID__c = con.id;
            studentTraining.Training_Code__c = trainingMaster.id;
            studentTraining.External_ID__c = 'FFEUID200157-English App';
            //studentTraining.Points_Earned__c = trainingMaster.Points__c;
            studentTraining.Specialization_Name__c = 'Python for Everybody';
            studentTraining.Courses__c = 'Test1,Test2,Test3';
            insert studentTraining;
            
            //to cover if part to send email notification
            Training_Result__c trainingResult = new Training_Result__c();
           // trainingResult.Milestone__c = 2;
           // trainingResult.Completion_Flag__c = 'No';
            trainingResult.Student_Training_Mapping__c = studentTraining.id;
            trainingResult.FFE_ID__c = 'FFEUID200157';
            trainingResult.STU_ID__c = 'English App';
            trainingResult.Marks_Obtained__c = 100;
            trainingResult.Status__c = 'Not Processed';
            trainingResult.Vendor_Code__c = 'VNTR123';
            trainingResult.Time_on_App__c = 30;
            trainingResult.Specialization_Name__c = 'Python for Everybody';
            insert trainingResult;
            
            //update is done to update date for yesterday
            trainingResult.Record_Inserted_Date__c = date.today();
            update trainingResult;
            
            //to cover else part while sending email
            Training_Result__c trainingResultElsePart = new Training_Result__c();
            trainingResultElsePart.Milestone__c = 2;
            trainingResultElsePart.Completion_Flag__c = 'No';
            trainingResultElsePart.Student_Training_Mapping__c = studentTraining.id;
            trainingResultElsePart.FFE_ID__c = 'FFEUID20015';
            trainingResultElsePart.STU_ID__c = 'English App';
            trainingResultElsePart.Marks_Obtained__c = 100;
            trainingResultElsePart.Status__c = 'Not Processed';
            trainingResultElsePart.Vendor_Code__c = 'VNTR123';
            trainingResultElsePart.Time_on_App__c = 30;
			trainingResultElsePart.Specialization_Name__c = 'Python for Everybody';
            insert trainingResultElsePart;
			trainingResultElsePart.Specialization_Name__c = 'CAD and Digital Manufacturing';
			update trainingResultElsePart;
            
          
            test.StopTest();

        }
    }
}