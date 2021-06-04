public class WhatsappService {
    public  static void sendMsg(Set<id> mmaIds){
        try{
            // Message Temp Variables
            Map<String, String> MsgTempBodyMentee 	= new Map<String, String>();
            Map<String, String> MsgTempBodyMentor 	= new Map<String, String>();
            Set<String> ContactsToBeused 			= new Set<String>();
            List<smsWrapper> smsWrapperList			= new List<smsWrapper>();
            
            // 1. get All mesage template
			List<Message_Template__c> msgRecList 		= [SELECT Applicable_Status__c,Recipient_Type__c,SMS_Body__c FROM Message_Template__c ];
            system.debug('msgRecList::'+msgRecList);
            for(Message_Template__c msgTemp : msgRecList){
                if(msgTemp.Recipient_Type__c == 'Mentee'){
                    MsgTempBodyMentee.put(msgTemp.Applicable_Status__c,msgTemp.SMS_Body__c);
                }else if(msgTemp.Recipient_Type__c == 'Mentor'){
                    MsgTempBodyMentor.put(msgTemp.Applicable_Status__c,msgTemp.SMS_Body__c);
                }
            }
            system.debug('MsgTempBodyMentee::'+MsgTempBodyMentee);
            system.debug('MsgTempBodyMentor::'+MsgTempBodyMentor);
            //2. Loop through all mma
            List<Mentor_Mentee_Association__c> mmaRecList = [SELECT Id,mentee_del__c,mentee_del__r.Phone,mentee_del__r.Name,Mentor__c,Mentor__r.Phone,Mentor__r.Name,Status__c FROM Mentor_Mentee_Association__c where id in : mmaIds];
            system.debug('mmaRecList::'+mmaRecList);
            
            for(Mentor_Mentee_Association__c mmaData : mmaRecList){
                if(mmaData.mentee_del__c != null)
                ContactsToBeused.add(mmaData.mentee_del__c);
                if(mmaData.Mentor__c != null)
                ContactsToBeused.add(mmaData.Mentor__c);
            }
            system.debug('ContactsToBeused::'+ContactsToBeused);

            Map<Id,Contact> contactById = new Map<Id,Contact>([Select Phone,Name,Whatsapp_opting__c,is_Mentee__c From Contact where id In:ContactsToBeused AND Whatsapp_opting__c = true]);
            system.debug('contactById::'+contactById);
                      
            // Parse Body for specific contact and Make smsWrapperList;
            for(Mentor_Mentee_Association__c mmaData : mmaRecList ){
                
                if(MsgTempBodyMentee.containsKey(mmaData.Status__c) ){
                    
                    Contact conData = contactById.get(mmaData.mentee_del__c);
                    if(conData != null){
                        String smsBody 	= parseSMSBody(MsgTempBodyMentee.get(mmaData.Status__c),contactById.get(mmaData.mentee_del__c),mmaData.Mentor__c != null ?contactById.get(mmaData.Mentor__c):null);
                        
                        smsWrapperList.add(new smsWrapper(smsBody,conData.phone)); 
                    }
                    
                }
                if(MsgTempBodyMentor.containsKey(mmaData.Status__c)){
                    Contact conData = contactById.get(mmaData.Mentor__c);
                    if(conData != null){
                        String smsBody 	= parseSMSBody(MsgTempBodyMentor.get(mmaData.Status__c),contactById.get(mmaData.mentee_del__c),mmaData.Mentor__c != null ?contactById.get(mmaData.Mentor__c):null);
                        
                        smsWrapperList.add(new smsWrapper(smsBody,conData.phone));
                    }
                    
                }
            }
            system.debug('smsWrapperList'+smsWrapperList);
            
            if(!smsWrapperList.isEmpty()){
                for(smsWrapper wrapInstance : smsWrapperList){
                    //String bodyPayload = 'From='+EncodingUtil.urlEncode('whatsapp:'+'+14155238886'+'','UTF-8')+'&Body='+EncodingUtil.urlEncode(wrapInstance.messageBody,'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+wrapInstance.phoneNumber+'','UTF-8')+'';
                    //sendSMSCallout(bodyPayload);
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                    system.debug('wrapInstance.phoneNumber'+wrapInstance.phoneNumber);
                    system.debug('wrapInstance.messageBody'+wrapInstance.messageBody);
                    SMS_Service_Helper.sendSingleSMS('7353048304','hello');
                }
            }
            
        }
        catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    } 
    public static String parseSMSBody(String templateBody, Contact conRecMentee,Contact conRecMentor){
        if(templateBody.contains('{!Mentor.Name}')){
            templateBody = templateBody.replace('{!Mentor.Name}',conRecMentor != null ? conRecMentor.Name:'');
        }
        if(templateBody.contains('{!Mentee.Name}')){
            templateBody = templateBody.replace('{!Mentee.Name}',conRecMentee!= null ?conRecMentee.Name:'');
        }
        return templateBody;
        
    }
    public Class smsWrapper{
        String messageBody;
        String phoneNumber;
        public smsWrapper(String messageBody,String phoneNumber){
            this.messageBody = messageBody;
            this.phoneNumber = phoneNumber;
        }
    }
    
    public static void sendSMSCallout(String bodypayloadparam){
        
        try{
            system.debug('bodypayloadparam::'+bodypayloadparam);
            String endpoint = 'https://api.twilio.com/2010-04-01/Accounts/ACdf4f6c7fb6f66eb08e22373818639ee0/Messages.json';
            Blob headerValue = Blob.valueOf('ACdf4f6c7fb6f66eb08e22373818639ee0'+':'+'f18fa5e7ee4a2d5dc75c126b8a27741c');
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            String bodyPayload = bodypayloadparam;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Authorization', authorizationHeader);
            request.setBody(bodyPayload);
            System.debug('request'+request.toString());
            HttpResponse response = http.send(request);
            System.debug('response'+response);
            if(response.getStatusCode() == 201){
                System.debug('Message send Successfully'+response.getStatusCode());
            }
            else{
                
                system.debug('Error Occured');
            }
            
        }
        catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
    
}