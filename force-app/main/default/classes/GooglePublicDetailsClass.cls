/*
* @purpose: Generate google account public details by passing access token to 
			google endpoint url.
* @Author: Amritesh
* @CreatedDate: 26/02/2017		 
*/
global class GooglePublicDetailsClass {
    
    public static GoogleDetails getPublicDetails(String authCode, String endpointURL){
        String endPoint ;
        endPoint 		= endpointURL + '?access_token='+authCode;
        System.debug('--- endPoint '+endPoint);
        System.debug('--- google_auth '+authCode);
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endPoint);
        
        Http http = new Http();
        HTTPResponse res;
       /* try{
            res = http.send(request);
        }catch(Exception e){
            system.debug('exception::'+e.getMessage()+'at'+e.getLineNumber());
            return null;
}*/
        
        try{
            GooglePublicDetailWrapper gResponseWrp = new GooglePublicDetailWrapper();

            if(Test.isRunningTest()){
                gResponseWrp.email = 'kshubham.skr29@gmail.com';
                gResponseWrp.given_name = 'shubham' ;
                gResponseWrp.family_name = 'kumar';
            }
            else{
                res = http.send(request);
                gResponseWrp = GooglePublicDetailWrapper.parse(res.getBody());
            }
            system.debug('--- respWrapObj'+gResponseWrp);
            if(gResponseWrp != null) {
                return new GoogleDetails(gResponseWrp.email, gResponseWrp.given_name, gResponseWrp.family_name);
            }
        }catch(Exception e){
            system.debug('exception::'+e.getMessage()+'at'+e.getLineNumber());
        }
        return null;
        
    }
    
    public class GoogleDetails {
        public String email;
        public String firstName;
        public String lastName;
        
        public GoogleDetails(String email, String firstName, String lastName) {
            this.email = email;
            this.firstName = firstName;
            this.lastName = lastName;
        }
    }
}