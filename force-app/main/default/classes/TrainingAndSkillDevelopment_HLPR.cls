public class TrainingAndSkillDevelopment_HLPR {
    
    
    //for AMCAT pre/post assessment score details
    public static List<Contact> getSecondYearData(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            //changed query condition done by varun 
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,English_Spoken_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where RecordTypeId =:StudentRecordType  AND Current_year__c=:System.label.X2nd_year AND (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech') AND ( English_Written_Score__c!=:null and English_Spoken_Score__c!=:null and Aptitude_Analytical_Score__c!=:null and Aptitude_Logical_Score__c!=:null)]; 
            //where RecordTypeId =:StudentRecordType AND Financial_year__c=:currentFinancialYear AND Current_year__c=:System.label.X2nd_year AND(English_Written_Score__c<=:trngcustomSettng.Min_English_Wriitten_Score__c OR English_Spoken_Score__c<=:trngcustomSettng.Min_English_Spoken_Score__c OR Aptitude_Analytical_Score__c<=:trngcustomSettng.Min_Aptitude_Analytical_Score__c OR Aptitude_Logical_Score__c<=:trngcustomSettng.Min_Aptitude_Logical_Score__c)];
            return conList;
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getSecondYearData', e);
            return null;
        }
    }
    
    public static Integer getSecondYearDataLength(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            //changed query condition done by varun 
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,English_Spoken_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where RecordTypeId =:StudentRecordType  AND Current_year__c=:System.label.X2nd_year AND (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech') AND ( English_Written_Score__c!=:null and English_Spoken_Score__c!=:null and Aptitude_Analytical_Score__c!=:null and Aptitude_Logical_Score__c!=:null)]; 
            system.debug(conList.size());                 //where RecordTypeId =:StudentRecordType AND Financial_year__c=:currentFinancialYear AND Current_year__c=:System.label.X2nd_year AND(English_Written_Score__c<=:trngcustomSettng.Min_English_Wriitten_Score__c OR English_Spoken_Score__c<=:trngcustomSettng.Min_English_Spoken_Score__c OR Aptitude_Analytical_Score__c<=:trngcustomSettng.Min_Aptitude_Analytical_Score__c OR Aptitude_Logical_Score__c<=:trngcustomSettng.Min_Aptitude_Logical_Score__c)];
            
            return conList.size();
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getSecondYearData', e);
            return null;
        }
    }
    //for AMCAT pre/post assessment score details
    public static List<Contact> getThirdYearData(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            //changed query condition done by varun 
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score_post__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where RecordTypeId =:StudentRecordType  AND Current_year__c=:System.label.X3rd_year AND (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech')  AND( English_Written_Score_post__c!=:null and English_Spoken_Score_post__c!=:null and Aptitude_Analytical_Score_post__c!=:null and Aptitude_Logical_Score_post__c!=:null)]; 
            return conList;
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
    }
    
    
    public static Integer  getThirdYearDataEnglisLength(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            //changed query condition done by varun 
            List<Training_Result__c> trainingResults = [Select id,Marks_Obtained__c,Pre_assessment_Scores__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.Course__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
                                                        Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
                                                        Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
                                                        
                                                        Where Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X3rd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:System.label.Aspiring_English AND (Student_Training_Mapping__r.Student_ID__r.Course__c = 'BE/B.Tech' OR Student_Training_Mapping__r.Student_ID__r.Course__c = 'Integrated MTech')];
            return trainingResults.size();
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
    }
    
    public static List<Contact> getFourthYearData(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score_post__c,Endline_Aptitude_Analytical_Score__c,Endline_Aptitude_Logical_Score__c,Endline_English_Written_Score__c,Endline_English_Spoken_Score__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where RecordTypeId =:StudentRecordType  AND Current_year__c=:System.label.X4th_year AND (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech')  AND( Endline_Aptitude_Analytical_Score__c!=:null and Endline_Aptitude_Logical_Score__c!=:null and Endline_English_Written_Score__c!=:null and Endline_English_Spoken_Score__c!=:null)]; 
            
            
            return conList;
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
    }
    
    //Aspiring students details
    public static List<Student_Training__c> getSecondAspiringStdYearData(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            List<Training_Result__c> trainingResults = [Select id,Marks_Obtained__c,Pre_assessment_Scores__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.Course__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
                                                        Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
                                                        Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
                                                        
                                                        Where Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c='Aspiring Program'];
            List<Student_Training__c> studTrainingMapping  = new List<Student_Training__c>();
            
            studTrainingMapping = [Select id,Training_Code__c,Student_ID__c,Training_Code__r.Training_Type__c,Student_ID__r.Name,Student_ID__r.FFE_ID__c,Student_ID__r.Aptitude_Analytical_Score__c,Student_ID__r.English_Written_Score__c,Student_ID__r.Aptitude_Logical_Score__c,Student_ID__r.English_Spoken_Score__c From Student_Training__c Where Training_Code__r.Training_Type__c = 'Aspiring Program'  AND Student_ID__r.Current_year__c=:System.label.X2nd_year AND (Student_ID__r.English_Written_Score__c!=:null and Student_ID__r.English_Spoken_Score__c!=:null and Student_ID__r.Aptitude_Analytical_Score__c!=:null and Student_ID__r.Aptitude_Logical_Score__c!=:null)];
            System.debug(studTrainingMapping.size());
            return studTrainingMapping;
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getSecondYearData', e);
            return null;
        }
    }
    
    
    public static List<Contact> getSecondYearAspiringStudentData(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,English_Spoken_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech')  AND RecordTypeId =:StudentRecordType AND Current_year__c=:System.label.X2nd_year];
            return conList;
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getSecondYearAspiringStudentData', e);
            return null;
        }
    }
    
    
    //for english app students
    public static List<StudentTraingData> englishAndAptitudeAppData(String trainingType){
        Decimal MinEnglishSpokenScore;
        Decimal MinEnglishWriittenScore;
        Decimal MinAptitudeAnalyticalScore; 
        Decimal MinAptitudeLogicalScore;
        Training__c trngcustomSettng = Utility.getTrainingDetails();
        
        if(trainingType == System.label.English){
            MinEnglishSpokenScore = Integer.valueOf(trngcustomSettng.Min_English_Spoken_Score__c);
            MinEnglishWriittenScore = Integer.valueOf(trngcustomSettng.Min_English_Wriitten_Score__c);
        }else if (trainingType == System.label.Aptitude){
            MinAptitudeAnalyticalScore = Integer.valueOf(trngcustomSettng.Min_Aptitude_Analytical_Score__c);
            MinAptitudeLogicalScore = Integer.valueOf(trngcustomSettng.Min_Aptitude_Logical_Score__c);
        }
        
        try{
            
            /*  List<Training_Result__c> trainingResults = [select id,Marks_Obtained__c,Pre_assessment_Scores__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
Where (Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:System.label.English AND (Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c<=:MinEnglishWriittenScore OR 
Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c<=:MinEnglishSpokenScore)) OR
(Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:system.label.Aptitude AND (Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c<=:MinAptitudeLogicalScore OR
Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c<=:MinAptitudeAnalyticalScore)) OR
(Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c =: system.label.Aspiring_Program)]; */
            //added by varun  
            List<Training_Result__c> trainingResults = [Select id,Marks_Obtained__c,Pre_assessment_Scores__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Course__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
                                                        Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
                                                        Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
                                                        Where (Student_Training_Mapping__r.Student_ID__r.Course__c = 'BE/B.Tech' OR Student_Training_Mapping__r.Student_ID__r.Course__c = 'Integrated MTech') AND ((Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:System.label.English) OR (Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:system.label.Aptitude) OR (Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X2nd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c =: system.label.Aspiring_Program))];
            
            Set<Id> trainingMasterIDs = new Set<Id>();
            
            for(Training_Result__c training : trainingResults){
                trainingMasterIDs.add(training.Student_Training_Mapping__r.Training_Code__r.id);
            }
            
            List<Vendor__c> vendors = [select id,Training_Master__c,Training_Master__r.id,Name,Vendor_Code__c,Vendor_URL__c From Vendor__c where Training_Master__c=:trainingMasterIDs];
            
            Map<String,String> vendorCodeWithURLval = new Map<String,String>();
            Map<String,String> vendorNameMap = new Map<String,String>();
            
            for(Vendor__c vend : vendors){
                vendorCodeWithURLval.put(vend.Vendor_Code__c,String.valueOf(vend.Vendor_URL__c));
                vendorNameMap.put(vend.Vendor_Code__c,vend.Name);
            }
            
            
            List<StudentTraingData> contactwithEnglishTrngNameList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithAptitudeTrngNameList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithEngAndAptitudeTrainingList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithAspiringStdTrainingList = new List<StudentTraingData>();
            
            for(Training_Result__c training : trainingResults){
                StudentTraingData std = new StudentTraingData();
                std.students = training;
                std.vendorURL = vendorCodeWithURLval.get(training.Vendor_Code__c);   
                std.vendorName = vendorNameMap.get(training.Vendor_Code__c);
                //if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.English && (training.Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c<=MinEnglishWriittenScore || training.Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c<=MinEnglishSpokenScore))
                if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.English)
                {
                    contactwithEnglishTrngNameList.add(std);
                }//else if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.Aptitude && (training.Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c<=MinAptitudeLogicalScore || training.Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c<=MinAptitudeAnalyticalScore)){
                else if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.Aptitude)
                {
                    contactwithAptitudeTrngNameList.add(std);
                }else if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.Aspiring_Program){
                    contactwithAspiringStdTrainingList.add(std);
                }
                contactwithEngAndAptitudeTrainingList.add(std);
            }
            
            
            
            /*Map<String,StudentTraingData> bulkvendors = new Map<String,StudentTraingData>();

for(StudentTraingData std : contactwithEngAndAptitudeTrainingList){

if(!bulkvendors.containsKey(std.students.Student_Training_Mapping__r.Student_ID__r.id)){
StudentTraingData stdblkvnd = new StudentTraingData();
stdblkvnd.students = std.students;
system.debug(std.vendorURL);

StudentTraingData.WrpVendorCode blkvndr = new StudentTraingData.WrpVendorCode();
blkvndr.vndURL = std.vendorURL;
blkvndr.vndName = std.vendorName; 

stdblkvnd.wrpvendCode.add(blkvndr);
bulkvendors.put(std.students.Student_Training_Mapping__r.Student_ID__r.id,stdblkvnd);
}else{
StudentTraingData stdblkvnd = bulkvendors.get(std.students.Student_Training_Mapping__r.Student_ID__r.id);

StudentTraingData.WrpVendorCode blkvndr = new StudentTraingData.WrpVendorCode();
blkvndr.vndURL = std.vendorURL;
blkvndr.vndName = std.vendorName; 

stdblkvnd.wrpvendCode.add(blkvndr);
bulkvendors.put(std.students.Student_Training_Mapping__r.Student_ID__r.id,stdblkvnd);
}

}*/
            
            
            if(trainingType == system.label.English){
                return contactwithEnglishTrngNameList;
            }else if (trainingType == system.label.Aptitude){
                return contactwithAptitudeTrngNameList;
            }else if(trainingType == system.label.Aspiring_Program){
                return contactwithAspiringStdTrainingList;
            }/*else if(trainingType == system.label.All){
return bulkvendors.values();
}*/
            return null;
        }Catch(exception e){
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'englishAndAptitudeAppData', e);
            return null;
        }
    }
    
    
    public static List<StudentTraingData> getThirdYearData(String trainingType){
        try{
            Id studentRecordTypeIds = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            List<Training_Result__c> trainingResults = [select id,Pre_assessment_Scores__c,Student_Training_Mapping__r.Student_ID__r.Course__c,Marks_Obtained__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
                                                        Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
                                                        Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c, 
                                                        Student_Training_Mapping__r.Specialization_Name__c,Student_Training_Mapping__r.Courses__c,Student_Training_Mapping__r.isCertified__c,Student_Training_Mapping__r.Conclusion__c FROM Training_Result__c Where ( Student_Training_Mapping__r.Student_ID__r.RecordType.ID=:studentRecordTypeIds AND Student_Training_Mapping__r.Student_ID__r.Current_year__c=:system.label.X3rd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:system.label.Aspiring_English) OR
                                                        ( Student_Training_Mapping__r.Student_ID__r.RecordType.ID=:studentRecordTypeIds AND Student_Training_Mapping__r.Student_ID__r.Current_year__c=:system.label.X3rd_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:system.label.IT)];
            
            
            Set<Id> trainingMasterIDs = new Set<Id>();
            
            for(Training_Result__c training : trainingResults){
                trainingMasterIDs.add(training.Student_Training_Mapping__r.Training_Code__r.id);
            }
            
            List<Vendor__c> vendors = [select id,Training_Master__c,Training_Master__r.id,Name,Vendor_Code__c,Vendor_URL__c From Vendor__c where Training_Master__c=:trainingMasterIDs];
            
            Map<String,String> vendorCodeWithURLval = new Map<String,String>();
            Map<String,String> vendorNameMap = new Map<String,String>();
            
            for(Vendor__c vend : vendors){
                vendorCodeWithURLval.put(vend.Vendor_Code__c,String.valueOf(vend.Vendor_URL__c));
                vendorNameMap.put(vend.Vendor_Code__c,vend.Name);
            }
            
            
            List<StudentTraingData> contactwithEnglishTrngNameList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithITTrngNameList = new List<StudentTraingData>();
            
            
            for(Training_Result__c training : trainingResults){
                StudentTraingData std = new StudentTraingData();
                std.students = training;
                std.vendorURL = vendorCodeWithURLval.get(training.Vendor_Code__c);   
                std.vendorName = vendorNameMap.get(training.Vendor_Code__c);
                /* std.Specialization = training.Student_Training_Mapping__r.Specialization_Name__c;
std.Course = training.Student_Training_Mapping__r.Courses__c;
if(training.Student_Training_Mapping__r.Conclusion__c == 'Completed'){
std.isCertified = training.Student_Training_Mapping__r.isCertified__c; 
}  */
                
                if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.Aspiring_English){
                    contactwithEnglishTrngNameList.add(std);
                }else if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.IT){
                    contactwithITTrngNameList.add(std);
                }
            }
            
            if(trainingType == system.label.Aspiring_English){
                System.debug('Hi');
                return contactwithEnglishTrngNameList;
            }else if (trainingType == system.label.IT){
                return contactwithITTrngNameList;
            }
            
            return null;
        }Catch(exception e){
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
    }
    
    
    public static List<StudentTraingData> getfourthYearData(String trainingType){
        try{
            
            if(trainingType == 'All'){
                trainingType = 'Mock Interviews';
            }
            
            /* List<Training_Result__c> trainingResults = [select id,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
Where (Student_Training_Mapping__r.Student_ID__r.Current_year__c=:System.label.X4th_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:system.label.Mock_Interview_HR) OR
(Student_Training_Mapping__r.Student_ID__r.Current_year__c=:system.label.X4th_year AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:system.label.Mock_Interview_Tech)];

*/
            Id studentRecordTypeIds = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            List<Training_Result__c> trainingResults = [select id,Pre_assessment_Scores__c,Marks_Obtained__c,Completion_Flag__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
                                                        Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
                                                        Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
                                                        Where Student_Training_Mapping__r.Student_ID__r.Current_year__c='4th Year' AND Student_Training_Mapping__r.Training_Code__r.Training_Type__c=:trainingType AND (Student_Training_Mapping__r.Student_ID__r.Course__c = 'BE/B.Tech' OR Student_Training_Mapping__r.Student_ID__r.Course__c = 'Integrated MTech') AND Student_Training_Mapping__r.Student_ID__r.RecordType.ID=:studentRecordTypeIds];
            
            Set<Id> trainingMasterIDs = new Set<Id>();
            
            for(Training_Result__c training : trainingResults){
                trainingMasterIDs.add(training.Student_Training_Mapping__r.Training_Code__r.id);
            }
            
            List<Vendor__c> vendors = [select id,Training_Master__c,Training_Master__r.id,Name,Vendor_Code__c,Vendor_URL__c From Vendor__c where Training_Master__c=:trainingMasterIDs];
            
            Map<String,String> vendorCodeWithURLval = new Map<String,String>();
            Map<String,String> vendorNameMap = new Map<String,String>();
            
            for(Vendor__c vend : vendors){
                vendorCodeWithURLval.put(vend.Vendor_Code__c,String.valueOf(vend.Vendor_URL__c));
                vendorNameMap.put(vend.Vendor_Code__c,vend.Name);
            }
            
            
            List<StudentTraingData> contactwithMockHRTrngNameList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithMockTechTrngNameList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithEngAndAptitudeTrainingList = new List<StudentTraingData>();
            
            for(Training_Result__c training : trainingResults){
                StudentTraingData std = new StudentTraingData();
                std.students = training;
                std.vendorURL = vendorCodeWithURLval.get(training.Vendor_Code__c);   
                std.vendorName = vendorNameMap.get(training.Vendor_Code__c);
                if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.Mock_Interview_HR ){
                    contactwithMockHRTrngNameList.add(std);
                }else if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == system.label.Mock_Interview_Tech){
                    contactwithMockTechTrngNameList.add(std);
                }
                contactwithEngAndAptitudeTrainingList.add(std);
            }
            
            
            
            
            Map<String,StudentTraingData> bulkvendors = new Map<String,StudentTraingData>();
            
            for(StudentTraingData std : contactwithEngAndAptitudeTrainingList){
                
                if(!bulkvendors.containsKey(std.students.Student_Training_Mapping__r.Student_ID__r.id)){
                    StudentTraingData stdblkvnd = new StudentTraingData();
                    stdblkvnd.students = std.students;
                    system.debug(std.vendorURL);
                    
                    StudentTraingData.WrpVendorCode blkvndr = new StudentTraingData.WrpVendorCode();
                    blkvndr.vndURL = std.vendorURL;
                    blkvndr.vndName = std.vendorName; 
                    
                    stdblkvnd.wrpvendCode.add(blkvndr);
                    bulkvendors.put(std.students.Student_Training_Mapping__r.Student_ID__r.id,stdblkvnd);
                }else{
                    StudentTraingData stdblkvnd = bulkvendors.get(std.students.Student_Training_Mapping__r.Student_ID__r.id);
                    
                    StudentTraingData.WrpVendorCode blkvndr = new StudentTraingData.WrpVendorCode();
                    blkvndr.vndURL = std.vendorURL;
                    blkvndr.vndName = std.vendorName; 
                    
                    stdblkvnd.wrpvendCode.add(blkvndr);
                    bulkvendors.put(std.students.Student_Training_Mapping__r.Student_ID__r.id,stdblkvnd);
                }
                
            }
            
            system.debug('bulkvendors:::'+bulkvendors);
            
            
            if(trainingType == system.label.Mock_Interview_HR){
                return contactwithMockHRTrngNameList;
            }else if (trainingType == system.label.Mock_Interview_Tech){
                return contactwithMockTechTrngNameList;
                //}else if(trainingType == system.label.All){
            }else {
                return bulkvendors.values();
            }
            
            return null;
        }Catch(exception e){
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getfourthYearData', e);
            return null;
        }
    }
    
    public static List<Contact> getPlacementStudentData(){
        return [SELECT id,Name,Location__c,CTC__c,FFE_ID__c,Company_Name__c FROM Contact where Company_Name__c!=''];
    }
    
    public static Integer getMockinterViewRecordForThirdYear() {
        
        List<Training_Result__c> trainingResults = [select id,Pre_assessment_Scores__c,Marks_Obtained__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c, Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity, Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c  Where Student_Training_Mapping__r.Student_ID__r.Current_year__c= '3rd Year' AND  Student_Training_Mapping__r.Training_Code__r.Training_Type__c = 'Mock Interviews'];
        return  trainingResults.size();
        
    } 
    
    
    public static List<StudentTraingData> getMockInterViewRecordDetailForThirdYear() {
        
        try {
            Id studentRecordTypeIds = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            List<Training_Result__c> trainingResults = [select id,Pre_assessment_Scores__c,Marks_Obtained__c,Vendor_Code__c,Completion_Flag__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c, Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity, Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c  Where Student_Training_Mapping__r.Student_ID__r.Current_year__c= '3rd Year' AND  Student_Training_Mapping__r.Training_Code__r.Training_Type__c = 'Mock Interview' AND Student_Training_Mapping__r.Student_ID__r.RecordType.ID=:studentRecordTypeIds];
            
            Set<Id> trainingMasterIDs = new Set<Id>();
            
            for(Training_Result__c training : trainingResults){
                trainingMasterIDs.add(training.Student_Training_Mapping__r.Training_Code__r.id);
            }
            
            List<Vendor__c> vendors = [select id,Training_Master__c,Training_Master__r.id,Name,Vendor_Code__c,Vendor_URL__c From Vendor__c where Training_Master__c=:trainingMasterIDs];
            
            Map<String,String> vendorCodeWithURLval = new Map<String,String>();
            Map<String,String> vendorNameMap = new Map<String,String>();
            
            for(Vendor__c vend : vendors){
                vendorCodeWithURLval.put(vend.Vendor_Code__c,String.valueOf(vend.Vendor_URL__c));
                vendorNameMap.put(vend.Vendor_Code__c,vend.Name);
            }
            
            
            List<StudentTraingData> contactwithEnglishTrngNameList = new List<StudentTraingData>();
            List<StudentTraingData> contactwithITTrngNameList = new List<StudentTraingData>();
            
            
            for(Training_Result__c training : trainingResults){
                StudentTraingData std = new StudentTraingData();
                std.students = training;
                std.vendorURL = vendorCodeWithURLval.get(training.Vendor_Code__c);   
                std.vendorName = vendorNameMap.get(training.Vendor_Code__c);
                
                if(training.Student_Training_Mapping__r.Training_Code__r.Training_Type__c == 'Mock Interviews'){
                    contactwithEnglishTrngNameList.add(std);
                }
            }
            
            
            return contactwithEnglishTrngNameList;
            
            return null;}
        
        
        Catch(exception e){
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
        
        
        
    }
    public static Integer getThirdYearApirationalLength() {
        List<Training_Result__c> trainingResults = [select id,Pre_assessment_Scores__c,Marks_Obtained__c,Vendor_Code__c,Student_Training_Mapping__r.Student_ID__r.Current_year__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingState,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Written_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Logical_Score_post__c,
                                                    Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score_post__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score_post__c,Student_Training_Mapping__r.Student_ID__r.Aptitude_Analytical_Score__c,Student_Training_Mapping__r.Student_ID__r.English_Spoken_Score__c,Student_Training_Mapping__r.Student_ID__r.MailingCity,
                                                    Student_Training_Mapping__r.Student_ID__r.Name,Student_Training_Mapping__r.Student_ID__r.FFE_ID__c,Student_Training_Mapping__r.Student_ID__r.id,Student_Training_Mapping__r.Training_Code__r.id,Student_Training_Mapping__r.Training_Code__r.Training_Type__c FROM Training_Result__c 
                                                    Where (Student_Training_Mapping__r.Student_ID__r.Course__c = 'BE/B.Tech' OR Student_Training_Mapping__r.Student_ID__r.Course__c = 'Integrated MTech') AND Student_Training_Mapping__r.Student_ID__r.Current_year__c=:system.label.X3rd_year AND  Student_Training_Mapping__r.Training_Code__r.Training_Type__c =:system.label.IT];
        return  trainingResults.size();
    }
    
    public static Integer getFourthYearDataLength(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score_post__c,Endline_Aptitude_Analytical_Score__c,Endline_Aptitude_Logical_Score__c,Endline_English_Written_Score__c,Endline_English_Spoken_Score__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where RecordTypeId =:StudentRecordType  AND Current_year__c=:System.label.X4th_year AND (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech')  AND( Endline_Aptitude_Analytical_Score__c!=:null and Endline_Aptitude_Logical_Score__c!=:null and Endline_English_Written_Score__c!=:null and Endline_English_Spoken_Score__c!=:null)]; 
            
            
            return conList.size();
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
    }
    
    public static Integer getThirdYearDataLength(){
        try{
            Id StudentRecordType	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String currentFinancialYear =  Utility.financialYear();
            Training__c trngcustomSettng = Utility.getTrainingDetails();
            //changed query condition done by varun 
            List<Contact> conList = [SELECT id,Name,Gender__c,FFE_ID__c,MailingAddress,Current_year__c,MailingCity,MailingState,Course__c,Different_donor_view__c,English_Written_Score__c,English_Spoken_Score_post__c,English_Spoken_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score_post__c,Aptitude_Logical_Score_post__c,Aptitude_Analytical_Score_post__c From Contact 
                                     where RecordTypeId =:StudentRecordType  AND Current_year__c=:System.label.X3rd_year AND (Course__c = 'BE/B.Tech' OR Course__c = 'Integrated MTech')  AND( English_Written_Score_post__c!=:null and English_Spoken_Score_post__c!=:null and Aptitude_Analytical_Score_post__c!=:null and Aptitude_Logical_Score_post__c!=:null)]; 
            return conList.size();
        }Catch(Exception e){
            HandleBusinessException.captureError('TrainingAndSkillDevelopment_HLPR', 'getThirdYearData', e);
            return null;
        }
    }
    
}