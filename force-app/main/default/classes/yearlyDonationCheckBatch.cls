/*
    * @Purpose      : Batch class for uncheck flag in donor record .
    * @Author       : Gourab 
    */
global class yearlyDonationCheckBatch implements Database.Batchable<sObject>,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      Id donorRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId(); 
      String query = 'Select Id,FirstName,LastName,Email,Has_Donated_First_Time_Donor__c from Contact where RecordTypeId =:donorRecType and Has_Donated_First_Time_Donor__c=true';
      return Database.getQueryLocator(query);
   }

   global void execute(SchedulableContext SC) {
        Database.executeBatch(new yearlyDonationCheckBatch()); 
    }
    
   global void execute(Database.BatchableContext BC, List<Contact> donorList){
       try{  
     List<Contact> donorUpdateList = new List<Contact>();
     for(Contact con : donorList){
      con.Has_Donated_First_Time_Donor__c = false;
      donorUpdateList.add(con);   
     }
     update donorUpdateList;
       }Catch(Exception e){
           HandleBusinessException.captureError('yearlyDonationCheckBatch', 'executeBatch', e);
       } 
    }

   global void finish(Database.BatchableContext BC){
   }

}