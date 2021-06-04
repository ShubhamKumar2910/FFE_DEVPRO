@isTest public class WhatsappService_Test {
    @isTest public static void sendMsgTest(){
        List<Message_Template__c> msgTempList = new List<Message_Template__c>();
        Message_Template__c msgTempMentee = new Message_Template__c();
        Message_Template__c msgTempMentor = new Message_Template__c();
        List<Contact> conList = new List<Contact>();
		Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        
        msgTempMentor.Applicable_Status__c = 'Approved';
        msgTempMentor.Recipient_Type__c = 'Mentor';
        msgTempMentor.SMS_Body__c = 'Hi {!Mentor.Name},you are requested to arrange sessions for the following approved program with {!Mentee.Name}';
        msgTempMentee.Applicable_Status__c = 'Approved';
        msgTempMentee.Recipient_Type__c = 'Mentee';
        msgTempMentee.SMS_Body__c = 'Hi {!Mentee.Name},Your request has been approved for the requested program.';
        
        msgTempList.add(msgTempMentor);
        msgTempList.add(msgTempMentee);
        insert msgTempList;
        
        Contact conMentor = new Contact();
        conMentor.FirstName =  'Ajeet';
        conMentor.LastName =  'Kumar';
        conMentor.Whatsapp_opting__c = true;
        conMentor.Phone = '+917042458620';
        conMentor.RecordTypeId =  '0121e000000L5TF';
        conList.add(conMentor) ;
        
        Contact conMentee = new Contact();
        conMentee.FirstName =  'Aakash';
        conMentee.LastName =  'Jain';
        conMentee.is_Mentee__c = true;
        conMentee.Whatsapp_opting__c = true;
        conMentee.Phone = '+917042458620';
        conList.add(conMentee);
        
        insert conList;
        
        mma.mentee_del__c = conMentee.Id;
        mma.Mentor__c = conMentor.Id;
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        insert mma;
        
        Set<Id> mmaIds = new Set<Id>();
        mmaIds.add(mma.Id);
        WhatsappService.sendMsg(mmaIds);
    }

}