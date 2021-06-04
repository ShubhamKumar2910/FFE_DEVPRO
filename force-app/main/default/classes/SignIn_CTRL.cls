/*
 * @purpose: This Class is used for Sign Up Page
 * @Author : Amritesh
 * @createdDate: 20/02/2017
*/ 
public class SignIn_CTRL {
    
    @RemoteAction
    Public static string generateLoginURL(String ffeId,String types){
        return Utility.temporaryDonorLoginURL(ffeId, null,types);
    }
   /* @RemoteAction
    public static String createAuthURL() {
        
        Google_API_Details__c gad = Google_API_Details__c.getInstance();
        string keys = gad.Client_Id__c;
        string secert = gad.Client_Secret__c;
        string redirect_uri = gad.Mentor_Mentee_redirect_uri__c;
        string authUrl= gad.Auth_Endpoint_URL__c;
        string scope='https://www.googleapis.com/auth/gmail.labels';//https://gmail.googleapis.com/gmail/v1/users/{userId}/labels
        string tokenUrl='https://accounts.google.com/o/oauth2/token';
        
        String key = EncodingUtil.urlEncode(keys,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = authUrl+'?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope='+scope+
            '&redirect_uri='+uri+
            '&access_type=offline'+
            '&prompt=consent';
        return authuri;
    } */
    @RemoteAction
    Public static string generateLoginURLForEmail(String emailId,String types){
        return Utility.temporaryDonorLoginURL(null, emailId,types);
    }
}