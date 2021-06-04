public class MenteePortal_Controller {
    
    
    public String pageLoadInstanceString {get;set;}
    public String baseURL {get;set;}
    
    
    public MenteePortal_Controller(){
        string menteeId = ApexPages.currentPage().getParameters().get('id');
       /* baseURL = getDocumentBaseURL();  */
        baseURL = Constants.MENTOR_MENTEE_SITE_URL; 
        System.debug('baseURL'+baseURL);
        onPageLoadData pageLoadInstance = new onPageLoadData();
        
        pageLoadInstance.picklistValues = new Map<String,List<String>>();
        
        pageLoadInstance.picklistValues.put('mentorGender',picklist_values('Contact','Gender__c'));
        pageLoadInstance.picklistValues.put('spokenLang',picklist_values('Contact','Spoken_Languages__c'));
        pageLoadInstance.picklistValues.put('branch',picklist_values('Contact','Branch_Stream__c'));
        pageLoadInstance.picklistValues.put('mentoringNeeds',picklist_values('Contact','Modules__c'));
        pageLoadInstance.picklistValues.put('AreYouCurrentlyEmployed',picklist_values('Contact','Are_you_currently_employed__c'));
        pageLoadInstance.picklistValues.put('HighestEducationalQualification',picklist_values('Contact','Highest_Educational_Qualification__c'));
        pageLoadInstance.picklistValues.put('BranchofPracticeStudy',picklist_values('Contact','Branch_Areas_of_Practice_Study__c'));
        pageLoadInstance.picklistValues.put('PreferredTimeToConductSession',picklist_values('Contact','Preferred_time_to_conduct_session__c'));
        pageLoadInstance.picklistValues.put('CorporateName',picklist_values('Contact','Corporate__c'));
        
        pageLoadInstance.allProgrammes = [SELECT CreatedDate,Name,Skills__c FROM Program__c];
        
        List<Self_Assessment_Template__c> selfAssessmentQuestions = [SELECT Name,CreatedDate,LastActivityDate,LastModifiedById,(select name,id,Question__c,Type__c,Values__c from Self_Assessment_Questions__r) FROM Self_Assessment_Template__c];
        system.debug('selfAssessmentQuestions'+selfAssessmentQuestions);
        List<QuestionTemplateWrap> questionTempList = new List<QuestionTemplateWrap>();
        
        Map<Id,Self_Assessment_Response__c> allSelfAssessmentRes = new Map<Id,Self_Assessment_Response__c>();
        
        for(Self_Assessment_Response__c resp :[Select id,Name,Answer_Number__c,Self_Assessment_Question__c,FinalAnswer__c from Self_Assessment_Response__c where Mentee__r.Login_Hash_Code__c=:menteeId]){
            allSelfAssessmentRes.put(resp.Self_Assessment_Question__c,resp);
        }
        for(Self_Assessment_Template__c tempRec:selfAssessmentQuestions){
            QuestionTemplateWrap questionTemp = new QuestionTemplateWrap();
            questionTemp.templateQuestion = tempRec.Name;
            List<QuestionWrap> QuestionWrapList = new List<QuestionWrap>();
            for(Self_Assessment_Question__c eachQuestion:tempRec.Self_Assessment_Questions__r){
                QuestionWrap quesWrap = new QuestionWrap();
                quesWrap.questionRec = eachQuestion;
                if(allSelfAssessmentRes.containsKey(eachQuestion.Id)){
                    quesWrap.questionRes = allSelfAssessmentRes.get(eachQuestion.Id);
                    quesWrap.questionRec.FinalAnswer__c =   String.valueOf(allSelfAssessmentRes.get(eachQuestion.Id).FinalAnswer__c);
                }
                
                if(eachQuestion.Type__c=='Picklist'){
                    quesWrap.optionList = eachQuestion.Values__c.split(',');
                }
                QuestionWrapList.add(quesWrap);
            }
            questionTemp.allQuestions = QuestionWrapList;
            questionTempList.add(questionTemp);
        }
        pageLoadInstance.selfAssessmentQuestions = questionTempList;
        
        pageLoadInstanceString = JSON.serialize(pageLoadInstance);
        
    }
    
    @RemoteAction
    public static contact getMentorContactDetails(string mentorId){
        contact mentorDetail = [SELECT firstname,lastname,name,id,Skills__c,Language__c,Location__c,Profile_Pic_Attachment_Id__c,Native_Tongue__c,Linkedin_Profile_Link__c,Preferred_time_to_conduct_session__c,Languages_Known__c,Gender__c,Email,mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry,
                                College_Name__c,College_Location__c,Branch_Areas_of_Practice_Study__c,Area_of_Specialization__c,Years_of_Work_Experience__c,Professional_Designation__c,Corporate__c,Are_you_currently_employed__c, Login_Hash_Code__c FROM contact where Login_Hash_Code__c =:mentorId];
        return mentorDetail;    
    }

    
    @RemoteAction
    public static void saveMentorDetails(contact mentorRec, list<string> languageList){
        
        mentorRec.Spoken_Languages__c = String.join(languageList, ';');
        mentorRec.Is_Mentor__c = True;
        mentorRec.Mentor_registration_date__c = date.today();
        update mentorRec;
    }
    
    @RemoteAction
    public static void markSelfAssesment(string menteeId){
        update new Contact(Id = menteeId, is_SelfAssesment_Completed__c = true, is_Mentee__c = true );
        
    }
    
     @RemoteAction
    public static void mentorSignOut(string mentorId){
        update new contact(Id = mentorId,Login_Hash_Code__c = '' );
    }
    
    @RemoteAction
    public static contact getMenteeContactDetails(string menteeId){
       /* contact menteeDetail = [select firstname,lastname,name,id,Skills__c,Language__c, is_SelfAssesment_Completed__c, Location__c,Profile_Pic_Attachment_Id__c,Languages_Known__c,Gender__c,Email,mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry,
                                College_Name__c,College_Location__c from contact where Id =:menteeId];  */
        
        contact menteeDetail = [select firstname,lastname,name,id,Skills__c,Language__c, FFE_ID__c, is_SelfAssesment_Completed__c, Location__c,Profile_Pic_Attachment_Id__c,Languages_Known__c,Gender__c,Email,mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry,
                                College_Name__c,College_Name__r.Name,Phone,College_Location__c,Login_Hash_Code__c from contact where Login_Hash_Code__c =:menteeId];
        return menteeDetail;    
    }
    
    @RemoteAction
    public static List<pragrammeWithAttachment> getProgramDetails(){
        try{
            List<pragrammeWithAttachment> listToBeReturned = new List<pragrammeWithAttachment>();
            
            for(Program__c programmeRec: [SELECT CreatedDate,Name,Skills__c, (SELECT Id, Name FROM Attachments) FROM Program__c]){
                System.debug('programmeRec'+programmeRec.Attachments.size());
                if(!programmeRec.Attachments.isEmpty()){
                    list<Attachment> attList = new list<Attachment>();
                    for(Attachment att:programmeRec.Attachments){
                        attList.add(att);
                    }
                    listToBeReturned.add(new pragrammeWithAttachment(programmeRec,attList));  //programmeRec.Attachments.Id
                }else{
                    listToBeReturned.add(new pragrammeWithAttachment(programmeRec,null));
                }
                
            }
            System.debug('listToBeReturned'+listToBeReturned);
            return listToBeReturned;
        }catch(Exception e){
            System.debug('listToBeReturned'+e.getLineNumber()+' AT '+e.getMessage());
            return null;
        }
    }
    public static String htmlDecode (String s) {  
        
        Map<String, String> htmlDecodingMap = new Map<String, String>();
        htmlDecodingMap.put('&lt;', '<');
        htmlDecodingMap.put('&gt;', '>');
        htmlDecodingMap.put('&amp;quot;', '"');
        htmlDecodingMap.put('&amp;', '&');
        
        for (String token : htmlDecodingMap.keySet()) {
            s = s.replace(token, htmlDecodingMap.get(token));
        }
        return s;
    }
    @RemoteAction
    public static list<Session__c> getAllSession(string menteeId){
        list<Mentor_Mentee_Association__c > MentorMenteeAssociationList = [select name,id,mentee_del__c,mentee_del__r.Name,mentee_del__r.firstname,mentee_del__r.lastname,mentee_del__r.Id,mentee_del__r.Skills__c,mentee_del__r.Language__c,mentee_del__r.Location__c,mentee_del__r.Languages_Known__c,
                                                                           mentee_del__r.Gender__c ,mentee_del__r.Email,mentee_del__r.mailingStreet ,mentee_del__r.mailingCity, mentee_del__r.Profile_Pic_Attachment_Id__c ,mentee_del__r.mailingState,mentee_del__r.mailingPostalCode,mentee_del__r.mailingCountry,mentee_del__r.Profile_Picture__c from Mentor_Mentee_Association__c where mentee_del__r.Login_Hash_Code__c =: menteeId AND Status__c != 'Requested' limit 1];
        list<string> mentorMenteeAssociationIdList = new list<string>();
        for(Mentor_Mentee_Association__c mmAssociation:MentorMenteeAssociationList){
            mentorMenteeAssociationIdList.add(mmAssociation.Id);
        }
        if(mentorMenteeAssociationIdList.size() > 0 ){
            return [select name, id, Agenda__c, Date__c, Description__c, Meeting_Link__c, Mentor_Mentee_Association__c,Status__c,Mentor_Mentee_Association__r.Total_Mentoring_Hours__c, Mentor_Mentee_Association__r.Duration_of_Sessions_Attended__c, Feedback_Status__c,End_time__c, Time__c,(select name,id,Description__c,Mentor_Rating__c,Mentee_Rating__c,Feedback_given_by__c from Feedbacks__r) from Session__c where Mentor_Mentee_Association__c IN :mentorMenteeAssociationIdList ORDER BY Date__c DESC]; 
        }else{
            return null;
        }
        
        
    }
    
    @RemoteAction
    public static void submitFeedBack(string sessionId, string feedBackDescription,string menteeRating){
        system.debug('sessionId==>'+sessionId+'sessionFeedback==>'+feedBackDescription);  
        Feedback__c mentorFeedback = new Feedback__c();
        mentorFeedback.Session__c = sessionId;
        mentorFeedback.Description__c = feedBackDescription;
        mentorFeedback.Feedback_given_by__c = 'MENTEE';
        mentorFeedback.Mentee_Rating__c = menteeRating;
        insert mentorFeedback;
    }
    
    @RemoteAction
    public static String doUploadAttachment(String sessionId, String attachmentBody, String attachmentName) {
        system.debug('sessionId==>'+sessionId+'attachmentBody==>'+attachmentBody+'attachmentName==>'+attachmentName);
        if(sessionId != null && attachmentBody != null) {
            Attachment att = new Attachment();
            String newBody = '';
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            att.Name = attachmentName;
            att.parentId = sessionId;
            
            insert att;
            return att.Id; 
        }
        return null;
    }
    
    @RemoteAction 
    public static void insertMentorMenteeAssociation(string menteeId,string programId ){
        if(menteeId != '' && programId !=''){
            Mentor_Mentee_Association__c mentorMenteeAssociation = new Mentor_Mentee_Association__c();
            mentorMenteeAssociation.mentee_del__c = menteeId;
            mentorMenteeAssociation.Program__c = programId;
            mentorMenteeAssociation.Status__c = 'Requested';
            insert mentorMenteeAssociation;
        }
        
    }
    
    @RemoteAction 
    public static void updateMenteeDetails(contact menteeRecord){
        menteeRecord.MailingPostalCode = string.valueof(menteeRecord.MailingPostalCode);
        update menteeRecord;
    }
    
    
    @RemoteAction
    Public static contact getMenteeDetails(string contactId){
        system.debug('contactId========>'+contactId);
        Contact menteeRec = [SELECT id,Renewal_On__c,TYS_Video_Link__c,TYS_SchoolLife__c,TYS_GuidanceProvider__c,TYS_CollegeAssessment__c,TYS_FFE_Scholarship_and_Impact__c,TYS_Future_Plans__c,TYS_Dreams_and_Responsibilities__c,
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
                              FROM Applications__r )
                             FROM Contact WHERE  Id =:contactId];//Added KYC_Verified__c,Is_IFSC_Code_Verified__c,Other_Type_Bank_Account__c in query fields -- Sumit Gaurav -- 23-June-2020
        
        return menteeRec; 
        
    }
    
    @RemoteAction
    public static contact getSelfAssesmentAnswers(){
        contact con = [select name,id,(select Single_Answer__c,Question_Type__c,Self_Assessment_Question__c from Self_Assessment_Responses__r) from contact limit 1];
        return con;
    }
    
    
    class onPageLoadData{
        Map<String, List<String>> picklistValues {get;set;}
        List<QuestionTemplateWrap> selfAssessmentQuestions{get;set;}
        
        List<Program__c> allProgrammes{get;set;}
    }
    class QuestionTemplateWrap{
        public string templateQuestion{get;set;}
        public List<QuestionWrap> allQuestions{get;set;}
    }
    class QuestionWrap{
        public Self_Assessment_Question__c questionRec{get;set;}
        public Self_Assessment_Response__c questionRes{get;set;}
        public List<String> optionList{get;set;}
    }
    
    @RemoteAction
    public static void insertSelfAssessmentAnswers(list<SelfAssessmentResponseWrapper> menteeResponse, string menteeId ){    
        try{
            system.debug('menteeResponse'+menteeResponse);
            string menteeSAId;
            if(menteeId != null)
            	menteeSAId =[select name,id from contact where Login_Hash_Code__c =:menteeId ].Id;
            if(menteeResponse != null){
                integer month = 0;
                List<Self_Assessment_Response__c> ListOFAssessmentResponse = New List<Self_Assessment_Response__c>();
                for(SelfAssessmentResponseWrapper response:menteeResponse){
                    system.debug('insideForLoop');
                    Self_Assessment_Response__c assessmentResponse = New Self_Assessment_Response__c();
                    if(response.respId!='' && response.respId!=null){
                        assessmentResponse.Id = response.respId;
                    }
                    if(menteeId != null)
                        assessmentResponse.Mentee__c = menteeSAId;
                    if(response.AnswerCheckbox != null){
                        assessmentResponse.Answer_Checkbox__c = Boolean.valueOf(response.AnswerCheckbox);
                        assessmentResponse.FinalAnswer__c = String.valueOf(response.AnswerCheckbox);
                    }  
                    if(response.AnswerDate != null ){
                        system.debug('response.AnswerDate'+response.AnswerDate);
                        month = response.AnswerMonth + 1 ;
                        assessmentResponse.Answer_Date__c = date.newInstance(response.AnswerYear, month, response.AnswerDate);  
                        assessmentResponse.FinalAnswer__c = String.valueOf(assessmentResponse.Answer_Date__c);
                    }
                    
                    system.debug('response.AnswerPicklist===>'+response.AnswerPicklist);
                    if(response.AnswerPicklist != null){
                        assessmentResponse.Answer_Picklist__c = response.AnswerPicklist;
                        assessmentResponse.FinalAnswer__c = String.valueOf(response.AnswerPicklist);
                    }
                    system.debug('text------'+response);
                    
                    system.debug('text------'+response.AnswerText);
                    system.debug('text------'+response.AnswerNumber);
                    if(response.AnswerText != null){
                        system.debug('text------');
                        assessmentResponse.Answer_Text__c = response.AnswerText;
                        assessmentResponse.FinalAnswer__c = String.valueOf(response.AnswerText);
                    }
                    
                    if(response.AnswerNumber != null){
                        system.debug('number------');
                        assessmentResponse.Answer_Number__c = Integer.valueof(response.AnswerNumber);
                        assessmentResponse.FinalAnswer__c = String.valueOf(response.AnswerNumber);
                    }
                    if(response.SelfAssessmentQuestion != null){
                        assessmentResponse.Self_Assessment_Question__c = response.SelfAssessmentQuestion;
                        
                    }
                    
                    ListOFAssessmentResponse.add(assessmentResponse);
                }
                system.debug('ListOFAssessmentResponse==>'+ListOFAssessmentResponse);
                system.debug('ListOFAssessmentResponse==>'+ListOFAssessmentResponse.size());
                upsert ListOFAssessmentResponse;
                
            }
            
            
        }catch(exception e){
            system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
            HandleBusinessException.captureError('MenteePortal_Controller','insertSelfAssessmentAnswers',e);
        }
        
    }
    
    @RemoteAction
    public static string menteeRegForm(Contact meenteRec, list<string> modulesList, list<string> languageList){
        System.debug('meenteRec'+meenteRec);
        //  try{
        System.debug('meenteRec'+meenteRec);
        System.debug('meenteRec'+meenteRec.Branch_Stream__c);
        meenteRec.Modules__c = String.join(modulesList, ';');
        meenteRec.Spoken_Languages__c = String.join(languageList, ';');
        meenteRec.Mentee_registration_date__c = date.today();
        //meenteRec.is_Mentee__c = true;
        
        update meenteRec;
        list<Mentor_Mentee_Association__c> mmAssociationList = [select name,id from Mentor_Mentee_Association__c where mentee_del__c =: meenteRec.Id];
        if(mmAssociationList.size() != 0){
            delete mmAssociationList;
        }
        Mentor_Mentee_Association__c mmAssociation = new Mentor_Mentee_Association__c(); 
        if(modulesList.size() > 0 ){
            mmAssociation.Modules__c = String.join(modulesList, ';');
            mmAssociation.mentee_del__c = meenteRec.Id;
            mmAssociation.Status__c = 'Requested';
            system.debug('mmAssociation==>'+mmAssociation);
            insert mmAssociation;     
            
        }  
        
        system.debug('Login_Hash_Code__c===='+meenteRec.Login_Hash_Code__c);
        return meenteRec.Login_Hash_Code__c;
        // }
        /*     catch(exception e){
system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
return null;
}    */
        
    }
    
    @RemoteAction
    public static contact submit(String menteeId, String menteeEmail){
        try{
            List<Contact> conList = [Select Id,FirstName,LastName,FFE_ID__c,is_Mentee__c,Email,Phone,Aadhar_number__c,hobbies_and_interests__c,What_are_your_top_two_career_goals__c,Gender__c,
                                     Spoken_Languages__c,College_Name__c,College_Location__c,Branch_Stream__c,Modules__c from Contact Where FFE_ID__c =:menteeId AND Email =:menteeEmail ];
            system.debug('conList==>'+conList);
            if(!conList.isEmpty()){
                return conList[0];    
            }
        }
        catch(exception e){
            system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
        }
        return null;
        
    }

    @RemoteAction
    public static String doUploadProfilePic(String mentorId, String attachmentBody, String attachmentName) {
        system.debug('sessionId==>'+mentorId+'attachmentBody==>'+attachmentBody+'attachmentName==>'+attachmentName);
        if(mentorId != null && attachmentBody != null) {
            Attachment att = new Attachment();
            String newBody = '';
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            att.Name = attachmentName;
            att.parentId = mentorId;
            
            insert att;
            
            update new Contact(Id = mentorId,Profile_Pic_Attachment_Id__c = att.Id );
            return att.Id; 
        }
        return null;
    }
    
    public String getDocumentBaseURL(){
        String sfUrl=URL.getSalesforceBaseUrl().getHost();
        
        //String baseURL = 'https://'+sfUrl;
        list<site_url__c> siteUrl = site_url__c.getall().values();
        system.debug(siteUrl[0].Name);
        string baseURL = siteUrl[0].Name;
        String domainNameSubstring = baseURL.substringBefore('.');
        return domainNameSubstring + '--c.documentforce.com';
    }
    
    
    public static String[] picklist_values(String object_name, String field_name)
    {
        String[] values = new String[]{};
            String[] types = new String[]{object_name};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results)
        {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues())
            {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        
        system.debug('values'+values);
        return values;
    }

    //Auth here
    public PageReference checkUserAuth(){
        return MentorMenteeAuthHelper.checkUserAuth(Apexpages.currentPage().getParameters().get('id'));
    }


    public class SelfAssessmentResponseWrapper {
        public string AnswerCheckbox ; 
        public string AnswerNumber ;
        public string AnswerPicklist ;
        public string AnswerText ;
        public string Mentee ;
        public string SelfAssessmentQuestion ;
        public Integer AnswerDate;
        public Integer AnswerMonth;
        public Integer AnswerYear;
        public String respId;
    }
    
    
     class pragrammeWithAttachment{
        public Program__c programmeRec;
        public list<Attachment> attId;
        
        public pragrammeWithAttachment(Program__c programmeRec,list<Attachment> attId){
            this.programmeRec = programmeRec;
            this.attId = attId;
        }
    }
    
}