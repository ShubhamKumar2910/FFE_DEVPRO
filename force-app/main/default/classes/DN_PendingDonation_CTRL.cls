/*
*@purpose    : updates Payment order for Donation
*@returnType : PageReference
*/
public class DN_PendingDonation_CTRL {
    
    public String errorMsg  {get;set;}
    public string sURL      {get; set;}
    
    
    public PageReference DN_PendingDonation_CTRL(){
        
        try{
            
            
            string donationID                           =   ApexPages.currentPage().getParameters().get('id');
            
            
            Opportunity donation                        =   [SELECT id,name,npsp__Primary_Contact__c,Amount,Amount_USD__c,CloseDate,No_of_Student__c,Payment_Order__c,Payment_Status__c,Program_Frequency__c,Currency__c,npe03__Recurring_Donation__c,npsp__Requested_Amount__c,npe01__Amount_Outstanding__c,Order_No__c 
                                                             From Opportunity 
                                                             where id =: donationID ];
            
            if(donation.Payment_Order__c != null){
                PageReference pg    =  new PageReference('/');
                return pg;
            } 
            else
            {
                DN_PaymentWrapper  pnWP                 =       new DN_PaymentWrapper ();
                pnWP.programs                           =       new List<DN_PaymentWrapper.programWrapper>();
                DN_PaymentWrapper.programWrapper pp     =       new DN_PaymentWrapper.programWrapper();
                
                
                pnWP.donorRecord                        =       [SELECT id,name,Email,MobilePhone,npe01__WorkEmail__c,npe01__WorkPhone__c,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone 
                                                                 from contact 
                                                                 where id =:donation.npsp__Primary_Contact__c];
                
                pnWP.currencyType = donation.Currency__c;
                
                if(donation.Currency__c == DN_ServiceConstants.INR_CURRENCY){
                    
                    pnWP.totalOrderAmountINR=donation.Amount;
                }
                else{
                    
                    pnWP.totalOrderAmountUSD=donation.Amount_USD__c;
                }
                
                pp.studentCount = Integer.Valueof(donation.No_of_Student__c);
                
                pp.frequency                            =       [SELECT id,name,Program__c,Program__r.Program__c,Amount__c 
                                                                 from Program_Frequency__c 
                                                                 where id = :donation.Program_Frequency__c];
                
                if(donation.Currency__c == DN_ServiceConstants.INR_CURRENCY){
                    
                    pp.programAmountINR = donation.Amount;
                }
                else{
                    
                    pp.programAmountUSD = donation.Amount_USD__c;
                }
               
                pnWP.programs.add(pp);
               
                DN_CCAvenue_Service newDonation         =       new DN_CCAvenue_Service();
                DN_OrderConfirmationWrapper  returnOrderDetails = new DN_OrderConfirmationWrapper();
                returnOrderDetails =  newDonation.createPendingDonationOrder(pnWP, donationID, null);
                
                sURL = returnOrderDetails.redirectURL;
                
                if(returnOrderDetails.errorMsg != null){
                    
                    errorMsg = returnOrderDetails.errorMsg;
                }
            }
        }catch(Exception ex){
            HandleBusinessException.captureError('DN_PendingDonation_CTRL', 'DN_PendingDonation_CTRL', ex);
            system.debug(ex.getMessage());
        } 
        
        return null;
    }
    
}