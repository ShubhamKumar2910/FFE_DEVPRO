/************************************************************************************************************
Apex ClassName  - HashAadharNumber_OneTime_Batch
Version - 1.0 
Created Date    - 24-June-2020  
Developed By    - Sumit Gaurav
Description     - The purpose of this batch is to hash the aadhar number and delete the copy of Aadhar from Application's attachment
Modification Log :
-----------------------
* Developers                   Date                   Description
* ----------                  -----                  ------------------------*/
global class HashAadharNumber_OneTime_Batch implements Database.Batchable<sObject> {
    
    //Start method of Batch class
    global Database.queryLocator start(Database.BatchableContext bc) {
        String query ='select id,KYC_Verified__c,Active_Application_ID__c,Aadhar_number__c from Contact where '+System.Label.HashAadharNumberBatchWhereClause;                           
        return Database.getQueryLocator(query);
    }
    
    //Execute method of Batch Class
    global void execute(Database.BatchableContext bc, List<Contact> contactList) {
        
        List<Contact> contactToUpdateList=new List<Contact>();
        Set<String> activeApplicationIDSet=new Set<String>();
        try{
            for(Contact con:contactList){
                if(!String.IsBlank(con.Aadhar_number__c)){
                    string hashCodeString=FFE_KYC_Verification.generateHashCode(con.Aadhar_number__c);
                    if(!String.IsBlank(hashCodeString)){
                        con.Aadhar_number__c=hashCodeString;
                        if(!String.IsBlank(con.Active_Application_ID__c)){
                            activeApplicationIDSet.add(con.Active_Application_ID__c);
                        }
                        contactToUpdateList.add(con);
                    }
                }
            }
            
            if(contactToUpdateList.size()>0){
                DataBase.update(contactToUpdateList,false);
            }
            
            if(activeApplicationIDSet.size()>0){
                
                List<Attachment> eAadharfile=[Select id from Attachment where Name='Copy of Aadhaar.pdf' and parentId IN :activeApplicationIDSet];
                
                if(eAadharfile.size()>0){
                    DataBase.delete(eAadharfile,false);
                }
            }
        }
        catch(Exception e){
            HandleBusinessException.captureError('HashAadharNumber_OneTime_Batch', 'excutemethod', e);
        } 

    }
    //Finish method of Batch Class
    global void finish(Database.BatchableContext bc) {
        System.debug('Finish Method');
    }
}