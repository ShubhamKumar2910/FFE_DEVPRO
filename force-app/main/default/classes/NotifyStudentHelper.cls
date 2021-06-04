/*
* @Purpose      : After button Clicked Student got notify.
* @Author       : Gourab
* @CreatedDate  : 04/06/2018
*/
global class NotifyStudentHelper {
    
    // Get GAU Name
    Webservice static List<String> GauNameDetails(){
        
        List<String> GauNameList = new List<String>();
        List<npsp__General_Accounting_Unit__c> gauLst = [SELECT Name FROM npsp__General_Accounting_Unit__c];
        for(npsp__General_Accounting_Unit__c ga : gauLst){
            
            GauNameList.add(ga.Name);
        }
        return GauNameList;
    }
    
    //Get past 10 Financial Year
    Webservice static List<String> PastTenFinancialYear(){
        List<String> PreviousTenfinancialYear = new List<String>();
        
        for(integer i=0;i<=9;i++){
            if(system.today().month() > = 1 && system.today().month()<=3){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year()) - (i+1)) + '-' + String.valueOf(Integer.valueOf(system.today().Year()) - i).substring(2, 4)); 
            }else if(system.today().month() > = 4 && system.today().month()<=12){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year())- i) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1) - i).substring(2, 4)); 
                
            } 
        }
        return PreviousTenfinancialYear;
    }
    
        //Get past 10 Financial Year
    Webservice static List<String> currentTenFinancialYearexcludingThis(){
        List<String> PreviousTenfinancialYear = new List<String>();
        
        for(integer i=1;i<=10;i++){
            if(system.today().month() > = 1 && system.today().month()<=3){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year()) - i) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1) - i).substring(2, 4)); 
            }else if(system.today().month() > = 4 && system.today().month()<=12){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year()) - i + 1) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1) - i + 1).substring(2, 4)); 
            } 
        }
        return PreviousTenfinancialYear;
    }
        Webservice static String sendNotify_New(String Fyear,String gau,String msg,String ContactId,String smsMsg,String smsCheckBoxValue, String emailCheckBoxValue){
        try{
            
            String body = '';  
            Map<String,String> EmailMap = new Map<String,String>();
            Map<String,String> MobileMap = new Map<String,String>();
            Map<String,String> StudentMap = new Map<String,String>();
            
            Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
            List<string> smsSendList = new List<string>();
            
                Id  donRecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();   
                List<Fund_Utilization__c> fuList = [SELECT Id,Application__r.Student__r.Financial_year__c,General_Accounting_Unit__r.Name,
                                                    Application__r.Student__r.Email,Application__r.Student__r.MobilePhone,Application__r.Student__r.Name,
                                                    Application__r.Student__r.FFE_ID__c FROM Fund_Utilization__c Where Application__r.RPT_Financial_Year__c =:Fyear 
                                                    and General_Accounting_Unit__r.Name =:gau and Donor__r.Id=:ContactId AND Application__r.Student__r.RecordTypeID=:donRecordTypeId];
            
            system.debug('Fund Utilization List::::::'+fuList);
            if(!fuList.isEmpty()){
               List<OrgWideEmailAddress> ot =  [Select id,DisplayName,Address from OrgWideEmailAddress Where Address =:'crm@ffe.org']; 
                for(Fund_Utilization__c fu : fuList){
                    
                    EmailMap.put(fu.Application__r.Student__r.FFE_ID__c,fu.Application__r.Student__r.Email);
                    MobileMap.put(fu.Application__r.Student__r.FFE_ID__c,fu.Application__r.Student__r.MobilePhone);
                    StudentMap.put(fu.Application__r.Student__r.FFE_ID__c,fu.Application__r.Student__r.Name);
                   
                }
                
                for(String st : StudentMap.keySet()){
                    
                    body = 'Dear'+ ' ' + StudentMap.get(st) + ',';
                    body += '<br> <br>';
                    body += msg +'.' + '<br><br>';
                    body += 'Regards,<br>FFE Team'; 
                    
                    String toAdr = EmailMap.get(st); 
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setToAddresses(new List<String>{toAdr});
                    message.setHtmlBody(body);
                    message.setSubject('Important Notification from FFE');
                    if(ot.size()>0){
                      message.setOrgWideEmailAddressId(ot[0].id);  
                    }
                    else{
                        message.setSenderDisplayName(Constants.FFE_Account);
                    }
                    message.setTreatTargetObjectAsRecipient(false);
                    mailList.add(message);
                   
                    // for SMS
                     String smsSend = MobileMap.get(st);
                     smsSendList.add(smsSend);
                }
                String returnMessage = '';
                // Send Mail & SMS - to Student 
                if(emailCheckBoxValue == 'true'){
                    Messaging.sendEmail(mailList);
                    returnMessage = 'Successfully email sent.';
                }
                if(smsCheckBoxValue == 'true'){
                    SMS_Service_CTRL.singleListOfString_To_String(smsSendList,smsMsg);
                    returnMessage = 'Successfully SMS sent.';
                }
                if(emailCheckBoxValue == 'true' && smsCheckBoxValue == 'true'){
                    returnMessage = 'Successfully email and SMS sent.';
                }
                return returnMessage; 
            }else{
                return label.Notify_Failed_Message;
            }
                
               
            
        }
        catch(Exception e){
            HandleBusinessException.captureError('NotifyStudentHelper', 'sendNotify_New', e);
            return label.Failure_messages;
        }
         
    } 
    Webservice static String sendNotify(String Fyear,String gau,String msg,String ContactId,String smsMsg){
        try{
            
            String body = '';  
            Map<String,String> EmailMap = new Map<String,String>();
            Map<String,String> MobileMap = new Map<String,String>();
            Map<String,String> StudentMap = new Map<String,String>();
            
            Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
            List<string> smsSendList = new List<string>();
            
                Id  donRecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();   
                List<Fund_Utilization__c> fuList = [SELECT Id,Application__r.Student__r.Financial_year__c,General_Accounting_Unit__r.Name,
                                                    Application__r.Student__r.Email,Application__r.Student__r.MobilePhone,Application__r.Student__r.Name,
                                                    Application__r.Student__r.FFE_ID__c FROM Fund_Utilization__c Where Application__r.RPT_Financial_Year__c =:Fyear 
                                                    and General_Accounting_Unit__r.Name =:gau and Donor__r.Id=:ContactId AND Application__r.Student__r.RecordTypeID=:donRecordTypeId];
            
            system.debug('Fund Utilization List::::::'+fuList);
            if(!fuList.isEmpty()){
               List<OrgWideEmailAddress> ot =  [Select id,DisplayName,Address from OrgWideEmailAddress Where Address =:'crm@ffe.org']; 
                for(Fund_Utilization__c fu : fuList){
                    
                    EmailMap.put(fu.Application__r.Student__r.FFE_ID__c,fu.Application__r.Student__r.Email);
                    MobileMap.put(fu.Application__r.Student__r.FFE_ID__c,fu.Application__r.Student__r.MobilePhone);
                    StudentMap.put(fu.Application__r.Student__r.FFE_ID__c,fu.Application__r.Student__r.Name);
                   
                }
                
                for(String st : StudentMap.keySet()){
                    
                    body = 'Dear'+ ' ' + StudentMap.get(st) + ',';
                    body += '<br> <br>';
                    body += msg +'.' + '<br><br>';
                    body += 'Regards,<br>FFE Team'; 
                    
                    String toAdr = EmailMap.get(st); 
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setToAddresses(new List<String>{toAdr});
                    message.setHtmlBody(body);
                    message.setSubject('Important Notification from FFE');
                    if(ot.size()>0){
                      message.setOrgWideEmailAddressId(ot[0].id);  
                    }
                    else{
                        message.setSenderDisplayName(Constants.FFE_Account);
                    }
                    message.setTreatTargetObjectAsRecipient(false);
                    mailList.add(message);
                   
                    // for SMS
                     String smsSend = MobileMap.get(st);
                     smsSendList.add(smsSend);
                }
                // Send Mail & SMS - to Student 
                Messaging.sendEmail(mailList);
                SMS_Service_CTRL.singleListOfString_To_String(smsSendList,smsMsg);
                return label.Success_Message; 
            }else{
                return label.Notify_Failed_Message;
            }
                
               
            
        }
        catch(Exception e){
            HandleBusinessException.captureError('NotifyStudentHelper', 'sendNotify', e);
            return label.Failure_messages;
        }
         
    } 
    
   
}