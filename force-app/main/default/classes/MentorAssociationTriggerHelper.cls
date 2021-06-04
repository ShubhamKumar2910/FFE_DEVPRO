public class MentorAssociationTriggerHelper {
    
    public static Boolean runOnce =true;
    private static MentorAssociationTriggerHelper instance {get;set;}
    
    private MentorAssociationTriggerHelper(){}
    
    public static MentorAssociationTriggerHelper getInstance(){
        // lazy load the record type - only initialize if it doesn't already exist
        if(instance == null) instance = new MentorAssociationTriggerHelper();
        return instance;
    }
    
    public void updateTotalHoursAtInsert(Map<Id, Mentor_Mentee_Association__c> newMmaMap , Map<Id, Mentor_Mentee_Association__c> oldMmaMap){
        Map<id, String> selectedModuleMap = new Map<id, String>();
        List<Mentor_Mentee_Association__c> listToBeUpdated = new List<Mentor_Mentee_Association__c>();
        
        map<string, decimal> moduleMap = new map<string, decimal>();
        List<Program__c> allModuleData = [SELECT Hours_Required__c,Name FROM Program__c];
        set<id> mmaIds = new set<id>();
        for(Program__c pr : allModuleData ){
            moduleMap.put(pr.Name,pr.Hours_Required__c);
        }
        system.debug('All module map data hour and name'+moduleMap);
        
        for(Mentor_Mentee_Association__c mm :newMmaMap.values()){
            if((mm.Modules__c != null && oldMmaMap == null) || (mm.Modules__c != null && oldMmaMap.get(mm.Id).Modules__c != mm.Modules__c)){
                List<String> allThemodules = mm.Modules__c.split(';');
                
                System.debug('allThemodules'+allThemodules);
                decimal hour = 0;
                
                for(String individyalModule : allThemodules){
                    if(moduleMap.containsKey(individyalModule))
                        hour += moduleMap.get(individyalModule);
                }
                if(hour == 0){
                    Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c(Id=mm.Id);
                    mma.Total_Mentoring_Hours__c = 0;
                    listToBeUpdated.add(mma);
                }
                else if(hour > 0){
                    Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c(Id=mm.Id);
                    mma.Total_Mentoring_Hours__c = hour;
                    listToBeUpdated.add(mma);  
                }
            }
            else{
                decimal hour = 0;
                
                Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c(Id=mm.Id);
                mma.Total_Mentoring_Hours__c = hour;
                listToBeUpdated.add(mma);  
            }
        }
        
        
        update listToBeUpdated; 
    }
}