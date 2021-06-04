public class ApplicationStudentInfoController {
    
    public Contact student{get;set;}
    public List<Application__c> appList{get;set;}
    
    public ApplicationStudentInfoController() {
        
        appList = new List<Application__c>(); 
        String studentId = ApexPages.currentPage().getParameters().get('ScholarId');
        student       = new Contact();
        student = getScholarUserDetail(studentId);
        if(!student.Applications__r.isEmpty()){
            for(Application__c a : student.Applications__r){ 
                if(a.RecordType.DeveloperName == Constants.SCHOLARSHIP_APPLICATION_DN){
                    appList.add(a);
                }
            }
        }
    }
    
    /*@purpose      : Get current guest user info
*@param         : contactId
*@returnType    : Contact
*/
    //added a field to query by sumit
    public static Contact getScholarUserDetail(String  contactId){
        return [SELECT id,Name,Xth_ExamBoard__c,X12th_ExamBoard__c,firstname,Aadhar_number__c,lastname,MobilePhone,Birthdate,Email,phone,MailingAddress,DN_Organization__c,Student_ID__c,Internal_Status__c,
                npe01__WorkPhone__c,npe01__WorkEmail__c,FFE_ID__c,X10th__c,X10th_Marks_Obtained__c,X10th_Maximum_Marks__c,Active_Application_ID__c,
                X10th_Medium_Of_Instruction__c,X10th_Type__c,X10th_Year_Passed__c,X12th__c,X12th_Marks_Obtained__c,Profile_Pic_Attachment_Id__c,
                MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,X12th_Maximum_Marks__c,X12th_Medium_Of_Instruction__c,
                X12th_Type__c,X12th_Year_Passed__c,Branch_Stream__c,Branch_Other__c,College_City__c,College_Name__c,College_Other__c,Rejection_Reason__c,
                College_State__c,Type__c,Course__c,toLabel(Current_year__c),Other_Entrance_Test__c,Entrance_Exam_Maximum_Marks__c,Entrance_Exam_Taken_In_Year__c,Entrance_Test_Marks__c,College_Name__r.Name,
                Entrance_Test_Name__c,Entrance_Test_Rank__c,Facilitator_Name__c,Facilitator_Name__r.Name,Father_Age__c,Father_Education__c,Father_Name__c,Annual_Family_Income__c,
                Facilitator_Name__r.FFE_ID__c,Facilitator_Name__r.MailingCity,Facilitator_Name__r.MailingStreet,Facilitator_Name__r.MailingPostalCode,Facilitator_Name__r.MailingCountry,
                Facilitator_Name__r.MobilePhone,Facilitator_Name__r.MailingState,
                Father_Occupation__c,Gender__c,Mother_Age__c,Mother_Education__c,Mother_Name__c,Mother_Occupation__c,AP_Year_of_beginning__c,DisplayFacilitatorSection__c,
                Do_you_have_Google_login__c,Facebook_login_ID__c,Google_login_ID__c,Do_you_have_Facebook_login__c,Facilitator_Name__r.Working_Mode__c,
                Bank_Account_Holder_s_Name__c,Bank_Branch_Phone_No__c,Bank_City__c,Bank_Name__c,Bank_Pincode__c,Bank_State__c,Full_Bank_Account_No_With_all_digits__c,
                X11_character_IFSC_Code_of_the_Branch__c,RecordType.DeveloperName,Branch_Address__c,ScholarshipAmount__c,IsPrelimProcessed__c,
                What_is_your_ambition_in_life__c,Who_has_inspired_you_the_most_until_now__c,Tell_us_some_things_about_yourself__c,Describe_your_family_s_income__c,
                When_you_start_earning_how_you_help__c,Parent_Mobile__c,Parent_Phone__c,
                (SELECT Amount_Funded__c,Amount_Requested__c,Application_Stage__c,Application_Type__c,Course_Name__c,Branch__c,
                 Course__c,External_Status__c,Id,Internal_Status__c,Name,RecordTypeId,FacilitatorInputDone__c,College_Name__c,
                 Remaining_Fund__c,Student__c,Year__c,Receiving_Full_AICTE_OtherTution_Fee_Wa__c,Requested_Books_Expenses__c,Requested_College_Fees__c,Requested_Hostel_Mess_Expenses__c,Student_College_Fees__c,Student_Hostel_Mess_Expenses__c,Student_Books_Expenses__c,Student_Transportation_Expenses__c,Student_Uniform_Expenses__c,Requested_Scholarship_Amount__c,Requested_Transportation_Expenses__c,Requested_Uniform_Expenses__c,
                 SchlrShp_FinancialAsst_Other_Than_FFE__c,Has_student_provided_Justification__c,Have_you_met_the_student_s_parent_s__c,Have_you_visited_the_student_s_house__c,Student_truly_deserves_a_scholarship__c,Please_Comment_on_Parent_s_Backgroun__c,If_Yes_How_much_Other_Source__c,Student_Scholarship_Amount__c,Assistance_Source__c,RecordType.DeveloperName,If_Yes_How_much_AICTE_Fee_from_Govt__c FROM Applications__r where Application_Stage__c=:Constants.ACTIVE_APPLICATION and RecordType.DeveloperName=:Constants.SCHOLARSHIP_APPLICATION_DN) FROM Contact WHERE  Id =:contactId];
        
    }
}