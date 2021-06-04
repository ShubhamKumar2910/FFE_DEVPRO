trigger BusinessAccountUtilization on Business_Account_Utilization__c (after update) {
    
    boolean flag=(BypassTrigger__c.getInstance('BusinessAccountUtilization')!=null ?BypassTrigger__c.getInstance('BusinessAccountUtilization').Bypass__c :false);
    if(flag){ system.debug('flag===='+flag);return;}
    
    if(Trigger.isUpdate && Trigger.isAfter){
        BusinessAccountUtilizationTrigger_Helper.afterUpdate(Trigger.newMap,Trigger.oldMap);
    }
    
}