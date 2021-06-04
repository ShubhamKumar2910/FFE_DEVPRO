/*
* @Purpose      : DonorProfilepage Implementation.
* @Author       : Amritesh
*/

public class DN_Donorprofile_Helper {
  
    /*
    *@purpose       : Displaying  donor information on the donor profilepage based on donorId
    *@param         : donorId
    *@returnType    : Contact
    */
    public static Contact displayDonorDetails(String  donorId){
        return [SELECT id,Name,firstname,lastname,MobilePhone,LIV_ID__c,Email,phone,MailingAddress,DN_Organization__c,Aadhar_number__c,
                toLabel(DN_Citizenship__c),DN_Passport_Number__c,npe01__WorkPhone__c,npe01__WorkEmail__c,FFE_ID__c,
                DN_PAN__c,DN_FFE_Scholar_ID__c,DN_Year_Of_Graduation__c,DN_Special_Request_Comments__c,
                MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,toLabel(DN_Donor_Category__c),
                Do_you_have_Google_login__c,Facebook_login_ID__c,Google_login_ID__c,Do_you_have_Facebook_login__c, 
                IsPassportUploaded__c,Passport_file__c FROM Contact WHERE  Id =:donorId];        
    }
    //Added donorId as one additional parameter based to show attachments 
    public static List<Attachment> getAllAttachmentsForDonorView(string parentId,String  donorId, string documentFor){
        
        List<Attachment> Attachmentshow = new List<Attachment>();
        if(!String.IsBlank(parentId) && !String.IsBlank(donorId)){
            /* Commented the below block of code as it is no more in use  -- Sumit Gaurav 21-05-2020  
            Application__c app = [Select Id,Student__c From Application__c where Id =:parentId];
            // List<Application__c> listApps = [Select Id From Application__c where Student__c =: parentId order by createddate desc];
            List<Application__c> listApps = [Select Id From Application__c where Student__c =: app.Student__c order by createddate desc];
            List<Id> listIds = new List<Id>();
            for(Application__c objApp: listApps){
                listIds.add(objApp.Id);
            } */
            //change the instance variable from StudentRecord to donorRecord -- Sumit Gaurav 21-05-2020
            Contact donorRecord = [Select Id,name,Letter_of_Thanks_to_Donors__c,Oath_Pledge_and_Declaration_Form_signed__c,Odd_Semester_Mark_Sheet_of_the_previous__c,Even_Semester_Mark_Sheet_of_the_previous__c,Entrance_Test_Marks_Rank_Certificate__c,Parents_or_Guardians_Declaration__c,PUC_12th_Marks_Sheet__c,Bonafide_Student_Certificate__c,Admission_or_Seat_Allotment_Letter__c,Copy_of_First_Sheet_of_Bank_Pass_Book__c,Income_Salary_Certificate__c,Statement_of_Estimated_Expenses_for_FY__c,Receipts_for_Actual_Expenses__c, Applicant_s_Pledge_of_Future_Support__c,Marks_Sheet_for_10th_Standard__c from contact where id =:donorId];
            system.debug('donorRecord====='+donorRecord);
            /*List<Attachment> Attachmentlist = [Select id, Name,CreatedDate,Description from Attachment 
                    where ParentId =:listIds[0] AND Description =:documentFor And (Not Name Like 'Letter of Thanks to Donors%') order by CreatedDate];*/
                    
            /*List<Attachment> Attachmentlist = [Select id, Name,CreatedDate,Description from Attachment 
                    where ParentId =:parentId AND Description =:documentFor And (Not Name Like 'Letter of Thanks to Donors%') order by CreatedDate];*/
                    List<Attachment> Attachmentlist = [Select id, Name,CreatedDate,Description from Attachment 
                    where ParentId =:parentId AND Description =:documentFor order by CreatedDate];
                    system.debug('Attachmentlist====='+Attachmentlist);
            for(Attachment A : Attachmentlist){
                //if(A.Name == 'Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform).pdf'){
                //Added checks based on contains with the keywords for each type of documents -- Sumit Gaurav - 15-July-2020
                if(A.Name.contains('Receipts for Actual Expenses')){
                    if(donorRecord.Receipts_for_Actual_Expenses__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Pledge') || A.Name.contains('Oath')){
                    if(donorRecord.Applicant_s_Pledge_of_Future_Support__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Secondary School Certificate')){
                    if(donorRecord.Marks_Sheet_for_10th_Standard__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Income Certificate')){
                    if(donorRecord.Income_Salary_Certificate__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Statement of Estimated Expenses')){
                    if(donorRecord.Statement_of_Estimated_Expenses_for_FY__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Copy of First Sheet')){
                    if(donorRecord.Copy_of_First_Sheet_of_Bank_Pass_Book__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Counselling')){
                    if(donorRecord.Admission_or_Seat_Allotment_Letter__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Bonafide')){
                    if(donorRecord.Bonafide_Student_Certificate__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Higher Secondary')){
                    if(donorRecord.PUC_12th_Marks_Sheet__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Parent') || A.Name.contains('Guardian')){
                    if(donorRecord.Parents_or_Guardians_Declaration__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Rank Certificate')){
                    if(donorRecord.Entrance_Test_Marks_Rank_Certificate__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Even Semester Mark Sheet')){
                    if(donorRecord.Even_Semester_Mark_Sheet_of_the_previous__c == true){
                        Attachmentshow.add(A);
                    }
                }
                else if(A.Name.contains('Odd Semester Mark Sheet')){
                    if(donorRecord.Odd_Semester_Mark_Sheet_of_the_previous__c == true){
                        Attachmentshow.add(A);
                    }
                }
                /* if(A.Name.contains('Pledge and Declaration')){
                    if(donorRecord.Oath_Pledge_and_Declaration_Form_signed__c == true){
                        Attachmentshow.add(A);
                    }
                } */
                else if(A.Name.contains('Letter of Thanks')){
                //  if(StudentRecord.Letter_of_Thanks_to_Donors__c == true){
                        Attachmentshow.add(A);
                //S }
                }
                else if(A.Name.containsIgnoreCase('Declaration Form')){
                //  if(StudentRecord.Letter_of_Thanks_to_Donors__c == true){
                        Attachmentshow.add(A);
                //S }
                }
                system.debug('Attachmentshow=='+Attachmentshow);
            }
        }
        return Attachmentshow;
        /*return [Select id, Name,CreatedDate,Description from Attachment 
                where ParentId =:listIds[0] AND Description =:documentFor And (Not Name Like 'Letter of Thanks to Donors%') order by CreatedDate];*/
            
        }
    
    /*@purpose      : Getting theDonor update information from the Donor profile page  
    *@param        : donorInfo
    *@returnType   : String
    */
    public Static String updateDonorInSFDC(Contact donorInfo){ 
        try{
            donorInfo.Do_you_have_Google_login__c    = Boolean.valueOf(donorInfo.Do_you_have_Google_login__c);
            donorInfo.Do_you_have_Facebook_login__c  = Boolean.valueOf(donorInfo.Do_you_have_Facebook_login__c);
            
             if(donorInfo.MobilePhone != null && donorInfo.MobilePhone != '' &&
                DN_DonorRegistration_Helper.checkDupForMobile(donorInfo.MobilePhone,String.valueOf(donorInfo.Id),constants.FFE_Donor_Donor).size() > 0){
                return Constants.MOBILE_DUPLICATE_ERR_MSG;
            }
           if(donorInfo.Aadhar_number__c != null && donorInfo.Aadhar_number__c != ''
               && DN_DonorRegistration_Helper.checkDupForAadhar(donorInfo.Aadhar_number__c,String.valueOf(donorInfo.Id),constants.FFE_Donor_Donor).size() > 0){
                return Constants.Aadhaar_error_message_donorRegstr_page;
            }
            if(donorInfo.Email != null && donorInfo.Email != ''
               && DN_DonorRegistration_Helper.checkDupForEmail(donorInfo.Email,String.valueOf(donorInfo.Id),constants.FFE_Donor_Donor).size() > 0){
                return Constants.EMAIL_DUPLICATE_ERR_MSG;
            }
            if(donorInfo.Google_login_ID__c != null && donorInfo.Google_login_ID__c != ''
               && DN_DonorRegistration_Helper.checkDupForEmail(donorInfo.Google_login_ID__c,String.valueOf(donorInfo.Id),constants.FFE_Donor_Donor).size() > 0){
                return Constants.EMAIL_DUPLICATE_ERR_MSG;
            }
            if(donorInfo.Facebook_login_ID__c != null && donorInfo.Facebook_login_ID__c != ''
               && DN_DonorRegistration_Helper.checkDupForEmail(donorInfo.Facebook_login_ID__c,String.valueOf(donorInfo.Id),constants.FFE_Donor_Donor).size() > 0){
                return Constants.EMAIL_DUPLICATE_ERR_MSG;
            }

            upsert donorInfo;
            return DN_ServiceConstants.DONOR_INFO_UPDATED;
        }catch(exception e){
            system.debug(e.getMessage());
            HandleBusinessException.captureError('DN_Donorprofile_Helper', 'updateDonorInSFDC', e);
            return Constants.ERROR_MSG;
        }
    }
    
    /*@purpose     : Get Logged in donor's donation(Opportunity) record
    * @param       : donorId
    * @returnType  : List<Opportunity>
    */
    public static List<Opportunity>  displayDonorDonationDetails(String  donorId){
        List<Opportunity> donationList  = new List<Opportunity>();
        
        Id donationRTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(DN_ServiceConstants.GENERAL_DONATION).getRecordTypeId(); 
        donationList        = [select id,CloseDate,Payment_Order__c,Amount,Program_Frequency__c,Program_Frequency__r.Amount__c,
                               Program_Frequency__r.Name,Program_Frequency__r.Program__r.Program__c,npsp__Primary_Contact__c,
                               npsp__Primary_Contact__r.npe01__WorkEmail__c,No_of_Student__c,Payment_Order__r.CCAvenue_Payment_Status__c,
                               Payment_Order__r.Transaction_Date__c,Payment_Order__r.Order_No__c,Payment_Status__c,Amount_USD__c,Currency__c
                               from Opportunity where npsp__Primary_Contact__c=:donorId AND recordtype.Id=:donationRTypeId 
                               AND Payment_Order__c != null order by Payment_Order__r.Transaction_Date__c desc LIMIT 2000];
        
        return donationList;
    }
    
    
    /*
    * @purpose     : Get Logged in donor's Pledged Donation
    * @param       : donorId
    * @returnType  : List<Opportunity>
    */
    public static List<Opportunity>  getDonorPledgedDonation(String  donorId){
        List<Opportunity> donationList  = new List<Opportunity>();
        
        Id donationRTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(DN_ServiceConstants.GENERAL_DONATION).getRecordTypeId(); 
        donationList        = [select id,CloseDate,Amount,Name,npsp__Primary_Contact__c,npe03__Recurring_Donation__c,npe03__Recurring_Donation__r.Currency__c,
                               npsp__Primary_Contact__r.npe01__WorkEmail__c,No_of_Student__c,npe03__Recurring_Donation__r.Program_Frequency__c,
                               Payment_Status__c,Amount_USD__c,Currency__c,npe03__Recurring_Donation__r.Program_Frequency__r.Name,
                               npe03__Recurring_Donation__r.Program_Frequency__r.Program__r.Program__c,npe03__Recurring_Donation__r.No_of_Student__c,
                               npsp__Recurring_Donation_Installment_Name__c,npsp__Recurring_Donation_Installment_Number__c
                               from Opportunity where npsp__Primary_Contact__c=:donorId 
                               AND recordtype.Id=:donationRTypeId AND Payment_Order__c = null AND CloseDate > :System.TODAY()
                               AND npe03__Recurring_Donation__c !=null order by CloseDate asc LIMIT 2000];        
        return donationList;
    }
    
    
    /*@purpose      : Displaying DonorDonation programDetails
    * @returnType   : List<Donation_Program__c>
    */
    public static List<Donation_Program__c> getDonorDonationProgramDetails(String currencyType){
        return [Select id,only_1_frequency__c,Description__c,Program__c,Display_for_Scholar__c,
                (select id,Name,Frequency__c,Amount__c,Installment_Period__c, 
                 Installments__c,Program__c,Program__r.Program__c,Currency__c,
                 Minimum_Amount__c,Amount_Fixed__c
                 from Program_Frequencys__r where Currency__c=:currencyType
                 order by Order_of_display__c asc) 
                from Donation_Program__c 
                where Display_On_Portal__c = true AND Approval_Status__c =: Constants.APPROVED_STATUS
                order by Portal_display_Order__c asc];        
    }

    /**
     * @desc : added to meet new quickdonation UI.
     */
    public static Map<String,List<Donation_Program__c>> getDonationsPerProgram(String currencyType){
        Map<String,List<Donation_Program__c>> programLabelToDonationsMap	= new Map<String,List<Donation_Program__c>>();
        
        List<Donation_Program__c> programList = [SELECT id,Name,only_1_frequency__c,Description__c,Program__c,Display_for_Scholar__c,Resource_Image__c,
                                          (SELECT id,Name,Frequency__c,Amount__c,Installment_Period__c, 
                                           Installments__c,Program__c,Program__r.Program__c,Currency__c,
                                           Minimum_Amount__c,Amount_Fixed__c
                                           FROM Program_Frequencys__r WHERE Display_On_Portal__c = true AND Currency__c=:currencyType
                                           ORDER BY Order_of_display__c asc) 
                                          FROM Donation_Program__c 
                                          WHERE Display_On_Portal__c = true AND Approval_Status__c =: Constants.APPROVED_STATUS
                                          ORDER BY Portal_display_Order__c asc]; 
        
        for(Donation_Program__c donation : programList){            
            if(programLabelToDonationsMap.containsKey(donation.Program__c)) {
                programLabelToDonationsMap.get(donation.Program__c).add(donation);
            }else {
                programLabelToDonationsMap.put(donation.Program__c, new List<Donation_Program__c> {donation});
            }

        }
        return programLabelToDonationsMap; 
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
            HandleBusinessException.captureError('DN_Donorprofile_Helper', 'uploadAttachment', ex);
            return ex.getMessage();             
        }
    }
    
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
    
    public static List<Application__c> getDonorScholars(string donorId,String Year){
        
        Id StudentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        Id DonorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();

        String currentFinancialYear = '';
        if(Year == null || Year==''){
        currentFinancialYear = Utility.financialYear();
        }else{
        currentFinancialYear = Year;    
        }
        
        List<Application__c> app = [SELECT id,Student__r.Name,Student__r.Financial_year__c,Student__r.Gender__c,Student__r.MailingCity,Student__r.Current_year__c,Student__r.Is_Active_Alumni__c,Student__r.MailingState,Student__r.Course__c,Student__r.College_Name__r.Name,Student__r.Branch_Stream__c,Student__r.Semester7__c,Student__r.Semester8__c,Student__r.Semester9__c,Student__r.Semester10__c,Student__r.MBBS_Year_3_Part_1__c,Student__r.MBBS_Year_3_Part_2__c,Student__r.Placement_Info__c,Student__r.Company_Name__c,Student__r.CTC__c,Student__r.Designation__c,Student__r.Location__c From Application__c where Student__c IN (Select Student__c from Donor_Application_Mapping__c where Donor__c=:donorID AND Financial_Year__c=:currentFinancialYear) Order by Name ASC];
        system.debug('@@ '+app);
        
        
        List<Application__c> studentlist = [SELECT Student__r.Id,Student__r.Financial_year__c,id,Student__r.Name,Student__r.Gender__c,Student__r.MailingCity,Year__c,Student__r.Current_year__c,Student__r.Is_Active_Alumni__c,Student__r.MailingState,Student__r.Course__c,Student__r.College_Name__r.Name,Student__r.Branch_Stream__c,Student__r.Semester7__c,Student__r.Semester8__c,Student__r.Semester9__c,Student__r.Semester10__c,Student__r.MBBS_Year_3_Part_1__c,Student__r.MBBS_Year_3_Part_2__c,Student__r.Placement_Info__c,Student__r.Company_Name__c,Student__r.CTC__c,Student__r.Designation__c,Student__r.Location__c From Application__c
                                where Student__c IN (Select Student__c from Donor_Application_Mapping__c where Donor__c=:donorID AND Financial_Year__c=:currentFinancialYear) AND RPT_Financial_Year__c=:currentFinancialYear Order by Name ASC];
        Map<Id,Application__c> duplicatestudent = new Map<Id,Application__c>();
        for(Application__c app1 : studentlist){
            duplicatestudent.put(app1.Student__r.Id,app1);
        }
        //return [SELECT Student__r.Id,id,Student__r.Name,Student__r.Gender__c,Student__r.MailingCity,Year__c,Student__r.Current_year__c,Student__r.Is_Active_Alumni__c,Student__r.MailingState,Student__r.Course__c,Student__r.College_Name__r.Name,Student__r.Branch_Stream__c,Student__r.Semester7__c,Student__r.Semester8__c,Student__r.Semester9__c,Student__r.Semester10__c,Student__r.MBBS_Year_3_Part_1__c,Student__r.MBBS_Year_3_Part_2__c,Student__r.Placement_Info__c,Student__r.Company_Name__c,Student__r.CTC__c,Student__r.Designation__c,Student__r.Location__c From Application__c
                          //      where Student__c IN (Select Student__c from Donor_Application_Mapping__c where Donor__c=:donorID AND Financial_Year__c=:currentFinancialYear) AND RPT_Financial_Year__c=:currentFinancialYear Order by Name ASC];
        return duplicatestudent.values();
    }
    
    public static List<Contact> getDonorScholars1(string donorId,String Year){
        
        Id StudentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        Id DonorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();

        String currentFinancialYear = '';
        if(Year == null || Year==''){
        currentFinancialYear = Utility.financialYear();
        }else{
        currentFinancialYear = Year;    
        }
        //return [SELECT id,Name,Gender__c,MailingCity,Current_year__c,Is_Active_Alumni__c,MailingState,Course__c,College_Name__r.Name,Branch_Stream__c,Semester7__c,Semester8__c,Semester9__c,Semester10__c,MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c,Placement_Info__c,Company_Name__c,CTC__c,Designation__c,Location__c From Contact 
        //                      where (RecordTypeId =:StudentRecordType OR (RecordTypeId =:DonorRecordType AND Is_Active_Alumni__c=:true)) AND id IN (Select Student__c from Donor_Application_Mapping__c where Donor__c=:donorID AND Financial_Year__c=:currentFinancialYear) Order by Name ASC];
        return [SELECT id,Name,Gender__c,MailingCity,Current_year__c,Is_Active_Alumni__c,MailingState,Course__c,College_Name__r.Name,Branch_Stream__c,Semester7__c,Semester8__c,Semester9__c,Semester10__c,MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c,Placement_Info__c,Company_Name__c,CTC__c,Designation__c,Location__c From Contact 
                                where id IN (Select Student__c from Donor_Application_Mapping__c where Donor__c=:donorID AND Financial_Year__c=:currentFinancialYear) Order by Name ASC];
            
    }
    
    public static List<Contact> toDisplayStudentTab(string donorId,String Year){
        
        Id StudentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        Id DonorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();

        return [SELECT id,Name,Gender__c,MailingCity,Current_year__c,MailingState,Course__c From Contact 
                                where (RecordTypeId =:StudentRecordType OR (RecordTypeId =:DonorRecordType and Is_Active_Alumni__c=:true)) AND id IN (Select Student__c from Donor_Application_Mapping__c where Donor__c=:donorID) Order by Name ASC];
          
    }
    
        /*@purpose      : View all students having internal status online matched and external status as In progress
*@param        : studentId
*@returnType   : List of Students
*/
    
    public static Contact viewStudentProfile1(String contactId){
        string prelimRTypeId    = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 
        return [SELECT id,Aptitude_Analytical_Score__c,Aptitude_Logical_Score__c,English_Written_Score__c,English_Spoken_Score__c,Name,firstname,lastname,MobilePhone,Birthdate,Email,phone,MailingAddress,DN_Organization__c,Student_ID__c,
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
                When_you_start_earning_how_you_help__c,Parent_Mobile__c,Parent_Phone__c,Semester1__c,Semester2__c,Semester3__c,Semester4__c,Semester5__c,Semester6__c,Semester7__c,Semester8__c,MBBS_Year_1__c,MBBS_Year_2__c,MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c,CTC__c,Designation__c,Company_Name__c,Location__c,Has_Mentor__c,Other__c,Placement_Info__c,
                (SELECT Amount_Funded__c,Amount_Requested__c,Application_Site_URL__c,Application_Stage__c,
                 Course__c,toLabel(External_Status__c),Id,toLabel(Internal_Status__c),Name,RecordTypeId,CreatedDate,Application_Type__c,
                 Remaining_Fund__c,Course_Name__c,Student__c,Year__c,RecordType.DeveloperName,Has_student_provided_Justification__c,
                 Have_you_met_the_student_s_parent_s__c,Have_you_visited_the_student_s_house__c,Please_Comment_on_Parent_s_Backgroun__c,
                 Student_truly_deserves_a_scholarship__c,FacilitatorInputDone__c,Branch__c,College_Name__c,Receiving_Full_AICTE_OtherTution_Fee_Wa__c,
                 SchlrShp_FinancialAsst_Other_Than_FFE__c,If_Yes_How_much_Other_Source__c,Assistance_Source__c,If_Yes_How_much_AICTE_Fee_from_Govt__c,Requested_Books_Expenses__c,Requested_College_Fees__c,
                 Requested_Hostel_Mess_Expenses__c,Requested_Scholarship_Amount__c,Requested_Transportation_Expenses__c,Requested_Uniform_Expenses__c                 
                 FROM Applications__r),(SELECT Id, Name FROM Attachments where description='Student Resume Upload') 
                FROM Contact WHERE  Id =:contactId]; 
        
    }
    
public static Application__c viewStudentProfile(String contactId){
        string prelimRTypeId    = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
        Application__c studentindividualrecord=  [SELECT Year__c,Student__r.Aptitude_Analytical_Score__c,Student__r.Aptitude_Logical_Score__c,Student__r.English_Written_Score__c,Student__r.English_Spoken_Score__c,Student__r.id,Student__r.Name,Student__r.firstname,Student__r.lastname,Student__r.MobilePhone,Student__r.Birthdate,Student__r.Email,Student__r.phone,Student__r.MailingAddress,Student__r.DN_Organization__c,Student__r.Student_ID__c,Student__r.npe01__WorkPhone__c,Student__r.npe01__WorkEmail__c,Student__r.FFE_ID__c,Student__r.X10th__c,Student__r.X10th_Marks_Obtained__c,Student__r.X10th_Maximum_Marks__c,Student__r.College_Name__r.Name,Student__r.X10th_Medium_Of_Instruction__c,Student__r.X10th_Type__c,Student__r.X10th_Year_Passed__c,Student__r.X12th__c,Student__r.X12th_Marks_Obtained__c,Student__r.Profile_Pic_Attachment_Id__c,Student__r.MailingStreet,Student__r.MailingCity,Student__r.MailingState,Student__r.MailingPostalCode,Student__r.MailingCountry,Student__r.X12th_Maximum_Marks__c,Student__r.X12th_Medium_Of_Instruction__c,Student__r.X12th_Type__c,Student__r.X12th_Year_Passed__c,Student__r.Branch_Stream__c,Student__r.Branch_Other__c,Student__r.College_City__c,Student__r.College_Name__c,Student__r.College_Other__c,Student__r.Rejection_Reason__c,Student__r.College_State__c,Student__r.Type__c,Student__r.Course__c,Student__r.Entrance_Exam_Maximum_Marks__c,Student__r.Entrance_Exam_Taken_In_Year__c,Student__r.Entrance_Test_Marks__c,Student__r.Entrance_Test_Name__c,Student__r.Entrance_Test_Rank__c,Student__r.Facilitator_Name__c,Student__r.Facilitator_Name__r.Name,Student__r.Father_Age__c,Student__r.Father_Education__c,Student__r.Father_Name__c,Student__r.Internal_Status__c,Student__r.Father_Occupation__c,Student__r.Gender__c,Student__r.Mother_Age__c,Student__r.Mother_Education__c,Student__r.Mother_Name__c,Student__r.Mother_Occupation__c,Student__r.AP_Year_of_beginning__c,Student__r.Do_you_have_Google_login__c,Student__r.Facebook_login_ID__c,Student__r.Current_year__c,Student__r.Google_login_ID__c,Student__r.Do_you_have_Facebook_login__c,Student__r.Facilitator_Name__r.Working_Mode__c,Student__r.DisplayFacilitatorSection__c,Student__r.RecordType.DeveloperName,Student__r.Annual_Family_Income__c,Student__r.IsPrelimProcessed__c,Student__r.Other_Entrance_Test__c,Student__r.What_is_your_ambition_in_life__c,Student__r.Who_has_inspired_you_the_most_until_now__c,Student__r.Tell_us_some_things_about_yourself__c,Student__r.Describe_your_family_s_income__c,Student__r.When_you_start_earning_how_you_help__c,Student__r.Parent_Mobile__c,Student__r.Parent_Phone__c,Student__r.Semester1__c,Student__r.Semester2__c,Student__r.Semester3__c,Student__r.Semester4__c,Student__r.Semester5__c,Student__r.Semester6__c,Student__r.Semester7__c,Student__r.Semester8__c,Student__r.MBBS_Year_1__c,Student__r.MBBS_Year_2__c,Student__r.MBBS_Year_3_Part_1__c,Student__r.MBBS_Year_3_Part_2__c,Student__r.CTC__c,Student__r.Designation__c,Student__r.Company_Name__c,Student__r.Location__c,Student__r.Has_Mentor__c,Student__r.Other__c,Student__r.Placement_Info__c FROM Application__c WHERE Id=:contactId];
        //return [SELECT Student__r.id,Student__r.Name,Student__r.firstname,Student__r.lastname,Student__r.MobilePhone,Student__r.Birthdate,Student__r.Email,Student__r.phone,Student__r.MailingAddress,Student__r.DN_Organization__c,Student__r.Student_ID__c,Student__r.npe01__WorkPhone__c,Student__r.npe01__WorkEmail__c,Student__r.FFE_ID__c,Student__r.X10th__c,Student__r.X10th_Marks_Obtained__c,Student__r.X10th_Maximum_Marks__c,Student__r.College_Name__r.Name,Student__r.X10th_Medium_Of_Instruction__c,Student__r.X10th_Type__c,Student__r.X10th_Year_Passed__c,Student__r.X12th__c,Student__r.X12th_Marks_Obtained__c,Student__r.Profile_Pic_Attachment_Id__c,Student__r.MailingStreet,Student__r.MailingCity,Student__r.MailingState,Student__r.MailingPostalCode,Student__r.MailingCountry,Student__r.X12th_Maximum_Marks__c,Student__r.X12th_Medium_Of_Instruction__c,Student__r.X12th_Type__c,Student__r.X12th_Year_Passed__c,Student__r.Branch_Stream__c,Student__r.Branch_Other__c,Student__r.College_City__c,Student__r.College_Name__c,Student__r.College_Other__c,Student__r.Rejection_Reason__c,Student__r.College_State__c,Student__r.Type__c,Student__r.Course__c,Student__r.Entrance_Exam_Maximum_Marks__c,Student__r.Entrance_Exam_Taken_In_Year__c,Student__r.Entrance_Test_Marks__c,Student__r.Entrance_Test_Name__c,Student__r.Entrance_Test_Rank__c,Student__r.Facilitator_Name__c,Student__r.Facilitator_Name__r.Name,Student__r.Father_Age__c,Student__r.Father_Education__c,Student__r.Father_Name__c,Student__r.Internal_Status__c,Student__r.Father_Occupation__c,Student__r.Gender__c,Student__r.Mother_Age__c,Student__r.Mother_Education__c,Student__r.Mother_Name__c,Student__r.Mother_Occupation__c,Student__r.AP_Year_of_beginning__c,Student__r.Do_you_have_Google_login__c,Student__r.Facebook_login_ID__c,Student__r.Current_year__c,Student__r.Google_login_ID__c,Student__r.Do_you_have_Facebook_login__c,Student__r.Facilitator_Name__r.Working_Mode__c,Student__r.DisplayFacilitatorSection__c,Student__r.RecordType.DeveloperName,Student__r.Annual_Family_Income__c,Student__r.IsPrelimProcessed__c,Student__r.Other_Entrance_Test__c,Student__r.What_is_your_ambition_in_life__c,Student__r.Who_has_inspired_you_the_most_until_now__c,Student__r.Tell_us_some_things_about_yourself__c,Student__r.Describe_your_family_s_income__c,Student__r.When_you_start_earning_how_you_help__c,Student__r.Parent_Mobile__c,Student__r.Parent_Phone__c,Student__r.Semester1__c,Student__r.Semester2__c,Student__r.Semester3__c,Student__r.Semester4__c,Student__r.Semester5__c,Student__r.Semester6__c,Student__r.Semester7__c,Student__r.Semester8__c,Student__r.MBBS_Year_1__c,Student__r.MBBS_Year_2__c,Student__r.MBBS_Year_3_Part_1__c,Student__r.MBBS_Year_3_Part_2__c,Student__r.CTC__c,Student__r.Designation__c,Student__r.Company_Name__c,Student__r.Location__c,Student__r.Has_Mentor__c,Student__r.Other__c,Student__r.Placement_Info__c FROM Application__c WHERE Id=:contactId];
        system.debug('@@@ '+studentindividualrecord);
        return studentindividualrecord;
        
    }
    public static List<wrapper> getTrainingRecords(String contactId,String finYear){
        List<Student_Training__c> trainings =  [select id,createdDate,Training_Code__r.Name,name,Specialization_Name__c , (select id,Completion_Flag__c,Specialization_Name__c,Status__c from Training_Results__r) from Student_Training__c where Student_ID__c =: contactId];
        List<wrapper> listRecs = new List<wrapper>(); 
        String strYear ='';
        for(Student_Training__c training:trainings){
             Integer day = Date.valueOf(training.createdDate).day();
             Integer year = Date.valueOf(training.createdDate).year();
             Integer month = Date.valueOf(training.createdDate).month();
            if(month > 3){
                strYear = year + '-' + String.valueOf((year + 1)).substring(2);
            }
            else
            {
                strYear = (year - 1) + '-'+ String.valueOf((year)).substring(2);
            }
            for(Training_Result__c objTR : training.Training_Results__r){
            wrapper oo =new wrapper();
            oo.name = training.Training_Code__r.Name;
           // oo.date1 = strYear;
                oo.date1 = strYear;
            oo.status = objTR.Completion_Flag__c;
            oo.specialization = training.Specialization_Name__c;
                listRecs.add(oo);
            }
            
        }
        system.debug('@@@ trainings'+listRecs);
        return listRecs;
        
    }
    
        public static List<Mentoring_Details__c> geMentoringDetails(String contactId){
        List<Mentoring_Details__c> mentoringDetails =  [select id,Mentor_Name__c ,Name,Mentor_Organisation__c,Current_Session_Name__c,Session_status__c,Feedback__c From Mentoring_Details__c  where Student__c =:contactId];  
        return mentoringDetails;
        
    }
    
    public class wrapper{
        public string name;
        public string date1;
        public string status;
        public string specialization;
    }
    
}