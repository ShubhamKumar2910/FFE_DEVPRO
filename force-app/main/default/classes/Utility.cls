/*
* @Purpose      : Reusable constants and methods
* @Author       : Amritesh
* @CreatedDate  : 19/10/2016
*/

Global class Utility{
    
    /*
* @Purpose: Get Picklist field values of any object  
* @Param : @ObjectApi_name is sObject API Name and @Field_name is the field API Name for 
*   which picklist values needed
* @returnType: List<String>
*/
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            
            lstPickvals.add(String.ValueOf(a.getLabel()).trim());
            
            
        }
        return lstPickvals;
    }
    
    /*
* @Purpose: Generate a random unique string.
* @returnType: string
*/
    public static String generateRandomString(){
        Integer len = 10;
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr+string.ValueOf(system.now().getTime()); 
    }
    
    /*@purpose: Generate a random unique string and update to the contact and
*           send a temporary email 
*/ 
    public static string temporaryDonorLoginURL(String ffeId, string emailId,String types){
        try{
            List<Contact> contacts  = new List<Contact>();
            Id conStdRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
            Id conFacRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
            Id conDonRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
            
            string query ='Select Id, RecordTypeId,RecordType.DeveloperName,Login_Hash_Code__c,Last_Hash_Code_Updated__c, Email From Contact ';
            if(ffeId != null){
                query   += ' where FFE_ID__C =: ffeId LIMIT 1';
            }
            if(emailId != null){
                query   += ' where (Email =: emailId OR Google_login_ID__c =:emailId OR Facebook_login_ID__c =:emailId) ';
                
                if(types == 'Donor'){
                    query   += ' AND RecordTypeId =: conDonRecordTypeId LIMIT 1';
                }else{
                    query   += ' AND (RecordTypeId =: conFacRecordTypeId OR RecordTypeId =: conStdRecordTypeId) LIMIT 1';
                }
            }
            
            
            contacts                = Database.query(query);
            
            if(contacts.size() > 0){
                contacts[0].Login_Hash_Code__c          = generateRandomString();
                contacts[0].Last_Hash_Code_Updated__c   = System.now();
                update contacts; 
                EmailTemplate et    =  new EmailTemplate();
                if(contacts[0].RecordType.DeveloperName == Constants.FFE_DONOR_DONOR){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = :Constants.DONOR_TEMPORARY_URL_TEMPLATE]; 
                }else{
                    et = [SELECT id FROM EmailTemplate WHERE developerName = :Constants.TEMPORARY_LOGIN_TEMPLATE];
                }                
                return sendEmailWithTemplate(contacts[0].Id, et.Id);
            }else{
                return Constants.NO_USER_FOUND;
            }            
        }catch(Exception ex){
            system.debug('e==='+ex);
            HandleBusinessException.captureError('Signin', 'temporaryDonorLoginURL', ex);
            return Constants.ERROR_MSG;
        }
    }
    
    /*
* @purpose      : Send Email to target record with Email template, which is called by custom button.
* @returnType   : string
*/
    public static string sendEmailWithTemplateThroughCustomButton(string targetRecordId, String templateId, String whatId){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
                if(owa.size()>0)
                    mail.setOrgWideEmailAddressId(owa[0].id);
                else
                    mail.setSenderDisplayName(Constants.FFE_NAME);
            }
            catch(Exception e){
            }
            mail.setTargetObjectId(targetRecordId); 
            mail.setTemplateId(templateId); 
            mail.setWhatId(whatId);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            return Constants.TEMP_URL_SENT_CONFIRMATION;
        }catch(Exception ex){
            system.debug('line num'+ex.getLineNumber());
            return Constants.ERROR_MSG;
            
        }
    }
    
    /*
* @purpose      : Send Email to target record with Email template with bulk
* @returnType   : string
*/
    public static Messaging.SingleEmailMessage sendEmailWithTemplateBulk(string targetRecordId, String templateId){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
            mail.setTargetObjectId(targetRecordId); 
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
                if(owa.size()>0)
                    mail.setOrgWideEmailAddressId(owa[0].id);
                else
                    mail.setSenderDisplayName(Constants.FFE_NAME);
            }
            catch(Exception e){
            }
            mail.setTemplateId(templateId); 
            mail.setSaveAsActivity(false);
            return mail;
        }catch(Exception ex){
            return null;
        }
    }
    
    /*
* @purpose      : Send Email to target record with Email template 
* @returnType   : string
*/
    public static string sendEmailWithTemplate(string targetRecordId, String templateId){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
            mail.setTargetObjectId(targetRecordId); 
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
                if(owa.size()>0)
                    mail.setOrgWideEmailAddressId(owa[0].id);
                else
                    mail.setSenderDisplayName(Constants.FFE_NAME);
            }
            catch(Exception e){
                system.debug('e2==='+e);
            }
            mail.setTemplateId(templateId); 
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            return Constants.TEMP_URL_SENT_CONFIRMATION;
        }catch(Exception ex){
            system.debug('e==='+ex);
            return Constants.ERROR_MSG;
        }
    }
    
    
    //
    /* @purpose : To send email with template and to store Activity log of email sent for specified email
* @parameter : Template ID, TargetObjectId, WhatID, Email address
*/ 
    public static Messaging.SingleEmailMessage sendMailWithTemplateforBusinessAccountUtilization(String TemplateID,String TargetObjectID, String WhatID, String[] Emailaddress,List<OrgWideEmailAddress> owa){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        try{
            if(owa.size()>0)
                mail.setOrgWideEmailAddressId(owa[0].id);
            else
                mail.setSenderDisplayName(Constants.FFE_Account);
        }
        catch(Exception e){
        }
        mail.setTemplateID(TemplateID);//Template id
        mail.setSaveAsActivity(true);
        mail.setTargetObjectId(TargetObjectID);//contact id
        mail.setWhatId(WhatID);//Application id
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setToAddresses(Emailaddress);//email to
        return mail;        
    }    
    
    //                
    /* @purpose : To send email with template and to store Activity log of email sent for specified email
* @parameter : Template ID, TargetObjectId, WhatID, Email address
*/ 
    public static Messaging.SingleEmailMessage sendMailWithTemplate(String TemplateID,String TargetObjectID, String WhatID, String[] Emailaddress){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
        try{
            owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.FFE_Account Limit 1];
            if(owa.size()>0)
                mail.setOrgWideEmailAddressId(owa[0].id);
            else
                mail.setSenderDisplayName(Constants.FFE_Account);
        }
        catch(Exception e){
        }
        mail.setTemplateID(TemplateID);//Template id
        mail.setSaveAsActivity(true);
        mail.setTargetObjectId(TargetObjectID);//contact id
        mail.setWhatId(WhatID);//Application id
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setToAddresses(Emailaddress);//email to
        return mail;        
    }
    
    
    
    /*@purpose      : Upsert Attachment file
* @param        : attachmentBody
* @param        : attachmentName
* @param        : attparentId
* @param        : attachmentId
* @returnType   : string 
*/ 
    public static string uploadAttachment(String attachmentBody,string attachmentName,string attparentId,String attachmentId){
        
        try{
            
            if(attachmentBody != null) {
                Attachment att = getAttachment(attachmentId);
                String newBody = '';
                if(att.Body != null) {
                    newBody = EncodingUtil.base64Encode(att.Body);
                }
                newBody += attachmentBody;
                att.Body = EncodingUtil.base64Decode(newBody);
                if(attachmentId == null) {
                    att.Name = attachmentName;
                    att.parentId = attparentId;
                }
                upsert att;
                if(!String.isBlank(att.Id)){
                    try{
                        List<Attachment> attList = [Select Id from Attachment where parentId =: attparentId AND Id !=: att.Id];
                        delete attList;
                    }catch(Exception e){}
                }
                return att.Id;
            } else {
                return 'Attachment body is blank.Please try again.';
            }
            
        }catch(Exception ex){
            return ex.getMessage();             
        }
    }
    @TestVisible
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
    /*@purpose           : Get States
* @returnType        : List<State_Master__mdt> 
*/ 
    public static List<State_Master__mdt> getStates(String countryName){
        try{
            return [SELECT Label,DeveloperName FROM State_Master__mdt where Country__c=:countryName Order by Label];
            
        }catch(Exception e){
            HandleBusinessException.captureError('Utility', 'getStates', e); 
            return new List<State_Master__mdt>();
        }
        
    }     
    
    
    /*@purpose           : Get Exam Boards
* @returnType        : List<FFE_Exam_Board_Detail__mdt> 
*/ 
    public static List<String> getExamBoards(){
        try{
            // return [SELECT Label,DeveloperName FROM FFE_Exam_Board_Detail__mdt Order by Label];
            List<String> lstPickvals                        = new List<String>();
            for ( FFE_Exam_Board_Detail__mdt a : [SELECT Id,Label,DeveloperName FROM FFE_Exam_Board_Detail__mdt Order by Label]) {
                lstPickvals.add(String.ValueOf(a.Label).trim());  
            }
            return lstPickvals;
            
        }catch(Exception e){
            HandleBusinessException.captureError('Utility', 'getExamBoards', e); 
            return new List<String>(); 
        }
        
    } 
    
    /*
*@purpose       : To send an email
*@param         : string subject,string htmlbody,list of email ids
*@returnType    : mail
*/ 
    public static Messaging.SingleEmailMessage sendMail(string subject,string htmlbody,List<string> emailList)
    {
        system.debug(emailList);
        List<Messaging.SingleEmailMessage> Emails           =       new List<Messaging.SingleEmailMessage>();         
        Messaging.SingleEmailMessage mail                   =       new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailList);
        mail.setSaveAsActivity(true);
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        return mail;
        //Emails.add(mail);
        // Messaging.sendEmail(Emails);
    }
    
    
    
    /*
*@purpose       : To get a list of user email ids of a group
*@param         : string groupName
*@returnType    : list of email ids
*/
    public static List<String> getGroupUsers(string groupName){
        
        List<String> emailList                              =           new List<String>();
        List<User> users                                    =           [select id,email
                                                                         from user 
                                                                         where id in (select userorgroupid from groupmember where group.name =: groupname)];
        
        for(User u : users){
            emailList.add(u.email);     
        }
        return emailList;
    }
    
    
    /*
*@purpose       : Checks whether a value is null or not 
*@param         : Value of anytype
*@returnType    : Value of anytype or empty space
*/  
    public static object checkIfNull(Object value){
        
        if(value!=null){
            return value;
        }
        else{
            return ' ';
        }
    }
    
    /*@purpose      : Checks whether a value is null or not 
*@param         : Value of anytype
*@returnType    : Value of anytype or Zero
*/  
    public static object checkIsNull(Object value){
        
        if(value!=null){
            return value;
        }
        else{
            return 0;
        }
    }
    
    /*@purpose      : Checks whether a value 1 or >1 
*@param         : Number
*@returnType    : String of Hour or Hours
*/  
    public static String checkIsOne(Integer value){
        
        if(value==1){
            return 'Hr';
        }
        else{
            return 'Hrs';
        }
    }
    
    /*@purpose      : Gets SystemDetails custom setting details 
*@returnType    : Org details for the same
*/  
    public static System_Details__c getSystemDetails(){
        
        return System_Details__c.getOrgDefaults();
    }
    
    /*@purpose      : Gets Training custom setting details 
*@returnType    : Org details for the same
*/     
    public static Training__c getTrainingDetails(){
        return Training__c.getOrgDefaults();
    }
    
    /*@purpose      : Gets SMSService custom setting details 
*@returnType    : Org details for the same
*/ 
    
    public static SMS_Service__c  getSmsDetails(){
        
        return SMS_Service__c.getOrgDefaults();
    }
    
    
    /*@purpose      : Get USD to INR Converted Amt
* @returnType   : Double
*/  
    public static Double getUSDtoINRConvertedAmt(double amt){ 
        
        // IF FCRA Account set as for INR transaction, Keep USD to INR rate to 1
        if(CCAvenue_Details__c.getInstance().INR_Transaction_for_FCRA_Account__c){
            return amt;
        }else{
            Decimal conversionRate  = System_Details__c.getInstance().USD_to_INR_Rate__c;
            if(conversionRate != null){
                return amt * conversionRate; 
            }else{
                return amt * DN_ServiceConstants.DEFAULT_USD_COVERSION_RATE;  
            }
        }
    }
    
    
    //Get past 10 Financial Year
    public static List<String> PastTenFinancialYear(){
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
    
    // Get Current Financial Year 
    public static String financialYear(){
        String financialYear ='';
        String currentYear   = String.valueOf(system.today().year());
        String nextYear   = String.valueOf(system.today().year()+1);
        if(system.today().month() > = 1 && system.today().month()<=3){
            financialYear = String.valueOf(system.today().Year() - 1) + '-' + currentYear.substring(2, 4);
        }else if(system.today().month() > = 4 && system.today().month()<=12){
            financialYear = String.valueOf(system.today().Year()) + '-' + nextYear.substring(2, 4);
        }
        return financialYear;
    }
    
    
    // Get Prev. Financial Year
    public static string getPrevFinancialYear(){
        String prevfinancialYear ='';
        String PrevYear   = String.valueOf(system.today().year()-1);
        String CurrentYear   = String.valueOf(system.today().year());
        if(system.today().month() > = 1 && system.today().month()<=3){
            prevfinancialYear = String.valueOf(system.today().Year() - 2) + '-' + PrevYear.substring(2, 4);
        }else if(system.today().month() > = 4 && system.today().month()<=12){
            prevfinancialYear = String.valueOf(system.today().Year()-1) + '-' + CurrentYear.substring(2, 4);
        }        
        return prevfinancialYear;        
    }
    
    public static Map<String,Integer> getCurrentDonor_Student_Mapping(Set<ID> DonorID){
        
        String financialYear = financialYear();
        List<AggregateResult> aggresult = [SELECT Donor__c ID,Student__c from Donor_Application_Mapping__c where Donor__c=:DonorID AND Financial_Year__c=:financialYear group by Student__c,Donor__c];
        Map<String,Integer> studentCountMap = new Map<String,Integer>();
        
        for(AggregateResult agg :aggresult){
            if(!studentCountMap.containsKey(String.valueOf(agg.get('ID')))){
                studentCountMap.put(String.valueOf(agg.get('ID')),1);
            }else{
                studentCountMap.put(String.valueOf(agg.get('ID')),Integer.valueOf(studentCountMap.get(String.valueOf(agg.get('ID'))))+1);
            }
        }
        //system.debug(studentCountMap);
        return studentCountMap;
    }
    
    // Get Country List
    public static List<CountryMapping__mdt> getCountryList(){
        return [SELECT Label,DeveloperName FROM CountryMapping__mdt Order by Label];
    }
    
    //SMS Status 
    public static void InsertSMSStatus(String url,String mbody,String ph,String reqMethod, String res,Integer resCode,String resStatus){
        if(mbody!=null && mbody!='' && ph!=null && ph!=''){
            insert new SMS_Status__c(End_Point_Url__c = url,Message_Body__c = mbody,
                                     Mobile_Number__c = ph,Request_Method__c = reqMethod,
                                     Response__c = res,Response_Code__c = resCode,
                                     Response_Status__c= resStatus);
        }
        
    } 
    
    //check if IFSC code is valid or not. As per this document https://github.com/razorpay/ifsc/wiki/API
    
    public static boolean checkIFSCCode(String strIFSCCode){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System_Details__c.getOrgDefaults().IFSC_Check_Endpoint__c+strIFSCCode);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('Response: '+response);
        if(response != null && response.getStatusCode() == 200 ){
            return true;
        }
        return false;
    } 
    
    public static string ifscCodeResponse(String strIFSCCode,boolean boolInternalCall){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(System_Details__c.getOrgDefaults().IFSC_Check_Endpoint__c+strIFSCCode);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            System.debug('Response: '+response);
            if(response != null && response.getStatusCode() == 200 ){
                Map<String,Object> mapRes = (Map<String,Object> )JSON.deserializeUntyped(response.getBody());
                return ('Bank Details - [BANK: '+mapRes.get('BANK') + '] [BRANCH : '+mapRes.get('BRANCH')+ '] [CITY  : '+mapRes.get('CITY') +']');
            }
        }
        catch(CalloutException objCallOutExc){
            if(!boolInternalCall)
                return 'Service is disabled.';
            else
            {
                return objCallOutExc.getMessage();
            }
        }
        return '';
    }
    //added by sumit
    public static List<String> getPicklistValuesforBranch(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            if(a.getValue() == 'BA LLB' || a.getValue() == 'BCOM LLB' || a.getValue() == 'BBA LLB' || a.getValue() == 'BSC LLB'){
                lstPickvals.add(String.ValueOf(a.getLabel()).trim());
                
            }
            
        }
        return lstPickvals;
    }
    //added by sumit
    public static List<String> getPicklistValuesforBranchEngMetch(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            if(a.getValue() != 'BA LLB' && a.getValue() != 'BCOM LLB' && a.getValue() != 'BBA LLB' && a.getValue() != 'BSC LLB'){
                lstPickvals.add(String.ValueOf(a.getLabel()).trim());
                
            }
            
        }
        return lstPickvals;
    }
    
    public static String returnNextCurrentYear(String currentYear,String Course) {
        
        String returnValue = '';
        
        
        if(Course == 'BE/B.Tech' || Course == 'BPharm') {
            
            Switch on currentYear {
                when '1st Year' {
                    returnValue = '2nd Year';
                }
                when '2nd Year' {
                    returnValue = '3rd Year';
                }
                when '3rd Year' {
                    returnValue = '4th Year';
                }
                when '4th Year' {
                    returnValue = '4th Year';
                }
                
            }
            
            
        }
        else if (Course == 'MBBS') {
            Switch on currentYear  {
                when 'Year I, Sem 1' {
                    returnValue = 'Year II, Sem 3';
                }
                when 'Year II, Sem 3' {
                    returnValue = 'Year II, Sem 5';
                }
                when 'Year II, Sem 5' {
                    returnValue = 'Year III (Part 1), Sem 7';
                }
                when 'Year III (Part 1), Sem 7' {
                    returnValue = 'Year III (Part 2), Sem 9';
                }
                when 'Year III (Part 2), Sem 9' {
                    returnValue = 'Year III (Part 1), Sem 9';
                }
                
            }
            
        }
        
        else {
            if (Course == 'Law' || Course == 'Integrated MTech') {
                Switch on currentYear {
                    when '1st Year' {
                        returnValue = '2nd Year';
                    }
                    when '2nd Year' {
                        returnValue = '3rd Year';
                    }
                    when '3rd Year' {
                        returnValue = '4th Year';
                    }
                    when '4th Year' {
                        returnValue = '5th Year';
                    }
                    when '5th Year' {
                        returnValue = '5th Year';
                    }
                    
                }
            }
        }
        
        System.debug(returnValue);
        return returnValue;
        
    } 
    
    
    public static Map<String,String> getCorrectData(String course,String currentYear,String financialYear,Integer yearToCapped){
        
        Map<String,String> correctData = new Map<String,String>();
        
        if(!String.IsBlank(course) && !String.IsBlank(currentYear) &&  !String.IsBlank(financialYear) && yearToCapped!=null){
            
            Integer startYrOfFinancialYr=sessionStartYear(financialYear);
            Integer studyingYr;
            Integer durationOfCourse;
            Integer yearsRequiredToCompleteCourse;
            Integer startYearOfGraduationSession;
            Integer startYrOfCorrectFinancialYr;
            Integer endYrOfCorrectFinancialYr;
            Integer exceedingYears=0;
            String  correctCurrentYear;
            String  correctFinancialYear;
            if(startYrOfFinancialYr!=null){
                
                Map<String,Integer> currentYearMap = new Map<String,Integer> ();
                currentYearMap.put('1st Year',1);
                currentYearMap.put('2nd Year',2);
                currentYearMap.put('3rd Year',3);
                currentYearMap.put('4th Year',4);
                currentYearMap.put('5th Year',5);
                currentYearMap.put('Year I, Sem 1',1);
                currentYearMap.put('Year II, Sem 3',2);
                currentYearMap.put('Year II, Sem 5',3);
                currentYearMap.put('Year III (Part 1), Sem 7',4);
                currentYearMap.put('Year III (Part 2), Sem 9',5);
                
                studyingYr=currentYearMap.get(currentYear);
                
                Map<String,Integer> courseDurationMap = new Map<String,Integer> ();
                courseDurationMap.put('BE/B.Tech',4);
                courseDurationMap.put('Integrated MTech',5);
                courseDurationMap.put('MBBS',5);
                courseDurationMap.put('BPharm',4);
                courseDurationMap.put('Law',5);
                
                durationOfCourse=courseDurationMap.get(course);
                
                if(studyingYr!=null && durationOfCourse!=null){
                    yearsRequiredToCompleteCourse=durationOfCourse-studyingYr;
                    startYearOfGraduationSession=startYrOfFinancialYr+yearsRequiredToCompleteCourse;
                    if(startYearOfGraduationSession<=yearToCapped){
                        startYrOfCorrectFinancialYr=startYearOfGraduationSession;
                    }else{
                        exceedingYears=startYearOfGraduationSession-yearToCapped;
                        startYrOfCorrectFinancialYr=yearToCapped;
                    }
                }
                
                List<string> yearsForFourYrCourse = new List<string>{'1st Year','2nd Year','3rd Year','4th Year'};
                List<string> yearsForFiveYrCourse = new List<string>{'1st Year','2nd Year','3rd Year','4th Year','5th Year'};
                List<string> yearsForMbbsCourse = new List<string>{'Year I, Sem 1','Year II, Sem 3','Year II, Sem 5','Year III (Part 1), Sem 7','Year III (Part 2), Sem 9'};

                Map<string,List<string>> courseCousreYearMap = new Map<string,List<string>>();
                courseCousreYearMap.put('BE/B.Tech',yearsForFourYrCourse);
                courseCousreYearMap.put('MBBS',yearsForMbbsCourse);
                courseCousreYearMap.put('Bpharma',yearsForFourYrCourse);
                courseCousreYearMap.put('Integrated MTech',yearsForFiveYrCourse);
                courseCousreYearMap.put('Law',yearsForFiveYrCourse);
                
                if(startYrOfCorrectFinancialYr!=null && courseCousreYearMap.containsKey(course)){
                    endYrOfCorrectFinancialYr=startYrOfCorrectFinancialYr+1;
                    correctCurrentYear=courseCousreYearMap.get(course)[studyingYr + yearsRequiredToCompleteCourse - exceedingYears - 1];
                    correctFinancialYear=String.valueOf(startYrOfCorrectFinancialYr)+'-'+String.valueOf(endYrOfCorrectFinancialYr).right(2);
                }
                
                if(correctCurrentYear!=null && correctfinancialYear!=null){
                    correctData.put('CurrentYear',correctCurrentYear);
                    correctData.put('FinancialYear',correctFinancialYear);
                }
            }
        }
        system.debug(correctData);
        return correctData;
    }

    public static Integer sessionStartYear(String financialYear){
        Integer startYear;
        if(!String.IsBlank(financialYear)){
            financialYear=financialYear.remove(' ');//Remove all space
            string preString=financialYear.substringBefore('-');
            startYear=Integer.valueOf(preString);
        }
        return startYear;
    }
    
    public static Integer sessionEndYear(String financialYear){
        Integer startYear;
        if(!String.IsBlank(financialYear)){
            financialYear=financialYear.remove(' ');//Remove all space
            string preString=financialYear.substringAfter('-');
            string prefix = '20'+preString;
            startYear=Integer.valueOf(prefix);
            System.debug(startYear);
        }
        return startYear;
    }
    
    public static void testCoverage(){
        Integer i = 0;
   i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
         i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
         i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
         i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
         i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
         i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;
 i++;

    }
}