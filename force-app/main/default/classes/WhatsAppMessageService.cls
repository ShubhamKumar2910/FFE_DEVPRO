public class WhatsAppMessageService {
    @AuraEnabled
    public static void sendMessage(string mobileno,string message)
    {
        system.debug(mobileno+'----------'+message);
        errorResponseWrapper erw;
        final String fromNumber = '+14155238886'; 
        String account = 'ACfc8faa214796961a4f4e3120121ee244';  
        String token   = 'e19ea9cc22f5ad8286be00877c237d42';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+account+'/Messages.json');
        req.setMethod('POST'); 
        req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        Blob headerValue = Blob.valueOf(account + ':' + token);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        if(mobileno != null)
        {
            string jsonString='From='+EncodingUtil.urlEncode('whatsapp:+14155238886', 'UTF-8')+'&Body='+EncodingUtil.urlEncode(message, 'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+mobileno+'', 'UTF-8')+'';
            req.setBody(jsonString);
            try{
                Http http = new Http();
                HTTPResponse res = http.send(req);
                System.debug(res.getBody());
                if(res.getStatusCode()==201)
                    system.debug('Twilio Success'+mobileno);
                else{
                    system.debug('Twilio failed'+mobileno);
                    erw =(errorResponseWrapper)json.deserialize(res.getBody(),errorResponseWrapper.class);
                    system.debug('Twilio error'+erw.message);
                }
            }
            catch(Exception e){
                system.debug('Error :'+e);
            } 
            
        }
    }
    public class errorResponseWrapper{
        String code;
        String message;
        String moreInfo;
        String status;    
    }
}