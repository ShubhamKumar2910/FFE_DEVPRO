@isTest
public class TrainingResult_BatchTest {

    static testMethod void trainingBatch() {
        
        Training_Result__c tr = new Training_Result__c();
		tr.Completion_Flag__c = 'Yes';
		tr.Status__c = 'Not Processed';
		tr.Milestone__c = 3;
		insert tr;
		TrainingResult_Batch tb = new TrainingResult_Batch();
        database.executeBatch(tb);
		String sch = '0 0 23 * * ?';
        system.schedule('Test',sch, tb);
  
    }
	static testMethod void trainingBatch2() {
        
        Training_Result__c tr = new Training_Result__c();
		tr.Completion_Flag__c = 'No';
		tr.Status__c = 'Not Processed';
		tr.Milestone__c = 2;
		insert tr;
		TrainingResult_Batch tb = new TrainingResult_Batch();
        database.executeBatch(tb);
		String sch = '0 0 23 * * ?';
        system.schedule('Test',sch, tb);
    }			
}