global class ScheduleFacilitatorMatchedRecords7 implements Schedulable {
    
    // Execute at regular intervals
    global void execute(SchedulableContext ctx){
      Date d7 = Date.today() - 7;
      String d7String = String.valueof(d7);
      String soql = 'SELECT Facilitator_Assigned_Date__c,Id,Name FROM Contact WHERE Facilitator_Assigned_Date__c ='+d7String;
      BatchScheduleFacilitatorMatchedRecords7 batch = new BatchScheduleFacilitatorMatchedRecords7(soql);
      Database.executebatch(batch, 1);
    }
}