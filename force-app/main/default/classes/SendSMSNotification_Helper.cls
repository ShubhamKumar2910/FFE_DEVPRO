public class SendSMSNotification_Helper {
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
           
        }catch(Exception ex){
            HandleBusinessException.captureError('SMS_Service', 'sendSingleSMS', ex);
        }
    }

}