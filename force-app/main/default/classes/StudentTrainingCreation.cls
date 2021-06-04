public class StudentTrainingCreation{
    
    /*
*@ purpose : To Convert List - Map
*/    
    private static Map<Id, Contact> makeMapFromSObjectList(List<Contact> lstSobject) {
        
        if (lstSobject == null) return null;
        Map<Id, Contact> theMap = new Map<Id, Contact>();
        for (Contact s : lstSobject) {
            theMap.put((Id)s.get('Id'), s);
        }
        return theMap; 
    }    
    
    /*
* purpose   : To tag Student(s) to respective Training and creating a
*             junction object for student(s) attached to respective training
* parameter :Trigger.old,Trigger.new
*/
    
    public static void onAfterUpdate(List<Contact> oldList,List<Contact> newList){ 
        SavePoint sp  = Database.setSavepoint();
        try{
            
            Map<id,Contact> newContactMap                      =     makeMapFromSObjectList(newList);
            Map<id,Contact> oldContactMap                      =     makeMapFromSObjectList(oldList);
            
            Map<id,Training_Master__c> training_Eng_Rest_Map   =     new Map<id,Training_Master__c>([SELECT id,name,Student_Years__c,Amcat_dependence_check__c,Training_Type__c FROM Training_Master__c WHERE (Student_Years__c INCLUDES ('1st Year') or Student_Years__c INCLUDES ('2nd Year')) AND (Training_Type__c=:Constants.Aptitude OR Training_Type__c=:Constants.English) AND Amcat_dependence_check__c=:true]);
            List<Student_Training__c> studentTrainingList      = 	 new List<Student_Training__c>();
            
            
            for(id ids : newContactMap.keyset()){
                
                if(conditionCheck(oldContactMap,newContactMap,ids) == true){
                       
                       for(Training_Master__c training : training_Eng_Rest_Map.values()){ 
                           
                           if(training.Student_Years__c.contains(newContactMap.get(ids).Current_year__c) && training.Training_Type__c ==Constants.Aptitude &&(newContactMap.get(ids).Aptitude_Analytical_Score__c < Utility.getTrainingDetails().Min_Aptitude_Analytical_Score__c || newContactMap.get(ids).Aptitude_Logical_Score__c < Utility.getTrainingDetails().Min_Aptitude_Logical_Score__c) && (oldContactMap.get(ids).Aptitude_Analytical_Score__c <> newContactMap.get(ids).Aptitude_Analytical_Score__c || oldContactMap.get(ids).Aptitude_Logical_Score__c <> newContactMap.get(ids).Aptitude_Logical_Score__c)){
                               Student_Training__c st      = new Student_Training__c(Student_ID__c = ids,Training_Code__c = training.Id,External_ID__c=String.valueOf(newContactMap.get(ids).FFE_ID__c+'-'+training.Name));
                               studentTrainingList.add(st);
                           }
                           if(training.Student_Years__c.contains(newContactMap.get(ids).Current_year__c) && training.Training_Type__c ==Constants.English &&(newContactMap.get(ids).English_Spoken_Score__c < Utility.getTrainingDetails().Min_English_Spoken_Score__c || newContactMap.get(ids).English_Written_Score__c < Utility.getTrainingDetails().Min_English_Wriitten_Score__c) && (oldContactMap.get(ids).English_Spoken_Score__c <> newContactMap.get(ids).English_Spoken_Score__c || oldContactMap.get(ids).English_Written_Score__c <> newContactMap.get(ids).English_Written_Score__c) ){
                               Student_Training__c st      = new Student_Training__c(Student_ID__c = ids,Training_Code__c = training.Id,External_ID__c=String.valueOf(newContactMap.get(ids).FFE_ID__c+'-'+training.Name));
                               studentTrainingList.add(st);
                           }
                       }
                   }
            }
            
            if(!studentTrainingList.isEmpty()){
                upsert studentTrainingList  External_ID__c;
            }
            
        }
        catch(Exception ex){
            HandleBusinessException.captureError('StudentTrainingCreation', 'onAfterUpdate', ex);
            database.rollback(sp);
        }            
        
    }
    
    
    public static boolean conditionCheck(Map<id,Contact> oldContactMap ,Map<id,Contact> newContactMap, ID ids){ 
        
        if(String.valueOf(constants.Training_internal_status).contains(newContactMap.get(ids).Internal_Status__c)
           && (newContactMap.get(ids).Course__c==constants.BE_BTECH || newContactMap.get(ids).Course__c==constants.INTEGRATED_MTECH) 
           && (oldContactMap.get(ids).Aptitude_Analytical_Score__c <> newContactMap.get(ids).Aptitude_Analytical_Score__c || oldContactMap.get(ids).Aptitude_Logical_Score__c <> newContactMap.get(ids).Aptitude_Logical_Score__c || 
               oldContactMap.get(ids).English_Spoken_Score__c <> newContactMap.get(ids).English_Spoken_Score__c || oldContactMap.get(ids).English_Written_Score__c <> newContactMap.get(ids).English_Written_Score__c) 
           && (newContactMap.get(ids).Internal_Status__c != constants.INELIGIBLE) && (newContactMap.get(ids).Internal_Status__c != constants.ELIGIBLE)){
               return true; 
           }else{
               return false;    
           }
    }
    
}