global class DonorCategoryOneTimeBatch implements Database.Batchable<sObject> {
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        ID donorRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Donor_Donor).getRecordTypeId();
        if(Test.isRunningTest())
        return Database.getQueryLocator('SELECT id,DN_Donor_Category__c from Contact');
        else
        return Database.getQueryLocator('SELECT id,DN_Donor_Category__c from Contact where RecordTypeId=:donorRecordTypeID AND (DN_Donor_Category__c=\'Scholar\' OR DN_Donor_Category__c =\'Alumni\') ');
    
    }
    global void execute(Database.BatchableContext BC, List<Contact> contactList){   
        try{
            List<Contact> donorToUpdateList = new List<Contact>();
            Set<Id> donorIDSet = new Set<Id> ();
            for(Contact c:contactList){
                donorIDSet.add(c.id);
            }
            
            if(donorIDSet.size()>0){
                for(Contact con:[Select id,DN_Donor_Category__c,(select id from Opportunities where StageName='Posted' ) from Contact where id IN :donorIDSet]){
                    con.DN_Donor_Category__c='Alumni Scholar';
                    //Check if atleast one donation with posted status
                    if(con.Opportunities!=null && con.Opportunities.size()>0){
                        con.DN_Donor_Category__c='Alumni Donor';
                    }
                    donorToUpdateList.add(con);
                }
            }
            
            if(!donorToUpdateList.isEmpty()){
                Constants.Contact_TRIGGER_RUNNING = true;
                Update donorToUpdateList;
            }
        }catch(Exception e){
            system.debug('Exception==='+e);
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}