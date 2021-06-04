/*
* @Purpose      : Helperclass for DonorRegistration Page.
* @Author       : 
* @CreatedDate  : 
*/

public class Alumini_To_Donor_Helper {
    
    /*@purpose               :Get donor Information(here donor object is contact object) From page
* @param                 :@Contact object
* @returnType            :String
*/   
    
    Public static Boolean isStudent = false;
    
    public Static Alumni_To_Donor_Ctrl.messageWrapper createDonorInSFDC(Contact newDonor){
        Alumni_To_Donor_Ctrl.messageWrapper mwrp    = new Alumni_To_Donor_Ctrl.messageWrapper();
        SavePoint sp    = Database.setSavepoint();
        try{
            List<Contact> mobileDupContact =  checkDupForMobile(newDonor.MobilePhone,null);           
            if(newDonor.MobilePhone != null && mobileDupContact.size() > 0){
                if(isStudent == false){
                       mwrp.message = String.valueOf(emailMask(mobileDupContact[0].Email));
                   }else{
                       mwrp.message = Constants.googleFacebookDuplicate_Email;   
                   }
                   return mwrp;
            }
            
            List<Contact> panDupContact = checkDupForPan(newDonor.DN_PAN__c,null);
            if(newDonor.DN_PAN__c != null && newDonor.DN_PAN__c != ''
               && panDupContact.size() > 0){
                   if(isStudent == false){
                       mwrp.message = String.valueOf(emailMask(panDupContact[0].Email));
                   }else{
                       mwrp.message = Constants.googleFacebookDuplicate_Email;   
                   }
                   return mwrp;
               }
            
            List<Contact> aadharDupContact = checkDupForAadhar(newDonor.Aadhar_number__c,null);
            if(newDonor.Aadhar_number__c != null && newDonor.Aadhar_number__c != ''
               && aadharDupContact.size() > 0){
                   
                   if(isStudent == false){
                       mwrp.message = String.valueOf(emailMask(aadharDupContact[0].Email));
                   }else{
                       mwrp.message = Constants.googleFacebookDuplicate_Email;   
                   }
                   return mwrp;
               }
            
            if(newDonor.Google_login_ID__c != null && newDonor.Google_login_ID__c != ''
               && checkDupForEmail(newDonor.Google_login_ID__c,null).size() > 0){
                   if(isStudent == false){
                       mwrp.message = Constants.EMAIL_DUPLICATE_ERR_MSG;
                   }else{
                       mwrp.message = Constants.googleFacebookDuplicate_Email;  
                   }
                   return mwrp;
               }
            if(newDonor.Facebook_login_ID__c != null && newDonor.Facebook_login_ID__c != ''
               && checkDupForEmail(newDonor.Facebook_login_ID__c,null).size() > 0){
                   if(isStudent == false){
                       mwrp.message = Constants.EMAIL_DUPLICATE_ERR_MSG;
                   }else{
                       mwrp.message = Constants.googleFacebookDuplicate_Email;   
                   }        
                   return mwrp;
               }
            
            List<Contact> emailDupContact = checkDupForEmail(newDonor.Email,null);
            if(newDonor.Email != null && newDonor.Email != ''
               && emailDupContact.size() > 0){
                   
                   if(isStudent == false){
                       mwrp.message = String.valueOf(emailMask(emailDupContact[0].Email));
                   }else{
                       mwrp.message = Constants.googleFacebookDuplicate_Email;   
                   }
                   return mwrp;
               }
            
            
            
            
            
            newDonor.RecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            
            if(newDonor.Do_you_have_Google_login__c != null)
                newDonor.Do_you_have_Google_login__c    = Boolean.valueOf(newDonor.Do_you_have_Google_login__c);
            if(newDonor.Do_you_have_Facebook_login__c != null)
                newDonor.Do_you_have_Facebook_login__c  = Boolean.valueOf(newDonor.Do_you_have_Facebook_login__c);
            
            newDonor.Is_Active_Alumni__c = true;
            
            insert newDonor;
            
            mwrp.message    = Constants.SUCCESS_REGISTERED_MSG;
            mwrp.recordId   = DN_CCAvenue_Service.encryptString(newDonor.Id, DN_ServiceConstants.DN_ORDER_KEY);         
            return mwrp;
        }catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('DN_DonorRegistration_Helper', 'createDonorInSFDC', e);
            mwrp.message    = Constants.ERROR_MSG;
            return mwrp;
        }
    }
    
    /*@purpose     : Check if any contact already exist with Mobile no.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    
    
    public Static List<Contact> checkDupForMobile(String mobile, string currentRecordId){
        String recordTypeIDs                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        List<Contact> conList = new List<Contact>();
        
        if(currentRecordId != null){
            conList = [SELECT ID,Email,RecordTypeID FROM CONTACT where MobilePhone =:Mobile AND Id !=: currentRecordId LIMIT 1];
        }else{
            conList = [SELECT ID,Email,RecordTypeID FROM CONTACT where MobilePhone =:Mobile LIMIT 1];    
        }

        if(conList.size()>0 && conList[0].RecordTypeID == recordTypeIDs){
            isStudent = true;
        }
        
        return conList;
    }
    
    /*@purpose     : Check if any contact already exist with PAN no.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    public Static List<Contact> checkDupForPan(String PAN, string currentRecordId){
        String recordTypeIDs                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        List<Contact> conList = new List<Contact>();
        if(currentRecordId != null){
            conList = [SELECT ID,Email,RecordTypeID FROM CONTACT where DN_PAN__c =:PAN AND Id !=: currentRecordId LIMIT 1];
        }else{
            conList = [SELECT ID,Email,RecordTypeID FROM CONTACT where DN_PAN__c =:PAN LIMIT 1]; 
        }            
        if(conList.size()>0 && conList[0].RecordTypeID == recordTypeIDs)
            isStudent = true;
        
        return conList;
    }
    
    /*@purpose    : Check if any contact already exist with Email.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    public Static List<Contact> checkDupForEmail(String emailId, string currentRecordId){
        String recordTypeIDs                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        List<Contact> conList = new List<Contact>();
        
        if(currentRecordId != null){
            conList =  [SELECT ID,Email,RecordTypeID FROM CONTACT where (email =:emailId OR Google_login_ID__c =: emailId 
                                                                   OR Facebook_login_ID__c  =:emailId) AND Id !=: currentRecordId LIMIT 1];
        }else{
            conList =  [SELECT ID,Email,RecordTypeID FROM CONTACT where (email =:emailId OR Google_login_ID__c =: emailId 
                                                                   OR Facebook_login_ID__c  =:emailId) LIMIT 1]; 
        }   
        
        if(conList.size()>0 && conList[0].RecordTypeID == recordTypeIDs)
            isStudent = true;
        
        return conList;
    }
    
    /*@purpose    : Check if any contact already exist with Aadhar number.
* @param       :aadhar 
* @returnType  :List<Contact>
*/           
    public Static List<Contact> checkDupForAadhar(String Aadhar_number, string currentRecordId){
        String recordTypeIDs                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        List<Contact> conList = new List<Contact>();
        if(currentRecordId != null){
            conList = [SELECT ID,Email FROM CONTACT where Aadhar_number__c =:Aadhar_number  AND Id !=: currentRecordId LIMIT 1];
        }else{
            conList = [SELECT ID,Email FROM CONTACT where Aadhar_number__c =:Aadhar_number LIMIT 1]; 
        }            
        if(conList.size()>0 && conList[0].RecordTypeID == recordTypeIDs)
            isStudent = true;
        
        return conList;
    }
    
    public Static String emailMask(String email){
        String asterics = '';
        for(integer i=1;i<=email.substring(2, email.indexOf('@')-1).length();i++)
            asterics = asterics + '*';
        return email.replace(email.substring(1, email.indexOf('@')-1),asterics);
    }
    
    
    public static String updateAlumniEmail(String currentEmail,String alumniEmail,String Mobile,String Pan,String aadhar){
        
        if(alumniEmail != null && alumniEmail != ''
           && checkDupForEmail(alumniEmail,null).size() > 0){
               return Constants.EMAIL_DUPLICATE_ERR_MSG;
           }
        
        Contact con =  [SELECT ID,Email,Alumni_Email__c,DN_PAN__c,Aadhar_number__c,MobilePhone FROM CONTACT where Aadhar_number__c=:aadhar OR DN_PAN__c=:pan OR MobilePhone=:Mobile OR email =:currentEmail LIMIT 1];
        update new Contact(ID=con.id,Alumni_Email__c=alumniEmail,Is_Active_Alumni__c = true);
        return Constants.Email_Updation_Message;
    }
    
    
    public static string sendEmail(String currentEmail){
        return Utility.temporaryDonorLoginURL(null,currentEmail,null);
    }
}