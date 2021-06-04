@isTest
public class LoginAuthentication_Helper_Test {
    
    public static testmethod void mailAndApproval(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            LoginAuthentication_Helper.getGoogleAuthCode('XJDHFVNJ', 'Donor');//for if block
            LoginAuthentication_Helper.getGoogleAuthCode('XJDHFVNJ', null);//for else block
            LoginAuthentication_Helper.getGoogleEmail('AUTHCODE1111');
            LoginAuthentication_Helper.getFBAuthCode('XJDHFVNJ', 'Donor');//for if block
            LoginAuthentication_Helper.getFBAuthCode('XJDHFVNJ', null);//for else block
            LoginAuthentication_Helper.getFacebookEmail('AUTHCODE2222');
        }
        test.stopTest();
    }
}