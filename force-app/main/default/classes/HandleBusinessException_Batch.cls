/*
 * @description: Delete exception logs periodically 
 */
global class HandleBusinessException_Batch implements Database.Batchable<sObject>, Schedulable { 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select id,Class_Name__c,Method_Name__c,Error_Message__c,Error_Stack_Trace__c,Error_Line_No__c,Error_Type__c FROM Exceptions__c');
    }
    
    global void execute(SchedulableContext SC) {
       Database.executeBatch(new HandleBusinessException_Batch(), 200); 
    }
    
    global void execute(Database.BatchableContext BC, List<Exceptions__c> ExceptionList){ 
        try{
            if(ExceptionList != null && ExceptionList.size() > 0){
                delete ExceptionList;
            }            
        }catch(Exception ex){}       
    }
    
    global void finish(Database.BatchableContext BC){}
}