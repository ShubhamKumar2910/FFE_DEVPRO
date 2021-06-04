public class PaymentOrderTriggerHelper {
    
    /*
* @Purpose      : This method used for check the first time flag in donor record if donor catagory is Scholar. Based on current finalcial year and payment status equal 
*                 success in payment order object.  
* @Author       : Gourab 
*/
    public static void checkthedonorDemo(Map<Id,Payment_Order__c> newMap,Map<Id,Payment_Order__c> OldMap,Boolean bb){
        
        try{
            
            set<Id> dId = new set<Id>();
            Set<Id> donorId = new Set<Id>(); 
            List<Contact> conUpList = new List<Contact>();
            for(Payment_Order__c po :newMap.values()){
                System.debug('Payment Order::::'+po);
               if(bb==true){
                   if(po.Financial_Year__c == Utility.financialYear() && po.CCAvenue_Payment_Status__c==Label.CCAvenue_Payment_Status){
                    donorId.add(po.Donor__c);
                    } 
                }
                else{
                    if(po.Financial_Year__c == Utility.financialYear() && po.CCAvenue_Payment_Status__c==Label.CCAvenue_Payment_Status){
                    donorId.add(po.Donor__c);
                    }
                } 
                
            }  
            System.debug('Donor Id::::'+donorId);
            List<Contact> donorList = [Select Id,Has_Donated_First_Time_Donor__c,DN_Donor_Category__c,(Select Id,Name,npsp__Primary_Contact__c from Opportunities where StageName='Posted') from Contact where Id IN :donorId and (DN_Donor_Category__c='Alumni Donor' OR DN_Donor_Category__c='Alumni Scholar') ];// Scholar changed to Alumni Donor & Alumni Scholar  -- Sumit Gaurav -- 17-July-2020
            List<Payment_Order__c> payList = [Select id,Financial_Year__c from Payment_order__C where Financial_Year__c =: Utility.financialYear() and Donor__c=:donorId and CCAvenue_Payment_Status__c =:'Success'];
            System.debug('donorList::::'+donorList);
            System.debug('Payment order List::::'+payList);
            
            for(Contact con : donorList){
                // Change donor category to Alumni Donor if atleast donation with posted stage. -- Sumit Gaurav - 17-July-2020
                if(con.Opportunities!=null && con.Opportunities.size()>0){
                   con.DN_Donor_Category__c='Alumni Donor';
                }
                
                if(payList.size() == 1){
                    if(con.Has_Donated_First_Time_Donor__c == false){
                        con.Has_Donated_First_Time_Donor__c = true;
                        conUpList.add(con);
                    }
                }else{
                    if(con.Has_Donated_First_Time_Donor__c == true){
                    con.Has_Donated_First_Time_Donor__c = false;
                    conUpList.add(con);
                    }
                }
                /*if(con.Opportunities.size()==1){
                    if(con.Has_Donated_First_Time_Donor__c == false){
                        con.Has_Donated_First_Time_Donor__c = true;
                        conUpList.add(con);   
                    } 
                }else{  
                    con.Has_Donated_First_Time_Donor__c = false;
                    conUpList.add(con);
                    }*/
            }
             System.debug('Donor Update List::::'+conUpList);
            if(!conUpList.isEmpty()){
                Constants.SMS_TRIGGER_RUNNING = true;
                update conUpList; 
            }
        }
        catch(Exception e){
            HandleBusinessException.captureError('PaymentOrderTriggerHelper', 'checkthedonorDemo', e);
        }
    }
    
    /*
* @Purpose      : This method is used if payment status are Failure / Aborted then send mail to FFE public group.
* @Author       : Gourab 
*/
    
    public static void paymentOrderStatusUpdate(Map<Id,Payment_Order__c> newMap,Map<Id,Payment_Order__c> oldMap){      
        
        try{
            
            String finalString = '';
            boolean isScholar= false;
            boolean isnotScholar = false;           
            NotifyDonorTeam.paymentWrapper paywrap2= NotifyDonorTeam.publicGroupCreation();  
            Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
            Integer i = 1;
            Messaging.SingleEmailMessage mail;
            Map<Id,Payment_Order__c> POMap = New  Map<Id,Payment_Order__c>([Select Id,CCAvenue_Payment_Status__c,Donor__r.FirstName,Donor__r.LastName,Donor__r.FFE_ID__c, 
                                                                            Donor__r.DN_Donor_Category__c from Payment_Order__c Where Id IN :newMap.keySet()]);
            for(Payment_Order__c po : POMap.values()){
                
                if(po.CCAvenue_Payment_Status__c!=oldMap.get(po.Id).CCAvenue_Payment_Status__c && po.CCAvenue_Payment_Status__c == Label.Failure_Status || po.CCAvenue_Payment_Status__c == Label.Aborted_Status){
                    
                    if(po.Donor__r.DN_Donor_Category__c == 'Alumni Donor' || po.Donor__r.DN_Donor_Category__c == 'Alumni Scholar' ){// Scholar changed to Alumni Donor & Alumni Scholar  -- Sumit Gaurav -- 17-July-2020
                        
                        if(POMap.size()>1){
                            finalString = i+') '+po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+'  '; 
                            i = i+1;
                        }else{
                            finalString = po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+' could not complete his donation. Please Log in to find out more'; 
                        }
                        mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(paywrap2.FailEmailTemplate,po.Donor__c,null,paywrap2.mailAddresses,paywrap2.OrgmailAddr);
                        isScholar = true;   
                    }
                    
                    else{
                        if(POMap.size()>1){
                            finalString = i+') '+po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+'  '; 
                            i = i+1;
                        }else{
                            finalString = po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+' could not complete his donation. Please Log in to find out more'; 
                        }
                        mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(paywrap2.FailEmailTemplate,po.Donor__c,null,paywrap2.mailAddressesforNonScholar,paywrap2.OrgmailAddr);
                        isnotScholar = true;  
                    }
                    
                    mailList.add(mail);
                   }
            }
            
            if(POMap.size()>1){
                finalString = finalString + ' could not complete his/her donation. Please Log in to find out more'; 
            }
            Messaging.sendEmail(mailList);
            
            
            // SMS_Service_Helper.sendBulkSMS(paywrap2.mobile,'Record has been Changed');
            if(isScholar)
            SMS_Service_CTRL.singleListOfString_To_String(paywrap2.mobile,finalString);
            if(isnotScholar)
            SMS_Service_CTRL.singleListOfString_To_String(paywrap2.mobileforNonScholar,finalString);    
        } 
        catch(Exception e){
            HandleBusinessException.captureError('PaymentOrderTriggerHelper', 'paymentOrderStatusUpdate', e);
        }    
    }
    
    /*
* @Purpose      : This method is used if payment order is deleted then send mail to FFE public group.
* @Author       : Gourab 
*/
    public static void afterDeleteOperation(Map<Id,Payment_Order__c> oldMap){
        
        try{
            
            String finalString = '';
            boolean isScholar= false;
            boolean isnotScholar = false; 
            NotifyDonorTeam.paymentWrapper paywrap2= NotifyDonorTeam.publicGroupCreation();
            Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
            Integer i = 1;
            Messaging.SingleEmailMessage mail;
            Map<Id,Payment_Order__c> POMap = new Map<Id,Payment_Order__c> ([Select Id,CCAvenue_Payment_Status__c,Donor__r.FirstName,Donor__r.LastName,Donor__r.FFE_ID__c,Donor__r.DN_Donor_Category__c 
                                                                            from Payment_Order__c Where Id IN :oldMap.keySet()]);
                                                                           
            
            for(Payment_Order__c po :POMap.values()){
                if(po.CCAvenue_Payment_Status__c != Label.CCAvenue_Payment_Status || po.CCAvenue_Payment_Status__c ==''){
                    if(po.Donor__r.DN_Donor_Category__c == 'Alumni Donor' || po.Donor__r.DN_Donor_Category__c == 'Alumni Scholar'){// Scholar changed to Alumni Donor & Alumni Scholar  -- Sumit Gaurav -- 17-July-2020
                        
                       if(POMap.size()>1){
                        finalString = i+') '+po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+'  '; 
                        i = i+1;
                        }else{
                        finalString = po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+'donor is unable to complete the donation, please check email for details.'; 
                        } 
                        mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(paywrap2.FailEmailTemplate,po.Donor__c,null,paywrap2.mailAddresses,paywrap2.OrgmailAddr);
                        isScholar = true; 
                    }
                    else{
                        if(POMap.size()>1){
                        finalString = i+') '+po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+'  '; 
                        i = i+1;
                        }else{
                        finalString = po.Donor__r.FirstName +' '+ po.Donor__r.LastName +', '+po.Donor__r.FFE_ID__c+'donor is unable to complete the donation, please check email for details.'; 
                        } 
                        mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(paywrap2.FailEmailTemplate,po.Donor__c,null,paywrap2.mailAddressesforNonScholar,paywrap2.OrgmailAddr);
                        isnotScholar = true;
                    }
                    mailList.add(mail);
                }
            }
            if(POMap.size()>1){
                finalString = finalString + 'donors is unable to complete the donation, please check email for details.';  
            } 
            Messaging.sendEmail(mailList);
            if(isScholar)
            SMS_Service_Helper.sendBulkSMS(paywrap2.mobile,finalString);
            if(isnotScholar)
            SMS_Service_Helper.sendBulkSMS(paywrap2.mobileforNonScholar,finalString);
        }
        
        
        catch(Exception e){
            HandleBusinessException.captureError('PaymentOrderTriggerHelper', 'afterDeleteOperation', e);
        }
    }
    @future (callout = true )
    public static void afterUpdate_Send80GForm(List<Id> listPaymentOrderIds)
    {
        string strFinYear = Utility.financialYear();
        List<Payment_Order__c> listPaymentOrders = [SELECT
            Id, 
            CCAvenue_Payment_Status__c, 
            Mailling_Address__c, 
            Quick_Donation__c,
            Financial_Year__c, 
            Is_Email_sent__c, 
            PAN__c, 
            Mobile__c, 
            Donor__r.Email, 
            Donor__r.DN_Citizenship__c, 
            Donor__r.X80G_Not_Required__c, 
            Donor__r.MailingAddress,
            Donor__r.DN_PAN__c,Payment_Method__c,
            (SELECT
                id, 
                StageName,
                Is_Program_Frequency_Unknown__c
            FROM
                Opportunities__r
            limit 1)
        FROM
            Payment_Order__c
        WHERE
            Id in: listPaymentOrderIds];
        List<Payment_Order__c> listPaymentOrdersToUpdate = new  List<Payment_Order__c>();
        for(Payment_Order__c objPaymentOrder: listPaymentOrders)
        {
            System.debug('****Test**** '+objPaymentOrder.Opportunities__r);
            if(!(objPaymentOrder.Opportunities__r != null && objPaymentOrder.Opportunities__r.size()>0)){
                continue;
            }
            System.debug('****Test**** '+objPaymentOrder.Opportunities__r);
            //Added condition if Payment_Method__c='Interest' OR 'Foreign Fund Transfer' to restrict sending email on payment orders created from interest amount -- Sumit Gaurav 26-June-2020
            if(objPaymentOrder.Payment_Method__c!='Interest' && objPaymentOrder.Payment_Method__c!='Foreign Fund Transfer' && !objPaymentOrder.Is_Email_sent__c && objPaymentOrder.Financial_Year__c == strFinYear && objPaymentOrder.CCAvenue_Payment_Status__c == 'Success' && !objPaymentOrder.Donor__r.X80G_Not_Required__c && ((objPaymentOrder.Donor__r.DN_Citizenship__c == 'Indian' && string.isNotBlank(objPaymentOrder.Donor__r.DN_PAN__c)) || objPaymentOrder.Donor__r.DN_Citizenship__c != 'Indian') && objPaymentOrder.Donor__r.MailingAddress != null && ((!objPaymentOrder.Quick_Donation__c && ( String.isNotBlank(String.valueof(objPaymentOrder.Opportunities__r)) &&  objPaymentOrder.Opportunities__r != null && !objPaymentOrder.Opportunities__r[0].Is_Program_Frequency_Unknown__c)) || objPaymentOrder.Quick_Donation__c))
            {
                if(objPaymentOrder.Opportunities__r != null && objPaymentOrder.Opportunities__r.size() > 0)
                {
                    if(objPaymentOrder.Opportunities__r[0].StageName == 'Posted')
                    {
                        string str = SendITCertificate.sendTaxForm(objPaymentOrder.Id);
                        if(str == Label.Mail_Sent_Success_Msg)
                        {
                            objPaymentOrder.Is_Email_sent__c = true;
                            objPaymentOrder.Email_sent_date__c = System.now();
                            listPaymentOrdersToUpdate.add(objPaymentOrder);
                        }
                    }
                }
            }
        }
        if(listPaymentOrdersToUpdate != null && listPaymentOrdersToUpdate.size() > 0)
        {
            Update listPaymentOrdersToUpdate;
        }
    }
}