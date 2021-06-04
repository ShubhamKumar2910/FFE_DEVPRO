global class ScheduleFacilitatorMatchedRecords15 implements Schedulable {
    
    // Execute at regular intervals
    global void execute(SchedulableContext ctx){
      Date d15 = Date.today() - 15;
      String d15String = String.valueof(d15);
      String soql = 'SELECT Facilitator_Assigned_Date__c,Id,Name FROM Contact WHERE Facilitator_Assigned_Date__c ='+d15String;
      BatchScheduleFacilitatorMatchedRecords15 batch = new BatchScheduleFacilitatorMatchedRecords15(soql);
      Database.executebatch(batch, 1);
    }
}