/*
*@ Purpose : Used to Send Single Message / Bulk Messages.
*/

public class SMS_Service_Helper {
   
/*@purpose      : to send single SMS
*@param         : contact phoneNumber, TextMessage
*/  
    @future (callout=true)
   public static void sendSingleSMS(String contactNumber, String textMessage){
        
        try{
            
            textMessage            = EncodingUtil.urlEncode(textMessage, 'UTF-8');
            String EndPoint_URL    = Utility.getSmsDetails().EndPoint_URL__c+'username='+Utility.getSmsDetails().UserName__c+'&password='+Utility.getSmsDetails().Password__c+'&to='+contactNumber+'&from='+Utility.getSmsDetails().SenderID__c+'&udh=&text='+textMessage+''+Utility.getSmsDetails().single_message_url__c;
            system.debug('EndPoint_URL'+EndPoint_URL);
            HttpRequest req  = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(EndPoint_URL);
            Http http = new Http();
            HTTPResponse res = http.send(req);system.debug(res.getBody());system.debug(res.getStatus());
            system.debug('res'+res);
            
            try{
                  //  Constants.SMS_TRIGGER_RUNNING = true;
                    Utility.InsertSMSStatus(EndPoint_URL,textMessage,contactNumber,'POST',res.getBody(),res.getStatusCode(),res.getStatus());
                	
                }
                catch(Exception ex){
                    HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS::::SMS StatusObject Creation', ex);
                }
            
        }catch(Exception ex){
            HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS', ex);
        }
    }
    
/*
*@purpose       : to send Bulk SMS
*@param         : contact phoneNumber, TextMessage
*/     
  @future (callout=true)  
  public static void sendBulkSMS(List<String> contactNumbers, String textMessage){
        
        try{
            
            textMessage          = EncodingUtil.urlEncode(textMessage, 'UTF-8');
            String numbers       = '';
            
            for(String num :ContactNumbers){
                if(numbers == ''){
                    numbers = numbers+num;
                }else{
                    numbers=numbers+','+num;
                }
            }
            
            String EndPoint_URL   = Utility.getSmsDetails().EndPoint_URL__c+'username='+Utility.getSmsDetails().UserName__c+'&password='+Utility.getSmsDetails().Password__c+'&to='+numbers+'&from='+Utility.getSmsDetails().SenderID__c+'&text='+textMessage+''+Utility.getSmsDetails().Bulk_message_url__c;
            
            HttpRequest req  = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(EndPoint_URL);
            Http http = new Http();
            HTTPResponse res = http.send(req);
                try{
                    Constants.SMS_TRIGGER_RUNNING = true;
                    Utility.InsertSMSStatus(EndPoint_URL,textMessage,numbers,'POST',res.getBody(),res.getStatusCode(),res.getStatus());
                    
                   }
                catch(Exception ex){
                    HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS::::SMS StatusObject Creation', ex);
                }
            
        }catch(Exception ex){
            HandleBusinessException.captureError('SMS_Service', 'sendBulkSMS', ex);
        }
    }

    
  public static SMS_Status__c sendSingleSMSFromBatch(String contactNumber, String textMessage){
        
     try{
          
          textMessage            = EncodingUtil.urlEncode(textMessage, 'UTF-8');
          String EndPoint_URL    = Utility.getSmsDetails().EndPoint_URL__c+'username='+Utility.getSmsDetails().UserName__c+'&password='+Utility.getSmsDetails().Password__c+'&to='+contactNumber+'&from='+Utility.getSmsDetails().SenderID__c+'&udh=&text='+textMessage+''+Utility.getSmsDetails().single_message_url__c;
            
          HttpRequest req  = new HttpRequest();
          req.setMethod('POST');
          req.setEndpoint(EndPoint_URL);
          Http http = new Http();
          HTTPResponse res = http.send(req);system.debug(res.getBody());system.debug(res.getStatus());
            
          try{
             return InsertSMSStatus(EndPoint_URL,textMessage,contactNumber,'POST',res.getBody(),res.getStatusCode(),res.getStatus());
             }
          catch(Exception ex){
             HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS::::SMS StatusObject Creation', ex);return null;
            }
            
        }catch(Exception ex){
            HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS', ex);return null;
        }
    }
    
    //SMS Status 
    public static SMS_Status__c InsertSMSStatus(String url,String mbody,String ph,String reqMethod, String res,Integer resCode,String resStatus){
        if(mbody!=null && mbody!='' && ph!=null && ph!=''){
        return new SMS_Status__c(End_Point_Url__c = url,Message_Body__c = mbody,
                                 Mobile_Number__c = ph,Request_Method__c = reqMethod,
                                 Response__c = res,Response_Code__c = resCode,
                                 Response_Status__c= resStatus);
        }else{
            return null;
        }
        
    }
}