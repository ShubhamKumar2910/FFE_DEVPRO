/*
* @Purpose      :  AP_Student_Application_CTRL helper class.
* @Author       :  Supriya Chakrapani
* @CreatedDate  :  08-03-2017
*/

public class AP_Student_Application_helper{
    
    public Static messageWrapper validateStudent(Contact studentInfo){
        
        String retMsg = '';
        messageWrapper mwrp = new messageWrapper(); 
        if(studentInfo.MobilePhone != null 
           && DN_DonorRegistration_Helper.checkDupForMobile(studentInfo.MobilePhone,null,Constants.FFE_DONOR_STUDENT).size() > 0){
               mwrp.message = Constants.MOBILE_DUPLICATE_ERR_MSG;
               mwrp.status = 'Error';
               return mwrp;
           }
        
        /*if(studentInfo.Phone != null 
&& DN_DonorRegistration_Helper.checkDupForPhone(studentInfo.Phone,null,Constants.FFE_DONOR_STUDENT).size() > 0){
retMsg   = Constants.PHONE_DUPLICATE_ERR_MSG;
return retMsg ;
}*/
        
        if(studentInfo.Email != null && studentInfo.Email != ''
           && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Email,null,Constants.FFE_DONOR_STUDENT).size() > 0){
               mwrp.message = Constants.EMAIL_DUPLICATE_ERR_MSG;
               mwrp.status = 'Error';
               return mwrp;
           }
        
