public class SendSMSforEachModuleCompleted {
    public static boolean runOnce = true;
    public static void sendingSmsOnSingleModuleCompletion(Map<id, Mentor_Mentee_Association__c> mmaNewMap, Map<id, Mentor_Mentee_Association__c> mmaOldMap){
        
        map<string, decimal> moduleMap 			= new map<string, decimal>();
        map<string, Id> mmaRecMap 				= new map<string, Id>();
        Map<String, String> msgBodyForMentee 	= new Map<String, String>();
        Map<String, String> msgBodyForMentor 	= new Map<String, String>();
        Set<String> ContactsToBeused 			= new Set<String>();
        set<id> mmaIds 							= new set<id>();
        String status							= 'Single Module Completed';
        
        List<Message_Template__c> msgRecList = [SELECT Applicable_Status__c,Recipient_Type__c,SMS_Body__c FROM Message_Template__c where Applicable_Status__c = 'Single Module Completed'];
        for(Message_Template__c msgTemp : msgRecList){
            if(msgTemp.Recipient_Type__c == 'Mentee'){
                msgBodyForMentee.put(msgTemp.Applicable_Status__c,msgTemp.SMS_Body__c); // Key: status & Value :Body
            }else if(msgTemp.Recipient_Type__c == 'Mentor'){
                msgBodyForMentor.put(msgTemp.Applicable_Status__c,msgTemp.SMS_Body__c); // Key: status & Value :Body
            }
        }
        
        List<Program__c> allModuleData = [SELECT Hours_Required__c,Name FROM Program__c];
        for(Program__c pr : allModuleData ){
            moduleMap.put(pr.Name,pr.Hours_Required__c);
        }
        
        for(Mentor_Mentee_Association__c mma :  mmaNewMap.values()){
            
            if(mma.Duration_of_Sessions_Attended__c > mmaOldMap.get(mma.Id).Duration_of_Sessions_Attended__c ){
                if(mma.Time_Management_Total_Hours__c > mmaOldMap.get(mma.Id).Time_Management_Total_Hours__c){
                    if(mma.Time_Management_Total_Hours__c >= moduleMap.get('Time and Stress Management')){
                        mmaRecMap.put('Time and Stress Management',mma.Id);
                    } 
                }
                if(mma.Career_Development_Total_Hours__c > mmaOldMap.get(mma.Id).Career_Development_Total_Hours__c){
                    if(mma.Career_Development_Total_Hours__c >= moduleMap.get('Career Development')){
                        mmaRecMap.put('Career Development',mma.Id);
                    }
                }
                if(mma.Communication_Total_Hours__c > mmaOldMap.get(mma.Id).Communication_Total_Hours__c){
                    if(mma.Communication_Total_Hours__c >= moduleMap.get('Communication Skills')){
                        mmaRecMap.put('Communication Skills', mma.Id);
                    }
                }
                if(mma.Etiquette_Total_Hours__c > mmaOldMap.get(mma.Id).Etiquette_Total_Hours__c){
                    if(mma.Etiquette_Total_Hours__c >= moduleMap.get('Etiquette ( How to conduct yourself during interviews, while communicating etc.)')){
                        mmaRecMap.put('Etiquette',mma.Id);
                    }
                }
                if(mma.Interpersonal_Skills_Total_Hours__c > mmaOldMap.get(mma.Id).Interpersonal_Skills_Total_Hours__c){
                    if(mma.Interpersonal_Skills_Total_Hours__c >= moduleMap.get('Interpersonal Skills (work ethics, professionalism, collaboration etc.)')){
                        mmaRecMap.put('Interpersonal Skills',mma.Id);
                    }
                }
                if(mma.Problem_Solving_Total_Hours__c > mmaOldMap.get(mma.Id).Problem_Solving_Total_Hours__c){
                    if(mma.Problem_Solving_Total_Hours__c >= moduleMap.get('Problem Solving and Decision Making')){
                        mmaRecMap.put('Problem Solving',mma.Id);
                    }
                }
            }
        }
        for(String mmaId :  mmaRecMap.values()){
            mmaIds.add(mmaId);
        }
        system.debug('mmaRecMap==>'+mmaRecMap);
        
        List<Mentor_Mentee_Association__c> mmaRecList = [SELECT Id,mentee_del__c,mentee_del__r.Phone,mentee_del__r.Name,Mentor__c,Mentor__r.Phone,Mentor__r.Name,Status__c FROM Mentor_Mentee_Association__c where id in : mmaIds];
        
        for(Mentor_Mentee_Association__c mmaData : mmaRecList){
            if(mmaData.mentee_del__c != null)
                ContactsToBeused.add(mmaData.mentee_del__c);
            if(mmaData.Mentor__c != null)
                ContactsToBeused.add(mmaData.Mentor__c);
        }
        Map<Id,Contact> contactById = new Map<Id,Contact>([Select Phone,Name,is_Mentee__c,Salutation,Is_Mentor__c From Contact where id In:ContactsToBeused ]);
        
        for(Mentor_Mentee_Association__c mmaData : mmaRecList ){
            
            Contact conDataMentee = contactById.get(mmaData.mentee_del__c);
            if(conDataMentee != null){
                
                String smsBody 	= parseSMSBody(msgBodyForMentee.get(status),contactById.get(mmaData.mentee_del__c),contactById.get(mmaData.Mentor__c), mmaRecMap);
                system.debug('smsBody ::'+smsBody);
                system.debug('conData.Phone ::'+conDataMentee.Phone);
                SendSMSNotification_Helper.sendSingleSMS(conDataMentee.Phone,smsBody);
            }
            
            Contact conDataMentor = contactById.get(mmaData.Mentor__c);
            if(conDataMentor != null){
                String smsBody 	= parseSMSBody(msgBodyForMentor.get(status),contactById.get(mmaData.mentee_del__c),contactById.get(mmaData.Mentor__c), mmaRecMap);
                system.debug('smsBody ::'+smsBody);
                system.debug('conData.Phone ::'+conDataMentor.Phone);
                SendSMSNotification_Helper.sendSingleSMS(conDataMentor.Phone,smsBody);
            }
        }
    }
    public static String parseSMSBody(String templateBody, Contact conRecMentee,Contact conRecMentor, map<string, Id> mmaMap){
        if(templateBody.contains('{!Mentor.Name}')){
            templateBody = templateBody.replace('{!Mentor.Name}',conRecMentor != null ? conRecMentor.Name:'');
        }
        if(templateBody.contains('{!Mentee.Name}')){
            templateBody = templateBody.replace('{!Mentee.Name}',conRecMentee!= null ?conRecMentee.Name:'');
        }
        if(templateBody.contains('{!Mentee.Salutation}')){
            templateBody = templateBody.replace('{!Mentee.Salutation}',conRecMentee.Salutation!= null ?conRecMentee.Salutation:'');
        }
        if(templateBody.contains('{!Mentor.Salutation}')){
            templateBody = templateBody.replace('{!Mentor.Salutation}',conRecMentor.Salutation!= null ?conRecMentor.Salutation:'');
        }
        for(String moduleName: mmaMap.keySet() ){
            if(templateBody.contains('{!Module.Name}')){
                templateBody = templateBody.replace('{!Module.Name}',moduleName);
            }
        }
        return templateBody;
        
    }
}