trigger FFE_ContactTrigger on Contact (before insert, before update,after insert,after update) {

    boolean flag=(BypassTrigger__c.getInstance('FFE_ContactTrigger')!=null ?BypassTrigger__c.getInstance('FFE_ContactTrigger').Bypass__c :false);
    if(flag){ system.debug('flag===='+flag);return;}
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        
        FFE_ContactTriggerHandler.formatFieldValue(Trigger.New);
    }
    if(Trigger.isAfter ){
        Id studentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Id donorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        Contact objContact = Trigger.New[0];
        //Changed condition for sending Email to student with facilator details and documents when facilator is matched or changed -- Sumit Gaurav -- 09-June-2020
        if(Trigger.isInsert){
            //When student is referred by facilator -- Sumit Gaurav
            if(!Constants.Email_sent_to_Student_On_Facilitator_Matched && Trigger.New.size() == 1 && objContact.recordTypeId == studentRecordTypeId &&  Trigger.new[0].Internal_Status__c == 'Facilitator Matched' && Trigger.new[0].Email!=null && Trigger.new[0].Facilitator_Name__c != null)
            {
                FFE_ContactTriggerHandler.sendStudentApplicationAsAttachment(objContact.Id,objContact.FirstName,objContact.LastName,objContact.FFE_ID__c,objContact.Email);
                Constants.Email_sent_to_Student_On_Facilitator_Matched=true;
            }
            // When new mentor record is inserted
            WelcomeMentorEmail_Helper.sendWelcomeEmailNotificationToMentor(Trigger.newMap);         //Utilitarian Trigger

        }
        if(Trigger.isUpdate && !WelcomeMentorEmail_Helper.runOnce){
            
            //if(Trigger.New.size() == 1 && objContact.recordTypeId == studentRecordTypeId && Trigger.new[0].Internal_Status__c != Trigger.old[0].Internal_Status__c && Trigger.old[0].Internal_Status__c == 'Eligible' && Trigger.new[0].Internal_Status__c == 'Selected')  -- Sumit Gaurav
            if(!Constants.Email_sent_to_Student_On_Facilitator_Matched && Trigger.New.size() == 1 && objContact.recordTypeId == studentRecordTypeId && Trigger.new[0].Facilitator_Name__c != Trigger.old[0].Facilitator_Name__c && Trigger.new[0].Facilitator_Name__c != null && Trigger.new[0].Internal_Status__c == 'Facilitator Matched' && Trigger.new[0].Email!=null)
            {
                FFE_ContactTriggerHandler.sendStudentApplicationAsAttachment(objContact.Id,objContact.FirstName,objContact.LastName,objContact.FFE_ID__c,objContact.Email);
                Constants.Email_sent_to_Student_On_Facilitator_Matched=true;
            }
            List<Id> listDonorRecordIds = new List<Id>();
                for(Contact objCon: Trigger.New){
                if(objCon.recordTypeId == donorRecordTypeId){
                    listDonorRecordIds.add(objCon.id);
                }
            }
            //Added static var check to avoid recurssion -- Sumit Gaurav -- 26-June-2020
            if(!Constants.EightyG_Reciept_sent_to_Donor && listDonorRecordIds != null && listDonorRecordIds.size()>0 && !System.isBatch() && !System.isFuture()){
                Constants.EightyG_Reciept_sent_to_Donor=true;
                FFE_ContactTriggerHandler.afterUpdate_Send80GForm(listDonorRecordIds);
            }
            // when checkbox on contact(is_Mentee) is updated to true
            WelcomeMenteeEmail_Helper.sendWelcomeEmailNotificationToMentee(Trigger.newMap, trigger.oldMap);           //Utilitarian Trigger
             // when checkbox on contact(is_Mentor) is updated to true
             
			WelcomeMentorEmail_Helper.sendWelcomeMailAfterUpdate(Trigger.newMap , trigger.oldMap);	
            WelcomeMentorEmail_Helper.runOnce = true;
            //Utilitarian Trigger
        }
    }
}