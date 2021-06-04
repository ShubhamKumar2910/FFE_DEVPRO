public class SigninHelper {
    @RemoteAction
    public static String checkStudentDetails(String Id,String Password,String type){
        
        try{ 
            String returnMessage = '';
            if(type == 'Mentor'){
                system.debug('Id'+Id);
                String passwordFromDB =[select id,name,password__c from Contact where name=:Id and password__c != null].password__c;
                
                if(passwordFromDB.length() != 0){
                    if(passwordFromDB == Password){
                        returnMessage = 'Congratulations!!You are Logged in as Mentor';
                    }else{
                        returnMessage = 'Sorry!!The Password You entered is wrong!!';
                    }
                }else{
                    returnMessage = 'Sorry!!You are Not registered as Mentor!!';
                }
            }
            else{
                String passwordFromDB =[select id,name,password__c from Contact where name=:Id].password__c;
                if(passwordFromDB.length() != 0){
                    if(passwordFromDB == Password){
                        returnMessage = 'Congratulations!!You are Logged in as Mentee';
                    }else{
                        returnMessage = 'Sorry!!The Password You entered is wrong!!';
                    }
                }else{
                    returnMessage = 'Sorry!!You are Not registered as Mentee!!';
                }
            }
            return returnMessage;
        }
        catch(exception ex){
            System.debug('error.message====>'+ex.getMessage()+'error.getLineNumber===>'+ex.getLineNumber());
            return 'Sorry!!You are Not registered!!';
        }
    }  
    
    @RemoteAction
    Public static string menteeLogin(String emailId,String ffeuid){
        try{
            if(emailId.length() != 0 && ffeuid.length() != 0){
                string checkForMentee = [select name,id,email,FFE_ID__c from contact where email=:emailId AND FFE_ID__c=:ffeuid AND is_Mentee__c = true].id;
                if(checkForMentee.length() != 0){
                    return  temporaryMenteeLoginURL(checkForMentee, 'Mentee');
                }else{
                    return null;
                }  
              /*  List<contact> checkForMentee = [select name,id,email,FFE_ID__c from contact where email=:emailId AND FFE_ID__c=:ffeuid AND is_Mentee__c = true];
                system.debug('checkForMentee==='+checkForMentee);
                if(checkForMentee.size() > 0){
                    
                   temporaryMenteeLoginURL(checkForMentee[0].FFE_ID__c, checkForMentee[0].email); 
                    return checkForMentee[0].Id ;   
                }  */
            }  
            return 'Please enter valid Login Id';
        }catch(exception e){
            system.debug('getLineNumber==='+e.getLineNumber()+'getErroeMessage======'+e.getMessage());
            return 'Please enter valid Login Id';
        }

    }
    
    @RemoteAction
    Public static string mentorLogin(String emailId,String ffeuid){
        try{
            if(emailId.length() != 0 && ffeuid.length() != 0){
                string checkForMentor = [select name,id,email,FFE_ID__c from contact where email=:emailId AND password__c=:ffeuid AND RecordType.Name = 'Mentor'].id;
                system.debug(checkForMentor);
                if(checkForMentor.length() != 0){
                    return  temporaryMenteeLoginURL(checkForMentor, 'Mentor');
                }else{
                    return null;
                }  
                
            }
            return 'Please enter valid Login Id';
        }catch(exception e){ 
            system.debug('getLineNumber==='+e.getLineNumber()+'getErroeMessage======'+e.getMessage());
            return 'Please enter valid Login Id';
        }

    }
    
    @RemoteAction
    Public static string generateLoginURL(String ffeId,String types){
        return Utility.temporaryDonorLoginURL(ffeId, null,types);
    }
    
    @RemoteAction
    Public static string generateLoginURLForEmail(String emailId,String types){
        return Utility.temporaryDonorLoginURL(null, emailId,types);
    }
    
    public static string temporaryMenteeLoginURL(String contactId, string type){
        try{
           
            list<contact> contacts = [select name,id,Login_Hash_Code__c,Last_Hash_Code_Updated__c from contact where id =:contactId];
            system.debug('contacts===>'+contacts);
            
            if(contacts.size() > 0){
                contacts[0].Login_Hash_Code__c          = Utility.generateRandomString();
                contacts[0].Last_Hash_Code_Updated__c   = System.now();
                update contacts; 
                system.debug('contacts===>'+contacts);
                EmailTemplate et    =  new EmailTemplate();
                if(type == 'Mentor'){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = 'MentorLoginURl'];
                    
                }else if(type == 'Mentee'){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = 'MenteeLoginURl'];
                }
                    
                               
                return Utility.sendEmailWithTemplate(contacts[0].Id, et.Id);
            }else{
                return Constants.NO_USER_FOUND;
            }            
        }catch(Exception ex){
            system.debug('e==='+ex);
            HandleBusinessException.captureError('Signin', 'temporaryDonorLoginURL', ex);
            return Constants.ERROR_MSG;
        }
    }
}