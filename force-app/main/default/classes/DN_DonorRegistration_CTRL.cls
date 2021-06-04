/*
    * @Purpose      : Controller class for DonorRegistration Page.
    * @Author       : Amritesh
    */

public class DN_DonorRegistration_CTRL {
    
    public string DRscholarResidenstilPickValues    {get;set;}
    public string CitizenIndian						{get;set;}
    public string CitizenNonIndian					{get;set;}
    public string confirmationMsg					{get;set;}
    public string donorCategory						{get;set;}
    
   @RemoteAction
    public static DN_DonorRegistration_CTRL.messageWrapper createDonorInSFDC(Contact contactFromPage){
    	return DN_DonorRegistration_Helper.createDonorInSFDC(contactFromPage);
    }
    
    @RemoteAction
    public static string uploadDoc(String attachmentBody,string attachmentName,string attparentId,String attachmentId){
        return Utility.uploadAttachment(attachmentBody,attachmentName,attparentId,attachmentId);
    }
    
    public DN_DonorRegistration_CTRL(){
        DRscholarResidenstilPickValues	= JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_RESIDENTIAL_STATUS)).trim();
    	CitizenIndian 				  	= Constants.CITIZENSHIP_INDIAN;
        CitizenNonIndian              	= Constants.CITIZENSHIP_NON_INDIAN;   
        confirmationMsg					= Constants.SUCCESS_REGISTERED_MSG;
        donorCategory					= JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_CATEGORY)).trim();
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