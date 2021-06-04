/*
 * @purpose : This class is used for Donor fund allocation to student awaiting for fund 
 * @Author  : Amritesh          
 */ 
public class DN_FundAllocation_CTRL {
    
    public string applnType                 {get; set;}
    public string studentFilterOption       {get; set;}
    public string multiDonor_studentFilterOption        {get; set;}
    public string gauList                   {get; set;}
    public string DonorCategory             {get; set;}
    public string gauDelim             {get; set;}
    public string gauAmtDelim             {get; set;}
    public DN_FundAllocation_CTRL(){
        gauDelim = JSON.serializePretty(Label.GAUs_delimiter);
        gauAmtDelim = JSON.serializePretty(Label.GAU_Amount_delimiter);
        initialize();
    }
    
    @RemoteAction
    public static string getStudentswithApplication(DN_FundAllocation_CTRL.searchFilterWrapper searchWrp ){
        return JSON.serializePretty(DN_FundAllocation_Helper.getAllFilteredStudents(searchWrp));
    }   
    
         @RemoteAction
    public static string getStudentswithApplication_multi(DN_FundAllocation_CTRL.searchFilterWrapper searchWrp ){
        return JSON.serializePretty(DN_FundAllocation_Helper.getAllFilteredStudents_multi(searchWrp));
    }
   
    
    @RemoteAction
    public static string getStudentsByDonorName(String donorId){
        return JSON.serializePretty(DN_FundAllocation_Helper.getStudentsByDonor(donorId));
    }
    
    @RemoteAction
    Public static string getDonorStudentMapping(string applicationId){
        return JSON.serializePretty(DN_FundAllocation_Helper.getDonorDetails(applicationId));
    }
    @RemoteAction
    Public static string getDonorStudentMapping_multi(string applicationId){
        return JSON.serializePretty(DN_FundAllocation_Helper.getDonorDetails_multi(applicationId));
    }
    
    @RemoteAction
    public static string getGAUWiseDonorBalance(string gauId,string DonorCategorydata){
        return JSON.serializePretty(DN_FundAllocation_Helper.getGAUWiseBalance(gauId,DonorCategorydata));
    }
    
    @RemoteAction
    public static string getDonorByName(string dname){
        return JSON.serializePretty(DN_FundAllocation_Helper.getDonors(dname));
    } 
     
    @RemoteAction
    public static string disburseFund(FundDisburseWrapper fundWrp){
        return DN_FundAllocation_Helper.doFundDisburment(fundWrp);
    }
     @RemoteAction
    public static string disburseFund_multi(FundDisburseWrapper fundWrp){
        DN_FundAllocation_Helper.isMultiDonorFlag = true;
        return DN_FundAllocation_Helper.doFundDisburment(fundWrp);
    }
    
    public void initialize(){
        applnType           = JSON.serializePretty(DN_FundAllocation_Helper.getApplicationType());
        studentFilterOption = JSON.serializePretty(DN_FundAllocation_Helper.getStudentSeachFilterType());
        multiDonor_studentFilterOption = JSON.serializePretty(DN_FundAllocation_Helper.getMultiDonorStudentSeachFilterType());
        gauList             = JSON.serializePretty(DN_DonorAllocation_Helper.getGeneralAccountUnit());
        DonorCategory       = JSON.serializePretty(new List<String>{'Individual','Corporate','Foundation','Charitable Trust','Corporate Individual','Scholar','Non Profit Organization','Other'});

    }
    
    public class searchFilterWrapper {
        public string studentType;
        public List<Id> applType; 
        
        public searchFilterWrapper(){
            studentType = '';
            applType    = new List<Id>();
        }
    }

}