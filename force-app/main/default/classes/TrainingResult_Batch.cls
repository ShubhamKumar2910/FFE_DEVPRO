/*
*Purpose : Batch class to send Email Notification for Student regarding Training detail and to Update total point.         
*/
global class TrainingResult_Batch implements Database.Batchable<sObject>, Database.Stateful,Schedulable{
    
    static final String subject               = 'Pending Training Alert';
    global String htmlHeader 				  = '';
    global String htmlBody 					  = '';
    static final string htmlFooter            = '</table></br><p>Please spend required hrs for the training assiged to you else your scholarship can get impacted.<p>Regards,</br>Scholarship Team,</br>Foundation for Excellence.</p>';
    global Map<String,List<String>> emailMap  = new Map<String,List<String>>();
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {   
        date createdDateValue    = System.Today();
        String status            = Constants.NOT_PROCESSED;
        
        // String previousMonth	 = datetime.now().addMonths(-1).format('MMMMM');
      /*  Map<Id,Training_Master__c> triningMasterList = new Map<Id,Training_Master__c>([SELECT id ,name,Milestone_1__c,Milestone_2__c,Milestone_3__c from Training_Master__c]);
        set<id> trainingMasterID = triningMasterList.keySet();
		System.debug('trainingMasterID:::::::'+trainingMasterID);
			for(id ids:triningMasterList.keySet()){
				trainingMasterID.add(ids);
		}*/
        
        return Database.getQueryLocator('SELECT id,Name,Completion_Flag__c,FFE_ID__c,Marks_Obtained__c,Milestone__c,Student_Training_Mapping__c,Time_on_App__c,STU_ID__c,Vendor_Code__c,Status__c,CreatedDate,Record_Inserted_Date__c,Student_Training_Mapping__r.Points_Earned__c,Student_Training_Mapping__r.Training_Code__r.Points__c,Student_Training_Mapping__r.name,Student_Training_Mapping__r.Student_ID__r.Email,Student_Training_Mapping__r.Training_Code__r.Min_Time_on_App_30__c,Student_Training_Mapping__r.Student_ID__r.name,Student_Training_Mapping__r.Training_Code__r.Name FROM Training_Result__c WHERE Status__c=:status');    
    }
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new TrainingResult_Batch(), 100); 
    }
    
    global void execute(Database.BatchableContext BC, List<Training_Result__c> newList){
        try{
            system.debug('entered execute');
            Map<ID,Student_Training__c> studentTrainingMap 		= new Map<ID,Student_Training__c>();
            
            for(Training_Result__c traningResult : newList){
                
                if(traningResult.Milestone__c == Constants.MILESTONE_VALUE_3){
                    
                    if(traningResult.Milestone__c == Constants.MILESTONE_VALUE_3 && traningResult.Completion_Flag__c == Constants.COMPLETION_FLAG_YES){
                        traningResult.Status__c = Constants.PROCESSED;
                        studentTrainingMap.put(traningResult.Student_Training_Mapping__c,new Student_Training__c(Id=traningResult.Student_Training_Mapping__c,Points_Earned__c = traningResult.Student_Training_Mapping__r.Training_Code__r.Points__c,Conclusion__c = constants.COMPLETED));
                    }
                    else{
                        studentTrainingMap.put(traningResult.Student_Training_Mapping__c,new Student_Training__c(Id=traningResult.Student_Training_Mapping__c,Conclusion__c = System.Label.Not_Completed));
                    }
                }
                else if(traningResult.Milestone__c == Constants.MILESTONE_VALUE_2 && traningResult.Completion_Flag__c == Constants.COMPLETION_FLAG_NO){
                    traningResult.Status__c = Constants.PROCESSED;
                    
                    if(!emailMap.containsKey(traningResult.Student_Training_Mapping__r.Student_ID__r.Email)){
                        
                        htmlHeader += 'Dear '+traningResult.Student_Training_Mapping__r.Student_ID__r.name+',<p>You have not spent required minimum hours of training assinged to you.</p><p>Details are below:</p>';
                        htmlHeader += '<table border="1" style="border-collapse: collapse;table-layout: fixed;width: 400px">';
                        htmlHeader +=  '<tr>';
                        htmlHeader +=    '<th>Training Name/Code</th>';
                        htmlHeader +=    '<th>Minimum Hrs req</th>';
                        htmlHeader +=    '<th>Hrs spent till now</th>';
                        htmlHeader +=  '</tr>';
                        htmlHeader +=  '<tr>';
                        htmlHeader +=    '<td align="center">'+traningResult.Student_Training_Mapping__r.Training_Code__r.Name+'</td>';
                        htmlHeader +=    '<td align="center">'+Utility.checkIsNull(traningResult.Student_Training_Mapping__r.Training_Code__r.Min_Time_on_App_30__c)+' '+Utility.checkIsOne(Integer.valueOf(traningResult.Student_Training_Mapping__r.Training_Code__r.Min_Time_on_App_30__c))+'</td>';
                        htmlHeader +=    '<td align="center">'+Utility.checkIsNull(traningResult.Time_on_App__c)+' '+Utility.checkIsOne(Integer.valueOf(traningResult.Time_on_App__c))+'</td>';
                        htmlHeader +=  '</tr>';
                        
                        emailMap.put(traningResult.Student_Training_Mapping__r.Student_ID__r.Email,new List<String>{htmlbody});
                    } 
                    else{
                        htmlBody +=  '<tr>';
                        htmlBody +=    '<td align="center">'+traningResult.Student_Training_Mapping__r.Training_Code__r.Name+'</td>';
                        htmlBody +=    '<td align="center">'+Utility.checkIsNull(traningResult.Student_Training_Mapping__r.Training_Code__r.Min_Time_on_App_30__c)+' '+Utility.checkIsOne(Integer.valueOf(traningResult.Student_Training_Mapping__r.Training_Code__r.Min_Time_on_App_30__c))+'</td>';
                        htmlBody +=    '<td align="center">'+Utility.checkIsNull(traningResult.Time_on_App__c)+' '+Utility.checkIsOne(Integer.valueOf(traningResult.Time_on_App__c))+'</td>';
                        htmlBody +=  '</tr>';
                        
                        emailMap.get(traningResult.Student_Training_Mapping__r.Student_ID__r.Email).add(htmlbody);
                    }
                }
            }
            if(studentTrainingMap.values().size()>0)
                update studentTrainingMap.values();
            if(newList.size()>0)
                update newList;
        }catch(exception ex){
            HandleBusinessException.captureError('TrainingResultEmailNotification', 'onBeforeInsert', ex);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        try{
            List<Messaging.SingleEmailMessage> emailsToSend 			= 		new List<Messaging.SingleEmailMessage>();   
            for(String e : emailMap.keySet()){
                
                string body = string.join(emailMap.get(e),' ');
                emailstosend.add(Utility.sendMail(subject,string.valueof(htmlHeader+body+htmlFooter),new List<String>{e}));
            }
            if(!emailsToSend.isEmpty()){
                Messaging.sendEmail(emailsToSend);
            }
        }catch(exception ex){
            HandleBusinessException.captureError('TrainingResultEmailNotification', 'onBeforeInsert', ex);
        }
    }
}