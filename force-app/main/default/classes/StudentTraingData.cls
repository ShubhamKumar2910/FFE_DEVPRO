public Class StudentTraingData{
    public Training_Result__c students; 
    public String vendorURL;
    public String vendorName;
    public List<WrpVendorCode> wrpvendCode;
    
    public StudentTraingData(){
        students = new Training_Result__c();
        vendorURL ='';
        vendorName = '';
        wrpvendCode = new List<WrpVendorCode>();
    }
    
    public Class WrpVendorCode{
        public String vndURL;
        public String vndName;
        
        public WrpVendorCode(){
            vndURL ='';
            vndName = '';
        }
    }
}