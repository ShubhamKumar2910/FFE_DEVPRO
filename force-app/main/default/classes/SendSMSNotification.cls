public class SendSMSNotification {
    public static boolean runOnceForApproved = true;
    // Method will be fired as any update on MMA occurs & will accept newMap and oldMap
    public static void sendMsgToMentorMentee(Map<id,Mentor_Mentee_Association__c> mmaNewMap, Map<id,Mentor_Mentee_Association__c> mmaOldMap){
        Set<id> mmaIds = new Set<id>();
        Map<String, String> MsgTempBodyMentee 	= new Map<String, String>();
        Map<String, String> MsgTempBodyMentor 	= new Map<String, String>();
        Set<String> ContactsToBeused 			= new Set<String>();
        
        for(Mentor_Mentee_Association__c mma : mmaNewMap.values()){
            // when Status is Approved Only
            if(mma.Status__c  != mmaOldMap.get(mma.Id).Status__c && mma.Status__c == 'Approved'){
                mmaIds.add(mma.Id);
            }
            // when Status is Completed Only
            else if(mma.Status__c  != mmaOldMap.get(mma.Id).Status__c && mma.Status__c == 'Completed'){ 
                mmaIds.add(mma.Id);
            }
        }
        
        // 1. get All mesage template
        List<Message_Template__c> msgRecList = [SELECT Applicable_Status__c,Recipient_Type__c,SMS_Body__c FROM Message_Template__c ];
        for(Message_Template__c msgTemp : msgRecList){
            if(msgTemp.Recipient_Type__c == 'Mentee'){
                MsgTempBodyMentee.put(msgTemp.Applicable_Status__c,msgTemp.SMS_Body__c); // Key: status & Value :Body
            }else if(msgTemp.Recipient_Type__c == 'Mentor'){
                MsgTempBodyMentor.put(msgTemp.Applicable_Status__c,msgTemp.SMS_Body__c); // Key: status & Value :Body
            }
        }
        
        //2. Loop through all mma
        
        List<Mentor_Mentee_Association__c> mmaRecList = [SELECT Id,mentee_del__c,mentee_del__r.Phone,mentee_del__r.Name,Mentor__c,Mentor__r.Phone,Mentor__r.Name,Status__c FROM Mentor_Mentee_Association__c where id in : mmaIds];
        
        for(Mentor_Mentee_Association__c mmaData : mmaRecList){
            if(mmaData.mentee_del__c != null)
                ContactsToBeused.add(mmaData.mentee_del__c);
            if(mmaData.Mentor__c != null)
                ContactsToBeused.add(mmaData.Mentor__c);
        }
        
        Map<Id,Contact> contactById = new Map<Id,Contact>([Select Phone,Name,is_Mentee__c,Salutation,Is_Mentor__c From Contact where id In:ContactsToBeused ]);
        // Parse Body for specific contact and Make smsWrapperList
        for(Mentor_Mentee_Association__c mmaData : mmaRecList ){
            //For Mentee checking for status of MMA :: Applicable Status of Msg Temp
            if(MsgTempBodyMentee.containsKey(mmaData.Status__c) ){ 
                
                Contact conData = contactById.get(mmaData.mentee_del__c);
                if(conData != null){
                    String smsBody 	= parseSMSBody(MsgTempBodyMentee.get(mmaData.Status__c),contactById.get(mmaData.mentee_del__c),contactById.get(mmaData.Mentor__c));
                    SendSMSNotification_Helper.sendSingleSMS(conData.Phone,smsBody);
                }
            }
            //For Mentor checking for status of MMA :: Applicable Status of Msg Temp
            if(MsgTempBodyMentor.containsKey(mmaData.Status__c)){ 
                Contact conData = contactById.get(mmaData.Mentor__c);
                if(conData != null){
                    String smsBody 	= parseSMSBody(MsgTempBodyMentor.get(mmaData.Status__c),contactById.get(mmaData.mentee_del__c),contactById.get(mmaData.Mentor__c));
                    SMS_Service_Helper.sendSingleSMS(conData.Phone,smsBody);
                }
            }
        }
    }
    
    public static String parseSMSBody(String templateBody, Contact conRecMentee,Contact conRecMentor){
        if(templateBody.contains('{!Mentor.Name}')){
            templateBody = templateBody.replace('{!Mentor.Name}',conRecMentor != null ? conRecMentor.Name:'');
        }
        if(templateBody.contains('{!Mentee.Name}')){
            templateBody = templateBody.replace('{!Mentee.Name}',conRecMentee!= null ?conRecMentee.Name:'');
        }
        if(templateBody.contains('{!Mentee.Salutation}')){
            templateBody = templateBody.replace('{!Mentee.Salutation}',conRecMentee.Salutation!= null ?conRecMentee.Salutation:'');
        }
        if(templateBody.contains('{!Mentor.Salutation}')){
            templateBody = templateBody.replace('{!Mentor.Salutation}',conRecMentor.Salutation!= null ?conRecMentor.Salutation:'');
        }
        return templateBody;
    }
}