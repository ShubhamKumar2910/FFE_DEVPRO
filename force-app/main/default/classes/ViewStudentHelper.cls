public class ViewStudentHelper {

    public List<String> gauNames    {get;set;}
    public List<String> financialYear    {get;set;}
    
    public ViewStudentHelper(Apexpages.StandardController stdCon){} 
    public ViewStudentHelper(){}
    
    @RemoteAction
    public static List<String> getGauNames(){
        return NotifyStudentHelper.GauNameDetails();
    }
    
    @RemoteAction
    public static List<String> getfinancilaYearDetails(){
        return NotifyStudentHelper.PastTenFinancialYear();
    }
        
    @RemoteAction
    public static String stdentData(String Fyear,String gau,String donorId){

         List<Fund_Utilization__c> fuList = [SELECT Id,Disbursed_Amount__c,Application__r.Student__c,Application__r.RPT_Financial_Year__c,General_Accounting_Unit__r.Name,Application__r.Amount_Funded__c FROM Fund_Utilization__c
                                             Where Application__r.RPT_Financial_Year__c =:Fyear and General_Accounting_Unit__r.Name =:gau and Donor__r.Id=:donorId];
        Set<String> conIds = new Set<String>(); 
        Map<String,Decimal> donatedamountYear = new Map<String,Decimal>();
        Map<String,string> scholarshipamtdetails = new Map<String,string>();
        for(Fund_Utilization__c fu : fuList){
            scholarshipamtdetails.put(fu.Application__r.Student__c,String.valueOf(fu.Application__r.Amount_Funded__c));
            conIds.add(fu.Application__r.Student__c);
            if(!donatedamountYear.containsKey(fu.Application__r.Student__c)){
                donatedamountYear.put(fu.Application__r.Student__c,fu.Disbursed_Amount__c);
            }else{
                donatedamountYear.put(fu.Application__r.Student__c,fu.Disbursed_Amount__c+donatedamountYear.get(fu.Application__r.Student__c));
            }
        }

    
    List<contact> studentList = [Select id,FFE_ID__c,Name,MobilePhone,Email,Gender__c,X10th__c,X12th__c,Course__c,Branch_Stream__c From contact Where Id=:conIds];
        List<studentWithAttachment> studentwithAttachmentList = new List<studentWithAttachment>();
        for(contact con : studentList){
            studentWithAttachment studentWithAtt =  new studentWithAttachment();
            studentWithAtt.stdid = con.id;
            studentWithAtt.FFEID= con.FFE_ID__c;
            studentWithAtt.Name = con.Name;
            studentWithAtt.MobilePhone = con.MobilePhone;
            studentWithAtt.Email = String.valueOf(con.Email);
            studentWithAtt.Gender = con.Gender__c;
            studentWithAtt.X10th = String.valueOf(con.X10th__c);
            studentWithAtt.X12th = String.valueOf(con.X12th__c);
            studentWithAtt.Course = con.course__c;
            studentWithAtt.Branch = con.Branch_Stream__c;
            studentWithAtt.AttachmentLink = con.id;
            studentWithAtt.donatedAmt = String.valueOf(donatedamountYear.get(con.id));
            studentWithAtt.scholarshipamt = scholarshipamtdetails.get(con.id);
            studentwithAttachmentList.add(studentWithAtt);
        }
        return JSON.serializePretty(studentwithAttachmentList);
    }
    
    public class studentWithAttachment{
        public boolean isSelected;
        public String stdid;
        public String FFEID;
        public String Name;
        public String MobilePhone;
        public String Email;
        public String Gender;
        public String X10th;
        public String X12th;
        public String Course;
        public String Branch;
        public String AttachmentLink; 
        public String donatedAmt;
        public string scholarshipamt;
        
        public studentWithAttachment(){
            isSelected = false;
            stdid = '';
            FFEID= '';
            Name = '';
            MobilePhone = '';
            Email = '';
            Gender = '';
            X10th = '';
            X12th = '';
            Course = '';
            Branch = '';
            AttachmentLink = '';
            donatedAmt ='';
            scholarshipamt = '';
        }
    }

}