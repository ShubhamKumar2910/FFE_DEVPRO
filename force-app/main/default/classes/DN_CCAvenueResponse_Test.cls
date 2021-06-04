/*
*Purpose     :Test class for DN_CCAvenueResponse
*/

@isTest(seeAlldata=false)
private class DN_CCAvenueResponse_Test {
    
    @testsetup
    static void insertCustomSetting(){        
        CCAvenue_Details__c ccDetails   = new CCAvenue_Details__c(Non_FCRA_Working_Key__c='ERTTYHJFDUIOPERTY',SF_redirect_after_payment__c='www.test.com');
        insert ccDetails;
    }
    
    static testmethod void testMianCCAVenueResponse(){
        User testUser = Utility_Test.createUser('ccavenueRespone@testuser.com');
        System.runAs(testUser){
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor; 
            
            Payment_Order__c dummyOrder	= Utility_Test.createPaymentOrder(donor.Id,'dummyOrderNo');
            insert dummyOrder;
            
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.nonnripgredirect'));
            string encypt	= DN_CCAvenue_Service.encryptString('dummyResponse', 'ERTTYHJFDUIOPERTY');
            System.currentPageReference().getParameters().put('encResp', encypt);
            System.currentPageReference().getParameters().put('orderNo', 'dummyOrderNo');
            
            DN_CCAvenueResponse_CTRL ctrl	= new DN_CCAvenueResponse_CTRL();
            ctrl.DN_CCAvenueResponse_CTRL();
            Test.stopTest();
        }
    }
    
    static testmethod void testException(){
        User testUser = Utility_Test.createUser('ccavenueRespone@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            DN_CCAvenueResponse_CTRL ctrl	= new DN_CCAvenueResponse_CTRL();
            ctrl.DN_CCAvenueResponse_CTRL();
            
            Test.setCurrentPageReference(new PageReference('Page.nonnripgredirect'));
            string encypt	= DN_CCAvenue_Service.encryptString('dummyResponse', 'ERTTYHJFDUIOPERTY');
            System.currentPageReference().getParameters().put('encResp', encypt);
            System.currentPageReference().getParameters().put('orderNo', 'wrongOrderNo');
            
            DN_CCAvenueResponse_CTRL testCtrl	= new DN_CCAvenueResponse_CTRL();
            testCtrl.DN_CCAvenueResponse_CTRL();
            Test.stopTest();
        }
    }
}