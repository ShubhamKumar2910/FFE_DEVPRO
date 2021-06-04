public class DN_QuickDonatciopn_HLPR {
    public static Id donerRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
    
    public static DN_PaymentWrapper checkIsDonorPresent(DN_PaymentWrapper orderwrp){
        SavePoint sp  = Database.setSavepoint();
        try{
            
            List<Contact> conListDupMobile = checkDupForMobile(orderwrp.donorRecord.MobilePhone,null);
            if(orderwrp.donorRecord.MobilePhone != null && conListDupMobile.size() > 0){
                orderwrp.donorRecord.id = conListDupMobile[0].id;
                update orderwrp.donorRecord;//Update the donor with donation form data-- Sumit Gaurav - 16-June-2020
                return orderwrp;
            }
            
            List<Contact> conListDupPan = checkDupForPan(orderwrp.donorRecord.DN_PAN__c,null);
            if(orderwrp.donorRecord.DN_PAN__c != null && orderwrp.donorRecord.DN_PAN__c != ''
               && conListDupPan.size() > 0){
                   orderwrp.donorRecord.id = conListDupPan[0].id;
                   update orderwrp.donorRecord;//Update the donor with donation form data-- Sumit Gaurav - 16-June-2020
                   return orderwrp;
               } 
            
            List<Contact> conListDupAadhar = checkDupForAadhar(orderwrp.donorRecord.Aadhar_number__c,null);
            if(orderwrp.donorRecord.Aadhar_number__c != null && orderwrp.donorRecord.Aadhar_number__c != ''
               && conListDupAadhar.size() > 0){
                   orderwrp.donorRecord.id = conListDupAadhar[0].id;
                   update orderwrp.donorRecord;//Update the donor with donation form data-- Sumit Gaurav - 16-June-2020
                   return orderwrp;
               }
            
            List<Contact> conListDupEmail = checkDupForEmail(orderwrp.donorRecord.Email,null);
            if(orderwrp.donorRecord.Email != null && orderwrp.donorRecord.Email != ''
               && conListDupEmail.size() > 0){
                   orderwrp.donorRecord.id = conListDupEmail[0].id;
                   update orderwrp.donorRecord;//Update the donor with donation form data-- Sumit Gaurav - 16-June-2020
                   return orderwrp;
               }
            
            List<Contact> conListDupFFE = checkDupForFFEUID(orderwrp.donorRecord.Previous_FFE_ID__c,null);
            if(orderwrp.donorRecord.Previous_FFE_ID__c != null && orderwrp.donorRecord.Previous_FFE_ID__c != ''
               && conListDupFFE.size() > 0){
                   orderwrp.donorRecord.id = conListDupFFE[0].id;
                   update orderwrp.donorRecord;//Update the donor with donation form data-- Sumit Gaurav - 16-June-2020
                   return orderwrp;
               }
            
            orderwrp.donorRecord.RecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            
            insert orderwrp.donorRecord;
            
            //EmailTemplate newDonorRegisteredTemplate  = [Select id,Developername from EmailTemplate where Developername =:Constants.NewDonorRegiteredThroughtQuickDonationPage Limit 1];
            //String message = Utility.sendEmailWithTemplate(orderwrp.donorRecord.id,newDonorRegisteredTemplate.id);
            return orderwrp;
            
        }Catch(Exception e){
            database.rollback(sp);
            system.debug(e.getLineNumber());
            system.debug(e.getMessage());
            HandleBusinessException.captureError('DN_QuickDonation_HLPR', 'checkIsDonorPresent', e);
            return null;
            
        }
    }
    
    /*@purpose     : Check if any contact already exist with FFEUID.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    
    
    public Static List<Contact> checkDupForFFEUID(String FFEID, string currentRecordId){
        if(currentRecordId != null){
            return [SELECT ID FROM CONTACT where Previous_FFE_ID__c =:FFEID AND Id !=: currentRecordId AND RecordTypeId=:donerRecTypeId LIMIT 1];
        }else{
            return [SELECT ID FROM CONTACT where Previous_FFE_ID__c =:FFEID AND RecordTypeId=:donerRecTypeId LIMIT 1];    
        }
    }
    
    
    /*@purpose     : Check if any contact already exist with Mobile no.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    
    
    public Static List<Contact> checkDupForMobile(String mobile, string currentRecordId){
        if(currentRecordId != null){
            return [SELECT ID FROM CONTACT where MobilePhone =:Mobile AND Id !=: currentRecordId AND RecordTypeId=:donerRecTypeId LIMIT 1];
        }else{
            return [SELECT ID FROM CONTACT where MobilePhone =:Mobile AND RecordTypeId=:donerRecTypeId LIMIT 1];    
        }
    }
    
    /*@purpose     : Check if any contact already exist with PAN no.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    public Static List<Contact> checkDupForPan(String PAN, string currentRecordId){
        if(currentRecordId != null){
            return [SELECT ID FROM CONTACT where DN_PAN__c =:PAN AND Id !=: currentRecordId AND RecordTypeId=:donerRecTypeId LIMIT 1];
        }else{
            return [SELECT ID FROM CONTACT where DN_PAN__c =:PAN AND RecordTypeId=:donerRecTypeId LIMIT 1]; 
        }            
        
    }
    
    /*@purpose    : Check if any contact already exist with Email.
* @param       :mobile 
* @returnType  :List<Contact>
*/           
    public Static List<Contact> checkDupForEmail(String emailId, string currentRecordId){
        String recordTypeIDs                 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        List<Contact> conList = new List<Contact>();
        
        if(currentRecordId != null){
            conList =  [SELECT ID,RecordTypeID FROM CONTACT where (email =:emailId OR Google_login_ID__c =: emailId 
                                                                   OR Facebook_login_ID__c  =:emailId) AND Id !=: currentRecordId AND RecordTypeId=:donerRecTypeId LIMIT 1];
        }else{
            conList =  [SELECT ID,RecordTypeID FROM CONTACT where (email =:emailId OR Google_login_ID__c =: emailId 
                                                                   OR Facebook_login_ID__c  =:emailId) AND RecordTypeId=:donerRecTypeId LIMIT 1]; 
        }   
        return conList;
    }
    
    /*@purpose    : Check if any contact already exist with Aadhar number.
* @param       :aadhar 
* @returnType  :List<Contact>
*/           
    public Static List<Contact> checkDupForAadhar(String Aadhar_number, string currentRecordId){
        if(currentRecordId != null){
            return [SELECT ID FROM CONTACT where Aadhar_number__c =:Aadhar_number  AND Id !=: currentRecordId AND RecordTypeId=:donerRecTypeId LIMIT 1];
        }else{
            return [SELECT ID FROM CONTACT where Aadhar_number__c =:Aadhar_number AND RecordTypeId=:donerRecTypeId LIMIT 1];  
        }    
    }
    
    
    public static DN_OrderConfirmationWrapper paymentOrederCreation(DN_PaymentWrapper PaymentorderDonorWrp){
     try{
        DN_CCAvenue_Service newDonation =  new DN_CCAvenue_Service();
        Contact con = [Select id,Email,Name,FirstName,LastName,MobilePhone,MailingStreet,MailingCity,DN_Citizenship__c,Aadhar_number__c,MailingCountry, MailingState,MailingPostalCode,DN_PAN__c, DN_Passport_Number__c,FFE_ID__c,Previous_FFE_ID__c from contact where id=:PaymentorderDonorWrp.donorRecord.id];
        PaymentorderDonorWrp.donorRecord = con;
         system.debug('1'+PaymentorderDonorWrp);
        DN_OrderConfirmationWrapper orderCofirmWrp =  newDonation.createDonationOrderInSFDB(PaymentorderDonorWrp);
         system.debug(orderCofirmWrp.orderInfo.id);
        update new Payment_Order__c(id=orderCofirmWrp.orderInfo.id,Order_Amount__c=PaymentorderDonorWrp.totalOrderAmountINR,Order_Amount_USD__c=PaymentorderDonorWrp.totalOrderAmountUSD,Quick_Donation__c=true,Email__c=con.Email,First_Name__c=con.FirstName,Last_Name__c=con.LastName,Mobile__c = con.MobilePhone ,Mailling_Address__c = con.MailingStreet ,City__c = con.MailingCity ,Citizenship__c = con.DN_Citizenship__c ,Aadhar_Number__c = con.Aadhar_number__c ,Country__c = con.MailingCountry ,State__c =con.MailingState ,Zip_Pincode__c =con.MailingPostalCode ,PAN__c  = con.DN_PAN__c ,Passport__c = con.DN_Passport_Number__c ,FFeUID__c=con.Previous_FFE_ID__c);
        
        return orderCofirmWrp;
           }Catch(Exception e){
               system.debug(e.getLineNumber());
               system.debug(e.getMessage());
               HandleBusinessException.captureError('DN_QuickDonation_HLPR', 'paymentOrederCreation', e);
               return null;
           }
    }
    
    
    //to get city list
    public Static List<State_City_Master__c> getAllCities(String currentState) {         
        String Query = 'select City__c from State_City_Master__c where State__c=:currentState OR (State__c like \'%' +currentState+ '%\') Order By City__c LIMIT 40000';     
        List<State_City_Master__c> listOfcities         = new List<State_City_Master__c>();
        listOfcities = Database.query(Query);system.debug(listOfcities);
        //listOfcities.add(Database.query(Query));
        return listOfcities;
    }
}