/*
@Purpose     : This class handles Donation/Recurring donation creation and Processing of CCAvenue Request/Response. 
@CreatedDate : 13/02/2017
@Author      :Amritesh
*/
public class DN_CCAvenue_Service {
    
    /*@purpose  	: This method is used to differentiate diff kind of donation program and frequecy
     *            	  after donors proceed for payment through their profile page.
     * @param   	: donorInfo
     * @param   	: donationAmt
     * @param   	: frequencyId
     * @returnType	: DN_OrderConfirmationWrapper is wrapper class which
     *                is a collection of Donor record,Donation record,Error message and Order Encrypted String
     */
    public DN_OrderConfirmationWrapper createDonationOrderInSFDB(DN_PaymentWrapper paymentwrp){
    	
    	DN_OrderConfirmationWrapper returnOrderDetails	= new DN_OrderConfirmationWrapper();
    	
        try{
            
            double orderAmount = 0;
            // Check if Payment Currency is in USD,then convert into INR
            if(paymentwrp.currencyType == DN_ServiceConstants.USD_CURRENCY){
                orderAmount	= paymentwrp.totalOrderAmountUSD; 
            }else{
                orderAmount	= paymentwrp.totalOrderAmountINR;
            }
            
            if(paymentwrp.programs.size() == 0){
                returnOrderDetails.errorMsg	= DN_ServiceConstants.DONATION_FAILED_ERROR_MSG;
                return returnOrderDetails;
            }
            
            String paymentOrderId	= createPaymentOrder(paymentwrp);
            if(paymentOrderId	== DN_ServiceConstants.SYSTEM_ERROR){
               returnOrderDetails.errorMsg	= DN_ServiceConstants.DONATION_FAILED_ERROR_MSG;
               return returnOrderDetails;
            }
            
            List<Opportunity> generalDonations					= new List<Opportunity>();
            List<npe03__Recurring_Donation__c> recurDonations	= new List<npe03__Recurring_Donation__c>();
            
            for(DN_PaymentWrapper.programWrapper pr : paymentwrp.programs){
               
                if(pr.frequency.Frequency__c == DN_ServiceConstants.RECURRING_PAYMENT){
                    // Create Recurring Donation
                    recurDonations.add(getRecurringDonationObj(paymentwrp.donorRecord, pr, paymentOrderId, paymentwrp.currencyType));
                }else{
                    // Create General Donation
                    generalDonations.add(getDonationObj(paymentwrp.donorRecord, pr, paymentOrderId, paymentwrp.currencyType));
                }
                
            }            
            
            insert recurDonations;
            insert generalDonations;           
            
            if(recurDonations.size() > 0 &&	paymentOrderId != null)
            	updateRecurDonationsOrder(recurDonations, paymentOrderId);
            
            returnOrderDetails.orderInfo	= getPaymentOrderInfo(paymentOrderId);
            returnOrderDetails.orderString	= getEncryptedURLParams(paymentOrderId, paymentwrp.currencyType, orderAmount);
            returnOrderDetails.redirectURL	= CCAvenue_Details__c.getInstance().CCAvenue_registered_site_url__c+'?p='+returnOrderDetails.orderString;
            return returnOrderDetails;            
        }catch(Exception ex){
            returnOrderDetails.errorMsg	= DN_ServiceConstants.DONATION_FAILED_ERROR_MSG;
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'createDonationOrderInSFDB', ex);
            return returnOrderDetails;
        }              
    }
    
    /*@purpose	: Create Payment Order record for Donation Transaction
     *@param	: paymentwrp is wrapper of DN_PaymentWrapper type
	 *@returnType: string
     */
    public string createPaymentOrder(DN_PaymentWrapper paymentwrp){
        
        try{
            Payment_Order__c pOrder	= new Payment_Order__c();
            
            if(paymentwrp.currencyType != null)
                pOrder.Currency__c	= paymentwrp.currencyType;
            if(paymentwrp.donorRecord != null)
                pOrder.Donor__c	    = paymentwrp.donorRecord.Id; 
            if(paymentwrp.totalOrderAmountINR != null)
                pOrder.Order_Amount__c	= paymentwrp.totalOrderAmountINR;
            if(paymentwrp.totalOrderAmountUSD != null){
                pOrder.Order_Amount_USD__c	= paymentwrp.totalOrderAmountUSD;
                pOrder.Order_Amount__c		= Utility.getUSDtoINRConvertedAmt(Double.valueOf(paymentwrp.totalOrderAmountUSD)); 
            }
                
            
            pOrder.Transaction_Start_Time__c	= system.now();
            pOrder.Transaction_Date__c			= system.today();
            pOrder.Order_No__c					= 'DN'+string.ValueOf(system.now().getTime())+generateRandomString('1234567890', 10);
            pOrder.Transaction_ID__c			=  generateRandomString('12345678', 8)+string.ValueOf(system.now().getTime());
            
            string programs						= '';
            string frequecy						= '';
            for(DN_PaymentWrapper.programWrapper pr : paymentwrp.programs){
                programs	+= pr.frequency.Program__r.Program__c+',';
                frequecy	+= pr.frequency.Name+',';
            }
            
            pOrder.Programs__c		= programs.substring(0,programs.length()-1);
            pOrder.Frequencies__c	= frequecy.substring(0,frequecy.length()-1);
            
            insert pOrder;            
            return pOrder.Id;            
        }catch(Exception ex){
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'createPaymentOrder', ex);
            return DN_ServiceConstants.SYSTEM_ERROR;
        }
    }
    
	/*
    * @Purpose: Generate a random unique string.
    * @returnType: string
    */
    public static String generateRandomString(string randomString, Integer len ){
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), randomString.length());
            randStr += randomString.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    /*@purpose 	: Tag Payment Order to 1st Donation under the Recurring Donations
     * @param   : recDonations
     * @param   : paymentOrderId
     */
    public static void updateRecurDonationsOrder(List<npe03__Recurring_Donation__c> recDonations, string paymentOrderId){
        try{           
            List<Opportunity> donationList  = [Select id,Name,Amount,Payment_Order__c from Opportunity 
                                               where npe03__Recurring_Donation__c = :recDonations AND
                                               CloseDate=:system.today() AND 
                                               Name like :('%'+DN_ServiceConstants.FIRST_OF_RECDONATION_STRING+'%')];
            
            List<opportunity> updateList	= new List<opportunity>();
            if(donationList.size() > 0){
                for(Opportunity op : donationList){
                    if(op.Payment_Order__c == null)
                    	updateList.add(new Opportunity(Id=op.Id,Payment_Order__c= paymentOrderId));
                }
            }

            if(updateList.size()>0) update updateList;            
        }catch(Exception ex){
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'updateRecurDonationsOrder', ex);
        } 
        
    }
    
     /*@purpose  	: This method is used to concatinate donorId,donationId,Currency & amount, encrypt 
     *            	  the concatinated string with a defined key and return this encrypted string.
     *            	  This encrypted string will be used for payment gatewayd URL redirection.
     * @param   	: donorId
     * @param   	: donationId
     * @returnType	: string
     */
    public string getEncryptedURLParams(string orderId, string currencyType, decimal amount){        
        string mergedIds    = DN_ServiceConstants.ORDER_PARAM+'='+orderId+'&'+DN_ServiceConstants.CURRENCY_PARAM+'='+currencyType+'&'+DN_ServiceConstants.AMOUNT_PARAM+'='+amount;
        return encryptString(mergedIds,DN_ServiceConstants.DN_ORDER_KEY);      
    }
    
    
     /*@purpose 	: Get Recurring Donation record
     * @param   	: donorInfo
     * @param   	: amount
     * @param   	: frequency
     * @returnType	: npe03__Recurring_Donation__c
     */
    private npe03__Recurring_Donation__c getRecurringDonationObj(Contact donorInfo, DN_PaymentWrapper.programWrapper program ,string paymentOrderId, String currencyType){
        
        npe03__Recurring_Donation__c recDonation    = new npe03__Recurring_Donation__c();
        recDonation.Name                            = donorInfo.Name+' '+DN_ServiceConstants.RECURRING_DONATION;
        recDonation.npe03__Amount__c                = program.programAmountINR;
        recDonation.npe03__Date_Established__c      = system.today();
        recDonation.npe03__Installment_Period__c    = program.frequency.Installment_Period__c;        
        recDonation.npe03__Installments__c          = program.frequency.Installments__c;
        recDonation.npe03__Schedule_Type__c         = DN_ServiceConstants.SCHEDULE_TYPE_MULTIPLY;
        recDonation.npe03__Contact__c               = donorInfo.Id;
        recDonation.No_of_Student__c				= program.studentCount;
        recDonation.Program_Frequency__c			= program.frequency.Id;
        recDonation.Payment_Order__c				= paymentOrderId;
        recDonation.Currency__c						= currencyType;
        if(program.programAmountUSD !=  null && program.programAmountUSD > 0){
            recDonation.Amount_USD__c			= program.programAmountUSD;
            recDonation.npe03__Amount__c		= Utility.getUSDtoINRConvertedAmt(double.valueOf(program.programAmountUSD));
            Decimal conversionRate	= System_Details__c.getInstance().USD_to_INR_Rate__c;
                  
        }
        
        return recDonation;
    }   
    
    /*@purpose  	: Get Donation(Opportunity) record
     *@param   		: donorInfo
     *@param   		: amount
     *@param   		: frequency
     *@returnType	: Opportunity
     */
   private Opportunity getDonationObj(Contact donorInfo, DN_PaymentWrapper.programWrapper program, string paymentId,String currencyType){
        
        Opportunity donationOpp                 = new Opportunity();
        donationOpp.Name                        = donorInfo.Name +' '+ DN_ServiceConstants.GENERAL_DONATION;
        donationOpp.CloseDate                   = system.today();
        donationOpp.StageName                   = DN_ServiceConstants.PLEDGED_DONATION;
        donationOpp.npsp__Primary_Contact__c    = donorInfo.Id;
        donationOpp.Amount                      = program.programAmountINR;
        donationOpp.Payment_Order__c			= paymentId;
        donationOpp.Program_Frequency__c		= program.frequency.Id;
        donationOpp.No_of_Student__c			= program.studentCount;
        donationOpp.RecordTypeId                = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(DN_ServiceConstants.DONATION_RECORDTYPE).getRecordTypeId();
        donationOpp.Currency__c					= currencyType;

       if(program.programAmountUSD !=  null && program.programAmountUSD > 0){
           donationOpp.Amount_USD__c	= program.programAmountUSD;
           donationOpp.Amount			= Utility.getUSDtoINRConvertedAmt(double.valueOf(program.programAmountUSD));            
       }       
       return donationOpp;
    }
        
    /*@purpose  	: Process CCAvenue Response message and Create Payment Gateway 
     * 				  response record for the Donation made.
     *@param   		: string    
     *@returnType	: Program_Frequency__c
	*/
    public static string processCCAvenueResponse(string resposne, string orderId){
        string orderStatus;        
        try{
            String[] resDetails 				= resposne.split('&');
            Map<string,string> responseMap		= new Map<string,string>();
            
            Payment_Gateway_Response__c	resobj	= new Payment_Gateway_Response__c();
            
            for(String pair : resDetails){
                String[] entry = pair.split('=',-1); 
                if(entry.size() == 2){
                    if(entry[0].trim() == ccAvenueResponseWrapper.TRACKING_ID)
                        if(entry[1].trim() != null) resobj.Tracking_ID__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BANK_REF_NO)
                        if(entry[1].trim() != null) resobj.Bank_Ref_No__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.ORDER_STATUS)
                        if(entry[1].trim() != null){
                            resobj.Order_Status__c	= entry[1].trim();
                            orderStatus	= entry[1].trim();
                        } 
                    if(entry[0].trim() == ccAvenueResponseWrapper.FAILURE_MSG)
                        if(entry[1].trim() != null) resobj.Failure_Message__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.PAYMENT_MODE)
                        if(entry[1].trim() != null) resobj.Payment_Mode__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.CARD_NAME)
                        if(entry[1].trim() != null) resobj.Card_Name__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.STATUS_CODE)
                        if(entry[1].trim() != null) resobj.Status_Code__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.AMOUNT)
                        if(entry[1].trim() != null) resobj.Order_Amount__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.CURRENCY_LABEL)
                        if(entry[1].trim() != null) resobj.Currency__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.STATUS_MSG)
                        if(entry[1].trim() != null) resobj.Status_Message__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_NAME)
                        if(entry[1].trim() != null) resobj.Billing_Name__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_ADDSS)
                        if(entry[1].trim() != null) resobj.Billing_Address__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_CITY)
                        if(entry[1].trim() != null) resobj.Billing_City__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_STATE)
                        if(entry[1].trim() != null) resobj.Billing_State__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_ZIP)
                        if(entry[1].trim() != null) resobj.Billing_Zip__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_COUNTRY)
                        if(entry[1].trim() != null) resobj.Billing_Country__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_TEL)
                        if(entry[1].trim() != null) resobj.Billing_Phone__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BILLING_EMAIL)
                        if(entry[1].trim() != null) resobj.Billing_Email__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_NAME)
                        if(entry[1].trim() != null) resobj.Delivery_Name__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_ADDRESS)
                        if(entry[1].trim() != null) resobj.Delivery_Address__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_CITY)
                        if(entry[1].trim() != null) resobj.Delivery_City__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_STATE)
                        if(entry[1].trim() != null) resobj.Delivery_State__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_ZIP)
                        if(entry[1].trim() != null) resobj.Delivery_Zip__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_COUNTRY)
                        if(entry[1].trim() != null) resobj.Delivery_Country__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DELIVERY_TEL)
                        if(entry[1].trim() != null) resobj.Delivery_Phone__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.MERCHANT_PARAM1)
                        if(entry[1].trim() != null) resobj.Merchant_Param1__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.MERCHANT_PARAM2)
                        if(entry[1].trim() != null) resobj.Merchant_Param2__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.MERCHANT_PARAM3)
                        if(entry[1].trim() != null) resobj.Merchant_Param3__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.MERCHANT_PARAM4)
                        if(entry[1].trim() != null) resobj.Merchant_Param4__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.MERCHANT_PARAM5)
                        if(entry[1].trim() != null) resobj.Merchant_Param5__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.VAULT)
                        if(entry[1].trim() != null) resobj.Vault__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.OFFER_TYPE)
                        if(entry[1].trim() != null) resobj.Offer_Type__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.OFFER_CODE)
                        if(entry[1].trim() != null) resobj.Offer_Code__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.DISCOUNT_VALUE)
                        if(entry[1].trim() != null) resobj.Discount_Value__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.MER_AMOUNT)
                        if(entry[1].trim() != null) resobj.Mer_Amount__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.ECI_VALUE)
                        if(entry[1].trim() != null) resobj.ECI_Value__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.RETRY)
                        if(entry[1].trim() != null) resobj.Retry__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.RESPONSE_CODE)
                        if(entry[1].trim() != null) resobj.Response_Code__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.TRANS_DATE)
                        if(entry[1].trim() != null) resobj.Transaction_Date__c	= entry[1].trim();
                    if(entry[0].trim() == ccAvenueResponseWrapper.BIN_COUNTRY)
                        if(entry[1].trim() != null) resobj.Bin_Country__c	= entry[1].trim();
                    
                    resobj.Order_Id__c	= orderId;
                }
            }           
            
            updateExistingPaymentOrder(orderId, orderStatus, resobj);
            
        }catch(Exception ex){
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'processCCAvenueResponse', ex);
        }        
        return orderStatus;
    }
    
	/*@purpose	: Update existing payment Order status and related Recurring donation
	* @param	: orderId
	* @param	: orderStatus
	* @param	: response
	*@returnType: String
	*/
	public static void updateExistingPaymentOrder(String orderId, String orderStatus, Payment_Gateway_Response__c response){
        
        try{
            Payment_Order__c pOrder	= new Payment_Order__c();
            pOrder					= [Select Id,CCAvenue_Payment_Status__c,
                                       (Select id from Recurring_Donations__r)
                                       from Payment_Order__c where Order_No__c =: orderId];
            
            if(response != null){
                response.Payment_Order__c = pOrder.Id;
                Insert response; 
            }            
            
            pOrder.CCAvenue_Payment_Status__c		= orderStatus;
            pOrder.Transaction_Completion_Time__c	= system.now();
            update pOrder;	
            
            try{
                if(pOrder.Recurring_Donations__r != null && pOrder.Recurring_Donations__r.size() > 0)
                	updateRecurDonationsOrder(pOrder.Recurring_Donations__r,pOrder.id); 
            }catch(Exception e){ 
                HandleBusinessException.captureError('DN_CCAvenue_Service', 'updateExistingPaymentOrder', e);
                system.debug(e);
            }
            
        }catch(exception e){
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'updateExistingPaymentOrder', e);
            system.debug(e);
        }        
    }
    
    /*@purpose	: Encrypt a string using MD5 hash Algorithm and AES129 Encryption Algorithm
     *@param	: Plain_Text
	 *@param	: encrypKey
	 *@returnType: string
     */
    public static string encryptString(string Plain_Text, string encrypKey){        
        Blob cryptoKey          = Blob.valueOf(encrypKey);       
        Blob hash               = Crypto.generateDigest(DN_ServiceConstants.HASH_FUNCTION_ALOGORITHM, cryptoKey);        
        Blob data               = Blob.valueOf(Plain_Text);  
        Blob encryptedData      = Crypto.encryptWithManagedIV(DN_ServiceConstants.ENCRYPTION_ALOGORITHM, hash , data);        
        return EncodingUtil.convertToHex(encryptedData);
    }
    
    /*@purpose	: Decrypt an encrypted string using MD5 hash Algorithm and AES129 Encryption Algorithm
     *@param	: ecryString
	 *@param	: decryKey
	 *@returnType: string
     */
    public static string decryptString(string encryString, string decryKey){
        Blob cryptoKey 					= Blob.valueOf(decryKey);
        Blob hash						= Crypto.generateDigest(DN_ServiceConstants.HASH_FUNCTION_ALOGORITHM, cryptoKey);
        Blob data 						= EncodingUtil.convertFromHex(encryString);
        Blob decryptedText 				= Crypto.decryptWithManagedIV(DN_ServiceConstants.ENCRYPTION_ALOGORITHM, hash, data);
        return decryptedText.toString();
    }    
    
   /*@purpose	: Get Paymen Order Info 
    *@param		: orderId
    *@returnType: Contact
    */
    public static Payment_Order__c getPaymentOrderInfo(string orderId){
        return [select id,Currency__c,Donor__c,Order_Amount__c,Order_Amount_USD__c,Order_No__c,Transaction_Date__c,
                Transaction_ID__c,Donor__r.Name,Donor__r.Email,Donor__r.MobilePhone,Donor__r.npe01__WorkEmail__c,
                Donor__r.npe01__WorkPhone__c,Donor__r.MailingStreet,Donor__r.MailingCity,Donor__r.MailingState,
                Donor__r.MailingPostalCode,Donor__r.MailingCountry,Donor__r.Phone
                from Payment_Order__c where Id =: orderId];
    }
    
    /*@purpose	: Create Order for Pending Donation
     *@param	: pwrp wrapper object of type DN_PaymentWrapper
	 *@praram	: donationId 
	 *@returnType:DN_OrderConfirmationWrapper
     */
    public DN_OrderConfirmationWrapper createPendingDonationOrder(DN_PaymentWrapper pwrp, String donationId, string orderId){
        Savepoint sp	= Database.setSavepoint();
        DN_OrderConfirmationWrapper returnOrderDetails 	= new DN_OrderConfirmationWrapper();
        
        try{
            // Delete Previous Order If tagged with only current Donation
            if(orderId != null){
                try{
                    List<Opportunity> existingDonation	= new List<Opportunity>([Select id from Opportunity where Payment_Order__c =:orderId]);
                    if(existingDonation.size() == 1){
                        delete new Payment_Order__C(Id=orderId);
                    }
                }catch(Exception e){
                    HandleBusinessException.captureError('DN_CCAvenue_Service', 'createPendingDonationOrder', e);
                }
            }
            
            String paymentOrderId	= createPaymentOrder(pwrp);
            // Create New Payment Order
            if(paymentOrderId	== DN_ServiceConstants.SYSTEM_ERROR){
               returnOrderDetails.errorMsg	= DN_ServiceConstants.DONATION_FAILED_ERROR_MSG;
            }
            
            string frequecyId;	
            Integer noOfStudent;
            
            try{
                if(pwrp.programs.size() > 0){
                    frequecyId		= pwrp.programs[0].frequency.Id;
                    noOfStudent		= pwrp.programs[0].studentCount;  
                } 
            }catch(Exception ex){
                HandleBusinessException.captureError('DN_CCAvenue_Service', 'createPendingDonationOrder', ex);
            }            
           	
            // Update Existing Opportunity Record
            if(frequecyId !=null && noOfStudent != null){
               update new Opportunity(Id = donationId,Payment_Order__c=paymentOrderId,Program_Frequency__c=frequecyId,No_Of_Student__c=noOfStudent); 
            }else{
                update new Opportunity(Id = donationId,Payment_Order__c=paymentOrderId);
            }            
            
            double orderAmount = 0;
            // Check if Payment Currency is in USD,then convert into INR
            if(pwrp.currencyType == DN_ServiceConstants.USD_CURRENCY){              
                orderAmount	= pwrp.totalOrderAmountUSD;
            }else{
                orderAmount	= pwrp.totalOrderAmountINR;
            }
            
            returnOrderDetails.orderInfo	= getPaymentOrderInfo(paymentOrderId);
            returnOrderDetails.orderString	= getEncryptedURLParams(paymentOrderId, pwrp.currencyType, orderAmount);
            returnOrderDetails.redirectURL	= CCAvenue_Details__c.getInstance().CCAvenue_registered_site_url__c+'?p='+returnOrderDetails.orderString;

        }catch(Exception ex){
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'createPendingDonationOrder', ex);
            database.rollback(sp); 
            returnOrderDetails.errorMsg	= DN_ServiceConstants.DONATION_FAILED_ERROR_MSG;
        }
        
        return returnOrderDetails;
    }
    
    /*
     * @purpose : Delete Payment Order and related donations & Recurring donations
     * @param	: orderId is Payment Order record Id
     */ 
    public static void deleteExistingPaymentOrder(string orderId){
        try{            
            delete [Select id,(select id from npe03__Donations__r) from npe03__Recurring_Donation__c where Payment_Order__c =: orderId];
            delete [Select id from Payment_Order__c where Id =: orderId];
            delete [Select id from Opportunity where Payment_Order__c =: orderId];
        }catch(Exception e){}
    } 
    
     /*
     * @purpose : Update Payment order as Aborted once cancelled.
     * @param	: orderId is Payment Order record Id
     * @param	: OrderStatus 
     */ 
    public static void updatePaymentToAborted(string orderId, string OrderStatus){
        try{
            Payment_Order__c pOrder					= new Payment_Order__c(); 
            pOrder.Id								= orderId;
            pOrder.CCAvenue_Payment_Status__c		= orderStatus;
            pOrder.Transaction_Completion_Time__c	= system.now();
            update pOrder;	
        }catch(Exception e){
            HandleBusinessException.captureError('DN_CCAvenue_Service', 'updatePaymentToAborted', e);
        }
    } 
}