public class EachModuleCompleted {
    public static void checkingModuleCompleteion(Map<id, Mentor_Mentee_Association__c> mmaNewMap, Map<id, Mentor_Mentee_Association__c> mmaOldMap){
        map<string, decimal> moduleMap = new map<string, decimal>();
        List<Program__c> allModuleData = [SELECT Hours_Required__c,Name FROM Program__c];
        System.debug('allModuleData==>'+allModuleData);
        for(Program__c pr : allModuleData ){
            moduleMap.put(pr.Name,pr.Hours_Required__c);
        }
        
        map<string, Mentor_Mentee_Association__c> mmaRecMap = new map<string, Mentor_Mentee_Association__c>();
        for(Mentor_Mentee_Association__c mma :  mmaNewMap.values()){
            if(mma.Duration_of_Sessions_Attended__c != mmaOldMap.get(mma.Id).Duration_of_Sessions_Attended__c){
                if(mma.Time_Management_Total_Hours__c > mmaOldMap.get(mma.Id).Time_Management_Total_Hours__c){
                    if(mma.Time_Management_Total_Hours__c >= moduleMap.get('Time and Stress Management')){
                        mmaRecMap.put('Time and Stress Management',mma);
                        system.debug('mmaRecMap==>'+mmaRecMap);
                    } 
                }
                if(mma.Career_Development_Total_Hours__c > mmaOldMap.get(mma.Id).Career_Development_Total_Hours__c){
                    if(mma.Career_Development_Total_Hours__c >= moduleMap.get('Career Development')){
                        mmaRecMap.put('Career Development',mma);
                        system.debug('mmaRecMap==>'+mmaRecMap);
                    }
                }
                if(mma.Communication_Total_Hours__c > mmaOldMap.get(mma.Id).Communication_Total_Hours__c){
                    if(mma.Communication_Total_Hours__c >= moduleMap.get('Communication Skills')){
                        mmaRecMap.put('Communication Skills', mma);
                        system.debug('mmaRecMap==>'+mmaRecMap);
                    }
                }
                if(mma.Etiquette_Total_Hours__c > mmaOldMap.get(mma.Id).Etiquette_Total_Hours__c){
                    if(mma.Etiquette_Total_Hours__c >= moduleMap.get('Etiquette ( How to conduct yourself during interviews, while communicating etc.)')){
                        mmaRecMap.put('Etiquette',mma);
                        system.debug('mmaRecMap==>'+mmaRecMap);
                    }
                }
                if(mma.Interpersonal_Skills_Total_Hours__c > mmaOldMap.get(mma.Id).Interpersonal_Skills_Total_Hours__c){
                    if(mma.Interpersonal_Skills_Total_Hours__c >= moduleMap.get('Interpersonal Skills (work ethics, professionalism, collaboration etc.)')){
                        mmaRecMap.put('Interpersonal Skills',mma);
                        system.debug('mmaRecMap==>'+mmaRecMap);
                    }
                }
                if(mma.Problem_Solving_Total_Hours__c > mmaOldMap.get(mma.Id).Problem_Solving_Total_Hours__c){
                    if(mma.Problem_Solving_Total_Hours__c >= moduleMap.get('Problem Solving and Decision Making')){
                        mmaRecMap.put('Problem Solving',mma);
                        system.debug('mmaRecMap==>'+mmaRecMap);
                    }
                }
            }  
        }
        System.debug('mmaRecMap'+mmaRecMap);
        EmailMergeFieldParser.parseModuleCompletedTemplates('SingleModuleCmpltdMentor','SingleModuleCmpltdMentee',mmaRecMap);
    } 
}