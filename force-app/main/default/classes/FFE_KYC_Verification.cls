/************************************************************************************************************
Apex ClassName - FFE_KYC_Verification
Version - 1.0 
Created Date - 23-June-2020  
Developed By - Sumit Gaurav
Function -  The class is called from KYC Verfied button on contact record page
Modification Log :
-----------------------
* Developers                   Date                   Description
* ----------                  -----                  ------------------------*/
global class FFE_KYC_Verification{

    /**************************************************************************************************
    @method name: kycVerification
    @param: Id
    @return: boolean
    Descrption :  This method updates 
    ***************************************************************************************************/
    webservice static boolean  kycVerification(Id contactId){
        
        Boolean verified=false;
        Boolean eAadharDeleted=false;
        String activeApplicationID;
        
        try{
            if(contactId!=null){
                Contact con=[select id,KYC_Verified__c,Active_Application_ID__c,Aadhar_number__c from Contact where id =:contactId];
                con.KYC_Verified__c=true;
                if(!String.IsBlank(con.Active_Application_ID__c)){
                    activeApplicationID=con.Active_Application_ID__c;
                }
                if(!String.IsBlank(con.Aadhar_number__c)){
                    string hashCodeString=generateHashCode(con.Aadhar_number__c);
                    if(!String.IsBlank(hashCodeString)){
                        con.Aadhar_number__c=hashCodeString;
                        update con;
                        verified=true;
                        eAadharDeleted=eAadharFileDeletion(activeApplicationID);
                    }
                }
            }
        }catch(exception e){
            HandleBusinessException.captureError('Utility', 'kycVerification', e);
        }
        if(verified && eAadharDeleted){
            return true;
        }else{
            return false;
        }
    }
    
    /**************************************************************************************************
    @method name: generateHashCode
    @param: Id
    @return: boolean
    Descrption :  This method generates code encrypted with ManagedIV for a string
    ***************************************************************************************************/
    public static string generateHashCode(String targetString){
        String hashCodeString;
        try{
            if(!String.IsBlank(targetString)){
            // Convert to BLOB
            Blob targetBlob = Blob.valueOf(targetString);
            String keyValue='9876543210123456';
            Blob key = Blob.valueOf(keyValue);
            // Encrypt with AES128 algorithm standards
            Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, targetBlob);
            String encryptedValue = EncodingUtil.base64encode (encrypted);
            hashCodeString=encryptedValue;
            System.debug (hashCodeString);
            }
        }catch(exception e){
            HandleBusinessException.captureError('Utility', 'generateHashCode', e);
        }
        return hashCodeString;
    }
    
    /**************************************************************************************************
    @method name: eAadharFileDeletion
    @param: Id
    @return: boolean
    Descrption :  This method deletes eAadhar after KYC verification
    ***************************************************************************************************/
    public static boolean eAadharFileDeletion (String activeApplicationID){
        Boolean deleted=false;
        if(!String.IsBlank(activeApplicationID)){
            try{
                List<Attachment> eAadharfile=[Select id from Attachment where Name='Copy of Aadhaar.pdf' and parentId=:activeApplicationID];
                if(eAadharfile.size()>0){
                    delete eAadharfile;
                    deleted = true;
                }
                else if(eAadharfile.size()==0){
                    deleted = true;
                }
            }catch(exception e){
                HandleBusinessException.captureError('Utility', 'eAadharFileDeletion', e);
            }
            
        }
        return deleted;
    }
}