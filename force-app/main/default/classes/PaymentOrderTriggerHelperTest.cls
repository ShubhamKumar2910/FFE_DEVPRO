@isTest
public class PaymentOrderTriggerHelperTest {

    static testmethod void ValidatePaymentOrder(){
        Map<Id,Payment_Order__c> paymentMap = new Map<Id,Payment_Order__c>();
         Map<Id,Payment_Order__c> oldMap = new Map<Id,Payment_Order__c>();
        
        Contact con=Utility_Test.insertNewDonorId('Gourab','Hazra');
        con.DN_Donor_Category__c = 'Alumni Donor';
        con.Has_Donated_First_Time_Donor__c=false;
        insert con;
        
        Payment_Order__c po = Utility_Test.createPaymentOrder(con.Id,'1111');
        po.Transaction_Date__c= Date.Today();
        po.CCAvenue_Payment_Status__c = 'Success';
        po.Donor__c=con.Id;
        insert po;
        oldMap.put(po.id,po);
        po.CCAvenue_Payment_Status__c = 'Failure';
        update po;
        paymentMap.put(po.id,po);
        po.CCAvenue_Payment_Status__c = 'Aborted';
        update po;
        
        Delete po;
       
      
    }
    
    static testmethod void ValidatePaymentOrder2(){
        Map<Id,Payment_Order__c> paymentMap = new Map<Id,Payment_Order__c>();
         Map<Id,Payment_Order__c> oldMap = new Map<Id,Payment_Order__c>();
        
        Contact con=Utility_Test.insertNewDonorId('Gourab','Hazra');
        con.DN_Donor_Category__c = 'Alumni Donor';
        con.Has_Donated_First_Time_Donor__c=false;
        insert con;
        
        Payment_Order__c po = Utility_Test.createPaymentOrder(con.Id,'1111');
        po.Transaction_Date__c= Date.Today();
        po.CCAvenue_Payment_Status__c = 'Success';
        po.Donor__c=con.Id;
        insert po;
        oldMap.put(po.id,po);
        po.CCAvenue_Payment_Status__c = 'Aborted';
        update po;
        paymentMap.put(po.id,po);
        
        
         Payment_Order__c po1 = Utility_Test.createPaymentOrder(con.Id,'1125');
        po1.Transaction_Date__c= Date.Today();
        po1.CCAvenue_Payment_Status__c = 'Success';
        po1.Donor__c=con.Id;
        insert po1;
        oldMap.put(po1.id,po1);
        po1.CCAvenue_Payment_Status__c = 'Aborted';
        update po1;
        paymentMap.put(po1.id,po1);
        
        
       
        Test.startTest();
        PaymentOrderTriggerHelper.paymentOrderStatusUpdate(paymentMap,oldMap);
        con.DN_Donor_Category__c = 'Individual';
        update con ;
         PaymentOrderTriggerHelper.paymentOrderStatusUpdate(paymentMap,oldMap);
       po1.CCAvenue_Payment_Status__c = '';
          update po1;
         PaymentOrderTriggerHelper.afterDeleteOperation(oldMap);
         con.DN_Donor_Category__c = 'Alumni Donor';
        update con ;
         PaymentOrderTriggerHelper.afterDeleteOperation(oldMap);
        
        Test.stopTest();
      
    }
}