//Web service class to update the Transaction details un Business account utilization class
@RestResource(urlMapping='/TrasactionStatuses/*')
global class CIBICICITransactionStatusUpdate {
    
    @HttpPost
    webservice static void updateBAUTransactionDetails(){
        SavePoint sp    = Database.setSavepoint();
        try{
            
            RestRequest rs   = Restcontext.request;
            String jsonInput = rs.requestBody.toString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            //parsing request String sent by 3rd party
            CIB_TransactionDetailsRequest jsonRequestData = CIB_TransactionDetailsRequest.parse(jsonInput);
            
            Map<String,String> updateBAUTransactionStatus = new Map<String,String>();
            Set<String> SFTRANIDList = new Set<String>();
            Set<String> SFUniqueIDList = new Set<String>();
            Set<String> BankTransactionReferenceNo = new Set<String>();
            // used to throw dynamic error messages if any field is empty / incorrect data format
            for(CIB_TransactionDetailsRequest.cls_BusinessAccountUtilizationDetail std:jsonRequestData.BusinessAccountUtilizationDetail){
                
                
                if(!SFTRANIDList.contains(String.valueOf(std.SFTRANID))){
                    SFTRANIDList.add(String.valueOf(std.SFTRANID));
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"' + String.valueOf(std.SFTRANID) + ': Duplicate SFTRANID in request body"}}');return;
                }
                
                if(!SFUniqueIDList.contains(String.valueOf(std.SFUniqueID))){
                    SFUniqueIDList.add(String.valueOf(std.SFUniqueID));
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"' + String.valueOf(std.SFUniqueID) + ': Duplicate SFUniqueID in request body"}}');return;
                }
                
                if(!BankTransactionReferenceNo.contains(String.valueOf(std.BankTransactionReferenceNo))){
                    BankTransactionReferenceNo.add(String.valueOf(std.BankTransactionReferenceNo));
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"' + String.valueOf(std.BankTransactionReferenceNo) + ': Duplicate BankTransactionReferenceNo in request body"}}');return;
                }
                
                
                if(std.SFTRANID == '' || std.SFTRANID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"SFTRANID '+system.label.empty_string_error_message+'"}}');return; 
                }
                /*if(std.BankTransactionReferenceNo == '' || std.BankTransactionReferenceNo == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"BankTransactionReferenceNo '+system.label.empty_string_error_message+'"}}');return; 
                }*/
                if(std.BankTxnDate == '' || std.BankTxnDate == null){
                    std.BankTxnDate = null;
                   // RestContext.response.statusCode   = 400;
                  //  RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"BankTxnDate '+system.label.empty_string_error_message+'"}}');return; 
                }else{
                    try{
                        Date paresedCheck = Date.parse(std.BankTxnDate);
                    }Catch(Exception e){
                        HandleBusinessException.captureError('CIBICICITransactionStatusUpdate', '@httpPost', e);
                        RestContext.response.statusCode   = 500;   
                        RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"'+system.label.CIB_Date_format+'"}}');return;
                    }
                }
                if(std.APITXNStatus == '' || std.APITXNStatus == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"APITXNStatus '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.SFUniqueID == '' || std.SFUniqueID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"SFUniqueID '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.BridgeBatchId == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"BridgeBatchId '+system.label.empty_string_error_message+'"}}');return; 
                }
                //during callout(first part) -X is appended with the string inorder to always send unique ID's, so here it is splited and just 1st index value is used to query out BAU records
                updateBAUTransactionStatus.put(std.SFTRANID.split('-X')[0],String.valueOf(std.APITXNReason+'@@'+std.APITXNStatus+'@@'+std.BankTransactionReferenceNo+'@@'+std.BankTxnDate+'@@'+std.BridgeBatchId));
            }
            
            List<Business_Account_Utilization__c> bauUpdationList = [SELECT id,Name,APICalloutCount__c,Disbursement_Status__c,APITXNReason__c,APITXNStatus__c,Bank_Txn_ID__c,BankTxnDate__c,BridgeBatchId__c FROM Business_Account_Utilization__c where Name=:updateBAUTransactionStatus.keyset()];
            
            List<Business_Account_Utilization__c> updateBAUTransactinDetails = new List<Business_Account_Utilization__c>();
            Map<String,String> BauName = new Map<String,String>();
            Map<String,Integer> BauCalloutCount = new Map<String,Integer>();
            //if request sent by Bridge APP is for APITRNXStatus="Paid",then Disbursment mode is updated to disbursed or else not
            for(Business_Account_Utilization__c bau : bauUpdationList){
                
                Date BTxnDate = null;system.debug('a'+updateBAUTransactionStatus.get(bau.name).split('@@')[3]);
                if(updateBAUTransactionStatus.get(bau.name).split('@@')[3] != null && updateBAUTransactionStatus.get(bau.name).split('@@')[3] != 'null'){system.debug('how is this possible');
                    BTxnDate = Date.parse(updateBAUTransactionStatus.get(bau.name).split('@@')[3]);
                }
                    
                    
                Business_Account_Utilization__c updateBau = new Business_Account_Utilization__c(Response_json_from_bridgeapp__c=jsonInput,id=bau.id,APITXNReason__c=updateBAUTransactionStatus.get(bau.name).split('@@')[0],APITXNStatus__c=updateBAUTransactionStatus.get(bau.name).split('@@')[1],Bank_Txn_ID__c=updateBAUTransactionStatus.get(bau.name).split('@@')[2],BankTxnDate__c=BTxnDate,BridgeBatchId__c=updateBAUTransactionStatus.get(bau.name).split('@@')[4]);
                if(updateBAUTransactionStatus.get(bau.name).split('@@')[1] == system.label.Processed || updateBAUTransactionStatus.get(bau.name).split('@@')[1] ==  system.label.Manually_Liquidated){
                    updateBau.Disbursement_Status__c=system.label.Disbursed;
                }
                updateBAUTransactinDetails.add(updateBau);
                BauName.put(bau.id,bau.Name);
                BauCalloutCount.put(bau.id,Integer.valueOf(bau.APICalloutCount__c));
                
            }
            //maximum and minmum limit for request
            if(updateBAUTransactinDetails.size() == 0){
                RestContext.response.statusCode   = 400;
                RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"Mentioned SFTRANID is not present in the system."}}');return;   
            }else if(updateBAUTransactinDetails.size() > 200){
                RestContext.response.statusCode   = 400;
                RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"Max Limit: 200 SFTRANID\'s can be sent in one request call."}}');return;   
                
            }
            
            // updates the BAU's
            if(!updateBAUTransactinDetails.IsEmpty()){
                update updateBAUTransactinDetails;
                
            }
            // sending response back from the updated BAU's
            CIB_Trsanction_Response response = new CIB_Trsanction_Response();
            List<CIB_Trsanction_Response.cls_BusinessAccountUtilizationDetail> responsewrp = new List<CIB_Trsanction_Response.cls_BusinessAccountUtilizationDetail>();
            for(Business_Account_Utilization__c bau : updateBAUTransactinDetails){
                CIB_Trsanction_Response.cls_BusinessAccountUtilizationDetail bauDetail = new CIB_Trsanction_Response.cls_BusinessAccountUtilizationDetail();
                integer calloutcount = 0;
                if(BauCalloutCount.get(bau.id) != null){
                    calloutcount = Integer.valueOf(BauCalloutCount.get(bau.id));
                }
                bauDetail.SFTRANID= BauName.get(bau.id)+'-X'+calloutcount;//sending response as wht they sent back to us
                bauDetail.APITXNStatus= bau.APITXNStatus__c;
                bauDetail.BridgeBatchId= bau.BridgeBatchId__c;
                bauDetail.UpdationStatus= system.label.Success;
                system.debug('check:'+bauDetail);
                responsewrp.add(bauDetail);
            }
            response.BusinessAccountUtilizationDetail = responsewrp;
            
            system.debug(JSON.serialize(response));

            
            RestContext.response.responseBody = 
                Blob.valueOf(JSON.serialize(response));return;
            
        }Catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('CIBICICITransactionStatusUpdate', '@httpPost', e);
            RestContext.response.statusCode   = 500;   
            RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"'+system.label.IITBAA_Exception_error_message+'"}}');return;
        }
    }
}