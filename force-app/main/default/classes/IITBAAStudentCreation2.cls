/*
*  Name         : IITBAAStudentCreation2
*  Company      : Et marlabs
*  Purpose      : REST API Class to insert Students and there applications data into SF from IITBAA for fund disbursment
*  Developer    : Jayanth B
*  Request     : Json String of Students with there application details(max 1 application will be sent by IITBAA, but class is written in generic way where multiple application for 1 students are allowed)
*  Response   : JSON String of Students with there application details
*  Created      :  19/1/2018
*  Modified by  :
*  Modified at  : 
***************************************************************************
*/

@RestResource(urlMapping='/StudentsDetails/*')
global with sharing class IITBAAStudentCreation2 {
    
    @HttpPost
    webservice static void createStudentsandApplicationData(){
        SavePoint sp    = Database.setSavepoint();
        try{
            String responseJSON ;
            
            RestRequest req     					      =   RestContext.request; 
            String jsonInput   							  =   req.requestBody.toString(); 
            
            RestContext.response.addHeader('Content-Type', 'application/json');    
            IITBAAStudentCreationRequest jsonRequestData  = IITBAAStudentCreationRequest.parse(jsonInput);
            
            Set<String> emailDuplicateCheck               = new Set<String>();
            Set<String> mobileDuplicateCheck    		  = new Set<String>();
            Set<String> aadharduplicateCheck    	      = new Set<String>();
            Set<String> studentIDDuplicateCheck 		  = new Set<String>();
            Map<String,IITBAAStudentCreationRequest.cls_Applications> uniqueApplicationCheck   = new Map<String,IITBAAStudentCreationRequest.cls_Applications>();
            Set<String> sameYearDupCheckForApp = new Set<String>();
            //used to check if duplicate application in request body
            Set<String> ExistingApplicationIDDuplicateCheck = new Set<String>();
            Set<String> StdEmails = new Set<String>();
            Map<String,String> emailCYSem = new Map<String,String>();
            
            
            List<IITBAAStudentCreationRequest.cls_Applications> requestAppDupCheck = new List<IITBAAStudentCreationRequest.cls_Applications>();
            //used to make all the fields in json string as mandatory
            for(IITBAAStudentCreationRequest.cls_Request std:jsonRequestData.Request){
                //err msg : max 2 application allowed in one request for 1 student
                if(std.Applications.size()>2){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Max 2 applications can be sent for 1 student in single request call"}}');return; 
                }
                //err msg : min 1 application should be there in one request for 1 student
                if(std.Applications.size() == 0){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Min 1 application needs to be sent for 1 student in single request call"}}');return; 
                }
                
                if(std.StudentDetail.Email == '' || std.StudentDetail.Email == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Email '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(std.StudentDetail.LastName == '' || std.StudentDetail.LastName == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"LastName '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.FirstName == '' || std.StudentDetail.FirstName == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"FirstName '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.Phone == '' || std.StudentDetail.Phone == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Phone '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.AadharNumber == '' || std.StudentDetail.AadharNumber == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"AadharNumber '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankAccountHolderName == '' || std.StudentDetail.BankAccountHolderName == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankAccountHolderName '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankAccountNumber == '' || std.StudentDetail.BankAccountNumber == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankAccountNumber '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankName == '' || std.StudentDetail.BankName == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankName '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.StudentUniqueID == '' || std.StudentDetail.StudentUniqueID == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"StudentUniqueID '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankIFSCCode == '' || std.StudentDetail.BankIFSCCode == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankIFSCCode '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.Gender == '' || std.StudentDetail.Gender == null || (std.StudentDetail.Gender != 'Male' && std.StudentDetail.Gender != 'Female')){
                    RestContext.response.statusCode   = 400;
                    if(std.StudentDetail.Gender == '' || std.StudentDetail.Gender == null){
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Gender '+system.label.empty_string_error_message+'"}}');return; 
                    }else{
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Gender must be either Male/Female."}}');return;    
                    }
                }
                if(std.StudentDetail.AcademicStartYear == '' || std.StudentDetail.AcademicStartYear == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"AcademicStartYear '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.MailingStreet == '' || std.StudentDetail.MailingStreet == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"MailingStreet '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.MailingCity == '' || std.StudentDetail.MailingCity == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"MailingCity '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.MailingState == '' || std.StudentDetail.MailingState == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"MailingState '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.MailingCountry == '' || std.StudentDetail.MailingCountry == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"MailingCountry '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.MailingPostalCode == '' || std.StudentDetail.MailingPostalCode == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"MailingPostalCode '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.Course == '' || std.StudentDetail.Course == null || (std.StudentDetail.course!='BE/B.Tech' && std.StudentDetail.course!='Integrated MTech')){
                    RestContext.response.statusCode   = 400;
                    if(std.StudentDetail.Course == '' || std.StudentDetail.Course == null){
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Course '+system.label.empty_string_error_message+'"}}');return; 
                    }else{
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Course should be either BE/B.Tech or Integrated MTech"}}');return;  
                    }
                }
                if(std.StudentDetail.Branch == '' || std.StudentDetail.Branch == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Branch '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankCity == '' || std.StudentDetail.BankCity == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankCity '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankState == '' || std.StudentDetail.BankState == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankState '+system.label.empty_string_error_message+'"}}');return; 
                }
                if(std.StudentDetail.BankPinCode == '' || std.StudentDetail.BankPinCode == null){
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BankPinCode '+system.label.empty_string_error_message+'"}}');return; 
                }
                
                if(!emailDuplicateCheck.contains(String.valueOf(std.StudentDetail.Email))){
                    emailDuplicateCheck.add(String.valueOf(std.StudentDetail.Email));// to check if particular email id is registered with FFE(but not as IITBAA students,Flag is maintianed to differenciate)
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' + String.valueOf(std.StudentDetail.Email) + ': '+system.label.IITBAA_Duplicate_Email_in_Request_body+'"}}');return;
                }
                
                if(!mobileDuplicateCheck.contains(String.valueOf(std.StudentDetail.Phone))){
                    mobileDuplicateCheck.add(String.valueOf(std.StudentDetail.Phone));// to check if particular Phone num is registered with FFE
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' +  String.valueOf(std.StudentDetail.Phone) + ': '+system.label.IITBAA_Duplicate_Mobile_number_in_Request_body+'"}}');return;
                }
                
                if(!aadharduplicateCheck.contains(String.valueOf(std.StudentDetail.AadharNumber))){
                    aadharduplicateCheck.add(String.valueOf(std.StudentDetail.AadharNumber));// to check if particular Aadhar is registered with FFE
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' +  String.valueOf(std.StudentDetail.AadharNumber) + ': '+system.label.IITBAA_Duplicate_Aadhar_number_in_Request_body+'"}}');return;
                }
                
                if(!studentIDDuplicateCheck.contains(String.valueOf(std.StudentDetail.StudentUniqueID))){
                    studentIDDuplicateCheck.add(String.valueOf(std.StudentDetail.StudentUniqueID));// to check if particular studentUnique id is registered with FFE
                }else{
                    RestContext.response.statusCode   = 400;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' +  String.valueOf(std.StudentDetail.StudentUniqueID) + ': '+system.label.IITBAA_Duplicate_StudentUniqueID_in_Request_body+'"}}');return;
                }
                
                
                
                
                //all validation in another class
                integer countapp = 0;
                for(IITBAAStudentCreationRequest.cls_Applications app : std.Applications){
                    
                    if(!uniqueApplicationCheck.containsKey(String.valueOf(std.StudentDetail.Email).toLowerCase()+'-'+app.CurrentYear+'-'+app.Semester)){
                        uniqueApplicationCheck.put(String.valueOf(std.StudentDetail.Email).toLowerCase()+'-'+app.CurrentYear+'-'+app.Semester,app);// to check if particular email id is registered with FFE
                    }else{
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":" Duplicate applications cannot be sent for 1 student"}}');return;
                    }
                    
                    if(!sameYearDupCheckForApp.contains(String.valueOf(std.StudentDetail.Email).toLowerCase()+app.CurrentYear)){
                        if(countapp == 0){
                            sameYearDupCheckForApp.add(String.valueOf(std.StudentDetail.Email).toLowerCase()+app.CurrentYear);// to check if particular email id is registered with FFE
                        }else{
                            RestContext.response.statusCode   = 400;
                            RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":" application under '+ String.valueOf(std.StudentDetail.Email) +' student should have same application year."}}');return;
                            
                        }
                    }
                    countapp = countapp + 1;
                    
                    if(app.ExistingApplicationID == '' || app.ExistingApplicationID == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"ExistingApplicationID '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    
                    if(app.ApplicationType == '' || app.ApplicationType == null || (app.ApplicationType != 'New' && app.ApplicationType != 'Renewal')){
                        RestContext.response.statusCode   = 400;
                        if(app.ApplicationType == '' || app.ApplicationType == null){
                            RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"ApplicationType '+system.label.empty_string_error_message+'"}}');return; 
                        }else{
                            RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"ApplicationType should be either New/Renewal"}}');return;      
                        }
                    }
                    
                    if(app.CourseName == '' || app.CourseName == null || (app.CourseName!='BE/B.Tech' && app.CourseName!='Integrated MTech')){
                        RestContext.response.statusCode   = 400;
                        if(app.CourseName == '' || app.CourseName == null){
                            RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"CourseName '+system.label.empty_string_error_message+'"}}');return; 
                        }else{
                            RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"CourseName should be either BE/B.Tech or Integrated MTech"}}');return;  
                        }
                    }
                    
                    if((app.CurrentYear!='5th Year' && app.CurrentYear!='4th Year' && app.CurrentYear!='3rd Year' && app.CurrentYear!='1st Year' && app.CurrentYear!='2nd Year') || app.CurrentYear == '' || app.CurrentYear == null){
                        RestContext.response.statusCode   = 400;
                        if(app.CurrentYear == '' || app.CurrentYear == null){ 
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"CurrentYear '+system.label.empty_string_error_message+'"}}');return; 
                        }else{
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"CurrentYear should be one among this 1st Year/2nd Year/3rd Year/4th Year/5th Year"}}');return;    
                        }
                        }
                    
                    if(app.BranchName == '' || app.BranchName == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BranchName '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    
                    if(app.CollegeFee == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"CollegeFee '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    if(app.HostelExpense == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"HostelExpense '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    
                    if(app.BookExpense == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"BookExpense '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    if(app.TransportationExpense == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"TransportationExpense '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    
                    if(app.UniformExpense == null){
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"UniformExpense '+system.label.empty_string_error_message+'"}}');return; 
                    }
                    
                    if((app.Semester != '1st Semester' && app.Semester != '2nd Semester' && app.Semester != '3rd Semester' && app.Semester != '4th Semester' && app.Semester != '5th Semester' && app.Semester != '6th Semester' && app.Semester != '7th Semester' && app.Semester != '8th Semester' && app.Semester != '9th Semester' && app.Semester != '10th Semester') || app.Semester == '' || app.Semester == null){
                        RestContext.response.statusCode   = 400;
                        if(app.Semester == '' || app.Semester == null){
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Semester '+system.label.empty_string_error_message+'"}}');return; 
                        }else{
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Semester should be one among this 1st Semester/2nd Semester/3rd Semester/4th Semester/5th Semester/6th Semester/7th Semester/8th Semester/9th Semester/10th Semester"}}');return;    
                        }
                    }
                    
                    
                    if(!ExistingApplicationIDDuplicateCheck.contains(String.valueOf(app.ExistingApplicationID))){
                        ExistingApplicationIDDuplicateCheck.add(String.valueOf(app.ExistingApplicationID));
                    }else{
                        RestContext.response.statusCode   = 400;
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' + String.valueOf(app.ExistingApplicationID) + ': '+system.label.IITBAA_Duplicate_ApplicationID_in_Request_body+'"}}');return;
                    }
                    
                    emailCYSem.put(String.valueOf(std.StudentDetail.Email).toLowerCase(),String.valueOf(std.StudentDetail.Email).toLowerCase()+'-'+app.CurrentYear+'-'+app.Semester);
                }
                
                StdEmails.add(String.valueOf(std.StudentDetail.Email).toLowerCase());
                
                
            }
            
            //
            //duplicate check with system
            if(!emailDuplicateCheck.isEmpty()){
                String dupEmail = IITBAAStudentDuplicateCheck.duplicateCheck(emailDuplicateCheck,'Email');
                if(dupEmail != null){   
                    RestContext.response.statusCode   = 409;
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' +  dupEmail + ' '+system.label.IITBAA_Duplicate_emai_check+'"}}');return;
                }
            }
            if(!mobileDuplicateCheck.isEmpty()){
                String dupmobile = IITBAAStudentDuplicateCheck.duplicateCheck(mobileDuplicateCheck,'Mobile');
                if(dupmobile != null){   
                    RestContext.response.statusCode   = 409;   
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' +  dupmobile + ' '+system.label.IITBAA_Duplicate_mobilecheck+'"}}');return;
                }
            }
            if(!aadharduplicateCheck.isEmpty()){
                String dupAadhadr = IITBAAStudentDuplicateCheck.duplicateCheck(aadharduplicateCheck,'Aadhar');
                if(dupAadhadr != null){   
                    RestContext.response.statusCode   = 409;   
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' +  dupAadhadr + ' '+system.label.IITBAA_Duplicate_Aadhar_check+'"}}');return;
                }
            }
            if(!studentIDDuplicateCheck.isEmpty()){
                String dupStudentID = IITBAAStudentDuplicateCheck.duplicateCheck(studentIDDuplicateCheck,'UniqueStudentID');
                if(dupStudentID != null){   
                    RestContext.response.statusCode   = 409;   
                    RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"' + dupStudentID + ' '+system.label.IITBAA_Duplicate_student_id_check+'"}}');return;
                }
            }
            //
            
            
            
            
            List<Application__c> ExistingAppList = [SELECT id,Student__r.Email,Student__c,Application_Stage__c,Semester__c,Year__c From Application__c where Student__r.Email=:StdEmails];
            Set<String> existingStudentEmails = new Set<String>();
            Map<String,String> studentIDWithEmail = new Map<String,String>();
            Map<String,boolean> studentActiveOrNotWithEmail = new Map<String,boolean>();
            //emailCYSem
            boolean checkIsActive = false;
            for(Application__c app : ExistingAppList){
                existingStudentEmails.add(app.Student__r.Email);
                studentIDWithEmail.put(app.Student__r.Email,app.Student__c);
                if(emailCYSem.containsKey(app.Student__r.Email)){// if application is already present in the system
                    if(app.Year__c == emailCYSem.get(app.Student__r.Email).split('-')[1] && app.Semester__c == emailCYSem.get(app.Student__r.Email).split('-')[2]){
                        RestContext.response.statusCode   = 409;   
                        RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"Application with '+app.Student__r.Email+' Email Id is already present in FFE for '+app.Year__c+', '+app.Semester__c+'"}}');return;
                    }
                }//below if else is used to either activate application if non under that student is active or else it will be open
                if(app.Application_Stage__c == 'Active'){
                    studentActiveOrNotWithEmail.put(app.Student__r.Email,false);
                    checkIsActive = true;
                }else{
                    if(checkIsActive == false)
                        studentActiveOrNotWithEmail.put(app.Student__r.Email,true);
                }
            }
            
            
            
            
            string studentRTypeId                        = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
            
            List<IITBAAStudentCreationRequest.cls_Request> ExistingStudentWrp = new List<IITBAAStudentCreationRequest.cls_Request>();
            List<IITBAAStudentCreationRequest.cls_Request> nonExistingStudentWrp = new List<IITBAAStudentCreationRequest.cls_Request>();
            
            College_Master__c colMaster = [Select id from College_Master__c where Name='IIT Bombay'];
            
            List<Contact> contactList = new List<Contact>();
            for(IITBAAStudentCreationRequest.cls_Request std:jsonRequestData.Request){
                if(!existingStudentEmails.contains(std.StudentDetail.Email.toLowerCase())){
                    contactList.add(new contact(College_Name__c=colMaster.id,FirstName = std.StudentDetail.FirstName,LastName = std.StudentDetail.LastName,Email = std.StudentDetail.Email,Gender__c = std.StudentDetail.Gender,MobilePhone=std.StudentDetail.Phone,Aadhar_number__c=std.StudentDetail.AadharNumber,Academic_start_year__c=std.StudentDetail.AcademicStartYear,
                                                MailingStreet=std.StudentDetail.MailingStreet,MailingCity=std.StudentDetail.MailingCity,MailingState=std.StudentDetail.MailingState,MailingCountry=std.StudentDetail.MailingCountry,MailingPostalCode=std.StudentDetail.MailingPostalCode,Course__c=std.StudentDetail.Course,
                                                Branch_Stream__c=std.StudentDetail.Branch,Bank_Account_Holder_s_Name__c=std.StudentDetail.BankAccountHolderName,Full_Bank_Account_No_With_all_digits__c=std.StudentDetail.BankAccountNumber,Bank_Name__c=std.StudentDetail.BankName,X11_character_IFSC_Code_of_the_Branch__c=std.StudentDetail.BankIFSCCode,
                                                Bank_City__c=std.StudentDetail.BankCity,Bank_State__c=std.StudentDetail.BankState,Bank_Pincode__c=std.StudentDetail.BankPinCode,Student_ID__c=std.StudentDetail.StudentUniqueID,recordTypeID=studentRTypeId,Internal_status__c=Constants.AWAITING_FUND_STATUS,From_IITBAA__c=true));
                }
            }
            // insertion of only those students who's not existing in the system as IITBAA students
            if(!contactList.isEmpty())
                insert contactList;
            
            Map<String,String> conIdForApplications   = new Map<String,String>();
            List<String> studentSalesforceIdsForQuery = new List<String>();
            for(Contact con:contactList){
                conIdForApplications.put(con.email,con.id);
                studentSalesforceIdsForQuery.add(String.valueOF(con.id));
            }
            
            
            
            string prelimRTypeId                         = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 
            string renewalRTypeId                        = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_RENEWAL_APPLICATION).getRecordTypeId(); 
            List<Application__c> studentApplicationListToInsert  = new List<Application__c>();
            
            //application record creations
            for(IITBAAStudentCreationRequest.cls_Request std:jsonRequestData.Request){
                boolean isActivated = false;
                boolean isActivatedforExisting = false;
                // if else is used to differeciate the applications of those students who exist in the system and those who dont
                for(IITBAAStudentCreationRequest.cls_Applications app : std.Applications){
                    Application__c application = new Application__c();
                    
                    if(!existingStudentEmails.contains(String.valueOf(std.StudentDetail.Email).toLowerCase())){//for newly inserted student
                        application = new Application__c(Student__c=conIdForApplications.get(std.StudentDetail.Email),Year__c=app.CurrentYear,Application_Type__c=app.ApplicationType,Course_Name__c=app.CourseName,Branch__c=app.BranchName,College_Fees__c=app.CollegeFee,Hostel_Mess_Expenses__c=app.HostelExpense,
                                                         Books_Expenses__c=app.BookExpense,Transportation_Expenses__c=app.TransportationExpense,Uniform_Expenses__c=app.UniformExpense,Existing_Application_ID__c=app.ExistingApplicationID,Requested_College_Fees__c=app.CollegeFee,
                                                         Requested_Hostel_Mess_Expenses__c=app.HostelExpense,Requested_Books_Expenses__c=app.BookExpense,Requested_Transportation_Expenses__c=app.TransportationExpense,
                                                         Requested_Uniform_Expenses__c=app.UniformExpense,Internal_Status__c=Constants.AWAITING_FUND_STATUS,External_Status__c=Constants.INPROGRESS_APPLICATION,
                                                         Amount_Requested__c= (app.CollegeFee + app.HostelExpense + app.BookExpense + app.TransportationExpense + app.UniformExpense),Semester__c=app.Semester);
                        
                        if(isActivated == false){//making application active or open based on student application status
                            application.Application_Stage__c=Constants.ACTIVE_APPLICATION;
                            isActivated = true;
                        }else{
                            application.Application_Stage__c=Constants.APP_STAGE_OPEN;        
                        }
                    }else{//already existing student
                        application = new Application__c(Student__c=studentIDWithEmail.get(String.valueOf(std.StudentDetail.Email).toLowerCase()),Year__c=app.CurrentYear,Application_Type__c=app.ApplicationType,Course_Name__c=app.CourseName,Branch__c=app.BranchName,College_Fees__c=app.CollegeFee,Hostel_Mess_Expenses__c=app.HostelExpense,
                                                         Books_Expenses__c=app.BookExpense,Transportation_Expenses__c=app.TransportationExpense,Uniform_Expenses__c=app.UniformExpense,Existing_Application_ID__c=app.ExistingApplicationID,Requested_College_Fees__c=app.CollegeFee,
                                                         Requested_Hostel_Mess_Expenses__c=app.HostelExpense,Requested_Books_Expenses__c=app.BookExpense,Requested_Transportation_Expenses__c=app.TransportationExpense,
                                                         Requested_Uniform_Expenses__c=app.UniformExpense,Internal_Status__c=Constants.AWAITING_FUND_STATUS,External_Status__c=Constants.INPROGRESS_APPLICATION,
                                                         Amount_Requested__c= (app.CollegeFee + app.HostelExpense + app.BookExpense + app.TransportationExpense + app.UniformExpense),Semester__c=app.Semester);
                        
                        
                        if(studentActiveOrNotWithEmail.get(String.valueOf(std.StudentDetail.Email).toLowerCase()) == false){
                            application.Application_Stage__c=Constants.APP_STAGE_OPEN;
                        }else{
                            if(isActivatedforExisting == false){//making application active or open based on student application status
                            application.Application_Stage__c=Constants.ACTIVE_APPLICATION;isActivatedforExisting = true;
                            }else{
                              application.Application_Stage__c=Constants.APP_STAGE_OPEN;  
                            }
                        }
                    }
                    
                    if(app.ApplicationType == Constants.APPLICATIONTYPE_NEW){
                        application.RecordTypeID=prelimRTypeId; 
                    }else{
                        application.RecordTypeID=renewalRTypeId; 
                    }
                    
                    
                    studentApplicationListToInsert.add(application);
                }
            }
            
            if(!studentApplicationListToInsert.isEmpty())
                insert  studentApplicationListToInsert;   
            
            
            List<String> entireSalesforceIDS = new List<String>();
            entireSalesforceIDS.addAll(studentSalesforceIdsForQuery);
            entireSalesforceIDS.addAll(studentIDWithEmail.values());
            
            //response json creation
            List<Contact> studentsFromIITBAA = [Select id,FFE_ID__c,FirstName,LastName,Email,Student_ID__c,(Select id,Name,Application_Type__c,Course_Name__c,Year__c,Branch__c,Semester__c,Existing_Application_ID__c From Applications__r where Existing_Application_ID__c=:ExistingApplicationIDDuplicateCheck) from contact where ID=:entireSalesforceIDS];
            
            String response = '{"Response":[{';
            integer j = 0;
            for(Contact con : studentsFromIITBAA){
                if(j == 0)
                    response += '"StudentDetail":{';
                else
                    response += ',{"StudentDetail":{';    
                
                response += '"FirstName":"'+con.FirstName+'",';
                response += '"LastName":"'+con.LastName+'",';
                response += '"Email":"'+con.Email+'",';
                response += '"StudentUniqueID":"'+con.Student_ID__c+'",';
                response += '"FFEUID":"'+con.FFE_ID__c+'",';
                response += '"StudentSFID":"'+con.id+'"';
                response += '},"Applications":[';
                for(integer i =0 ; i< con.Applications__r.size();i++){
                    response += '{';
                    response += '"ApplicationType":"'+con.Applications__r[i].Application_Type__c+'",';
                    response += '"CourseName":"'+con.Applications__r[i].Course_Name__c+'",';
                    response += '"CurrentYear":"'+con.Applications__r[i].Year__c+'",';
                    response += '"Semester":"'+con.Applications__r[i].Semester__c+'",';
                    response += '"Branch":"'+con.Applications__r[i].Branch__c+'",';
                    response += '"ExistingApplicationID":"'+con.Applications__r[i].Existing_Application_ID__c+'",';
                    response += '"ApplicationSFID":"'+con.Applications__r[i].Name+'"';
                    if(i == con.Applications__r.size()-1)
                        response += '}]}';
                    else
                        response += '},'; 
                }
  
                j = j+1;
            }
            response +=']}';
            system.debug(response);
            
            RestContext.response.responseBody = 
                Blob.valueOf(response);return;
            
        }Catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('IITBAAStudentCreationWebservice', '@httpPost', e);
            system.debug(e);system.debug(e.getLineNumber());
            RestContext.response.statusCode   = 500;   
            RestContext.response.responseBody = Blob.valueOf('{"Response":{"error-msg":"'+system.label.IITBAA_Exception_error_message+'"}}');return;
        }
    }
}