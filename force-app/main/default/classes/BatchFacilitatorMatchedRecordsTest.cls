@isTest
public class BatchFacilitatorMatchedRecordsTest
{
    static testmethod void test7()
    {
	
	 Date d7 = Date.today() - 7;
	
	 Contact Studentrecord  = Utility_Test.insertSingleStudent('Test Student FN 7', 'Test Student LN 7'); 
	 Studentrecord.Facilitator_Assigned_Date__c = d7;
	 Studentrecord.Email = 'abc@gmail.com';
	 
	 insert Studentrecord;
	 
	 Test.startTest();
	 
	 String CRON_EXP = '0 0 0 15 3 ? *';
	 
	 String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ScheduleFacilitatorMatchedRecords7());
     CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
     //BatchScheduleFacilitatorMatchedRecords20 c = new BatchScheduleFacilitatorMatchedRecords20();
     //Database.executeBatch(c);
	 Test.stopTest();

        
    }
    
    static testmethod void test15()
    {
	
	 Date d15 = Date.today() - 15;
	
	 Contact Studentrecord  = Utility_Test.insertSingleStudent('Test Student FN 15', 'Test Student LN 15'); 
	 Studentrecord.Facilitator_Assigned_Date__c = d15;
	 Studentrecord.Email = 'abc@gmail.com';
	 
	 insert Studentrecord;
	 
	 Test.startTest();
	 
	 String CRON_EXP = '0 0 0 15 3 ? *';
	 
	 String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ScheduleFacilitatorMatchedRecords15());
     CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
     //BatchScheduleFacilitatorMatchedRecords20 c = new BatchScheduleFacilitatorMatchedRecords20();
     //Database.executeBatch(c);
	 Test.stopTest();

        
    }
    
    static testmethod void test20()
    {
	
	 Date d20 = Date.today() - 20;
	
	 Contact Studentrecord  = Utility_Test.insertSingleStudent('Test Student FN 20', 'Test Student LN 20'); 
	 Studentrecord.Facilitator_Assigned_Date__c = d20;
	 Studentrecord.Email = 'abc@gmail.com';
	 
	 insert Studentrecord;
	 
	 Test.startTest();
	 
	 String CRON_EXP = '0 0 0 15 3 ? *';
	 
	 String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ScheduleFacilitatorMatchedRecords20());
     CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
     //BatchScheduleFacilitatorMatchedRecords20 c = new BatchScheduleFacilitatorMatchedRecords20();
     //Database.executeBatch(c);
	 Test.stopTest();

        
    }
    
}