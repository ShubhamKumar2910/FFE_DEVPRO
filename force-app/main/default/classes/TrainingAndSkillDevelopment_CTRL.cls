public class TrainingAndSkillDevelopment_CTRL {
    
    public string CourseBEBTechYear    {get;set;} 
    public string EnglishWrittenScore  {get;set;}
    public string EnglishSpokenScore  {get;set;}
    public string AptitudelogicalScore  {get;set;}
    public string AptitudeAnalyticalScore  {get;set;}
    
    
    public TrainingAndSkillDevelopment_CTRL(){
        CourseBEBTechYear   = JSON.serializePretty(new List<String>{'2nd Year','3rd Year','4th Year'});
        Training__c trngcustomSettng = Utility.getTrainingDetails();
        EnglishSpokenScore = String.valueOf(Integer.valueOf(trngcustomSettng.Min_English_Spoken_Score__c));
        EnglishWrittenScore = String.valueOf(Integer.valueOf(trngcustomSettng.Min_English_Wriitten_Score__c));
        AptitudeAnalyticalScore = String.valueOf(Integer.valueOf(trngcustomSettng.Min_Aptitude_Analytical_Score__c));
        AptitudelogicalScore = String.valueOf(Integer.valueOf(trngcustomSettng.Min_Aptitude_Logical_Score__c));
    }
    
    
    @RemoteAction    
    public static string getSecondYearData(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getSecondYearData());
    }
    
    @RemoteAction    
    public static Integer getSecondYearDataLength(){
        return TrainingAndSkillDevelopment_HLPR.getSecondYearDataLength();
    }
    
    @RemoteAction    
    public static string getThirdYearData_1(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getThirdYearData());
    }
    
    @RemoteAction    
    public static string getfourthYearData_1(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getFourthYearData());
    }
    
    @RemoteAction    
    public static Integer getFourthYearDataLength(){
        return TrainingAndSkillDevelopment_HLPR.getFourthYearDataLength();
    }
    
    @RemoteAction    
    public static Integer getThirdYearDataLength(){
        return TrainingAndSkillDevelopment_HLPR.getThirdYearDataLength();
    }
    
    @RemoteAction    
    public static string getSecondAspiringStdYearData(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getSecondAspiringStdYearData());
    }
    
    
    @RemoteAction    
    public static string getSecondYearAspiringStudentData(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getSecondYearAspiringStudentData());
    }
    
    @RemoteAction    
    public static string englishAndAptitudeAppData(String trainingType){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.englishAndAptitudeAppData(trainingType));
    }
    
    
    
    @RemoteAction    
    public static string getThirdYearData(String trainingType){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getThirdYearData(trainingType));
    }
    
    @RemoteAction    
    public static Integer getThirdYearDataEnglisLength(){
        return (TrainingAndSkillDevelopment_HLPR.getThirdYearDataEnglisLength());
    }
    
    @RemoteAction    
    public static Integer getThirdYearApirationalLength(){
        return (TrainingAndSkillDevelopment_HLPR.getThirdYearApirationalLength());
    }
    
    @RemoteAction    
    public static string getfourthYearData(String trainingType){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getfourthYearData(trainingType));
    }
    
    @RemoteAction
    public static string getPlacementStudentData(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getPlacementStudentData());
    }
    
    @RemoteAction
    public static string getMockinterViewRecordForThirdYear(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getMockinterViewRecordForThirdYear());
    }
    
    @RemoteAction
    public static string getMockInterViewRecordDetailForThirdYear(){
        return JSON.serializePretty(TrainingAndSkillDevelopment_HLPR.getMockInterViewRecordDetailForThirdYear());
    }
    
}