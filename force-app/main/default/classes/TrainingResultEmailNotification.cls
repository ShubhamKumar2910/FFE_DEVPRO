public class TrainingResultEmailNotification {
    
    /*
* Purpose : To link Student_Training_Mapping__c to Training result before insertion
* Parameter : Trigger.new
*/     
    public static void onBeforeInsert(List<Training_Result__c> newList){
        SavePoint sp  = Database.setSavepoint();
        try{
            set<String> ExternalIds                        	 		 = new set<String>();
            Map<String,String> studentTrainingID              		 = new Map<String,String>();
            
            Map<String, List<String>> dependentAndContrllingFieldsValues = ControllingAndDependentPickListInfo.getFieldDependencies('Student_Training__c','Specialization_Name__c','Courses__c');
            Map<String,String> trainingSpecialization = new Map<String,String>();
            Map<String,String> dependentandcontrollingval = new Map<String,String>();
            
            
            
            for(Training_Result__c trainingResult : newList){
                ExternalIds.add(String.valueOf(trainingResult.FFE_ID__c)+'-'+String.valueOf(trainingResult.STU_ID__c));
                if(trainingResult.Specialization_Name__c !=null && trainingResult.Specialization_Name__c!=''){
                    trainingSpecialization.put(String.valueOf(trainingResult.FFE_ID__c)+'-'+String.valueOf(trainingResult.STU_ID__c),trainingResult.Specialization_Name__c);
                    
                    if(dependentAndContrllingFieldsValues.containsKey(trainingResult.Specialization_Name__c)){
                        List<String> dependingfields = dependentAndContrllingFieldsValues.get(trainingResult.Specialization_Name__c);
                        String multiplicklistVal = '';
                        if(dependingfields.size()>0){
                            for(String s :dependingfields){
                                multiplicklistVal = multiplicklistVal + s +';';
                            }
                        }
                        dependentandcontrollingval.put(trainingResult.Specialization_Name__c,multiplicklistVal);
                    }
                }
            }
            
            List<Student_Training__c> studentTrainingList     		 = [SELECT id,External_ID__c,name,Student_ID__c,Training_Code__c,Points_Earned__c,Conclusion__c FROM Student_Training__c WHERE External_ID__c=:ExternalIds];
            
            
            for(Student_Training__c studentTraining :studentTrainingList){
                studentTrainingID.put(studentTraining.External_ID__c,studentTraining.id);
            }
            
            set<String> student_FFE_ID 						 		 = new set<String>();
            set<String> TrainingName						 		 = new Set<String>();
            set<String> uncreatedStudentTrainingMapping 	 		 = new set<String>();
            
            //to split the externalID string to respective FFEId, TrainingName
            for(String s : ExternalIds){
                if(!studentTrainingID.containsKey(s)){
                    uncreatedStudentTrainingMapping.add(s);
                    student_FFE_ID.add(s.split('-')[0]);
                    TrainingName.add(s.split('-')[1]);
                }
            }
            
            Map<String,Contact> unmappedStudentwithFFEID 	  	      = new Map<String,Contact>();
            Map<String,Training_Master__c> unmappedTrainingwithName   = new Map<String,Training_Master__c>();
            List<Student_Training__c> insertStudentTraining 		  = new List<Student_Training__c>();
            
            //to store FFEID as key and student record as value
            for(Contact con : [SELECT id,name,FFE_ID__c from Contact where FFE_ID__c =: student_FFE_ID]){
                unmappedStudentwithFFEID.put(con.FFE_ID__c,con);
            }
            
            //to store training name as key and training record as value
            for(Training_Master__c tm : [SELECT id,name from Training_Master__c where Name=:TrainingName]){
                unmappedTrainingwithName.put(tm.name,tm);
            }
            
            //to create Student Training mapping
            for(String s :uncreatedStudentTrainingMapping){
                if(unmappedStudentwithFFEID.get(s.split('-')[0])!=null && unmappedTrainingwithName.get(s.split('-')[1])!=null){
                    //Specialization_Name__c=trainingSpecialization.get(s),Courses__c=dependentandcontrollingval.get(trainingSpecialization.get(s))
                    //Student_Training__c st = new Student_Training__c(Student_ID__c = unmappedStudentwithFFEID.get(s.split('-')[0]).id,Training_Code__c = unmappedTrainingwithName.get(s.split('-')[1]).Id,External_ID__c=s);
                    Student_Training__c st = new Student_Training__c();
                    st.Student_ID__c = unmappedStudentwithFFEID.get(s.split('-')[0]).id;
                    st.Training_Code__c = unmappedTrainingwithName.get(s.split('-')[1]).Id;
                    st.External_ID__c=s;
                    if(trainingSpecialization.containsKey(s)   && dependentandcontrollingval.containsKey(trainingSpecialization.get(s))){
                        st.Specialization_Name__c=trainingSpecialization.get(s);
                        st.Courses__c=dependentandcontrollingval.get(trainingSpecialization.get(s));
                    }
                    system.debug(st);
                    insertStudentTraining.add(st);
                }
            }
            
            //upsert insertStudentTraining External_ID__c;
            insert insertStudentTraining;
            //to get IDs
            for(Student_Training__c st :insertStudentTraining){
                studentTrainingID.put(st.External_ID__c,st.id);
            }
            
            for(Training_Result__c trainingResult : newList){
                trainingResult.Student_Training_Mapping__c = studentTrainingID.get(String.valueOf(trainingResult.FFE_ID__c)+'-'+String.valueOf(trainingResult.STU_ID__c));
                trainingResult.Record_Inserted_Date__c = system.today();
            } 
        }catch(Exception ex){
            database.rollback(sp);
            HandleBusinessException.captureError('TrainingResultEmailNotification', 'onBeforeInsert', ex);
            
        }
    }
    
    // For Update Operation
    public static void onUpdateOperation(List<Training_Result__c> newList,Map<Id,Training_Result__c> oldMap){
        try{
            Map<String, List<String>> dependentAndContrllingFieldsValues = ControllingAndDependentPickListInfo.getFieldDependencies('Student_Training__c','Specialization_Name__c','Courses__c');
            List<Student_Training__c> UpdateSTMList = new List<Student_Training__c>();
            Map<String,String> dependentandcontrollingval = new Map<String,String>();
            Map<Id,String> spewithSTMMap = new Map<Id,String>();
            System.debug('dependentAndContrllingFieldsValues:::::::'+dependentAndContrllingFieldsValues);
            for(Training_Result__c tr : newList){
                
                if(tr.Specialization_Name__c !=oldMap.get(tr.id).Specialization_Name__c){
                    spewithSTMMap.put(tr.Student_Training_Mapping__c,tr.Specialization_Name__c);
                }
            }
            List<Student_Training__c> studTrainList = [Select Id,Name,External_ID__c,Specialization_Name__c,Courses__c 
                                                       from Student_Training__c where ID IN :spewithSTMMap.keySet()];
            System.debug('studTrainList:::::::'+studTrainList);
            
            
            for(Student_Training__c st :studTrainList){
                System.debug('dependentAndContrllingFieldsValues.get(spewithSTMMap.get(st.Id)):::::::'+dependentAndContrllingFieldsValues.get(spewithSTMMap.get(st.Id)));
                st.Specialization_Name__c = spewithSTMMap.get(st.Id); 
                List<String> dependingfields = dependentAndContrllingFieldsValues.get(spewithSTMMap.get(st.Id));
                String multiplicklistVal = '';
                if(dependingfields != null && dependingfields.size()>0){
                    for(String s :dependingfields){
                        multiplicklistVal = multiplicklistVal + s +';';
                    }
                }
                st.Courses__c = multiplicklistVal;
                System.debug('couses::::'+st.Courses__c);
                UpdateSTMList.add(st); 
            }
            System.debug('UpdateSTMList::::::::::'+UpdateSTMList);
            if(UpdateSTMList.size()>0){
                update  UpdateSTMList; 
            }
        }
        
        catch(Exception ex){
            HandleBusinessException.captureError('TrainingResultEmailNotification', 'onUpdateOperation', ex);
        }
    }
}