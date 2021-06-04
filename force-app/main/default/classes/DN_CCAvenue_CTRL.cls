/*
@Purpose     : This class creates a encrypted request for ccAvenue Payment Gateway 
@CreatedDate : 08/02/2017
@Author      : Amritesh
*/
public class DN_CCAvenue_CTRL {
    
    public string ACCESS_CODE   {get; set;}
    public String encRequest    {get; set;}
    public string postURL		{get; set;}

    public DN_CCAvenue_CTRL(){        
        try{
            postURL					= CCAvenue_Details__c.getInstance().CCAvenue_Transaction_URL__c;
            string encryString      = ApexPages.currentPage().getParameters().get('p');
            urlParameters(encryString);     
        }catch(Exception ex){HandleBusinessException.captureError('DN_CCAvenue_CTRL', 'DN_CCAvenue_CTRL', ex);}      
      
    }
    
    // This method decrypts enrypted url value and use all url parameters to form 
    // encrypted data string for CCAvenue Payment
    public void urlParameters(string encryString){
        string decryParam	= DN_CCAvenue_Service.decryptString(encryString, DN_ServiceConstants.DN_ORDER_KEY);
        String[] resDetails	= decryParam.split('&');
        
        string orderId;
        string currencyType;
        string amountVal;
        
        for(String pair : resDetails){
            String[] entry = pair.split('=',-1); 
            if(entry.size() == 2){
                if(entry[0].trim() == DN_ServiceConstants.ORDER_PARAM)
                    if(entry[1].trim() != null) orderId	= entry[1].trim();              
                if(entry[0].trim() == DN_ServiceConstants.CURRENCY_PARAM)
                    if(entry[1].trim() != null) currencyType	= entry[1].trim();
                if(entry[0].trim() == DN_ServiceConstants.AMOUNT_PARAM)
                    if(entry[1].trim() != null) amountVal	= entry[1].trim();
            }
        }
        
        double amount	= double.valueOf(amountVal);
        getRequestString(DN_CCAvenue_Service.getPaymentOrderInfo(orderId),currencyType,amount);

    }
    
    // This method checks FCRA/Non-FCRA ccAvenue details based on Currency Type and
    // forms a encrypted string based on FCRA/Non-FCRA ccAvenue Detail,donor details and donation detail.
    public void getRequestString(Payment_Order__c pOrder, string currencyType, double amount){
        
        try{
        
            // Get CCAvenue working Key,Access Code and other details
            CCAvenue_Details__c ccDetails   = CCAvenue_Details__c.getInstance();
            String merchantId;
            String Plain_Text;
            String workingKey;
            string redirecturl;
            string cancelURL;
            string ccAvenueCurrency;
                
            if(currencyType == DN_ServiceConstants.USD_CURRENCY){                
                if(ccDetails.INR_Transaction_for_FCRA_Account__c){
                    ccAvenueCurrency	= DN_ServiceConstants.INR_CURRENCY;
                }else{
                    ccAvenueCurrency	= currencyType;
                }
                merchantId  = ccDetails.FCRA_Merchant_ID__c;
                ACCESS_CODE = ccDetails.FCRA_Access_Code__c;
                workingKey  = ccDetails.FCRA_Working_Key__c;
                redirecturl = ccDetails.Redirect_URL_For_USD_Transaction__c;
                cancelURL	= ccDetails.Cancel_URL_for_USD_Transaction__c;
            }
            
            if(currencyType == DN_ServiceConstants.INR_CURRENCY){
                ccAvenueCurrency	= currencyType;
                merchantId  		= ccDetails.Non_FCRA_Merchant_ID__c;
                ACCESS_CODE 		= ccDetails.Non_FCRA_Access_Code__c;
                workingKey  		= ccDetails.Non_FCRA_Working_Key__c;
                redirecturl 		= ccDetails.Redirect_URL_For_INR_Transaction__c;
                cancelURL			= ccDetails.Cancel_URL_for_INR_Transaction__c;
            }
            
            Long tstamp = System.now().getTime();
            Plain_Text  = 'tid='+pOrder.Transaction_ID__c+tstamp+'&merchant_id='+merchantId+'&order_id='+pOrder.Order_No__c+'&amount='+amount+'&currency='+ccAvenueCurrency+'&redirect_url='+redirecturl+'&cancel_url='+cancelURL+'&language=EN&billing_name='+pOrder.donor__r.Name+'&billing_address='+pOrder.donor__r.MailingStreet+'&billing_city='+pOrder.donor__r.MailingCity+'&billing_state='+pOrder.donor__r.MailingState+'&billing_zip='+pOrder.donor__r.MailingPostalCode+'&billing_country='+pOrder.donor__r.MailingCountry+'&billing_tel='+pOrder.donor__r.MobilePhone+'&billing_email='+pOrder.donor__r.Email+'&delivery_name='+pOrder.donor__r.Name+'&delivery_address='+pOrder.donor__r.MailingStreet+'&delivery_city='+pOrder.donor__r.MailingCity+'&delivery_state='+pOrder.donor__r.MailingState+'&delivery_zip='+pOrder.donor__r.MailingPostalCode+'&delivery_country='+pOrder.donor__r.MailingCountry+'&delivery_tel='+pOrder.donor__r.Phone;
            encRequest	= DN_CCAvenue_Service.encryptString(Plain_Text, workingKey);

        }catch(Exception ex){
            HandleBusinessException.captureError('DN_CCAvenue_CTRL', 'getRequestString', ex);
        }
    } 
}