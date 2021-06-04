trigger MentorAssociationTrigger on Mentor_Mentee_Association__c (after insert,after update, before update) {
    
    static MentorAssociationTriggerHelper helperInstance = MentorAssociationTriggerHelper.getInstance();
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate) && MentorAssociationTriggerHelper.runOnce){

        MentorAssociationTriggerHelper.runOnce = false;
        
        // Updates Total Hour needed on MMA Record(According to Module level hours)
        helperInstance.updateTotalHoursAtInsert(Trigger.newMap, Trigger.oldMap);
       
        // Send SMS notification to mentor and mentee when mentor is allocated that is status on MMA is Approved OR Complwted
        SendSMSNotification.sendMsgToMentorMentee(Trigger.newMap, Trigger.oldMap);
        
    }
    if(trigger.isAfter && trigger.isUpdate){
        mentorAssigned_helper.notifyMenteeAboutMentorAllocation(Trigger.newMap, Trigger.oldMap);
        
        // Notification on Programme Completion - 15/16
        ProgramCompletedHelper.notifyMentorAboutPrgrmCmpltion(Trigger.newMap, Trigger.oldMap);
        ProgramCompletedHelper.notifyMenteeAboutPrgrmCmpltion(Trigger.newMap, Trigger.oldMap);
       
        // Notification on Each Module Complettion
        EachModuleCompleted.checkingModuleCompleteion(Trigger.newMap, Trigger.oldMap);
 
    }
    if(trigger.isbefore && trigger.isUpdate){ 
        
        // SMS Notification on Programme Completion to mentor and mentee
        if(SendSMSforEachModuleCompleted.runOnce == true ){
            SendSMSforEachModuleCompleted.sendingSmsOnSingleModuleCompletion(Trigger.newMap, Trigger.oldMap);
            SendSMSforEachModuleCompleted.runOnce = false;
        }
    }
    
}