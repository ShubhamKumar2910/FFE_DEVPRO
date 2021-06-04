@isTest public class GooglePublicDetailWrapper_Test {
    @isTest  public static  void mailAndApproval(){
       
            String json=		'{'+
                '  "sub": "104040785521062562114",'+
                '  "name": "Prithvi Shiroor",'+
                '  "given_name": "Prithvi",'+
                '  "family_name": "Shiroor",'+
                '  "picture": "https://lh3.googleusercontent.com/a-/AOh14GhlnvXTQ4d8-PQX0BbmpVeIpTJqW0aXPKkLn-0vhQ\u003ds96-c",'+
                '  "email": "prinz.deagle@gmail.com",'+
                '  "email_verified": true,'+
                '  "locale": "en"'+
                '}';
        GooglePublicDetailWrapper.parse(json);
           // fromJSON obj = parse(json);
            //System.assert(obj != null);
        
    }
}