/*
* @Purpose      : Helperclass for DonorRegistration Page.
* @Author       : 
* @CreatedDate  : 
*/

public class DN_DonorRegistration_Helper {
    public static Id donerRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
    public static Id stdRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
    public static Id facRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();

    /*@purpose               :Get donor Information(here donor object is contact object) From page
	* @param                 :@Contact object
	* @returnType            :String
	*/   
    public Static DN_DonorRegistration_CTRL.messageWrapper createDonorInSFDC(Contact newDonor){
        DN_DonorRegistration_CTRL.messageWrapper mwrp	= new DN_DonorRegistration_CTRL.messageWrapper();
        SavePoint sp	= Database.setSavepoint();
        try{
            if(newDonor.Aadhar_number__c != null && checkDupForAadhar(newDonor.Aadhar_number__c,null,constants.FFE_Donor_Donor).size() > 0){
                mwrp.message	= Constants.Aadhaar_error_message_donorRegstr_page;
                return mwrp;
            }
            if(newDonor.MobilePhone != null && checkDupForMobile(newDonor.MobilePhone,null,constants.FFE_Donor_Donor).size() > 0){
                mwrp.message	= Constants.MOBILE_DUPLICATE_ERR_MSG;
                return mwrp;
            }
            if(newDonor.Phone != null && checkDupForPhone(newDonor.Phone,null,constants.FFE_Donor_Donor).size() > 0){
                mwrp.message	= Constants.PHONE_DUPLICATE_ERR_MSG;
                return mwrp;
            }
            if(newDonor.Email != null && newDonor.Email != ''
               && checkDupForEmail(newDonor.Email,null,'Donor').size() > 0){
                mwrp.message	= Constants.EMAIL_DUPLICATE_ERR_MSG;
                return mwrp;
            }
            if(newDonor.Google_login_ID__c != null && newDonor.Google_login_ID__c != ''
               && checkDupForEmail(newDonor.Google_login_ID__c,null,'Donor').size() > 0){
                mwrp.message	= Constants.EMAIL_DUPLICATE_ERR_MSG;
                return mwrp;
            }
            if(newDonor.Facebook_login_ID__c != null && newDonor.Facebook_login_ID__c != ''
               && checkDupForEmail(newDonor.Facebook_login_ID__c,null,'Donor').size() > 0){
                mwrp.message	= Constants.EMAIL_DUPLICATE_ERR_MSG;
                return mwrp;
            }

            
            
            newDonor.RecordTypeId                 	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 

            if(newDonor.Do_you_have_Google_login__c != null)
            	newDonor.Do_you_have_Google_login__c  	= Boolean.valueOf(newDonor.Do_you_have_Google_login__c);
            if(newDonor.Do_you_have_Facebook_login__c != null)
            	newDonor.Do_you_have_Facebook_login__c 	= Boolean.valueOf(newDonor.Do_you_have_Facebook_login__c);
			
            
            insert newDonor;
           
            mwrp.message	= Constants.SUCCESS_REGISTERED_MSG;
            mwrp.recordId	= DN_CCAvenue_Service.encryptString(newDonor.Id, DN_ServiceConstants.DN_ORDER_KEY);         
        	return mwrp;
        }catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('DN_DonorRegistration_Helper', 'createDonorInSFDC', e);
            mwrp.message	= Constants.ERROR_MSG;
            return mwrp;
        }
    }
    

      
    /*@purpose     : Check if any contact already exist with Mobile no.
    * @param       :mobile 
    * @returnType  :List<Contact>
    */           
    
    
    public Static List<Contact> checkDupForMobile(String mobile, string currentRecordId,String recordTypeName){
        if(currentRecordId != null){
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where MobilePhone =:Mobile AND Id !=: currentRecordId LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and MobilePhone =:Mobile AND Id !=: currentRecordId LIMIT 1];
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and MobilePhone =:Mobile AND Id !=: currentRecordId LIMIT 1];   
            }
         }else{
             if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where MobilePhone =:Mobile LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and MobilePhone =:Mobile LIMIT 1];
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and MobilePhone =:Mobile LIMIT 1];   
            }
        }
    }
    
    /*@purpose     : Check if any contact already exist with Phone no.
    * @param       :mobile 
    * @returnType  :List<Contact>
    */           
    public Static List<Contact> checkDupForPhone(String phoneNo, string currentRecordId,String recordTypeName){
        if(currentRecordId != null){
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where Phone =:phoneNo AND Id !=: currentRecordId LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and Phone =:phoneNo AND Id !=: currentRecordId LIMIT 1];
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and Phone =:phoneNo AND Id !=: currentRecordId LIMIT 1];   
            }
        }else{
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where Phone =:phoneNo LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and Phone =:phoneNo LIMIT 1];
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and Phone =:phoneNo LIMIT 1];   
            }
        }            
        
    }
    
    /*@purpose    : Check if any contact already exist with Email.
    * @param       :mobile 
    * @returnType  :List<Contact>
    */           
    public Static List<Contact> checkDupForEmail(String emailId, string currentRecordId,String recordTypeName){
       if(currentRecordId != null){
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where (email =:emailId OR Google_login_ID__c =: emailId 
                                                  OR Facebook_login_ID__c	=:emailId) AND Id !=: currentRecordId LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and (email =:emailId OR Google_login_ID__c =: emailId 
                                                  OR Facebook_login_ID__c	=:emailId) AND Id !=: currentRecordId LIMIT 1];    
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and (email =:emailId OR Google_login_ID__c =: emailId 
                                                  OR Facebook_login_ID__c	=:emailId) AND Id !=: currentRecordId LIMIT 1];    
            }
        }else{
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where (email =:emailId OR Google_login_ID__c =: emailId 
                                                  OR Facebook_login_ID__c	=:emailId) LIMIT 1]; 
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and (email =:emailId OR Google_login_ID__c =: emailId 
                                                  OR Facebook_login_ID__c	=:emailId) LIMIT 1];    
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and (email =:emailId OR Google_login_ID__c =: emailId 
                                                  OR Facebook_login_ID__c	=:emailId) LIMIT 1];    
            }
        }    
    }
    
   /*@purpose    : Check if any contact already exist with Aadhar number.
    * @param       :aadhar 
    * @returnType  :List<Contact>
    */           
    public Static List<Contact> checkDupForAadhar(String Aadhar_number, string currentRecordId,String recordTypeName){
        if(currentRecordId != null){
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where Aadhar_number__c =:Aadhar_number AND Id !=: currentRecordId LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and Aadhar_number__c =:Aadhar_number AND Id !=: currentRecordId LIMIT 1];
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and Aadhar_number__c =:Aadhar_number AND Id !=: currentRecordId LIMIT 1];   
            }
        }else{
            if(recordTypeName == Constants.FFE_DONOR_STUDENT){
            return [SELECT ID FROM CONTACT where Aadhar_number__c =:Aadhar_number LIMIT 1];
            }else if(recordTypeName == Constants.FFE_Donor_Donor){
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:donerRecTypeId) and Aadhar_number__c =:Aadhar_number LIMIT 1];
            }else{
            return [SELECT ID FROM CONTACT where (RecordTypeId=:stdRecTypeId OR RecordTypeId=:facRecTypeId) and Aadhar_number__c =:Aadhar_number LIMIT 1];   
            }
        }         
    }
    
      /*@purpose    : Check if any contact already exist with FFEID.
    * @param       :aadhar 
    * @returnType  :List<Contact>
    */           
    public Static String checkDupForFacilitator(String Refered_by_Facilitator_Id){
        
        List<Contact> facilitator = [SELECT ID,name FROM CONTACT where FFE_ID__c =:Refered_by_Facilitator_Id LIMIT 1];
        
        if(facilitator.size()!=0 && (facilitator[0].Name!=null || facilitator[0].Name!='' )){  
            
            return String.valueof(facilitator[0].Name);   
        }else{
            return Constants.Facilitator_error;
        } 
    } 
    
}