/*Description: Generate the CCAvenue for Payment 
*Purpose     :Test class for DN_CCAvenue
*/

@isTest
private class DN_CCAvenue_Test {
    
    Static testmethod void duplicateCCAvnue(){
        
        User testUser = Utility_Test.createUser('ccAvenuectrl@testuser.com');
        System.runAs(testUser){
            test.startTest();
            DN_CCAvenue_Service ccAvenueService = new DN_CCAvenue_Service();   
            /*******Creating the instance for wrapper and calling the methods from "DN_CCAvenue_Service" object  to get encrypted string*****/
            DN_PaymentWrapper paymentwrapper = new DN_PaymentWrapper();
            String paymentOrderId	         = ccAvenueService.createPaymentOrder(paymentwrapper);
            string orderString	             = ccAvenueService.getEncryptedURLParams(paymentOrderId, DN_ServiceConstants.USD_CURRENCY,34000.00);
            string encryString               = ApexPages.currentPage().getParameters().put('p',orderString); 
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c paymentOrder = new Payment_Order__c();
            paymentOrder.Order_Amount__c = double.valueOf('5000000.00');
            paymentOrder.Currency__c     ='INR';
            paymentOrder.Donor__c		= donor.Id;
            insert paymentOrder;
            
            DN_CCAvenue_CTRL ccAvenueController = new DN_CCAvenue_CTRL();  
            ccAvenueController.getRequestString(paymentOrder,'INR',double.valueOf('5000000.00'));
            CCAvenue_Details__c ccDetails   = CCAvenue_Details__c.getInstance();
            ccDetails.Non_FCRA_Merchant_ID__c = '2193';
            ccDetails.FCRA_Working_Key__c     = 'AVRAVTYBHNUINMOMINUH'; 
            ccDetails.FCRA_Access_Code__c     = 'F94007DF1640D69A';
            ccDetails.Redirect_URL_For_INR_Transaction__c='https://www.drupal.org/project/commerce_ccavenue';
            ccDetails.Cancel_URL_for_INR_Transaction__c  ='http://rishirdua.github.io/commerce-ccavenue';
            test.stopTest();
        }      
    }
    
    
    Static testmethod void duplicateCCAvnue1(){
        
        User testUser = Utility_Test.createUser('ccAvenuectrl@testuser.com');
        System.runAs(testUser){
            test.startTest();
            
            string encryString         = ApexPages.currentPage().getParameters().get('p'); 
            DN_CCAvenue_CTRL  ccAvenue = new DN_CCAvenue_CTRL();
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c paymentOrder = new Payment_Order__c();
            paymentOrder.Order_Amount__c = double.valueOf('5000000.00');
            paymentOrder.Currency__c     ='USD';
            paymentOrder.Donor__c	= donor.Id;
            insert paymentOrder;
            
            DN_CCAvenue_CTRL ccAvenueController = new DN_CCAvenue_CTRL();  
            ccAvenueController.getRequestString(paymentOrder,'USD',double.valueOf('5000000.00'));
            CCAvenue_Details__c ccDetails   = CCAvenue_Details__c.getInstance();
            ccDetails.Non_FCRA_Merchant_ID__c = '2193';
            ccDetails.FCRA_Working_Key__c     = 'AVRAVTYBHNUINMOMINUH'; 
            ccDetails.FCRA_Access_Code__c     = 'F94007DF1640D69A';
            ccDetails.Redirect_URL_For_INR_Transaction__c='https://www.drupal.org/project/commerce_ccavenue';
            ccDetails.Cancel_URL_for_INR_Transaction__c  ='http://rishirdua.github.io/commerce-ccavenue';
            test.stopTest();
        }
    }
}