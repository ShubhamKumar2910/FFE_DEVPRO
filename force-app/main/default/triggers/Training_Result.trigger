trigger Training_Result on Training_Result__c (before insert,after insert,after update) {

    if(Trigger.isbefore && Trigger.isInsert)
    {
       TrainingResultEmailNotification.onBeforeInsert(Trigger.new);
    }

   if(Trigger.isAfter && Trigger.isUpdate){
        TrainingResultEmailNotification.onUpdateOperation(Trigger.new,Trigger.oldMap);
    } 
}