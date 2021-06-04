/*
* @purpose : Controller for Quick Donation Page
*/ 
public class DN_QuickDonation {
    
    //public string programs    {get;set;}
    static string Currency_Type     = 'INR';
    public string DRscholarResidenstilPickValues    {get;set;}
    public string CitizenIndian                     {get;set;}
    public string deletePayment                     {get;set;}
    public string CitizenNonIndian                  {get;set;}
    public string countryList                       {get;set;}
    public string listOfStates                      {get;set;}
    public String docBody                           {get;set;}
    public String baseURL                           {get;set;}
    public DN_QuickDonation(){       
        initialize();
    }
    
    @RemoteAction 
    public static DN_OrderConfirmationWrapper makeDonation(DN_PaymentWrapper orderwrp){  
        //checks if donor present his Id will be attached or else new donor will be created and his Id will be attached
        DN_PaymentWrapper PaymentorderDonorWrp  =   DN_QuickDonatciopn_HLPR.checkIsDonorPresent(orderwrp);
        
        DN_OrderConfirmationWrapper orderCofirmWrp = DN_QuickDonatciopn_HLPR.paymentOrederCreation(PaymentorderDonorWrp);
        
        return orderCofirmWrp; 
    }
    
    //Prithvi: chaned to meed new UI needs.
    @RemoteAction
    public static Map<String,List<Donation_Program__c>> getDonationPrograms(){
        return DN_Donorprofile_Helper.getDonationsPerProgram(Currency_Type);
    }
    
    
    @RemoteAction 
    Public static void cancelDonation(string orderId, string orderStatus){
        if(orderStatus  == DN_ServiceConstants.PAYMENT_CANCEL){
            DN_CCAvenue_Service.updatePaymentToAborted(orderId, orderStatus);        
        }else{
            DN_CCAvenue_Service.deleteExistingPaymentOrder(orderId);          
        }
    }
    
    @RemoteAction
    public static List<State_Master__mdt> getStateList(String countryName){
        return Utility.getStates(countryName);
    }
    
    
    @RemoteAction
    public static List<State_City_Master__c> getCityList(String StateName){
        return DN_QuickDonatciopn_HLPR.getAllCities(StateName);
    }
    
    public void initialize(){
        DRscholarResidenstilPickValues  = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_RESIDENTIAL_STATUS));
        CitizenIndian                   = Constants.CITIZENSHIP_INDIAN;
        CitizenNonIndian                = Constants.CITIZENSHIP_NON_INDIAN;
        deletePayment                   = DN_ServiceConstants.PAYMENT_DELETE;
        countryList                     = JSON.serializePretty(Utility.getCountryList());
        listOfStates                    = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
        baseURL                         = URL.getSalesforceBaseUrl().toExternalForm();
    }
    
}