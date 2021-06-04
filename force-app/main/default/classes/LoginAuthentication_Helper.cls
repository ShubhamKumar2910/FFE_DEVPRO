/*
 * @purpose: Helper class for Google,Facebook API calls to get requeust tokens
 * @Author: Amritesh
 */ 
global class LoginAuthentication_Helper {
    
    public static final string DONOR_STIE		=	'Donor';
    public static final string APPLICATION_SITE	= 	'Application';
    public static final String MENTORSHIP_SITE  =	'mentorship';
    // Call GoogleAuthorizationClass to get access token using authorization code
    public static string getGoogleAuthCode(String code, string loginSite){
        system.debug('code'+code);
        system.debug('loginSite'+loginSite);
        Google_API_Details__c gad = Google_API_Details__c.getInstance();
        if(loginSite == DONOR_STIE){
            return GoogleAuthorizationClass.generateAuthCode(code,gad.Auth_Endpoint_URL__c,gad.Redirect_URI__c, gad.Client_Id__c, gad.Client_Secret__c);
        }else if(loginSite == MENTORSHIP_SITE){
            return GoogleAuthorizationClass.generateAuthCode(code, gad.Auth_Endpoint_URL__c,gad.Mentor_Mentee_redirect_uri__c, gad.Client_Id__c,gad.Client_Secret__c);
        }else {
            return GoogleAuthorizationClass.generateAuthCode(code, gad.Auth_Endpoint_URL__c,gad.Application_Redirect_URL__c, gad.Client_Id__c,gad.Client_Secret__c);
        }   
    }
    
    // Call GooglePublicDetailsClass to get google email using access token
    public static GooglePublicDetailsClass.GoogleDetails getGoogleEmail(string authcode){
        //system.debug('Getting the G-mail'+authcode);
        return GooglePublicDetailsClass.getPublicDetails(authCode, Google_API_Details__c.getInstance().Endpoint_URL__c);
        
    }
    
    // Call FacebookAuthHandler to get access token using authorization code
    public static string getFBAuthCode(String code, string loginSite){
        Facebook_API_Details__c fad = Facebook_API_Details__c.getInstance();
        if(loginSite == DONOR_STIE){
            return FacebookAuthHandler.generateFBAuthCode(code,fad.Auth_Endpoint_URL__c,fad.Redirect_URL__c, fad.App_Id__c, fad.App_Secret__c);
        }else if(loginSite == MENTORSHIP_SITE){
            return FacebookAuthHandler.generateFBAuthCode(code,fad.Auth_Endpoint_URL__c,fad.Mentorship_Site_URL__c, fad.App_Id__c, fad.App_Secret__c);
        }
        else{
            system.debug('in the Else');
            return FacebookAuthHandler.generateFBAuthCode(code,fad.Auth_Endpoint_URL__c,fad.Application_Redirect_URL__c, fad.App_Id__c, fad.App_Secret__c);
        }
    }
    
    // Call GooglePublicDetailsClass to get google email using access token
    public static string getFacebookEmail(string authcode){
        Facebook_API_Details__c fad = Facebook_API_Details__c.getInstance();
        return FacebookAuthHandler.getFBPublicDetails(fad.Endpoint_URL__c, fad.App_Id__c, fad.App_Secret__c, authcode);        
    }
}