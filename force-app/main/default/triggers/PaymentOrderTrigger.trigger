/*
* @Purpose      : Trigger
* @Author       : Gourab 
*/
trigger PaymentOrderTrigger on Payment_Order__c (After insert,After Update,Before Delete) {
    
    
    
    if((Trigger.isInsert && Trigger.isAfter) || (Trigger.isUpdate && Trigger.isAfter)){
        Constants.Contact_TRIGGER_RUNNING =true;
        if(Constants.SMS_TRIGGER_RUNNING == false){
            Boolean b = true;
            if(Trigger.isUpdate && Trigger.isAfter){
                b=false;
            }
            PaymentOrderTriggerHelper.checkthedonorDemo(Trigger.newMap,Trigger.oldMap,b); 
            
            if(Trigger.isUpdate && Trigger.isAfter){
                PaymentOrderTriggerHelper.paymentOrderStatusUpdate(Trigger.newMap,Trigger.oldMap);
                List<Id> listIds = new List<Id>();
                string strFinYear = Utility.financialYear();
                for(Payment_Order__c objPaymentOrder: Trigger.new){
                    //Added condition if Payment_Method__c='Interest' OR 'Foreign Fund Transfer' to restrict sending email on payment orders created from interest amount -- Sumit Gaurav 26-June-2020
                    if(objPaymentOrder.Payment_Method__c!='Interest' && objPaymentOrder.Payment_Method__c!='Foreign Fund Transfer' && !objPaymentOrder.Is_Email_sent__c && objPaymentOrder.Financial_Year__c == strFinYear && objPaymentOrder.CCAvenue_Payment_Status__c == 'Success')
                        listIds.add(objPaymentOrder.Id);
                }
                //Added static var check to avoid recurssion -- Sumit Gaurav -- 26-June-2020
                if(!Constants.EightyG_Reciept_sent_to_Donor && listIds != null && listIds.size() > 0 && !System.isBatch() && !System.isFuture()){
                    Constants.EightyG_Reciept_sent_to_Donor=true;
                    PaymentOrderTriggerHelper.afterUpdate_Send80GForm(listIds);
                }
            } 
        }
        
    }
    
    if(Trigger.isDelete && Trigger.isBefore){
        Constants.Contact_TRIGGER_RUNNING =true;
        if(Constants.SMS_TRIGGER_RUNNING == false){
            PaymentOrderTriggerHelper.afterDeleteOperation(Trigger.oldMap);
        }
        
    }
    
}