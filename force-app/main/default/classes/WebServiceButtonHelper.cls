/*
*@ Purpose : contains Webservice Methods which are used by Custom Button
*/

global class WebServiceButtonHelper {
    
    /*
* @purpose      : Send Email to target record with Email template, which is called by custom button.
* @parameter    :TargetRecordID(used to whom email has to be sent),WhatID(used to access merge fields)
* @returnType   : string
*/
    Webservice static String sendEmailWithTemplateThroughCustomButton(string targetRecordId,String whatId){
        
        EmailTemplate emailTemplateId = [Select id from EmailTemplate where Developername =: Constants.EMAIL_TEMPLATE_NAME];
        return Utility.sendEmailWithTemplateThroughCustomButton(targetRecordId,emailTemplateId.id, whatId);
    }
    
    /*@purpose: Submit Approval Process for sepcified object
* @param : ApprovalProcessName, SubmitterID(user id), RecordID(which record needs to submit for approval)
*/
    Webservice static void submitSobjectApprovalProcess(String appId, String currentSubmitterID, String approvalProcessName){
        
        Approval.ProcessSubmitRequest req1   =    new  Approval.ProcessSubmitRequest();        
        req1.setObjectId(appId);
        
        req1.setSubmitterId(currentSubmitterID);        
        req1.setProcessDefinitionNameOrId(approvalProcessName);
        req1.setSkipEntryCriteria(true);
        Approval.process(req1);
    }
    
    /*
* @ SMS notification on Events , programs by FFE
* @parameter : phonenumber,Message
*/     
    Webservice static void send_SMS_during_Events(List<String> ContactNumberID,String messageForEvent){
        
        List<Contact> contactList        =   [SELECT id,MobilePhone from contact where id=:ContactNumberID];
        List<String> contactNumbers      =   new List<String>();
        
        for(Contact con : contactList){
            
            if(con.MobilePhone != null)
                contactNumbers.add(String.valueOf(con.MobilePhone));
        }
        
        if(!contactNumbers.isEmpty())
            SMS_Service_Helper.sendBulkSMS(contactNumbers,messageForEvent);
    }
    
    
    /*
* @ SMS notification for student regarding documents that need to be uploaded.
* @parameter : student(contact) number
*/     
    Webservice static void send_SMS(String ContactNumber){
        SMS_Service_CTRL.uploadDocumentSMS(ContactNumber);
    }
    
    
    /*
* @ SMS notification for Donor regarding 80G form.
* @parameter : Donor(contact) number
*/     
    Webservice static void send_80G_form_SMS(String DonorNumber,String EmailSuccessfullySentCondition){
        if(EmailSuccessfullySentCondition == Constants.MAIL_SENT_SUCCESS_MSG)
            SMS_Service_CTRL.send_80G_form_SMS(DonorNumber);
    }  
    
    
    /*
* @ to run batch through a custom button for Training score object records.
*/     
    Webservice static void runBatch(){
        
        Database.executeBatch(new TrainingResult_Batch(),100); 
    }
    
    
    //
    //
    webservice static string sendBulk80GForm(String OpportuniytId){
        SendBulkITCertificate shn = new SendBulkITCertificate(OpportuniytId); 
        database.executeBatch(shn,50);
        return Constants.Email_Scheduled_Msg;
    }
    
    webservice static String refundAmount(String sourceGauId,String destinationdonor,String destinationDonorBalance,Integer refundingAmount,String sourceDBln,Integer sourceDonorbalanceCurrentBlnc){
        try{
            List<Donor_Balance__c> updateDonorBalanceList = new List<Donor_Balance__c>();
            Donor_Balance__c donorBalanceToRefund =  [select id,Gau_Balance_Refund_Amount__c,Current_Balance__c,Donor_Name__c,GAU_Name__c,Donor_Name__r.Name,GAU_Name__r.Name  from Donor_Balance__c where Donor_Name__c=:destinationdonor AND GAU_Name__c=:sourceGauId LIMIT 1];
            
            if(donorBalanceToRefund !=null ){
                donorBalanceToRefund.Current_Balance__c = donorBalanceToRefund.Current_Balance__c - Integer.valueOf(refundingAmount);
                donorBalanceToRefund.Gau_Balance_Refund_Amount__c = Integer.valueOf(refundingAmount);
                updateDonorBalanceList.add(donorBalanceToRefund);
                
                Donor_Balance__c reduceamountDB = new Donor_Balance__c(id=sourceDBln,Current_Balance__c=Integer.valueOf(sourceDonorbalanceCurrentBlnc)+Integer.valueOf(refundingAmount));
                updateDonorBalanceList.add(reduceamountDB);
                
                if(!updateDonorBalanceList.isEmpty())
                    update updateDonorBalanceList;   
                return 'Success';
            }
            return 'Please contact System Admin!!';
        }Catch(Exception e){
            system.debug(e.getMessage());
            return 'Please contact System Admin!!';
        }
    }
    
    
    /////
    Webservice static String getBAU_TransactionDetails(List<String> BAU_Ids){
        return CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(BAU_Ids);
        //    return 'Successfully posted to Bridge Appv daskjhjksah';
    }
    
    
    /*
* @ Email notification.
* @parameter : Financial year
*/     
    Webservice static string emailNotificationForUsDonor(List<String> financialyear,String emailIds,String EmailMsg,String subjectval){
        system.debug('FY:'+financialyear +'emailIds:'+emailIds+'EmailMsg:'+EmailMsg+'subjectval:'+subjectval);  
        return emailNotificationForUsDonorHelper.sendMailtodonors(financialyear,emailIds,EmailMsg,subjectval);
        /* emailNotificationForUsDonorHelperBatch em = new emailNotificationForUsDonorHelperBatch(financialyear);
Database.executeBatch(em,20);  */
        
    } 
    
    /*  Webservice static void sendMailWithBATXNs(List<String> BAU_Ids){
system.debug('Called for Get Transaction button');
CIB_ICICI_TransactionAPICallout.sendMailWithBATXNs(BAU_Ids);    
} */
    
    // on click of Posted button //this works after the GAU allocation amount has been distributed
    /*public static void refundAmountThroughPosted(String donorId){

List<GAU_Balance_Transfer__c> gauBlncTrns = [Select Id,isRefunded__c,Source_donor__c,Donor_Balance__c,Source_GAU__c,Destination_donor__c,Transfered_Fund__c,Source_GAU__r.npsp__Total_Allocations__c,Donor_Balance__r.Current_Balance__c,Refunded_Amount__c from GAU_Balance_Transfer__c where Donor_Balance__r.Donor_Name__c =:donorId AND isRefunded__c=:false];       

Set<String> destinationDonors = new Set<String>();

for(GAU_Balance_Transfer__c gau:gauBlncTrns){
destinationDonors.add(String.valueOf(gau.Destination_donor__c));
}

List<Donor_Balance__c> destinationDonorsDonorBalance =  [select id,Gau_Balance_Refund_Amount__c,Current_Balance__c,Donor_Name__c,GAU_Name__c,Donor_Name__r.Name,GAU_Name__r.Name  from Donor_Balance__c where Donor_Name__c=:destinationDonors];
Map<String,Donor_Balance__c> destinationDonorPlusSourceGausInDB = new Map<String,Donor_Balance__c>();

for(Donor_Balance__c db:destinationDonorsDonorBalance){
destinationDonorPlusSourceGausInDB.put(String.valueOf(db.Donor_Name__c)+'@@'+String.valueOf(db.GAU_Name__c),db);
}

Map<id,Donor_Balance__c> updateDonorBalanceMap = new Map<id,Donor_Balance__c>();
Map<id,Donor_Balance__c> updatesourceDonorBalanceMap = new Map<id,Donor_Balance__c>();
List<GAU_Balance_Transfer__c> gauListToUpdate =  new List<GAU_Balance_Transfer__c>();
for(GAU_Balance_Transfer__c gau:gauBlncTrns){
//to reduce amount from destination donor balance
Donor_Balance__c updateDestinationDB = new Donor_Balance__c(id=destinationDonorPlusSourceGausInDB.get(String.valueOf(gau.Destination_donor__c)+'@@'+String.valueOf(gau.Source_GAU__c)).ID,
Current_Balance__c=Integer.valueOf(destinationDonorPlusSourceGausInDB.get(String.valueOf(gau.Destination_donor__c)+'@@'+String.valueOf(gau.Source_GAU__c)).Current_Balance__c) - Integer.valueOf(gau.Transfered_Fund__c),
Gau_Balance_Refund_Amount__c=Integer.valueOf(gau.Transfered_Fund__c));

if(!updateDonorBalanceMap.containsKey(updateDestinationDB.id)){
updateDonorBalanceMap.put(updateDestinationDB.id,updateDestinationDB);
}else{
updateDestinationDB.Gau_Balance_Refund_Amount__c = updateDonorBalanceMap.get(updateDestinationDB.id).Gau_Balance_Refund_Amount__c + Integer.valueOf(gau.Transfered_Fund__c);
updateDestinationDB.Current_Balance__c = updateDonorBalanceMap.get(updateDestinationDB.id).Current_Balance__c - Integer.valueOf(gau.Transfered_Fund__c);
updateDonorBalanceMap.put(updateDestinationDB.id,updateDestinationDB); 
}

//to increase amount in source donor balance
Donor_Balance__c updateSourceDB = new Donor_Balance__c(id=gau.Donor_Balance__c,Current_Balance__c=Integer.valueOf(gau.Donor_Balance__r.Current_Balance__c) + Integer.valueOf(gau.Transfered_Fund__c));


if(!updatesourceDonorBalanceMap.containsKey(updateSourceDB.id)){
updatesourceDonorBalanceMap.put(updateSourceDB.id,updateSourceDB);
}else{
updateSourceDB.Current_Balance__c = updatesourceDonorBalanceMap.get(updateSourceDB.id).Current_Balance__c + Integer.valueOf(gau.Transfered_Fund__c);
updatesourceDonorBalanceMap.put(updateSourceDB.id,updateSourceDB);
}

gauListToUpdate.add(new GAU_Balance_Transfer__c(id=gau.id,isRefunded__c=true,Refunded_Amount__c=gau.Transfered_Fund__c));
}

if(!updateDonorBalanceMap.isEmpty())
update updateDonorBalanceMap.values();
if(!updatesourceDonorBalanceMap.isEmpty())
update updatesourceDonorBalanceMap.values();
if(!gauListToUpdate.isEmpty())
update gauListToUpdate;        
}*/
    
    /**************************************************************************************************
@method name: checkForDonAppMapping
@param: Contact Id,Financial Year 
@return: boolean
Descrption :  This method is called from Beneficiary detail page button on Donor page layout
***************************************************************************************************/
    Webservice static Boolean checkForDonAppMapping(String conId,String fyear) {
        List<Donor_Application_Mapping__c> listDonAppMapping = [Select id from Donor_Application_Mapping__c where Donor__c=:conId AND Financial_Year__c =:fyear AND Application__r.Internal_Status__c ='Disbursed' ];
        System.debug(listDonAppMapping);
        if(listDonAppMapping.size() > 0) {
            return true;
        }
        else {
            return false ;
        }
    }
    
    /***********************************************************************************************************************
@method name: saveAttachement
@param: Contact Id,Financial Year 
@return: 
Descrption :  This method is called from Beneficiary detail page button on Donor page layout to   save attachment as Excel
****************************************************************************************************************************/
    Webservice static void saveAttachement(String conId,String financialYear) {                        
        PageReference xls = Page.BeneficiaryDetailsInExcel;
        xls.getParameters().put('id',conId);
        xls.getParameters().put('fyear',financialYear);
        
        String name = 'BeneficiaryDetailFor'+financialYear+ '.xls';
        
        
        Blob body;
        try {
            
            body = xls.getContent();
            Attachment attach = new Attachment();
            attach.Body = body;
            
            attach.Name = name;
            attach.IsPrivate = false;
            
            attach.parentId = conId ;
            
            insert attach;
            
        } catch (VisualforceException e) {            
            system.debug('in the catch block');
            body = Blob.valueOf('Some Text');
        }
        
    } 
    
    /**************************************************************************************************
@method name: checkForFundUtilization
@param: Contact Id,Financial Year 
@return: boolean
Descrption :  This method is called from Fund Utilization detail page button  on Donor page layout 
***************************************************************************************************/
    Webservice static Boolean checkForFundUtilization(String conId,String fyear) {
        List<Fund_Utilization__c> fundutilizationList = [Select id from Fund_Utilization__c where Donor__c=:conId AND  Application__r.RPT_Financial_Year__c =: fyear AND Application__r.Internal_Status__c = 'Disbursed' ];
        if(fundutilizationList.size() > 0) {
            return true;
        }
        else {
            return false ;
        }
    }
    
    /*************************************************************************************************************************
@method name: saveAttachementForUtilization
@param: Contact Id,Financial Year 
@return: 
Descrption :  This method is called from Fund Utilization detail page button on Donor page layout  to save attachment as Excel
*******************************************************************************************************************************/
    Webservice static void saveAttachementForUtilization(String conId,String financialYear) {                        
        PageReference xls = Page.FundUtilizationDetailsInExcel;
        xls.getParameters().put('id',conId);
        xls.getParameters().put('fyear',financialYear);
        
        String name = 'FundUtilizationFor'+financialYear+ '.xls';
        Blob body;
        try {
            
            body = xls.getContent();
            Attachment attach = new Attachment();
            attach.Body = body;
            
            attach.Name = name;
            attach.IsPrivate = false;
            
            attach.parentId = conId ;
            
            insert attach;
            
        } catch (VisualforceException e) {            
            system.debug('in the catch block');
            body = Blob.valueOf('Some Text');
        }   
    } 
    Webservice static List<String> priceList(String appId) {
        List<String> priceList =  new List<String>();
        Application__c app =  [Select id,RecordType.Name from Application__c Where id =:appId];
        if(app.RecordType.Name == 'Scholarship - Prelim') {
            priceList.add('40000');
        }
        else {
            
            
            
            
            priceList.add('40000');
            priceList.add('35000');
            priceList.add('30000');
            priceList.add('25000');
            priceList.add('20000');
            priceList.add('10000');
            
            
        }
        return priceList;
    } 
    
}