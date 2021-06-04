@RestResource(urlMapping='/getApplicationsDetails/*')
global with sharing  class IITBAAGetApplicationDetails {
    
    @HttpPost
    webservice static void getApplicationsStatuses() {
        try{
            RestRequest req     					      =   RestContext.request; 
            String jsonInput   							  =   req.requestBody.toString(); 
            
            RestContext.response.addHeader('Content-Type', 'application/json');
            IITBAAGetStudentsApplicationRequest jsonRequestData  = IITBAAGetStudentsApplicationRequest.parse(jsonInput);
            
            Set<String> AppID = new Set<String>();
            Set<String> ExistingUniqueAppID = new Set<String>();
            Set<String> FFEUID = new Set<String>();
            Set<String> studentSFId = new Set<String>();
            
            for(IITBAAGetStudentsApplicationRequest.cls_Applications app:jsonRequestData.Applications){
                
                if(app.Email == '' || app.Email == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"Email '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(app.StudentUniqueID == '' || app.StudentUniqueID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"StudentUniqueID '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(app.FFEUID == '' || app.FFEUID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"FFEUID '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(app.StudentSFID == '' || app.StudentSFID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"StudentSFID '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(app.ExistingApplicationID == '' || app.ExistingApplicationID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"ExistingApplicationID '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(app.ApplicationSFID == '' || app.ApplicationSFID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"ApplicationSFID '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                
                if(!AppID.contains(String.valueOf(app.ApplicationSFID))){
                    AppID.add(String.valueOf(app.ApplicationSFID));
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"' + String.valueOf(app.ApplicationSFID) + ': Duplicate ApplicationSFID in request body"}}');return;
                }
                
                if(!ExistingUniqueAppID.contains(String.valueOf(app.ExistingApplicationID))){
                    ExistingUniqueAppID.add(String.valueOf(app.ExistingApplicationID));
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"' + String.valueOf(app.ExistingApplicationID) + ': Duplicate ExistingApplicationID in request body"}}');return;
                }
                FFEUID.add(app.FFEUID);
                studentSFId.add(app.StudentSFID);
                
            }
            
            List<Application__c> appList = [Select Name,Amount_Funded__c,Internal_Status__c,Student__c,Existing_Application_ID__c,Student__r.FFE_ID__c From Application__c
                                            Where Name IN:AppID];
            
            
            if(appList.size() == 0){
                RestContext.response.statusCode   = 400;
                RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"Mentioned ApplicationSFID is not present in the system"}}');return;   
            }
            
            String response = '{"Applications":[';
            for(integer i =0 ; i< appList.size();i++){
                response += '{"ApplicationSFID":"'+appList[i].Name+'",';
                response += '"ExistingApplicationID":"'+appList[i].Existing_Application_ID__c+'",';
                if(appList[i].Internal_Status__c == Constants.Disbursed){
                response += '"ApplicationStatus":"'+appList[i].Internal_Status__c+'",';    
                }else{
                response += '"ApplicationStatus":"'+Constants.AWAITING_FUND_STATUS+'",';    
                }
                if(appList[i].Amount_Funded__c == null || appList[i].Amount_Funded__c == 0){
                response += '"AmountFunded":0,';
                }else{
                response += '"AmountFunded":'+appList[i].Amount_Funded__c+',';    
                }
                response += '"FFEUID":"'+appList[i].Student__r.FFE_ID__c+'",';
                response += '"StudentSFID":"'+appList[i].Student__c+'"';
                
                if(i == appList.size()-1)
                    response += '}';
                else
                    response += '},'; 
            }
            response += ']}';
            system.debug(response);
            RestContext.response.responseBody = 
                Blob.valueOf(response);return;
            
        }Catch(Exception e){
            HandleBusinessException.captureError('IITBAAGetApplicationDetails', '@httpPost', e);
            system.debug(e);system.debug(e.getLineNumber());
            RestContext.response.statusCode   = 500;   
            RestContext.response.responseBody = Blob.valueOf(system.label.IIT_BAA_error_response+'"'+system.label.IITBAA_Exception_error_message+'"}}');return;
            
        }
    }
}