/*
* @Purpose      : Controller for DonorAllocation Profile Page
* @Author       : Amritesh
*/

public class DN_DonorAllocation_CTRL {
    
     public string DonorCategory             {get; set;}
    public string DonorCategory1             {get; set;}
    public string studentClzRatingPicklistValues    {get;set;} 
    public string studentCoursePicklistValues       {get;set;}
    public string studentCourseYearPicklistValues   {get;set;}
    public string CourseBEBTech                     {get;set;}
    public string CourseMBBS                        {get;set;}
    public string CourseIntegratedMTech             {get;set;}
    public string listOfGAUS                        {get;set;}
    public string listOfPrgms                       {get;set;}
    public string listOfStates                      {get;set;}
    public double maxIncome                         {get;set;}
    public string genderList                        {get;set;}
    public string branchList                        {get;set;}
    public string countryList                       {get;set;}
   // gourab 
   // 
   // public string examList                        {get;set;}
   // public string ExamRankList                    {get;set;}
    public string ScholarList                       {get;set;}
    public string priorityList                      {get;set;}
    
    
    public DN_DonorAllocation_CTRL(){
        initialize();        
    }
    
    
        
    @RemoteAction    
    public static string createDonorStudentMapping(String donorId,List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper> lstStudents){
        return DN_DonorAllocation_Helper.createDonorStudentMapping(donorId, lstStudents);
    } 
    
     @RemoteAction    
    public static string save_multiDonor(List<Map<String,String>> donorBalanceList,List<Map<String,String>> donorAppList){
         return DN_DonorAllocation_Helper.save_multiDonor(donorBalanceList, donorAppList);  
    }

    
    @RemoteAction
    public static string getDonorDetails(){
        return JSON.serializePretty(DN_DonorAllocation_Helper.getDonorDetails()); 
    }
    
    @RemoteAction
    public static string getFilteredDonors(DonorFilterWrapper donorFilter){
        return JSON.serializePretty(DN_DonorAllocation_Helper.getFileredDonorList(donorFilter)); 
    }
    
     @RemoteAction
    public static string getFilteredDonors_multiDonor(DonorFilterWrapper donorFilter,String strDonorCategory){
        return JSON.serializePretty(DN_DonorAllocation_Helper.getFileredDonorList_multiDonor(donorFilter,strDonorCategory)); 
    }

    
    @RemoteAction
    public static List<Application__c> getFilteredStudents(collegeFilterWrpper  searchFilter,string DonorId){
        return   DN_DonorAllocation_Helper.getFilteredStudents(searchFilter,DonorId);
    }

    @RemoteAction
    public static List<String> getDonorLocation(string donorCity, string donorCountry){
        return DN_DonorAllocation_Helper.getDonorLocation(donorCity, donorCountry);
    }
    
    @RemoteAction
    public static List<String> getStudentCollegeState(string collegeState){
        return   DN_DonorAllocation_Helper.getStudentCollegeState(collegeState);
    }
    @RemoteAction
    public static List<String> getStudentCollegeCity(string collegeCity){
        return   DN_DonorAllocation_Helper.getStudentCollegeCity(collegeCity);
    }
    @RemoteAction
    public static List<String> getStudentCollegeName(string collegeName){
        return   DN_DonorAllocation_Helper.getStudentCollegeName(collegeName);
    }
    
    @RemoteAction
    public static List<DN_DonorAllocation_Helper.prevWrapper> getPreviousYearApplnfrmDB(string donorId){
        return DN_DonorAllocation_Helper.getPreviousYearAppln(donorId);
    }
    
     @RemoteAction
    public static List<State_Master__mdt> getStateList(String countryName){
        return Utility.getStates(countryName);
    }
    
    public void initialize(){
        
        studentClzRatingPicklistValues  = JSON.serializePretty(Utility.getPicklistValues(Constants.COLLEGEMASTER_SOBJECT,Constants.COLLEGEMASTER_STUDENTCLZRATING));
        studentCoursePicklistValues     = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.STUDENT_COURSE));
        studentCourseYearPicklistValues = '';
        CourseBEBTech                   = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year','4th Year'});
        CourseIntegratedMTech           = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year','4th Year','5th Year'});
        CourseMBBS                      = JSON.serializePretty(new List<String>{'Year I, Sem 1','Year II, Sem 3','Year II, Sem 5','Year III (Part 1), Sem 7','Year III (Part 2), Sem 9'});    
        listOfGAUS                      = JSON.serializePretty(DN_DonorAllocation_Helper.getGeneralAccountUnit());
        listOfPrgms                     = JSON.serializePretty(DN_DonorAllocation_Helper.getPrograms());
        listOfStates                    = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
        maxIncome                       = Constants.MAX_INCOME_RANGE;
        genderList                      = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_GENDER));
        branchList                      = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD));
        countryList                     = JSON.serializePretty(Utility.getCountryList());
        // Gourab - added two Line
       // examList                      = JSON.serializePretty(AP_Student_Application_helper.getAllEntranceTestName());
       // ExamRankList                    = JSON.serializePretty(new List<String>{'upto 10000','upto 20000','upto 30000','upto 40000','upto 50000','upto 60000','upto 70000'});
        ScholarList                     = JSON.serializePretty(new List<String>{System.label.Greater_than_40000,System.label.Equal_40000,System.label.From_35000_to_40000,System.label.From_30000_to_35000});
        priorityList                    = JSON.serializePretty(new List<String>{'Priority 1','Priority 2','Priority 3','Priority 4'});
        DonorCategory       = JSON.serializePretty(new List<String>{'Individual','Corporate','Foundation','Charitable Trust','Corporate Individual','Scholar','Non Profit Organization','Other'});
        DonorCategory1       = JSON.serializePretty(new List<String>{'Individual','Corporate','Foundation','Charitable Trust','Corporate Individual','Alumni','Non Profit Organization','Other'});
    }
    
}