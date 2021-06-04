/*
* @description : This class is helper for AP_Application_CTRL class
* @Author      : Amritesh
* @createdDate : 22/03/2017
*/ 
global class AP_Application_Helper {
    
    /*@purpose       : Get current guest user info
*@param         : contactId
*@returnType    : Contact
*/
    public static Contact getScholarUserDetail(String  contactId){
        Contact c = [SELECT id,Renewal_On__c,TYS_Video_Link__c,TYS_SchoolLife__c,TYS_GuidanceProvider__c,TYS_CollegeAssessment__c,TYS_FFE_Scholarship_and_Impact__c,TYS_Future_Plans__c,TYS_Dreams_and_Responsibilities__c,
TYS_How_would_you_help_other_Students__c,Current_Annual_Family_Income__c,Certificate_Expiry_Date__c,Linkedin_Profile_Link__c,Do_you_have_Linkedin_Profile__c,Name,Xth_ExamBoard__c,X12th_ExamBoard__c, Type_Of_Bank_Account__c ,firstname,lastname,MobilePhone,Birthdate,Email,phone,MailingAddress,DN_Organization__c,Student_ID__c,Internal_Status__c,KYC_Verified__c,Is_IFSC_Code_Verified__c,Other_Type_Bank_Account__c,
                npe01__WorkPhone__c,npe01__WorkEmail__c,FFE_ID__c,X10th__c,X10th_Marks_Obtained__c,X10th_Maximum_Marks__c,Active_Application_ID__c,
                X10th_Medium_Of_Instruction__c,X10th_Type__c,X10th_Year_Passed__c,X12th__c,X12th_Marks_Obtained__c,Profile_Pic_Attachment_Id__c,
                MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,X12th_Maximum_Marks__c,X12th_Medium_Of_Instruction__c,
                X12th_Type__c,X12th_Year_Passed__c,Branch_Stream__c,Branch_Other__c,College_City__c,College_Name__c,College_Other__c,Rejection_Reason__c,
                College_State__c,Type__c,Course__c,Entrance_Exam_Maximum_Marks__c,Entrance_Exam_Taken_In_Year__c,Entrance_Test_Marks__c,College_Name__r.Name,
                Entrance_Test_Name__c,Entrance_Test_Rank__c,Facilitator_Name__c,Facilitator_Name__r.Name,Father_Age__c,Father_Education__c,Father_Name__c,Annual_Family_Income__c,
                Facilitator_Name__r.FFE_ID__c,Facilitator_Name__r.MailingCity,Facilitator_Name__r.MobilePhone,Facilitator_Name__r.MailingState,
                Father_Occupation__c,Gender__c,Mother_Age__c,Mother_Education__c,Mother_Name__c,Mother_Occupation__c,AP_Year_of_beginning__c,DisplayFacilitatorSection__c,
                Do_you_have_Google_login__c,Login_Hash_Code__c,Facebook_login_ID__c,Current_year__c,Google_login_ID__c,Do_you_have_Facebook_login__c,Facilitator_Name__r.Working_Mode__c,
                Bank_Account_Holder_s_Name__c,Bank_Branch_Phone_No__c,Bank_City__c,Bank_Name__c,Bank_Pincode__c,Bank_State__c,Full_Bank_Account_No_With_all_digits__c,English_Spoken_Score__c,English_Written_Score__c,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,Rejected__c,
                X11_character_IFSC_Code_of_the_Branch__c,RecordType.DeveloperName,Branch_Address__c,ScholarshipAmount__c,IsPrelimProcessed__c,
                What_is_your_ambition_in_life__c,Who_has_inspired_you_the_most_until_now__c,Tell_us_some_things_about_yourself__c,Describe_your_family_s_income__c,
                When_you_start_earning_how_you_help__c,Parent_Mobile__c,Parent_Phone__c,Total_Point_s__c,Aadhar_number__c,MBBS_Year_1__c,MBBS_Year_2__c,MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c,Semester1__c,Semester2__c,Semester3__c,Semester4__c,Semester5__c,Semester6__c,Semester7__c,Semester8__c,Aptitude_Analytical_Score_post__c,Aptitude_Logical_Score_post__c,English_Written_Score_post__c,English_Spoken_Score_post__c,CTC__c,Designation__c,Company_Name__c,Location__c,Other__c,Placement_Info__c,Semester9__c,Semester10__c,Has_Mentor__c,  
                (SELECT Comment_s_for_Student__c,Missing_Documents__c,Amount_Funded__c,FFE_Accommodation_Type__c ,Amount_Requested__c,Application_Stage__c,Application_Type__c,Course_Name__c,Branch__c,Parent_Application__c,
                 Course__c,toLabel(External_Status__c),Id,toLabel(Internal_Status__c),Name,RecordTypeId,FacilitatorInputDone__c,College_Name__c,Facilitator_meet_date__c,Have_you_called_met_your_facilitator__c,
                 Remaining_Fund__c,Student__c,Year__c,RecordType.DeveloperName,If_Yes_How_much_AICTE_Fee_from_Govt__c,Student_Books_Expenses__c,Student_Uniform_Expenses__c,Student_College_Fees__c,Student_Hostel_Mess_Expenses__c,Student_Transportation_Expenses__c,Requested_Scholarship_Amount__c,Requested_Books_Expenses__c,Requested_College_Fees__c,Requested_Hostel_Mess_Expenses__c,Requested_Transportation_Expenses__c,
                 Requested_Uniform_Expenses__c,Assistance_Source__c,SchlrShp_FinancialAsst_Other_Than_FFE__c,If_Yes_How_much_Other_Source__c,Scholarship_Amount__c,Change_in_AnnualIncome_of_Parents__c,Receiving_Full_AICTE_OtherTution_Fee_Wa__c,Annual_Marks_Scored_CGPA__c,
                 Even_Semester_Marks_Scored_SGPA__c,Odd_Semester_Marks_Scored_SGPA__c,Failure_Subject_s__c,Failure_ATKT_Yes_If_Yes_Semester__c,Failure_ATKT__c,Grading_System__c,FFE_Certificate_Expiry_Date__c 
                 FROM Applications__r where Parent_Application__c = null 
                 OR (Parent_Application__c != null AND Application_Stage__c =:Constants.APP_STAGE_CLOSED
                     AND Internal_Status__c =: Constants.Disbursed)),(Select id,Donor__r.Primary_Donor_logo_attachment_Id__c,Donor__r.Secondary_Donor_logo_attachment_id__c from Donor_Application_Mappings1__r order by CreatedDate LIMIT 1) 
                FROM Contact WHERE  Id =:contactId];//Added KYC_Verified__c,Is_IFSC_Code_Verified__c,Other_Type_Bank_Account__c in query fields -- Sumit Gaurav -- 23-June-2020
        
        String FinancialYear = Utility.financialYear();
        List<Application__c> listApps = [Select id from Application__c where RPT_Financial_Year__c=:FinancialYear and Student__c =: contactId limit 1];
        if(listApps != null && listApps.size() > 0){
            c.Renewal_On__c = false;
        }
        else if(displayRenewalApp()){// Added check for custom setting data renewal window date -- Sumit Guarav -- 1-June-2020
            c.Renewal_On__c = true;
        }
    
       return c; 
        
    }
    
    /*@purpose      : Getting the Student update information from the student profile page  
*@param        : studentInfo
*@returnType   : String
*/
    public Static String updateStudentInSFDC_TYS(Contact studentTYSInfo){
        try{
            upsert studentTYSInfo;
            return 'Information updated successfully!';
        }catch(exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'updateStudentInSFDC_TYS', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    public Static String updateStudentInSFDC(Contact studentInfo){
        try{
            studentInfo.Do_you_have_Google_login__c    = Boolean.valueOf(studentInfo.Do_you_have_Google_login__c);
            studentInfo.Do_you_have_Facebook_login__c  = Boolean.valueOf(studentInfo.Do_you_have_Facebook_login__c);
            if(studentInfo.MobilePhone != null && studentInfo.MobilePhone != '' && DN_DonorRegistration_Helper.checkDupForMobile(studentInfo.MobilePhone,studentInfo.Id,Constants.FFE_DONOR_STUDENT) != null && 
               DN_DonorRegistration_Helper.checkDupForMobile(studentInfo.MobilePhone,studentInfo.Id,Constants.FFE_DONOR_STUDENT).size() > 0){
                   return Constants.MOBILE_DUPLICATE_ERR_MSG;
               }
            if(studentInfo.Phone != null && studentInfo.Phone != '' && DN_DonorRegistration_Helper.checkDupForPhone(studentInfo.Phone,studentInfo.Id,Constants.FFE_DONOR_STUDENT) != null && 
               DN_DonorRegistration_Helper.checkDupForPhone(studentInfo.Phone,studentInfo.Id,Constants.FFE_DONOR_STUDENT).size() > 0){
                   return Constants.PHONE_DUPLICATE_ERR_MSG;
               } 
            if(studentInfo.Email != null && studentInfo.Email != '' && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Email,studentInfo.Id,Constants.FFE_DONOR_STUDENT) != null && 
               DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Email,studentInfo.Id,Constants.FFE_DONOR_STUDENT).size() > 0){
                   return Constants.EMAIL_DUPLICATE_ERR_MSG;
               }
            if(studentInfo.Google_login_ID__c != null && studentInfo.Google_login_ID__c != '' && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Google_login_ID__c,studentInfo.Id,Constants.FFE_DONOR_STUDENT) != null
               && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Google_login_ID__c,studentInfo.Id,Constants.FFE_DONOR_STUDENT).size() > 0){
                   return Constants.EMAIL_DUPLICATE_ERR_MSG;
               }
            if(studentInfo.Facebook_login_ID__c != null && studentInfo.Facebook_login_ID__c != '' && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Facebook_login_ID__c,studentInfo.Id,Constants.FFE_DONOR_STUDENT) != null
               && DN_DonorRegistration_Helper.checkDupForEmail(studentInfo.Facebook_login_ID__c,studentInfo.Id,Constants.FFE_DONOR_STUDENT).size() > 0){
                   return Constants.EMAIL_DUPLICATE_ERR_MSG;
               }
            if(studentInfo.Aadhar_number__c != null && studentInfo.Aadhar_number__c != '' && DN_DonorRegistration_Helper.checkDupForAadhar(studentInfo.Aadhar_number__c,studentInfo.Id,Constants.FFE_DONOR_STUDENT) != null
               && DN_DonorRegistration_Helper.checkDupForAadhar(studentInfo.Aadhar_number__c,studentInfo.Id,Constants.FFE_DONOR_STUDENT).size() > 0){
                   return Constants.Aadhar_Err_Msg;
               }
            if(String.isNotBlank(studentInfo.X11_character_IFSC_Code_of_the_Branch__c)){
                String strMessage = Utility.ifscCodeResponse(studentInfo.X11_character_IFSC_Code_of_the_Branch__c.toUpperCase(),true);
                
                if(strMessage.startsWith('Bank Details -')){
                    studentInfo.Is_IFSC_Code_Verified__c = true;
                    studentInfo.IFSC_Service_Error__c = '';
                }
                else
                {
                    studentInfo.Is_IFSC_Code_Verified__c = false;   
                    studentInfo.IFSC_Service_Error__c = strMessage;
                }
                 
                
            }
            
            upsert studentInfo;
            return Constants.STUDENTPROFILE_UPDATEMSG;
        }catch(exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'updateStudentInSFDC', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    
    /*@purpose       : Get facilitator info
*@param         : contactId
*@returnType    : Contact
*/
    public static Contact getFacilitatorUserDetail(String  contactId){
        return [SELECT id,Name,firstname,lastname,MobilePhone,Email,phone,MailingAddress,DN_Organization__c,  npe01__WorkPhone__c,npe01__WorkEmail__c,FFE_ID__c,Do_you_have_Facebook_login__c,Facilitator_Name__r.Working_Mode__c,
                MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,IsPrelimProcessed__c, Do_you_have_Google_login__c,Facebook_login_ID__c,Google_login_ID__c,Working_Mode__c, DisplayFacilitatorSection__c,RecordType.DeveloperName FROM Contact WHERE  Id =:contactId];
        
    }
    
    /*@purpose      : Getting the Facilitator update information from the facilitator profile page  
*@param        : FacilitatorInfo
*@returnType   : String
*/
    public Static String updateFacilitatorInSFDC(Contact FacilitatorInfo){
        try{
            FacilitatorInfo.Do_you_have_Google_login__c    = Boolean.valueOf(FacilitatorInfo.Do_you_have_Google_login__c);
            FacilitatorInfo.Do_you_have_Facebook_login__c  = Boolean.valueOf(FacilitatorInfo.Do_you_have_Facebook_login__c);
            
            if(FacilitatorInfo.MobilePhone != null && FacilitatorInfo.MobilePhone != '' &&
               DN_DonorRegistration_Helper.checkDupForMobile(FacilitatorInfo.MobilePhone,FacilitatorInfo.Id,Constants.FFE_DONOR_FACILITAtOR).size() > 0){
                   return Constants.MOBILE_DUPLICATE_ERR_MSG;
               }
            if(FacilitatorInfo.Phone != null && FacilitatorInfo.Phone != ''
               && DN_DonorRegistration_Helper.checkDupForPhone(FacilitatorInfo.Phone,FacilitatorInfo.Id,Constants.FFE_DONOR_FACILITAtOR).size() > 0){
                   return Constants.PHONE_DUPLICATE_ERR_MSG;
               }
            if(FacilitatorInfo.Email != null && FacilitatorInfo.Email != ''
               && DN_DonorRegistration_Helper.checkDupForEmail(FacilitatorInfo.Email,FacilitatorInfo.Id,Constants.FFE_DONOR_FACILITAtOR).size() > 0){
                   return Constants.EMAIL_DUPLICATE_ERR_MSG;
               }
            if(FacilitatorInfo.Google_login_ID__c != null && FacilitatorInfo.Google_login_ID__c != ''
               && DN_DonorRegistration_Helper.checkDupForEmail(FacilitatorInfo.Google_login_ID__c,FacilitatorInfo.Id,Constants.FFE_DONOR_FACILITAtOR).size() > 0){
                   return Constants.EMAIL_DUPLICATE_ERR_MSG;
               }
            if(FacilitatorInfo.Facebook_login_ID__c != null && FacilitatorInfo.Facebook_login_ID__c != ''
               && DN_DonorRegistration_Helper.checkDupForEmail(FacilitatorInfo.Facebook_login_ID__c,FacilitatorInfo.Id,Constants.FFE_DONOR_FACILITAtOR).size() > 0){
                   return Constants.EMAIL_DUPLICATE_ERR_MSG;
               }
            
            upsert FacilitatorInfo;
            return Constants.STUDENTPROFILE_UPDATEMSG;
        }catch(exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'updateFacilitatorInSFDC', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    
    /*@purpose     : Get all students alloted to the facilitator
*@param        : FacilitatorId
*@returnType   : List of Students
*/
    public static List<Contact> getStudentAllotedToFac(String facilitatorId){
        
        return [SELECT id,Name,firstname,lastname,MobilePhone,Display_on_facilitator_Profile__c,Birthdate,Email,phone,MailingAddress,DN_Organization__c,Student_ID__c,
                npe01__WorkPhone__c,npe01__WorkEmail__c,FFE_ID__c,X10th__c,X10th_Marks_Obtained__c,X10th_Maximum_Marks__c,IsPrelimProcessed__c,
                X10th_Medium_Of_Instruction__c,X10th_Type__c,X10th_Year_Passed__c,X12th__c,X12th_Marks_Obtained__c,Profile_Pic_Attachment_Id__c,
                MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,X12th_Maximum_Marks__c,X12th_Medium_Of_Instruction__c,
                X12th_Type__c,X12th_Year_Passed__c,Branch_Stream__c,Branch_Other__c,College_City__c,College_Name__c,College_Other__c,
                College_State__c,Type__c,Course__c,Entrance_Exam_Maximum_Marks__c,Entrance_Exam_Taken_In_Year__c,Entrance_Test_Marks__c,
                Entrance_Test_Name__c,Entrance_Test_Rank__c,Facilitator_Name__c,Father_Age__c,Father_Education__c,Father_Name__c,
                Father_Occupation__c,Gender__c,Mother_Age__c,Mother_Education__c,Mother_Name__c,Mother_Occupation__c,AP_Year_of_beginning__c,
                Do_you_have_Google_login__c,Facebook_login_ID__c,Google_login_ID__c,Do_you_have_Facebook_login__c,Facilitator_Name__r.Working_Mode__c,      
                DisplayFacilitatorSection__c,Current_year__c,Internal_Status__c,(select name,Id,Year__c,Internal_Status__c,Application_Type__c,RPT_Financial_Year__c,
                RecordType.Name,createdDate from Applications__r ),RecordType.DeveloperName 
                FROM Contact WHERE RecordType.DeveloperName = 'Student' AND Facilitator_Name__c =:facilitatorId Order By CreatedDate desc];
    }
    
    /*@purpose     : Upload Profile Picture
* @param        : attachmentBody
* @param        : attachmentName- Student Profile Picture
* @param        : attparentId
* @param        : attachmentId
* @returnType   : string 
*/ 
    public static string uploadProfilePic(String attachmentBody,string attachmentName,string attparentId,String attachmentId){
        
        try{ 
            String profilePicName = Constants.STUDENT_PROFILE_PIC;
            
            if(attachmentBody != null) {
                Attachment att = getAttachment(attachmentId);
                String newBody = '';
                if(att.Body != null) {
                    newBody = EncodingUtil.base64Encode(att.Body);
                }
                newBody += attachmentBody;
                att.Body = EncodingUtil.base64Decode(newBody);
                if(attachmentId == null) {
                    att.Name        = profilePicName;
                    att.parentId    = attparentId;
                }
                upsert att;
                if(!String.isBlank(att.Id)){
                    try{
                        List<Attachment> attList = [Select Id from Attachment where parentId =: attparentId AND Name =:profilePicName
                                                    AND Id !=: att.Id];
                        delete attList;
                    }catch(Exception e){}
                }
                if(attparentId != null){                    
                    try{
                        List<Contact> con   = [Select id,Profile_Pic_Attachment_Id__c 
                                               from Contact where Id =:attparentId 
                                               AND Profile_Pic_Attachment_Id__c !=:att.Id]; 
                        if(con.size() > 0 ){
                            update new Contact(id=attparentId,Profile_Pic_Attachment_Id__c=att.Id);
                        }
                    }catch(Exception ex){}
                }
                return att.Id;
            } else {
                return 'Attachment body is blank.Please try again.';
            }
            
        }catch(Exception ex){
            HandleBusinessException.captureError('AP_Application_Helper', 'uploadProfilePic', ex);
            return ex.getMessage();             
        }
    }  
    
    Public static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }    
    
    /*@purpose      : View all students having internal status online matched and external status as In progress
*@param        : studentId
*@returnType   : List of Students
*/
    
    //field added in the query by sumit
    public static Contact viewStudentProfile(String contactId){
        string prelimRTypeId    = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 
        return [SELECT id,Xth_ExamBoard__c,X12th_ExamBoard__c,College_Type__c,Aadhar_number__c,Is_KYC_Verified__c,Name,firstname,lastname,MobilePhone,Birthdate,Email,phone,MailingAddress,DN_Organization__c,Student_ID__c,
                npe01__WorkPhone__c,npe01__WorkEmail__c,FFE_ID__c,X10th__c,X10th_Marks_Obtained__c,X10th_Maximum_Marks__c,College_Name__r.Name,
                X10th_Medium_Of_Instruction__c,X10th_Type__c,X10th_Year_Passed__c,X12th__c,X12th_Marks_Obtained__c,Profile_Pic_Attachment_Id__c,
                MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,X12th_Maximum_Marks__c,X12th_Medium_Of_Instruction__c,
                X12th_Type__c,X12th_Year_Passed__c,Branch_Stream__c,Branch_Other__c,College_City__c,College_Name__c,College_Other__c,Rejection_Reason__c,
                College_State__c,Type__c,Course__c,Entrance_Exam_Maximum_Marks__c,Entrance_Exam_Taken_In_Year__c,Entrance_Test_Marks__c,
                Entrance_Test_Name__c,Entrance_Test_Rank__c,Facilitator_Name__c,Facilitator_Name__r.Name,Father_Age__c,Father_Education__c,Father_Name__c,Internal_Status__c,
                Father_Occupation__c,Gender__c,Mother_Age__c,Mother_Education__c,Mother_Name__c,Mother_Occupation__c,AP_Year_of_beginning__c,
                Do_you_have_Google_login__c,Facebook_login_ID__c,Current_year__c,Google_login_ID__c,Do_you_have_Facebook_login__c,Facilitator_Name__r.Working_Mode__c,
                DisplayFacilitatorSection__c,RecordType.DeveloperName,Annual_Family_Income__c,IsPrelimProcessed__c,Other_Entrance_Test__c,
                What_is_your_ambition_in_life__c,Who_has_inspired_you_the_most_until_now__c,Tell_us_some_things_about_yourself__c,Describe_your_family_s_income__c,
                When_you_start_earning_how_you_help__c,Parent_Mobile__c,Parent_Phone__c,Semester1__c,Semester2__c,Semester3__c,Semester4__c,Semester5__c,Semester6__c,Semester7__c,Semester8__c,MBBS_Year_1__c,MBBS_Year_2__c,MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c,CTC__c,Designation__c,Company_Name__c,Location__c,Has_Mentor__c,Placement_Info__c,
                (SELECT Amount_Funded__c,Amount_Requested__c,Application_Site_URL__c,Application_Stage__c,
                 Course__c,toLabel(External_Status__c),Id,toLabel(Internal_Status__c),Name,RecordTypeId,CreatedDate,Application_Type__c,
                 Remaining_Fund__c,Course_Name__c,Student__c,Year__c,RecordType.DeveloperName,Has_student_provided_Justification__c,
                 Have_you_met_the_student_s_parent_s__c,Have_you_visited_the_student_s_house__c,Please_Comment_on_Parent_s_Backgroun__c,
                 Student_truly_deserves_a_scholarship__c,FacilitatorInputDone__c,Branch__c,College_Name__c,Receiving_Full_AICTE_OtherTution_Fee_Wa__c,
                 SchlrShp_FinancialAsst_Other_Than_FFE__c,If_Yes_How_much_Other_Source__c,Assistance_Source__c,If_Yes_How_much_AICTE_Fee_from_Govt__c,Requested_Books_Expenses__c,Requested_College_Fees__c,
                 Requested_Hostel_Mess_Expenses__c,Requested_Scholarship_Amount__c,Requested_Transportation_Expenses__c,Requested_Uniform_Expenses__c                 
                 FROM Applications__r) 
                FROM Contact WHERE  Id =:contactId]; 
        
    }
    
    public static List<Application__c> letterOfThanksForDonor(String contactId){
        return [SELECT id,name,RPT_Financial_Year__c,(SELECT  id,Name from attachments where Name like 'Letter of Thanks to Donors%') from Application__c where Student__c=:contactId order by CreatedDate];
    }
    
    
    /*@purpose     : Verify Student with Facilitator Comments
*@param        : studentId
*@returnType   : String
*/
    
    public static String facilitatorInbutByStudent(Application__c studentInfo){
        SavePoint sp  = Database.setSavepoint();
        try{
            studentInfo.Has_student_provided_Justification__c   = boolean.valueOf(studentInfo.Has_student_provided_Justification__c);
            studentInfo.Have_you_met_the_student_s_parent_s__c  = boolean.valueOf(studentInfo.Have_you_met_the_student_s_parent_s__c);
            studentInfo.Have_you_visited_the_student_s_house__c = boolean.valueOf(studentInfo.Have_you_visited_the_student_s_house__c);
            studentInfo.Student_truly_deserves_a_scholarship__c = boolean.valueOf(studentInfo.Student_truly_deserves_a_scholarship__c);
            studentInfo.FacilitatorInputDone__c                 = true;
            studentInfo.Internal_Status__c                      = Constants.VERIFIED_BY_FACILITATOR;
            update studentInfo;
            update new Contact(Id=studentInfo.Student__c,IsPrelimProcessed__c=true);
            //Utility.submitSobjectApprovalProcess(studentInfo.Id, UserInfo.getUserId(), Constants.APPLICATION_APPROVAL_NAME);
            return Constants.FACILITATOR_INPUT_MSG;  
            
        }catch(Exception ex){
            Database.rollback(sp);
            HandleBusinessException.captureError('AP_Application_Helper', 'facilitatorInbutByStudent', ex);            
            return Constants.ERROR_MSG;
        }
    }
    
    
    /*@purpose     : Verify Student with Facilitator Comments
*@param        : studentId
*@returnType   : String
*/    
    public static String verifyStudent(Application__c studentInfo){
        SavePoint sp  = Database.setSavepoint();
        try{
            studentInfo.Has_student_provided_Justification__c   = boolean.valueOf(studentInfo.Has_student_provided_Justification__c);
            studentInfo.Have_you_met_the_student_s_parent_s__c  = boolean.valueOf(studentInfo.Have_you_met_the_student_s_parent_s__c);
            studentInfo.Have_you_visited_the_student_s_house__c = boolean.valueOf(studentInfo.Have_you_visited_the_student_s_house__c);
            studentInfo.Student_truly_deserves_a_scholarship__c = boolean.valueOf(studentInfo.Student_truly_deserves_a_scholarship__c);
            studentInfo.Internal_Status__c                      = Constants.VERIFIED_BY_FACILITATOR;
            studentInfo.FacilitatorInputDone__c                 = true;
            studentInfo.Document_Verification_and_Attestation__c                  = true;
            update studentInfo;
            update new Contact(Id=studentInfo.Student__c,IsPrelimProcessed__c=true);
            //Utility.submitSobjectApprovalProcess(studentInfo.Id, UserInfo.getUserId(), Constants.APPLICATION_APPROVAL_NAME);
            return Constants.VERIFIED_BY_FAC;  
            
        }catch(Exception ex){
            Database.rollback(sp);
            HandleBusinessException.captureError('AP_Application_Helper', 'verifyStudent', ex);            
            return Constants.ERROR_MSG;
        }
    }
    
    /*@purpose     : Reject Student with Facilitator Comments
*@param        : studentId
*@returnType   : String
*/    
    public static String rejectStudent(Application__c studentInfo){
        SavePoint sp  = Database.setSavepoint();
        try{
            
            studentInfo.Has_student_provided_Justification__c   = boolean.valueOf(studentInfo.Has_student_provided_Justification__c);
            studentInfo.Have_you_met_the_student_s_parent_s__c  = boolean.valueOf(studentInfo.Have_you_met_the_student_s_parent_s__c);
            studentInfo.Have_you_visited_the_student_s_house__c = boolean.valueOf(studentInfo.Have_you_visited_the_student_s_house__c);
            studentInfo.Student_truly_deserves_a_scholarship__c = boolean.valueOf(studentInfo.Student_truly_deserves_a_scholarship__c);
            
            studentInfo.Internal_Status__c                      = Constants.REJECTED_BY_FACILITATOR;
            studentInfo.FacilitatorInputDone__c                 = true;
            update studentInfo;
            update new Contact(Id=studentInfo.Student__c,IsPrelimProcessed__c=true);
            return Constants.REJECTED_BY_FAC;
        }catch(Exception ex){
            Database.rollback(sp);
            HandleBusinessException.captureError('AP_Application_Helper', 'rejectStudent', ex);            
            return Constants.ERROR_MSG;
        }
        
    }  
    
    /*@purpose     : Renew Application for student
*@param        : application
*@returnType   : String
*/    
    public static String renewApplication(AP_Application_CTRL.RenewalWrapper rnwWrp){
        
        SavePoint sp  = Database.setSavepoint();
        try{
            Application__c applicationInfo              = rnwWrp.ScholarAppln;
            Contact studentInfo                         = rnwWrp.scholar;
            List<Application__c> existingAppls          = new List<Application__c>();
            string externalKey                          = applicationInfo.Student__c+'@@@'+applicationInfo.Year__c;
            existingAppls                               = [Select id from Application__c where ApplicationExternalKey__c=:externalKey];
            
            if(existingAppls.size() == 0){
                //applicationInfo.Internal_Status__c          = Constants.VERIFIED_BY_FACILITATOR;
                applicationInfo.Internal_Status__c          = 'Incomplete';
                applicationInfo.External_Status__c          = Constants.INPROGRESS_APPLICATION;
                applicationInfo.Application_Stage__c        = Constants.ACTIVE_APPLICATION;
                applicationInfo.RecordTypeId                = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_RENEWAL_APPLICATION).getRecordTypeId(); 
                applicationInfo.ApplicationExternalKey__c   = externalKey;
                
                update studentInfo;
                insert applicationInfo;
                
                return Constants.RENEWAL_APPLN_SUCCESS_MSG;
            }else{
                return Constants.EXISTNG_APPLN_ERR_MSG;
            }           
        }
        catch(Exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'renewApplication', e);
            database.rollback(sp);
            system.debug('exception'+e.getMessage());
            return Constants.ERROR_MSG;
            
        }
    }  
    
    /*@purpose     : Check for Renewal Application Period
*@returnType  : boolean
*/
    public static boolean displayRenewalApp(){
        System_Details__c sysm  = System_Details__c.getInstance();
        
        if(System.today()  >= sysm.Renewal_Application_Opening_Date__c
           && System.today() <=sysm.Renewal_Application_Close_Date__c){
               return true;
           }else{
               return false;
           }   
        
    }
    
    
    
    
    /*@purpose      : Upsert Attachment file
* @param        : attachmentBody
* @param        : attachmentName
* @param        : attparentId
* @param        : attachmentId
* @returnType   : string 
*/ 
    public static string uploadAttachment_new(String expenseDet,String studentId,String certificateExpDate,String attachmentBody,string attachmentName,string attparentId,String attachmentId,string description){
        if(String.isNotBlank(certificateExpDate))
        {
            
            
            Contact objStu   =  new  Contact ();
            try{
                objStu.Id                   = studentId;
                objStu.Certificate_Expiry_Date__c    = date.valueOf(certificateExpDate);
                update objStu;
            }catch(Exception e){
                HandleBusinessException.captureError('AP_Application_Helper', 'documentUploaded', e);
            }
            
        }
        if(String.isNotBlank(expenseDet))
        {
            
            
            Application__c  objApp  =  new  Application__c  ();
            try{
                objApp.Id                   = attparentId;
                objApp.Student_Hostel_Mess_Expenses__c = Decimal.ValueOf(expenseDet.split(';')[0]);
                objApp.Student_Transportation_Expenses__c = Decimal.ValueOf(expenseDet.split(';')[1]);
                objApp.Student_College_Fees__c = Decimal.ValueOf(expenseDet.split(';')[2]);
                objApp.Student_Books_Expenses__c = Decimal.ValueOf(expenseDet.split(';')[3]);
                objApp.Student_Uniform_Expenses__c = Decimal.ValueOf(expenseDet.split(';')[4]);
                update objApp;
            }catch(Exception e){
                HandleBusinessException.captureError('AP_Application_Helper', 'documentUploaded', e);
            }
            
        }
        return uploadAttachment(attachmentBody,attachmentName,attparentId,attachmentId,description);
    }
    public static string uploadAttachment(String attachmentBody,string attachmentName,string attparentId,String attachmentId,string description){
        
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
                    att.Name        = attachmentName;
                    att.parentId    = attparentId;
                    att.Description = description;
                }
                upsert att;
                /* if(!String.isBlank(att.Id)){
try{
List<Attachment> attList = [Select Id from Attachment where parentId =: attparentId AND Id !=: att.Id];
delete attList;
}catch(Exception e){}
}*/
                return att.Id;
            } else {
                return 'Attachment body is blank.Please try again.';
            }
            
        }catch(Exception ex){
            HandleBusinessException.captureError('AP_Application_Helper', 'uploadAttachment', ex);
            return ex.getMessage();             
        }
    }
    
        public static void updateDocMissing(String appId, String fileName) {
        System.debug(appId+'---'+fileName);
        if(String.isBlank(appId) || String.isBlank(fileName))
            return;
        
        fileName = fileName.substringBeforeLast('.');
        Application__c app = [SELECT Id, Missing_Documents__c, Comment_s_for_Student__c FROM Application__c WHERE Id = :appId];
        if(app != null && !String.isBlank(app.Comment_s_for_Student__c)) {
            List<String> missingDocsList = app.Missing_Documents__c.split(';');
            if(!missingDocsList.isEmpty()) {
                String updatedDocComment = '';
                Integer i = 1;
                for(String doc : missingDocsList) {
                    if(!doc.containsIgnoreCase(fileName)) {
                        updatedDocComment += ' ' +i+ '. ' +doc+ '\n';
                        i++;
                    }
                }
                System.debug('---'+updatedDocComment);
                String currentRemarks = app.Comment_s_for_Student__c.substringAfter('Remarks:');
                app.Comment_s_for_Student__c = 'Document Name(s) :'+'\n'+ updatedDocComment + '\n' + 'Remarks: '+ (!String.isBlank(currentRemarks) ? currentRemarks : '');
                System.debug('---'+app.Comment_s_for_Student__c);
                update app;
            }
        }
    }
    
    public static List<Attachment> getAllAttachments(string parentId, string documentFor){
        return [Select id, Name,CreatedDate,Description from Attachment 
                where ParentId =:parentId AND Description =:documentFor order by CreatedDate];
    }
    
    
    /*
* Get List of Cities for the Inidian State
*/ 
    public Static List<State_City_Master__c> getAllCities(String currentState) {         
        return [select City__c from State_City_Master__c 
                where State__c=:currentState AND Country__c=:Constants.COUNTRY_IND
                Order By City__c LIMIT 40000];                
    }
    /*
* Get max marks for the selected board
*/ 
    public Static String getBoardMaxMarks(String examBoard) {         
        return String.valueOf([select FFE_Max_Marks_Out_of__c  from FFE_Exam_Board_Detail__mdt  
                               where MasterLabel =:examBoard LIMIT 1].FFE_Max_Marks_Out_of__c);                
    }
    
    /*
* Get all attachments List required for Pre-lim form
*/
    public static List<PrelimForm_Attachment__mdt> getPrelimFiles(){
        return [Select id,Attachment_Name__c,IsMandatory__c,MasterLabel from PrelimForm_Attachment__mdt order by MasterLabel];        
    }
    
    /*
* Get all attachments List required for Renewal form
*/
    public static List<Renewal_Form_Attachments__mdt> getRenewalFiles(){
        return [Select id,Attachment_Name__c,IsMandatory__c,MasterLabel from Renewal_Form_Attachments__mdt order by MasterLabel];        
    }
    
    /*
* Update Application External Status once missing documents uploaded
*/ 
    
    public static Application__c documentUploaded(string appId){
        Application__c ap   =  new  Application__c ();
        try{
            ap.Id                   = appId;
            ap.External_Status__c   = Constants.DOCUMENT_UPLOADED;
            ap.Internal_Status__c  = 'Pending FFE Staff Review';
            ap.Missing_Documents__c = '';
            update ap;
            return ap;
        }catch(Exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'documentUploaded', e);
            return ap;
        }
    }
    
    
    public static String applicationExpenseUpdate(AP_Application_CTRL.RenewalWrapper rnwWrp){
        try{
            
            update rnwWrp.ScholarAppln;
            update rnwWrp.scholar;
            //update app;
            return Constants.APPLICATION_SUCESS_MSG;  
        }catch(Exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'applicationExpenseUpdate', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    
    
    /*
*@purpose    : Get list of all AcademicDetails from Custom metadata type "Academic_Detail__mdt"
* @returnType  :List<Academic_Detail__mdt>
*/
    public static List<Academic_Detail__mdt> getAcademicDetails(){
        return [Select Id,Course__c,Year__c,Semester__c from Academic_Detail__mdt];
        
    }
    
    public static Set<String> semesterData(List<Academic_Detail__mdt> academicDetails,String course,String currentYear){
        Set<String> semsterString = new Set<String>();
        if(currentYear != '1st Year'){
            for(Academic_Detail__mdt academicDetail : academicDetails){
                if(academicDetail.Course__c == course && academicDetail.Year__c == currentYear){
                    semsterString.addAll((academicDetail.Semester__c.trim()).split(','));
                }
            }
        }
        return semsterString;
    }
    
    
    
    /*
* Purpose : Get training master information from studentTrainingMapping
* Parameters : Course and Year in which studying
* Returntype: Training_Master__c
*/ 
    public static set<Student_Training__c> getAllTrainings(string course, string yearInWhichStudying,integer aptitudeAnlyticalScore,integer AptitudeLogicalScore,Integer EnglishSpokenScore,Integer EnglishWrittenScore,String studentID){
        SavePoint sp  = Database.setSavepoint();
        try{
            if(yearInWhichStudying == Constants.THIRD_YEAR_PART_1 || yearInWhichStudying == Constants.THIRD_YEAR_PART_2)
                yearInWhichStudying = Constants.THIRD_YEAR;
            
            set<Student_Training__c> studentTrainingMappingSet       = new set<Student_Training__c>();
            Map<String,set<String>> studentTrainingMap                       = new Map<String,set<String>>();
            for(Student_Training__c st : [SELECT id,name,Conclusion__c,External_ID__c,Points_Earned__c,Student_ID__c,Training_Code__c,Training_Code__r.Course__c,Training_Code__r.Student_Years__c,Training_Code__r.name,Training_Code__r.Start_Month__c,Training_Code__r.Training_Type__c,Training_Code__r.End_Month__c,Training_Code__r.Points__c,(SELECT id,Vendor_Code__c,Time_on_App__c,Milestone__c,Marks_Obtained__c,Completion_Flag__c FROM Training_Results__r) FROM Student_Training__c WHERE Student_ID__c=:studentID AND Training_Code__r.Course__c includes (:course) AND Training_Code__r.Student_Years__c includes (:yearInWhichStudying)]){
                
                
                if(!studentTrainingMap.containsKey(st.Student_ID__c)){
                    studentTrainingMap.put(st.Student_ID__c,new set<String>{st.Training_Code__c});//
                }
                else{   
                    studentTrainingMap.get(st.Student_ID__c).add(st.Training_Code__c);
                }
                if((st.Training_Code__r.Training_Type__c == Constants.Aptitude && (aptitudeAnlyticalScore< Utility.getTrainingDetails().Min_Aptitude_Analytical_Score__c || AptitudeLogicalScore < Utility.getTrainingDetails().Min_Aptitude_Logical_Score__c)) 
                   || (st.Training_Code__r.Training_Type__c == Constants.English && (EnglishSpokenScore< Utility.getTrainingDetails().Min_English_Spoken_Score__c || EnglishWrittenScore < Utility.getTrainingDetails().Min_English_Wriitten_Score__c)) 
                   || st.Training_Code__r.Training_Type__c == Constants.All){
                       studentTrainingMappingSet.add(st);
                   }
            }
            
            /*
List<Student_Training__c> studentTrainingMappingSetForAll = new List<Student_Training__c>();
set<String> trainingIds                                   = new set<String>();

for(Training_Master__c training : [SELECT id,name,Course__c,End_Month__c,Amcat_dependence_check__c,Training_Type__c,For_Whom__c,IsMandatory__c,Milestone_1__c,Milestone_2__c,Milestone_3__c,Min_Marks__c,Min_Time_on_App_20__c,Min_Time_on_App_30__c,Min_Time_on_App_50__c,Points__c,Start_Month__c,Student_Course_Type__c,Student_Years__c,Time_Frame__c,Total_marks__c,Total_Points__c,Year_in_which_studying__c from Training_Master__c where Course__c includes (:course) AND Student_Years__c includes (:yearInWhichStudying) AND Training_Type__c=:'All']){

Student_Training__c st  = new Student_Training__c(Student_ID__c = studentID,Training_Code__c = training.Id,External_ID__c='FFEID'+'-'+training.Name);
studentTrainingMappingSetForAll.add(st);
trainingIds.add(st.Training_Code__c);

}

if(!studentTrainingMappingSetForAll.isEmpty())
insert studentTrainingMappingSetForAll; // inserting studentTrainingMapping records to get data for printing on a page

set<id> stForAllId = new set<id>();
for(Student_Training__c std :studentTrainingMappingSetForAll){
stForAllId.add(std.id);
}

for(Student_Training__c st : [SELECT id,name,Conclusion__c,External_ID__c,Training_Code__r.Training_Type__c,Points_Earned__c,Student_ID__c,Training_Code__c,Training_Code__r.Course__c,Training_Code__r.Student_Years__c,Training_Code__r.name,Training_Code__r.Start_Month__c,Training_Code__r.End_Month__c,Training_Code__r.Points__c,(SELECT id,Vendor_Code__c,Time_on_App__c,Milestone__c,Marks_Obtained__c,Completion_Flag__c FROM Training_Results__r) FROM Student_Training__c WHERE Student_ID__c=:studentID AND Training_Code__r.Course__c includes (:course) AND Training_Code__r.Student_Years__c includes (:yearInWhichStudying) AND Training_Code__c=:trainingIds AND id=:stForAllId]){

if(st.Training_Code__r.Training_Type__c==Constants.All && !studentTrainingMap.get(st.Student_ID__c).contains(st.Training_Code__c)){

studentTrainingMappingSet.add(st);
}
}

if(!studentTrainingMappingSetForAll.isEmpty())
delete studentTrainingMappingSetForAll; // deleting studentTrainingMapping records of available for all which was created in current context
*/
            return studentTrainingMappingSet;
        }catch(Exception ex){
            Database.rollback(sp);
            HandleBusinessException.captureError('AP_Application_Helper', 'getAllTrainings', ex);            
            return null;
        }
    }
    
    
    public static string submitPlacementInfo(PlacementWrp studentInformation){
        try{
            update new contact(id=studentInformation.id,CTC__c=String.valueOf(studentInformation.CTC),Designation__c=studentInformation.Designation,Company_Name__c=studentInformation.CompanyName,Location__c=studentInformation.Location);
            return 'Placement details updated successfully';
        }catch(exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'updateStudentInSFDC', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    
    public static string submitOtherInfo(String stdId,String otherText){
        try{
            update new contact(id=stdId,Other__c=otherText);
            return 'Details updated successfully';
        }catch(exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'updateStudentInSFDC', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    
    public static string savePlacementInfo(String stdId,String placementinfo){
        try{
            
            Contact con = new contact();
            con.id = stdId;
            con.Placement_Info__c=placementinfo;
            if(placementinfo != 'Placed'){
                con.CTC__c='';
                con.Designation__c='';
                con.Company_Name__c='';
                con.Location__c='';
            }   
            if(placementinfo != 'Others' && placementinfo != 'Seeking Entreprenuership' && placementinfo != 'Seeking Govt. Jobs' && placementinfo != 'Higher Studies'){
                con.Other__c = '';
            }
            update con;
            return 'Details updated successfully';
        }catch(exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'updateStudentInSFDC', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG;
        }
    }
    
    public static String submitFinalYearMarksDetails(Contact con){
        try{
            update new contact(id=con.id,Semester1__c =con.Semester1__c,Semester2__c =con.Semester2__c,Semester3__c =con.Semester3__c,
                               Semester4__c =con.Semester4__c,Semester5__c =con.Semester5__c,Semester6__c =con.Semester6__c,Semester7__c =con.Semester7__c,
                               Semester8__c =con.Semester8__c,Semester9__c =con.Semester9__c,Semester10__c =con.Semester10__c,MBBS_Year_1__c = con.MBBS_Year_1__c,
                               MBBS_Year_2__c = con.MBBS_Year_2__c,MBBS_Year_3_Part_1__c = con.MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c = con.MBBS_Year_3_Part_2__c);
            
            return 'Academic scores updated successfully';
        }Catch(Exception e){
            HandleBusinessException.captureError('AP_Application_Helper', 'submitFinalYearMarksDetails', e);
            system.debug(e.getMessage());
            return Constants.ERROR_MSG; 
        }
    }
}