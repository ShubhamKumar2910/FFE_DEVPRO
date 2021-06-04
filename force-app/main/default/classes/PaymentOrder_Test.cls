@isTest
private class PaymentOrder_Test {
    public static testmethod void executeTest(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact con = Utility_Test.insertNewStudentRec('ABC','ZYX',null,null,null,null,null,70,90,'cet','2016');
            insert con;
            
            List <Payment_Order__c> paymentList = new List<Payment_Order__c>();    
            Payment_Order__c po = Utility_Test.createPaymentOrder(con.id,'N14927700918910566918371');
            insert po;
            
            
            po.Order_No__c = 'N14927700918910566918372';
            update po;
            paymentList.add(po); 
            
            Opportunity opp = new Opportunity();
            opp.Name = 'opportunityTest';
            opp.StageName = 'Pledged';
            opp.CloseDate = date.valueOf('2017-12-27');
            opp.Amount = double.valueOf('56.000');
            opp.Payment_Order__c = po.Id;
            insert opp;
            
            npe01__OppPayment__c payment = new npe01__OppPayment__c();
            payment.npe01__Payment_Amount__c= 20000;
            payment.npe01__Opportunity__c = opp.id;
            insert payment;    
            
            PaymentsUpdate.updatePayment(paymentList);    
            PaymentsUpdate.updatePayment(new List<Payment_Order__c>{new Payment_Order__c(Order_No__c='dummyId',Donor__c=null)}); //to cover catch block 
        }
        test.stopTest();
    }
    
}