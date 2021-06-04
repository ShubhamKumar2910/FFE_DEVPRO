//Callout for ICICI through Bridge App for getting Transaction details for BAU
public class CIB_ICICI_TransactionAPICallout {
    
    // this method is called from List view button call "getTransaction details"
    public static String getBAU_TransactionDetails(List<String> BAU_Ids){
        String responsval ='';
        try{
            
            CIB_ICICI_Service__c CIB_API_Detail = CIB_ICICI_Service__c.getOrgDefaults();
            
            HttpRequest req  = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(CIB_API_Detail.EndPoint_URL__c);
            req.setHeader('username', CIB_API_Detail.UserName__c);
            req.setHeader('password', CIB_API_Detail.Password__c);
            req.setTimeout(Integer.valueof(system.label.CIB_api_callout_settime));
            
            CIBICICI_RequestBody requestBody = new CIBICICI_RequestBody();
            requestBody.request              = new CIBICICI_RequestBody.cls_request();
            
            List<CIBICICI_RequestBody.cls_BusinessAccountUtilizationDetail> BauDetailList = new List<CIBICICI_RequestBody.cls_BusinessAccountUtilizationDetail>();
            
            List<Business_Account_Utilization__c> bauList 								  = [Select id,APICalloutCount__c,Name,SF_TRAN_ID__c,APITXNStatus__c,Disbursement_Mode__c,Pay_Mod__c,Amt__c,
                                                                                             Debit_Ac_No__c,Payable_Location__c,Print_Location__c,Beneficiary_Name__c,Beneficiary_Ac_No__c,
                                                                                             IFSC__c from Business_Account_Utilization__c where id=:BAU_Ids];
            // adding data validation
            system.debug(bauList);
            for(Business_Account_Utilization__c bau : bauList){
                
                if(bau.SF_TRAN_ID__c == null || bau.SF_TRAN_ID__c == ''){
                    return 'SF TRAN ID for '+ bau.Name + System.label.is_empty;
                }
                if(bau.APITXNStatus__c != System.label.automatic_CIB_Batch_Status && bau.APITXNStatus__c != system.label.Not_Posted && bau.APITXNStatus__c != system.label.Failed && bau.APITXNStatus__c !=system.label.CIB_failed && bau.APITXNStatus__c !=system.label.Expired_or_Rejected_by_Authorizer_Confirmer){
                    return 'APITXNStatus for '+ bau.Name +' Should be either "Not Posted/Cancelled/Failed/Expired or Rejected by Authorizer/Confirmer".';
                }
                if(bau.Disbursement_Mode__c == null || bau.Disbursement_Mode__c == ''){
                    return 'Disbursement Mode for '+ bau.Name + System.label.is_empty;
                }
                if(bau.Pay_Mod__c == null || bau.Pay_Mod__c == ''){
                    return 'Pay Mod for '+ bau.Name + System.label.is_empty;
                }
                if(bau.Debit_Ac_No__c == null || bau.Debit_Ac_No__c == ''){
                    return 'Debit Ac No for '+ bau.Name + System.label.is_empty;
                }
                if(bau.Payable_Location__c == null || bau.Payable_Location__c == ''){
                    return 'Payable Location for '+ bau.Name + System.label.is_empty;
                }
                if(bau.Print_Location__c == null || bau.Print_Location__c == ''){
                    return 'Print Location for '+ bau.Name + System.label.is_empty;
                }
                if(bau.Beneficiary_Name__c == null || bau.Beneficiary_Name__c == ''){
                    return 'Beneficiary Name for '+ bau.Name + System.label.is_empty;
                }
                if(bau.Beneficiary_Ac_No__c == null || bau.Beneficiary_Ac_No__c == ''){
                    return 'Beneficiary Ac No for '+ bau.Name + System.label.is_empty;
                }
                if(bau.IFSC__c == null || bau.IFSC__c == ''){
                    return 'IFSC for'+ bau.Name + System.label.is_empty;
                }
                //this is written because Bridge app considers SFTRANID as unique id and for Failed BAU same SFTRANID cant be sent so -X0,-X1----so on is added
                //so each time when callout is made for 1 record, it stores as a different record in BridgeApp
                Integer calloutCount = 0;
                CIBICICI_RequestBody.cls_BusinessAccountUtilizationDetail bauDetail = new CIBICICI_RequestBody.cls_BusinessAccountUtilizationDetail();
                if(bau.APICalloutCount__c != null){
                    calloutCount = Integer.valueOf(bau.APICalloutCount__c);
                }
                    
                bauDetail.SFTRANID= bau.SF_TRAN_ID__c+'-X'+calloutCount;          bauDetail.APITXNStatus= system.label.Posted;
                bauDetail.SFUniqueID= bau.Id;                   bauDetail.DisbursementMode= bau.Disbursement_Mode__c;
                bauDetail.PayMod= bau.Pay_Mod__c;               bauDetail.Amount= String.valueOf(bau.Amt__c);   
                bauDetail.BeneficiaryIFSC= bau.IFSC__c;         bauDetail.BeneficiaryAccNo= bau.Beneficiary_Ac_No__c; 
                bauDetail.DebitAccNo= bau.Debit_Ac_No__c;       bauDetail.PayableLocation= bau.Payable_Location__c;
                bauDetail.PrintLocation= bau.Print_Location__c; bauDetail.BeneficiaryName= bau.Beneficiary_Name__c;
                   
                BauDetailList.add(bauDetail);
            }
            
            requestBody.request.BusinessAccountUtilizationDetail  = BauDetailList;    
            
            system.debug('Check::'+JSON.serialize(requestBody));
            
            req.setBody(JSON.serialize(requestBody));
            Http http = new Http();
            HTTPResponse res = http.send(req);
            responsval = res.getBody();
            system.debug('check maga whats heppening 1'+res.getBody());
            system.debug('check maga whats heppening'+res.getStatusCode());
            //parsing the batch response
            ResponseWrapper response = ResponseWrapper.parse(res.getBody());
            system.debug('wow'+response.Batch.BatchStatus);
            List<Business_Account_Utilization__c> updatePostedBAU = new List<Business_Account_Utilization__c>();
            //updating the BAU status based on response from Bridge App
            for(Business_Account_Utilization__c bau : bauList){
                if(response.Batch.BatchStatus=='Success' && res.getStatusCode() >= CIB_API_Detail.MinRange__c && res.getStatusCode() <= CIB_API_Detail.MaxRange__c){
                    updatePostedBAU.add(new Business_Account_Utilization__c(id=bau.id,APITXNStatus__c =system.label.Posted,BridgeBatchId__c=String.valueOf(response.Batch.BatchId),BridgeBatchReason__c=response.Batch.BatchReason,BridgeBatchStatus__c=response.Batch.BatchStatus));
                }else{
                    if(response.Batch != null){
                        updatePostedBAU.add(new Business_Account_Utilization__c(id=bau.id,BridgeBatchId__c=String.valueOf(response.Batch.BatchId),BridgeBatchReason__c=response.Batch.BatchReason,BridgeBatchStatus__c=response.Batch.BatchStatus));
                    }
                }
            }
            
            
            SavePoint sp = Database.setSavepoint();  
            try{
                if(!updatePostedBAU.isEmpty())
                    update updatePostedBAU;
                
                Exceptions__c resultReqBody = new Exceptions__c(API_CalloutResponseBody__c=res.getBody(),Class_Name__c='CIB_ICICI_TransactionAPICallout',Method_Name__c='getBAU_TransactionDetails',API_CalloutRequestBody__c=String.valueOf(response.Batch.BatchId)+'@@@@'+JSON.serialize(requestBody));
				insert resultReqBody;
            }Catch(Exception e){
                database.rollback(sp);
                HandleBusinessException.captureError('CIB_ICICI_TransactionAPICallout', 'getBAU_TransactionDetails'+responsval, e);
                return system.label.CIB_Exception_message;
            }
            
            if(response.Batch.BatchStatus=='Success' && res.getStatusCode() >= CIB_API_Detail.MinRange__c && res.getStatusCode() <= CIB_API_Detail.MaxRange__c){
                return system.label.CIB_Success_message+res.getBody();
            }else{
                if(response.Batch != null){
                     return 'Failed : '+res.getBody();
                }else{
                     return 'Failed.contact Syatem admin!!';
                }
            }
            
        }Catch(Exception e){
            
            HandleBusinessException.captureError('CIB_ICICI_TransactionAPICallout', 'getBAU_TransactionDetails'+responsval, e);
            return system.label.CIB_Exception_message;
        }
    }
}