        if(studentInfo.Google_login_ID__c != null && studentInfo.Google_login_ID__c != ''
           && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Google_login_ID__c,null,Constants.FFE_DONOR_STUDENT).size() > 0){
               mwrp.message = Constants.EMAIL_DUPLICATE_ERR_MSG;
               mwrp.status = 'Error';
               return mwrp;
           }
        
        if(studentInfo.Facebook_login_ID__c != null && studentInfo.Facebook_login_ID__c != ''
           && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Facebook_login_ID__c,null,Constants.FFE_DONOR_STUDENT).size() > 0){
               mwrp.message = Constants.EMAIL_DUPLICATE_ERR_MSG;
               mwrp.status = 'Error';
               return mwrp;
           } 
        
        
        if(studentInfo.Aadhar_number__c != null && studentInfo.Aadhar_number__c != ''
           && DN_DonorRegistration_Helper.checkDupForAadhar(studentInfo.Aadhar_number__c,null,Constants.FFE_DONOR_STUDENT).size() > 0){
               //retMsg   = Constants.Aadhar_Err_Msg;
               mwrp.message = Constants.Aadhar_Err_Msg;
               mwrp.status = 'Error';
               //return retMsg ;
               return mwrp;
           }  
        
        if(studentInfo.Refered_by_Facilitator_Id__c != null && studentInfo.Refered_by_Facilitator_Id__c != ''){
             String facName = DN_DonorRegistration_Helper.checkDupForFacilitator(studentInfo.Refered_by_Facilitator_Id__c);
            if(Constants.Facilitator_error != facName) {
                mwrp.message = facName;
                mwrp.status = 'Success';
                return mwrp;
            }else{
                mwrp.message = Constants.Facilitator_error;
                mwrp.status = 'Error';
                return mwrp;
            }
                     
        }
        
        mwrp.message = '';
        mwrp.status = 'Success';
        return mwrp;
    }
    
    /*@purpose            :Get student Information(here student object is contact object) From page
* @param                 :@Contact object
* @returnType            :String
*/   
    public Static AP_Student_Application_CTRL.messageWrapper createStudentInSFDC(AP_Student_Application_CTRL.prelimWrapper plmwrp){
        Contact facilitatorID = new Contact();
        AP_Student_Application_CTRL.messageWrapper mwrp  = new AP_Student_Application_CTRL.messageWrapper();
        SavePoint sp  = Database.setSavepoint();
        try{            
            Contact newStudent          = plmwrp.scholar;
            Application__c appln        = plmwrp.ScholarAppln;
            
            AP_CheckScholarRankCriteria.WrapperApplication crtWrp   = AP_CheckScholarRankCriteria.ValidationRankCriteria(newStudent);
            
            newStudent.RecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
            if(newStudent.Do_you_have_Google_login__c != null)
                newStudent.Do_you_have_Google_login__c    = Boolean.valueOf(newStudent.Do_you_have_Google_login__c);
            if(newStudent.Do_you_have_Facebook_login__c != null)
                newStudent.Do_you_have_Facebook_login__c   = Boolean.valueOf(newStudent.Do_you_have_Facebook_login__c);      
            
            newStudent.Internal_Status__c   = crtWrp.internalStatus;
            newStudent.Rejection_Reason__c  = crtWrp.rejectionReason;
            
            
            newStudent.MailingCountry    = Constants.STUDENT_COUNTRY;
            
            
            
            appln.Internal_Status__c        = crtWrp.internalStatus;
            appln.External_Status__c        = crtWrp.externalStatus;
            
            if((appln.Year__c!='1st Year' && newStudent.Course__c=='BE/B.Tech') || (appln.Year__c!='1st Year' && newStudent.Course__c=='Integrated MTech') || (appln.Year__c!='Year I, Sem 1' && newStudent.Course__c=='MBBS')||(appln.Year__c!='1st Year' && newStudent.Course__c=='BPharm')){
            crtWrp.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
            crtWrp.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
            appln.Internal_Status__c        = System.Label.ScholarshipInternalStatusIneligible;
            appln.External_Status__c        = System.Label.ScholarshipExternalStatusSubmitted;
            newStudent.Rejection_Reason__c = system.label.Rejection_Reason_for_1st_year;
            }
            
            appln.Application_Type__c       = Constants.APPLICATIONTYPE_NEW;
            appln.RecordTypeId              = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 
            
            if(crtWrp.internalStatus == System.Label.ScholarshipInternalStatusEligible){
                appln.Application_Stage__c  = Constants.ACTIVE_APPLICATION;                
            }else{
                appln.Application_Stage__c  = Constants.APP_STAGE_OPEN;            
            }            
            appln.Course_Name__c      = newStudent.Course__c;
            if(newStudent.Branch_Stream__c == Constants.OTHER_STRING){
                appln.Branch__c    = newStudent.Branch_Other__c;
            }else{
                appln.Branch__c    = newStudent.Branch_Stream__c;
            }
            try{
                College_Master__c collg  = [Select id,Name from College_Master__c where id =:newStudent.College_Name__c];
                if(collg.Name == Constants.OTHER_STRING){
                    appln.College_Name__c    = newStudent.College_Other__c;
                }else{
                    appln.College_Name__c    = collg.Name;
                }
            }catch(Exception ex){HandleBusinessException.captureError('AP_Student_Application_helper', 'createStudentInSFDC', ex);}            
            
            appln.Email__c          = newStudent.Email;
            appln.FFE_Accommodation_Type__c = newStudent.FFE_Accomodation_Type__c;//Populating Accomodation Type on Prelim Application  -- Sumit Gaurav -- 06-May-2020
            mwrp.message  = Constants.PRELIM_SUCCESS_MSG;
            
            //To create student-facilitator mapping   
            
            if((newStudent.Refered_by_Facilitator_Id__c!=null && newStudent.Refered_by_Facilitator_Id__c!='') && (newStudent.Refered_by_Facilitator_Name__c!=null && newStudent.Refered_by_Facilitator_Name__c!='') && crtWrp.internalStatus == System.Label.ScholarshipInternalStatusEligible && crtWrp.rejectionReason==null){
                facilitatorID                   = [SELECT ID,Name FROM Contact WHERE FFE_ID__c =:newStudent.Refered_by_Facilitator_Id__c AND Name=:newStudent.Refered_by_Facilitator_Name__c];
                
                newStudent.Facilitator_Name__c  = facilitatorID.Id;
                newStudent.Internal_Status__c   = Constants.ONLINE_MATCHED_APPLICATION;
                appln.Application_Stage__c      = Constants.ACTIVE_APPLICATION;
                appln.Internal_Status__c        = Constants.ONLINE_MATCHED_APPLICATION;
                appln.External_Status__c        = Constants.INPROGRESS_APPLICATION;
                mwrp.message                    = Constants.DocumentUploadingMessage;
                
            }
            
            
            // Insert Scholar and Application record
            insert newStudent;
            
            appln.Student__c                = newStudent.Id; 
            appln.ApplicationExternalKey__c = newStudent.Id+'@@@'+appln.Year__c;
            //Commented the below eligibility criteria check -- Sumit Gaurav -- 11-June-2020
            /* Integer currentYear = System.Today().year(),currYearMinusOne;
            currYearMinusOne = currentYear - 1;
            Integer yearPassed = Integer.valueOf(newStudent.X12th_Year_Passed__c);
            if(newStudent.Annual_Family_Income__c > 250000 || yearPassed  < currYearMinusOne || newStudent.Entrance_Exam_Taken_In_Year__c != String.valueOf(currentYear)){
                
                appln.Internal_Status__c = System.Label.ScholarshipInternalStatusIneligible;
            } */
            
            insert appln;
            
            //to send SMS to student mobile
            //SMS_Service_CTRL.when_Student_register_for_sholarship(crtWrp.conInfo.MobilePhone,'1Constants.when_Student_register_for_sholarship_text');
            // system.debug('nodona eru');
            //SMS_Service_CTRL.when_Student_register_for_sholarship('7829483829','2Constants.when_Student_register_for_sholarship_text');
            //SMS_Service_CTRL.when_Student_register_for_sholarship(newStudent.MobilePhone,Constants.when_Student_register_for_sholarship_text);
            
            
            
            //to send mail for student with facilitator details
            if((newStudent.Refered_by_Facilitator_Id__c!=null && newStudent.Refered_by_Facilitator_Id__c!='') && (newStudent.Refered_by_Facilitator_Name__c!=null && newStudent.Refered_by_Facilitator_Name__c!='') && crtWrp.internalStatus == System.Label.ScholarshipInternalStatusEligible && newStudent.Facilitator_Name__c!=null){
                string targetRecordId   = newStudent.id;
                String whatId           = appln.id;
                
                EmailTemplate emailTemplateId = [Select id from EmailTemplate where Developername =: 'StudentSelectedTemplate'];//Replaced Facilitator_referred_Email template to StudentSelectedTemplate -- Sumit Gaurav - 12-June-2020
                String returnedString         = Utility.sendEmailWithTemplateThroughCustomButton(targetRecordId, emailTemplateId.id,whatID);
                
                //SMS to student when facilitator is matched
                //SMS_Service_CTRL.when_Student_register_for_sholarship('7829483829','Constants.When_facilitator_assigned_to_Student_text');
                
                
            }
            
            
            //mwrp.recordId  = newStudent.Id;
            mwrp.recordId  = DN_CCAvenue_Service.encryptString(newStudent.Id, DN_ServiceConstants.DN_ORDER_KEY);   
            
            return mwrp;
        }catch(Exception e){
            HandleBusinessException.captureError('AP_Student_Application_helper', 'createStudentInSFDC', e);
            database.rollback(sp);
            system.debug('exception'+e.getMessage());
            mwrp.message  = Constants.ERROR_MSG;
            return mwrp;
        }
    }
    
    /*@purpose    : Search Filter For Colleges.
* @param       :searchTerm
* @returnType  :List<College_Master__c>
*/ 
    public static List<College_Master__c> searchCollege(String searchTerm,String course) {
        List<College_Master__c> CollegeList  = Database.query('Select Id, Name,College_City__c,College_Rating__c,College_State__c from College_Master__c where Name != null AND  (Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\') ORDER BY Name');
        return CollegeList;
    } 
    
    /*@purpose    : Get list of all Entrance Test Name from Custom metadata type "Entrance_Test__mdt"
* @returnType  :List<Entrance_Test__mdt>
*/
    public static List<Entrance_Test__mdt> getAllEntranceTestName(){
        return [Select Id,Entrance_Test_Name__c from Entrance_Test__mdt LIMIT 2000];
        
    }
    
    /*@purpose     : Check for prelim Application Period
*@returnType  : boolean
*/
    public static boolean displayPrelimApp(){
        System_Details__c sysm  = System_Details__c.getInstance();
        if(System.today()  >= sysm.Scholarship_Prelim_Open_Date__c
           && System.today() <=sysm.Scholarship_Prelim_Close_Date__c){
               return true;
           }else{
               return false;
           }   
        
    }
    
        public Static String validateFacilitator(Contact studentInfo){
        
        String retMsg = '';
          
        if(studentInfo.Refered_by_Facilitator_Id__c != null && studentInfo.Refered_by_Facilitator_Id__c != ''){
            return DN_DonorRegistration_Helper.checkDupForFacilitator(studentInfo.Refered_by_Facilitator_Id__c);
            
        }else{
            return null;
        } 
    }
    
    public class messageWrapper {
    public string message;
    public string status;
        
        public messageWrapper(){
            message  = '';
            status= '';
        }
    }
}