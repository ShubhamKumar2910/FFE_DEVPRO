/*
* @Author		: Amritesh
* @Description : Hanlder that controls flow for all objects which TDM Supports.
*/ 
global class TDTM_Handler extends npsp.TDTM_Runnable {
    
    private static final string CONTACT_SOBJECT		= 'Contact';
    private static final string ACCOUNT_SOBJECT		= 'Account';
    private static final string OPPORTUNITY_SOBJECT	= 'Opportunity';
    
    public override DmlWrapper run(List<Sobject> newList, List<Sobject> oldList,npsp.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult){
        
        try{
        triggerInfo trgr = new triggerInfo(triggerAction, objResult);
        
        if (trgr.sObjectName == ACCOUNT_SOBJECT) {
            if (trgr.isBefore && trgr.isInsert) {
            }
        }else if (trgr.sObjectName == CONTACT_SOBJECT) {
          //  if(!System.isFuture() && !System.isBatch()){
                if(trgr.isinsert && trgr.isbefore){			
                } 
                if(trgr.isinsert && trgr.isafter){
                    
                    if(Utility.getSystemDetails().Send_SMS__c == true) {
                        System.debug('Trigger:::::TDTM_onAfterInsert called');
                        SMS_Service_CTRL.onAfterInsert(newList);
                    }
                    NotifyDonorTeam.donorCreateNotification(oldList,newList);
                }
                if(trgr.isupdate && trgr.isbefore){
                }
                if(trgr.isupdate && trgr.isafter && Constants.Contact_TRIGGER_RUNNING == false){
                    System.debug('Trigger:::::TDTM_all update called');
                    ChangeInBankInfoMail.onAfterUpdate(oldList, newList);
                    ContactTriggerHelper.onAfterUpdate(oldList, newList);
                    StudentTrainingCreation.onAfterUpdate(oldList, newList);
                    if(Constants.SMS_TRIGGER_RUNNING == false){
                    if(Utility.getSystemDetails().Send_SMS__c == true){
                        SMS_Service_CTRL.onAfterUpdateContact(oldList,newList);
                    }
                    // ContactTriggerHelper.donorFieldChangesUpdate(oldList,newList);
                    NotifyDonorTeam.donorFieldChangesUpdate(oldList,newList);
                    }
                }
                
           // }
            
        }
             
            
        }catch(Exception e){
             HandleBusinessException.captureError('TDTM_Handler', 'run', e);
        }
       return null;
    }
    
    /*
* @purpose:Holds the trigger context variables as an instance to pass to the processing methods
*/
    public class triggerInfo {
        
        public Boolean isInsert 	= false; 
        public Boolean isUpdate 	= false;
        public Boolean isBefore 	= false;
        public Boolean isAfter  	= false;
        public Boolean isDelete 	= false;
        public Boolean isUndelete 	= false;
        public String sObjectName;
        
        public triggerInfo(npsp.TDTM_Runnable.Action triggerAction, Schema.DescribeSObjectResult objResult) {
            this.isInsert = (triggerAction == npsp.TDTM_Runnable.Action.BeforeInsert
                             || triggerAction == npsp.TDTM_Runnable.Action.AfterInsert);
            this.isUpdate = (triggerAction == npsp.TDTM_Runnable.Action.BeforeUpdate
                             || triggerAction == npsp.TDTM_Runnable.Action.AfterUpdate);
            this.isBefore = (triggerAction == npsp.TDTM_Runnable.Action.BeforeInsert
                             || triggerAction == npsp.TDTM_Runnable.Action.BeforeUpdate
                             || triggerAction == npsp.TDTM_Runnable.Action.BeforeDelete);
            this.isAfter = !isBefore;
            this.isDelete = (triggerAction == npsp.TDTM_Runnable.Action.BeforeDelete
                             || triggerAction == npsp.TDTM_Runnable.Action.AfterDelete);
            this.isUndelete = (triggerAction == npsp.TDTM_Runnable.Action.AfterUndelete);
            this.sObjectName = objResult.getName();
        }
    }
}