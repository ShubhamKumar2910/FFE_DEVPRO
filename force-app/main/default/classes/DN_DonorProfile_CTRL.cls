/*
* @Purpose      : Controller for DonorProgile
* @Author       : Amritesh
*/

public class DN_DonorProfile_CTRL {
    
    public string DRscholarResidenstilPickValues    {get;set;}
    public string CitizenIndian                     {get;set;}
    public string CitizenNonIndian                  {get;set;}
    public string paymentWrpString                  {get;set;}
    public string currentdonorId                    {get;set;}
    public string updateSuccessMsg                  {get;set;}
    static String code;
    public string donorCurrencyType                 {get;set;}
    public string deletePayment                     {get;set;}
    public string abortPayment                      {get;set;}
    public string donorCategory                     {get;set;}
    public string FinancialYear                     {get;set;}
    
    public  DN_DonorProfile_CTRL(){        
        initialize(); 
    }
    
    //Changed method signature to 3 parameter , added donorId parameter -- Sumit Gaurav-- 21-05-2020
    @RemoteAction
    public static string getAllAttachmentsForDonorView(string parentId,string donorId, String attachemntFor){
        return JSON.serializePretty(DN_Donorprofile_Helper.getAllAttachmentsForDonorView(parentId,donorId,attachemntFor));
    }
    
    @RemoteAction
    public static string displayDonorDetails(String donorId){
       return JSON.serializePretty(DN_Donorprofile_Helper.displayDonorDetails(donorId));
    }
    
    @RemoteAction
    public Static String updateDonorInSFDC(Contact donorInfo){
        return DN_Donorprofile_Helper.updateDonorInSFDC(donorInfo); 
        
    }
    
    @RemoteAction
    public static string displayDonorDonationDetails(String  donorId){
        return JSON.serializePretty(DN_Donorprofile_Helper.displayDonorDonationDetails(donorId));
    }
    
    @RemoteAction
    public static string getPledgedDonations(String  donorId){
        return JSON.serializePretty(DN_Donorprofile_Helper.getDonorPledgedDonation(donorId));
    }
    
    @RemoteAction
    public static List<Donation_Program__c> getDonorDonationProgramDetails(String currencyType){
        return DN_Donorprofile_Helper.getDonorDonationProgramDetails(currencyType);
        
    }
          
