/*
*Purpose : Batch class to send Failed Transaction to Bridge app those were not able to connect with icici         
*/
global class AutomaticCIBTransactionCallout implements Database.Batchable<sObject>, Database.Stateful,Schedulable,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){   
        String DownTimeTrnxStatus = System.label.automatic_CIB_Batch_Status;
        return Database.getQueryLocator('Select id,APICalloutCount__c,Name,SF_TRAN_ID__c,APITXNStatus__c,Disbursement_Mode__c,Pay_Mod__c,Amt__c, Debit_Ac_No__c,Payable_Location__c,Print_Location__c,Beneficiary_Name__c,Beneficiary_Ac_No__c,IFSC__c from Business_Account_Utilization__c where APITXNStatus__c=:DownTimeTrnxStatus');    
    }
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new AutomaticCIBTransactionCallout(), 20); 
    }
    
    global void execute(Database.BatchableContext BC,List<Business_Account_Utilization__c> bauList){
        try{
            List<String> bauIds = new List<String>();
            for(Business_Account_Utilization__c bau : bauList){
                bauIds.add(bau.id);
            }
            String response = CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        }Catch(Exception e){
            HandleBusinessException.captureError('AutomaticCIBTransactionCallout', 'execute batch', e);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}