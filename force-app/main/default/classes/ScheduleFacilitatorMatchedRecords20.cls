global class ScheduleFacilitatorMatchedRecords20 implements Schedulable {
    
    // Execute at regular intervals
    global void execute(SchedulableContext ctx){
      Date d20 = Date.today() - 20;
      String d20String = String.valueof(d20);
      String soql = 'SELECT Facilitator_Assigned_Date__c,Id,Name FROM Contact WHERE Facilitator_Assigned_Date__c ='+d20String;
        
      BatchScheduleFacilitatorMatchedRecords20 batch = new BatchScheduleFacilitatorMatchedRecords20(soql);
      Database.executebatch(batch, 1);
    }
}