    @RemoteAction 
    public static DN_OrderConfirmationWrapper makeDonation(DN_PaymentWrapper orderwrp){
        DN_CCAvenue_Service newDonation =  new DN_CCAvenue_Service();
        return newDonation.createDonationOrderInSFDB(orderwrp);
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
    Public static DN_OrderConfirmationWrapper makePedingDonation(DN_PaymentWrapper pwrp, String donationId, string orderId){
        DN_CCAvenue_Service newDonation =  new DN_CCAvenue_Service();
        return newDonation.createPendingDonationOrder(pwrp, donationId, orderId);        
    }
    
    @RemoteAction
    public static string uploadDoc(String attachmentBody,string attachmentName,string attparentId,String attachmentId){
        return DN_Donorprofile_Helper.uploadAttachment(attachmentBody,attachmentName,attparentId,attachmentId);
    }
    
    @RemoteAction
    public static string getDonorStudents(String donorId,String Year){
        return JSON.serializePretty(DN_Donorprofile_Helper.getDonorScholars(donorId,Year));
    }
    
    
    @RemoteAction
    public static string toDisplayStudentTab(String donorId,String Year){
         return JSON.serializePretty(DN_Donorprofile_Helper.toDisplayStudentTab(donorId,Year));
    }
    
    @RemoteAction
    public static string viewStudentProfile(String studentId){
        return JSON.serializePretty(DN_Donorprofile_Helper.viewStudentProfile(studentId));
    }
     @RemoteAction
    public static  List<DN_Donorprofile_Helper.wrapper> getTrainingRecords(String studentId,string finYear){
        //return JSON.serializePretty(DN_Donorprofile_Helper.getTrainingRecords(studentId));
        return DN_Donorprofile_Helper.getTrainingRecords(studentId,finYear);
    }
    
    @RemoteAction
    public static  List<Mentoring_Details__c> geMentoringDetails(String studentId){
        return DN_Donorprofile_Helper.geMentoringDetails(studentId);
    }
    
    @RemoteAction
    public static string letterOfThanksForDonor(String studentId){
        return JSON.serializePretty(AP_Application_Helper.letterOfThanksForDonor(studentId));
    }
    
    //gourab
   // @RemoteAction
    /*public static string getFFEId(String studffeId){
        sampleData.getStudentFfeId(studffeId);
        return 'Called Successfully';
    }*/
    
    /* 
    * @purpose: Check Authorized user. If not redirect the user to login Page.
    */
    public PageReference checkUserAuth(){
        system.debug('lets check1');
        PageReference pg    = new PageReference('/'); 
        
        string encDonorId   = Apexpages.currentPage().getParameters().get('encDonorId');
        string hashCode     = Apexpages.currentPage().getParameters().get('d');
        
        if(encDonorId != null){
            currentdonorId          = DN_CCAvenue_Service.decryptString(encDonorId, DN_ServiceConstants.DN_ORDER_KEY);
            Cookie cookieEncDonor   = new Cookie('encDonorLog', currentdonorId, null, 86400, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookieEncDonor});            
        }
        if(hashCode != null){
            getContactId(hashCode);
            Cookie cookiehashCode   = new Cookie('hashCodeLog', currentdonorId, null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
        }

        if(currentdonorId == null){
            Cookie encDonor = ApexPages.currentPage().getCookies().get('encDonorLog');
            if(encDonor != null) currentdonorId = encDonor.getValue();
            if(currentdonorId != null){
                Cookie cookieEncDonor   = new Cookie('encDonorLog', currentdonorId, null, 86400, false);
                ApexPages.currentPage().setCookies(new Cookie[]{cookieEncDonor}); 
            }            
        }
        if(currentdonorId == null){
            Cookie chashcode = ApexPages.currentPage().getCookies().get('hashCodeLog');
            if(chashcode != null) currentdonorId    = chashcode.getValue();
            if(currentdonorId != null){
                Cookie cookiehashCode   = new Cookie('hashCodeLog', currentdonorId, null, 1800, false);
                ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            }          
        }
        
        if(currentdonorId == null){
            Cookie logType = ApexPages.currentPage().getCookies().get('loginType');
            if(logType != null){
                if(logType.getValue()   == 'googleLogin'){
                    try{
                        checkGoogleAuth();    
                    }catch(Exception e){
                        return pg;
                    }
                }
                if(logType.getValue()   == 'fbLogin'){
                    try{
                        checkFacebookAuth();    
                    }catch(Exception e){
                        return pg;
                    }
                }
            }else{
                return pg;
            }
        }
        
        // If current user is not an authorized user 
        // then redirect to login page
        if(currentdonorId == null) return pg;
        
        // Set Current User Currency Type
        getContactCurrency(currentdonorId);
        
        return null;
    }
    
    // Get Current user emails by validating with Google APIs and check if 
    // logged in user's email exist in the system or not. 
    public void checkGoogleAuth(){

        String authCode ;        
        Cookie lkcode = ApexPages.currentPage().getCookies().get('googleCode');
        if(lkcode != null){
            code = lkcode.getValue();
            Cookie cookiegObj   = new Cookie('googleCode', '', null, 100, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiegObj});
        }
            
        if(String.isBlank(code)){
            Cookie gSessId = ApexPages.currentPage().getCookies().get('googleSessionId');
            if(gSessId != null){
                authCode = gSessId.getValue();
            }
        }
        if(!String.isBlank(code)){
            authCode = LoginAuthentication_Helper.getGoogleAuthCode(code,LoginAuthentication_Helper.DONOR_STIE);
        }
        
        if(!String.isBlank(authCode)){
            if(!authCode.equalsIgnoreCase(Constants.ERROR_MESSAGE)){
                GooglePublicDetailsClass.GoogleDetails gResp = LoginAuthentication_Helper.getGoogleEmail(authCode);
                if(gResp != null && !String.isBlank(gResp.email)){
                    try{ 
                        Id conRecordTypeId         = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
                        Id conFacRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId(); 

                        Contact currentdonor    = [Select id,Donor_Currency_Type__c from Contact where (RecordTypeId =:conRecordTypeId OR (RecordTypeId =:conFacRecordTypeId AND is_Facilitator_also_a_Donor__c=true))
                                                  AND (Email =:gResp.email OR Google_login_ID__c =:gResp.email)];
                        
                        currentdonorId          = currentdonor.Id;
                        donorCurrencyType       = currentdonor.Donor_Currency_Type__c;
                        
                        Cookie cookieObj1 = new Cookie('googleSessionId', authCode, null, 3600, false);
                        ApexPages.currentPage().setCookies(new Cookie[]{cookieObj1});
                    }catch(Exception e){
                        HandleBusinessException.captureError('DN_DonorProfile_CTRL', 'checkGoogleAuth', e);
                        system.debug(e.getMessage());
                    }
                }
            }
        }
        
    }
    
    public void checkFacebookAuth(){
        String authCode ;        
        Cookie lkcode = ApexPages.currentPage().getCookies().get('facebookCode');
        
        if(lkcode != null){
            code = lkcode.getValue();
            Cookie cookiefObj   = new Cookie('facebookCode', '', null, 100, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiefObj});
        }
        if(String.isBlank(code)){
            Cookie gSessId = ApexPages.currentPage().getCookies().get('fbSessionId');   
            if(gSessId != null){
                authCode = gSessId.getValue();
            }
        }
        
