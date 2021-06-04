public class EmailMergeFieldParser {
    
    public class emailWrapper{
        public String emailBodyString;
        public String emailSubjectString;
        public String contactEmail;
        
        public emailWrapper(String emailBodyString,String emailSubjectString,String contactEmail){
            this.emailBodyString 		= emailBodyString;
            this.emailSubjectString 	= emailSubjectString;
            this.contactEmail 			= contactEmail;
        }
        
    }
    
    public static List<emailWrapper> parseModuleCompletedTemplates(String mentorTemplate,String menteeTemplate,map<string, Mentor_Mentee_Association__c> mmaRecMap){
        
        List<emailWrapper> emailInstance = new List<emailWrapper> ();
        Map<Id,Contact> contactMap		= new Map<Id,Contact> ();
        Set<String> allConIds 			= new Set<String> ();
        EmailTemplate mentorEmailTemp 	= new EmailTemplate();
        EmailTemplate menteeEmailTemp 	= new EmailTemplate();
        String menteeSubject 			= '';
        String mentorSubject 			= '';
        
        
        try{
            // Collecting individual Mentor and Mentee Ids
            if(mmaRecMap.size()>0){
                for(Mentor_Mentee_Association__c mmaRec: mmaRecMap.values() ){
                    // Run only if mentor needs an email
                    allConIds.add(mmaRec.Mentor__c);
                    // Run only if mentee needs an email
                    allConIds.add(mmaRec.mentee_del__c);
                   
                }
            }
            // Querying  Mentor and Mentee Contact records
            if(!allConIds.isEmpty()){
                
                contactMap = new Map<Id,Contact>([select name,id,FirstName,Email,Phone,Employer_Name__c,Student_College__c,Designation__c,is_Mentee__c,RecordTypeId,Location__c,College_Name__c,College_Location__c,Branch_Stream__c from Contact where Id in :allConIds]);
            }
            // Querying  Mentor and Mentee Email Templates records
            if(MentortempLate != null && MentortempLate != ''){
                mentorEmailTemp	=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: mentorTemplate];   
            }
            if(MenteetempLate != null && MenteetempLate != ''){
                menteeEmailTemp=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: menteeTemplate]; 
            }
            
            // Processing Email Template
            if(mmaRecMap.size()>0){
                for(String moduleName: mmaRecMap.keySet() ){
                    // Module name = moduleName
                    Contact mentorRec;
                    Contact menteeRec;
                    if(contactMap.containsKey(mmaRecMap.get(moduleName).Mentor__c)){
                        mentorRec 						= contactMap.get(mmaRecMap.get(moduleName).Mentor__c);
                    }
                    if(contactMap.containsKey(mmaRecMap.get(moduleName).mentee_del__c)){
                        menteeRec               		= contactMap.get(mmaRecMap.get(moduleName).mentee_del__c);
                    }
                    if(menteeEmailTemp != null ){
                        
                        String htmlBody 				= menteeEmailTemp.HtmlValue;
                        htmlBody 						= htmlBody.replace('{!Module.Name}', moduleName);
                        
                        menteeSubject					= menteeEmailTemp.Subject;
                        menteeSubject 					= menteeSubject.replace('{!Module.Name}', moduleName);
                        
                        Map<String, String> FieldValueByMergeField = new Map<String, String>();
                        FieldValueByMergeField = getMergeFieldsValues(htmlBody,mentorRec,menteeRec);
                        // Parsing Module Name
                        System.debug('FieldValueByMergeField'+FieldValueByMergeField);
                        //Parsing mentor and Mentee Info
                        for(String mergeField:FieldValueByMergeField.keySet()){
                            if(FieldValueByMergeField.get(mergeField) != null && FieldValueByMergeField.get(mergeField) != ''){
                                htmlBody = htmlBody.replace(mergeField, FieldValueByMergeField.get(mergeField));
                            }
                            else{
                                htmlBody = htmlBody.replace(mergeField, ' ');
                            }
                        }    
                        system.debug('menteeEmail==>'+menteeRec.Email);
                        emailInstance.add(new emailWrapper(htmlBody,menteeSubject,menteeRec.Email));
                        // Binding HTML Body With Contact Email
                        
                        
                    }
                    if(mentorEmailTemp != null ){
                        String htmlBody 				= mentorEmailTemp.HtmlValue;
                        htmlBody 						= htmlBody.replace('{!Module.Name}', moduleName);
                        
                        mentorSubject					= mentorEmailTemp.Subject;
                        mentorSubject 					= mentorSubject.replace('{!Module.Name}', moduleName);
                        
                        
                        Map<String, String> FieldValueByMergeField = new Map<String, String>();
                        FieldValueByMergeField = getMergeFieldsValues(htmlBody,mentorRec,menteeRec);
                        // Parsing Module Name
                        System.debug('FieldValueByMergeField'+FieldValueByMergeField);
                        //Parsing mentor and Mentee Info
                        for(String mergeField:FieldValueByMergeField.keySet()){
                            if(FieldValueByMergeField.get(mergeField) != null && FieldValueByMergeField.get(mergeField) != ''){
                                htmlBody = htmlBody.replace(mergeField, FieldValueByMergeField.get(mergeField));
                            }
                            else{
                                htmlBody = htmlBody.replace(mergeField, ' ');
                            }
                        }      
                        system.debug('mentorEmail==>'+mentorRec.Email);
                        emailInstance.add(new emailWrapper(htmlBody,mentorSubject,mentorRec.Email));
                        // Binding HTML Body With Contact Email
              
                    }
                                        
                }
            }
            
        }catch(Exception e){
            System.debug('Error'+e.getMessage()+e.getLineNumber());
        }
        System.debug('emailInstance'+emailInstance);
        sendEmail(emailInstance);
        return emailInstance;
    }
    public static Map<String, String> getMergeFieldsValues(String htmlBody,Contact mentorRec,Contact menteeRec){
        //String htmlBody = '{!Mentor.Name} ahahaha ahahaha ahahaha ahahahaha {!Mentee.Name} agagaga {!Mentee.Phone} ';
        Integer i=10;
        Map<String, String> mergeFieldtemp = new Map<String, String>();
        Map<String, String> FieldValueByMergeField = new Map<String, String>();
        while (i!=0){
            String s2 = htmlBody.substringBetween('{!','}');
            if(s2 != null){
                mergeFieldtemp.put(s2,'');
                i++;
                htmlBody = htmlBody.substring(htmlBody.indexOf('}')+1);
                System.debug('i============= :'+i);
                System.debug('Captured Merge :'+s2);
                System.debug(' New String####:'+htmlBody);
            }else{
                i=0;
            }
            
        }
        System.debug(' mergeFieldtemp:'+mergeFieldtemp);
        if(!mergeFieldtemp.isEmpty()){
            for(String mergeField :mergeFieldtemp.keySet()){
                System.debug('@@@@'+mergeField+'@@@');
                List<String> fieldAndObject = mergeField.split('\\.');
                System.debug('@@@@'+fieldAndObject+'@@@');
                if(!fieldAndObject.isEmpty() && fieldAndObject.size()==2){
                    String fieldApi = fieldAndObject[1];
                    String objectApi = fieldAndObject[0];
                    String fieldValue = '';
                    if(objectApi == 'Mentor'){
                        fieldValue = (String)mentorRec.get(fieldApi);
                    }else if(objectApi == 'Mentee'){
                        fieldValue = (String)menteeRec.get(fieldApi);
                    }
                    if(fieldValue != '') FieldValueByMergeField.put('{!'+mergeField+'}',fieldValue);
                }
                
            }
        }
        System.debug('FieldValueByMergeField'+FieldValueByMergeField);
        return FieldValueByMergeField;
    }
    
    public static void sendEmail(List<emailWrapper> emailWrapList){
        
        if(!emailWrapList.isEmpty()){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for(emailWrapper wrapInstance:emailWrapList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                recipients.add(wrapInstance.contactEmail);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('FFE Mentoring Team');
                mail.setSubject(wrapInstance.emailSubjectString);
                mail.setHtmlBody(wrapInstance.emailBodyString);
                
                mails.add(mail);
                System.debug('mails.size==>'+mails.size());
            }
            try{
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }catch(Exception e){
                System.debug('Error Line==>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
            }
            
        }
    }
}