trigger AttachmentTrigger on Attachment (after insert, after update, after delete, after undelete) {
    
    if(Trigger.IsInsert && Trigger.IsAfter){
        AttachmentTriggerHelper.afterInsertOfAttachment(Trigger.new);
        AttachmentTriggerHelper.countAttachments(Trigger.new, Trigger.old);
        
    }
    
    if(trigger.isafter) {
        if(trigger.isDelete || trigger.isUndelete || trigger.isUpdate ){            
            
                AttachmentTriggerHelper.countAttachments(Trigger.new, Trigger.old); 
        } 
    }
    
}