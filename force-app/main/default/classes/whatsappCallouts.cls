global class whatsappCallouts {
        @future (callout=true)

 global static void sendSMSCallout(String bodypayloadparam){
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
        System.debug('request::'+request.toString());
        HttpResponse response = http.send(request);
        System.debug('response::'+response);
        if(response.getStatusCode() == 201){
            System.debug('Message send Successfully'+response.getStatusCode());
        }
        else{
            
            system.debug('Error Occured');
        }
    }
}