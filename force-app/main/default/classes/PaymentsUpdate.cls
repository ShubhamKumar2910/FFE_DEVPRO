public class PaymentsUpdate {
    
    public static void updatePayment(List <Payment_Order__c> paymentList){
        Try{
            List <Id> poId = new List<Id>();
            List <Id> oppId = new List<Id>();
            List<npe01__OppPayment__c> opppaymentList = new List<npe01__OppPayment__c>();
            for(Payment_Order__c po:paymentList){
                poId.add(po.Id);            
            }
            if(poId<>null){
                List<Opportunity> opplist = [select Id from Opportunity where Payment_Order__c IN: poId];
                
                
                for(Opportunity opp: opplist){
                    oppId.add(opp.Id);
                }
            }
            if(oppId<>null){
                
                opppaymentList = [select Id, npe01__Payment_Amount__c, npe01__Paid__c, npe01__Payment_Date__c, npe01__Scheduled_Date__c, Cheque_DD_Bank_Name__c, npe01__Check_Reference_Number__c, npe01__Payment_Method__c, npe01__Written_Off__c from npe01__OppPayment__c where npe01__Opportunity__c IN:oppId];
                
            }
            
            for(Payment_Order__c por : paymentList){
                for(npe01__OppPayment__c oppay : opppaymentList){
                    oppay.npe01__Payment_Method__c = por.Payment_Method__c;
                    oppay.npe01__Paid__c = por.Paid__c;
                    oppay.npe01__Payment_Date__c = por.Payment_Date__c;
                    oppay.npe01__Check_Reference_Number__c = por.Cheque_DD_Bank_Name__c;
                    oppay.npe01__Written_Off__c = por.Written_Off__c;                
                }
                
            }
            update opppaymentList;
        }Catch(Exception e){
            String errormsg;      
            errormsg = Constants.ERROR_MSG;
            for(Payment_Order__c po:paymentList){
                po.adderror(errormsg);            
            }
        }
    }
}