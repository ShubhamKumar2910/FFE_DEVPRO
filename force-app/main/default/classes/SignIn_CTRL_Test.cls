/*
* Purpose: Test class for SignIn_CTRL Class
*/
@isTest
public class SignIn_CTRL_Test {
    
    public static testmethod void SignInCtrlTest(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact donor = Utility_Test.insertNewDonorId('ABC','XYZ');
            donor.Email = 'abc@gmail.com';
            insert donor;
            SignIn_CTRL.generateLoginURL(donor.FFE_ID__c,null);
        	SignIn_CTRL.generateLoginURLForEmail(donor.Email,null);
        }
        test.stopTest();
    }
    
    public static testmethod void createFacilitators(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            List<String> facList = Utility_Test.insertNewContactFacilitator('FirstName','LastName');
            //insert facList;
        }
        test.stopTest();
    }

}