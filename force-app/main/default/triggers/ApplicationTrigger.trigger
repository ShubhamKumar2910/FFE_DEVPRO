trigger ApplicationTrigger on Application__c (after update,before update,before insert,after insert) {
    
    boolean flag=(BypassTrigger__c.getInstance('ApplicationTrigger')!=null ?BypassTrigger__c.getInstance('ApplicationTrigger').Bypass__c :false);
    if(flag){ system.debug('flag===='+flag);return;}
    
    ApplicationTriggerHelper application =  ApplicationTriggerHelper.getInstance();   
    
    if(trigger.isinsert && trigger.isafter)
    {
        application.onAfterInsert(Trigger.new);
    }
    
    if(trigger.isupdate && trigger.isafter && Constants.APPLICATION_TRIGGER_RUNNING == false){
        
        application.applicationStageClosed(Trigger.new);
        application.onAfterUpdate(Trigger.oldMap,Trigger.newMap);
        if(Utility.getSystemDetails().Send_SMS__c == true && Constants.Stop_SMS == false){
            SMS_Service_CTRL.onAfterUpdateApplication(Trigger.oldMap,Trigger.newMap);
        }
        application.onAfterApplicationClose(Trigger.new);
    }    
    
    if(trigger.isupdate && trigger.isbefore)
    {
        application.onBeforeUpdate(Trigger.oldMap,Trigger.newMap);
    }
    
}