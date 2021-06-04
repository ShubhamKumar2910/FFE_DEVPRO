trigger DonorApplicationMapping on Donor_Application_Mapping__c (after insert,after update,after delete) {
    
    boolean flag=(BypassTrigger__c.getInstance('DonorApplicationMapping')!=null ?BypassTrigger__c.getInstance('DonorApplicationMapping').Bypass__c :false);
    if(flag){ system.debug('flag===='+flag);return;}
    
    if((Trigger.isinsert && Trigger.isafter )|| (Trigger.isUpdate && Trigger.isafter)){
        DonorApplicationMappingTrigger_Helper.afterInsertAndUpdate(Trigger.new);
        if(Trigger.isinsert && Trigger.isafter ){
        DonorApplicationMappingTrigger_Helper.afterInsert(Trigger.new);
        }
        
        if(Trigger.isupdate && Trigger.isafter ){
        DonorApplicationMappingTrigger_Helper.afterInsert(Trigger.new);
        }
    }
    
    if(Trigger.isdelete && Trigger.isafter){
        DonorApplicationMappingTrigger_Helper.afterdelete(Trigger.old);
    }
}