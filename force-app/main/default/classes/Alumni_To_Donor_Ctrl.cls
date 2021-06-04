/*
    * @Purpose      : Controller class for DonorRegistration Page.
    * @Author       : Amritesh
    */
public class Alumni_To_Donor_Ctrl {
    
    public string DRscholarResidenstilPickValues    {get;set;}
    public string CitizenIndian						{get;set;}
    public string CitizenNonIndian					{get;set;}
    public string confirmationMsg					{get;set;}
    public string donorCategory						{get;set;}
    public string aadharErrMsg						{get;set;}
    public string panErrMsg							{get;set;}
	public string mobileErrMsg						{get;set;}
    public String googleAndFacebookdup              {get;set;}
    public string isStudentMsg                      {get;set;}
    public string newConfirMsg                      {get;set;}
    public integer currentYear                      {get;set;}
    public string countryList	                    {get;set;}
    public string listOfStates                      {get;set;}
    
   @RemoteAction
    public static Alumni_To_Donor_Ctrl.messageWrapper createDonorInSFDC(Contact contactFromPage){
    	return Alumini_To_Donor_Helper.createDonorInSFDC(contactFromPage);
    }
    
    @RemoteAction
    public static String updateAlumniEmail(String currentEmail,String Mobile,String Pan,String aadhar,String alumniEmail){
    	return Alumini_To_Donor_Helper.updateAlumniEmail(currentEmail,alumniEmail,Mobile,pan,aadhar);
    }

    @RemoteAction
    public static String sendEmail(String email){
    	return Alumini_To_Donor_Helper.sendEmail(email);
    }
    
    @RemoteAction
    public static List<State_Master__mdt> getStateList(String countryName){
        return Utility.getStates(countryName);
    }
    
    @RemoteAction
    public static List<State_City_Master__c> getCityList(String StateName){
        return DN_QuickDonatciopn_HLPR.getAllCities(StateName);
    }
    public Alumni_To_Donor_Ctrl(){
        DRscholarResidenstilPickValues	= JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_RESIDENTIAL_STATUS)).trim();
    	CitizenIndian 				  	= Constants.CITIZENSHIP_INDIAN;
        CitizenNonIndian              	= Constants.CITIZENSHIP_NON_INDIAN;   
        confirmationMsg					= Constants.Email_Updation_Message;
        newConfirMsg                    = Constants.SUCCESS_REGISTERED_MSG;
        aadharErrMsg					= Constants.Aadhar_Err_Msg;
        panErrMsg						= Constants.PAN_Duplicate_Error_message;
        mobileErrMsg					= Constants.MOBILE_DUPLICATE_ERR_MSG;
        googleAndFacebookdup            = Constants.EMAIL_DUPLICATE_ERR_MSG;
        isStudentMsg                    = Constants.googleFacebookDuplicate_Email;  
        donorCategory					= JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_CATEGORY)).trim();
    	currentYear                     = system.today().year();
        countryList						= JSON.serializePretty(Utility.getCountryList());
        listOfStates                   	= JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
    }
    
    public class messageWrapper {
		public string message;
		public string recordId;
        
        public messageWrapper(){
            message	= '';
            recordId= '';
        }
    }

}