        if(!String.isBlank(code)){
            authCode = LoginAuthentication_Helper.getFBAuthCode(code,LoginAuthentication_Helper.DONOR_STIE);
        }
        if(!String.isBlank(authCode)){
            String fbEmail  = LoginAuthentication_Helper.getFacebookEmail(authcode);
            if(!String.isBlank(fbEmail)){
                try{
                    Id conRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
                    Id conFacRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId(); 

                    
                    Contact currentdonor    = [Select id,Donor_Currency_Type__c from Contact where (RecordTypeId =:conRecordTypeId OR (RecordTypeId =:conFacRecordTypeId AND is_Facilitator_also_a_Donor__c=true))
                                               AND (Email =:fbEmail OR Facebook_login_ID__c =:fbEmail)];
                    
                    currentdonorId          = currentdonor.Id;
                    donorCurrencyType       = currentdonor.Donor_Currency_Type__c;
                        
                    Cookie cookieObj1 = new Cookie('fbSessionId', authCode, null, 3600, false);
                    ApexPages.currentPage().setCookies(new Cookie[]{cookieObj1});
                }catch(Exception e){
                    HandleBusinessException.captureError('DN_DonorProfile_CTRL', 'checkFacebookAuth', e);
                    system.debug(e.getMessage());
                }
            }
        }
    }
    
    public PageReference redirectDonorPage(){
        code                        = ApexPages.currentPage().getParameters().get('code');
        Cookie cookieObj            = new Cookie('googleCode', code, null, 100, false);
        Cookie cookieLoginTypeObj   = new Cookie('loginType', 'googleLogin', null, 86400, false);
        PageReference MyNewPage     = Page.donorProfile;
        
        MyNewPage.setCookies(new Cookie[]{cookieObj, cookieLoginTypeObj});
        
        MyNewPage.setRedirect(true);
        return MyNewPage;
    }
    
    public PageReference redirectDonorPagefoFB(){
        code                        = ApexPages.currentPage().getParameters().get('code');
        Cookie cookieObj            = new Cookie('facebookCode', code, null, 100, false);
        Cookie cookieLoginTypeObj   = new Cookie('loginType', 'fbLogin', null, 86400, false);
        PageReference MyNewPage     = Page.donorProfile;
        
        MyNewPage.setCookies(new Cookie[]{cookieObj, cookieLoginTypeObj});
        
        MyNewPage.setRedirect(true);
        return MyNewPage;
    }
        
    public PageReference logOutUser(){
        Cookie cookieEncyobj    = new Cookie('encDonorLog', '', null, 0, false);
        Cookie cookiehashObj    = new Cookie('hashCodeLog', '', null, 0, false);
        Cookie cookiefbObj      = new Cookie('fbSessionId', '', null, 0, false);
        Cookie cookieGoogleObj  = new Cookie('googleSessionId', '', null, 0, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookieEncyobj, cookiehashObj, cookiefbObj, cookieGoogleObj});
        PageReference pg = new PageReference('/');
        pg.setRedirect(true);
        return pg;
    }
    
    public void initialize(){        
        DRscholarResidenstilPickValues  = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_RESIDENTIAL_STATUS));
        CitizenIndian                   = Constants.CITIZENSHIP_INDIAN;
        CitizenNonIndian                = Constants.CITIZENSHIP_NON_INDIAN;        
        paymentWrpString                = JSON.serializePretty(new DN_PaymentWrapper());
        updateSuccessMsg                = DN_ServiceConstants.DONOR_INFO_UPDATED;
        deletePayment                   = DN_ServiceConstants.PAYMENT_DELETE;
        abortPayment                    = DN_ServiceConstants.PAYMENT_CANCEL;
        donorCategory                   = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.DONOR_CATEGORY)).trim();
        FinancialYear                   = JSON.serializePretty(Utility.PastTenFinancialYear());

    }
    
    private void getContactId(String hashCode){
        try{
            Id conRecordTypeId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            Id conFacRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId(); 

            Contact con         = [Select id,Donor_Currency_Type__c from Contact 
                                   where Login_hash_Code__c =: hashCode/* AND (RecordTypeId =:conRecordTypeId OR RecordTypeId =:conFacRecordTypeId)*/];
            currentdonorId      = con.id;
            donorCurrencyType   = con.Donor_Currency_Type__c;
        }catch(Exception e){
            HandleBusinessException.captureError('DN_DonorProfile_CTRL', 'getContactId', e);
        }
    }
    
    private void getContactCurrency(String conId){
        try{
            Id conRecordTypeId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            Contact con         = [Select id,Donor_Currency_Type__c from Contact 
                                   where Id =: conId AND RecordTypeId =:conRecordTypeId];
            donorCurrencyType   = con.Donor_Currency_Type__c;
        }catch(Exception e){HandleBusinessException.captureError('DN_DonorProfile_CTRL', 'getContactCurrency', e);}
    }
}