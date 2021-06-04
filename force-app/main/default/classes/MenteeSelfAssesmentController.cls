public class MenteeSelfAssesmentController {
    
    public String pageLoadInstanceString {get;set;}
    
    public MenteeSelfAssesmentController(){
        
        onPageLoadData pageLoadInstance = new onPageLoadData();
        
        pageLoadInstance.picklistValues = new Map<String,List<String>>();
        
        
        
        pageLoadInstance.allProgrammes = [SELECT CreatedDate,Name,Skills__c FROM Program__c];
        
        List<Self_Assessment_Template__c> selfAssessmentQuestions = [SELECT Name,CreatedDate,LastActivityDate,LastModifiedById,(select name,id,Question__c,Type__c,Values__c from Self_Assessment_Questions__r) FROM Self_Assessment_Template__c];
        system.debug('selfAssessmentQuestions'+selfAssessmentQuestions);
        List<QuestionTemplateWrap> questionTempList = new List<QuestionTemplateWrap>();
        
        for(Self_Assessment_Template__c tempRec:selfAssessmentQuestions){
            QuestionTemplateWrap questionTemp = new QuestionTemplateWrap();
            questionTemp.templateQuestion = tempRec.Name;
            List<QuestionWrap> QuestionWrapList = new List<QuestionWrap>();
            for(Self_Assessment_Question__c eachQuestion:tempRec.Self_Assessment_Questions__r){
                QuestionWrap quesWrap = new QuestionWrap();
                quesWrap.questionRec = eachQuestion;
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
    Public static contact getMenteeDetails(string contactId){
        system.debug('contactId========>'+contactId);
        Contact menteeRec = [SELECT id, FirstName, LastName, FFE_ID__c, Spoken_Languages__c, Email, College_Name__r.Name, College_Location__c, Branch_Stream__c, Modules__c,What_are_your_top_two_career_goals__c,hobbies_and_interests__c,
                     MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Branch_Other__c,College_City__c,College_Name__c,College_Other__c,
                     College_State__c,Type__c,Course__c,Entrance_Exam_Maximum_Marks__c,Entrance_Exam_Taken_In_Year__c,
                     Gender__c,English_Written_Score_post__c,English_Spoken_Score_post__c,CTC__c,Designation__c,Company_Name__c,Location__c,Other__c,Placement_Info__c,Semester9__c,Semester10__c,Has_Mentor__c  FROM Contact WHERE  Id =:contactId];//Added KYC_Verified__c,Is_IFSC_Code_Verified__c,Other_Type_Bank_Account__c in query fields -- Sumit Gaurav -- 23-June-2020
        
        			return menteeRec; 
        
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
        public List<String> optionList{get;set;}
    }
    class pragrammeWithAttachment{
        public Program__c programmeRec;
        public String attId;
        
        public pragrammeWithAttachment(Program__c programmeRec,String attId){
            this.programmeRec = programmeRec;
            this.attId = attId;
        }
    }
    @RemoteAction
    public static void insertSelfAssessmentAnswers(list<SelfAssessmentResponseWrapper> menteeResponse, string menteeId ){    
        try{
            system.debug('menteeResponse'+menteeResponse);
            
            if(menteeResponse != null){
                integer month = 0;
                List<Self_Assessment_Response__c> ListOFAssessmentResponse = New List<Self_Assessment_Response__c>();
                for(SelfAssessmentResponseWrapper response:menteeResponse){
                    system.debug('insideForLoop');
                    Self_Assessment_Response__c assessmentResponse = New Self_Assessment_Response__c();
                    if(menteeId != null)
                        assessmentResponse.Mentee__c = menteeId;
                    if(response.AnswerCheckbox != null)
                        assessmentResponse.Answer_Checkbox__c = Boolean.valueOf(response.AnswerCheckbox);
                    if(response.AnswerDate != null ){
                      	 system.debug('response.AnswerDate'+response.AnswerDate);
                        month = response.AnswerMonth + 1 ;
                    	assessmentResponse.Answer_Date__c = date.newInstance(response.AnswerYear, month, response.AnswerDate);  
                        
                    }
                       
                    system.debug('response.AnswerPicklist===>'+response.AnswerPicklist);
                    if(response.AnswerPicklist != null)
                        assessmentResponse.Answer_Picklist__c = response.AnswerPicklist;
                    if(response.SelfAssessmentQuestion != null)
                        assessmentResponse.Self_Assessment_Question__c = response.SelfAssessmentQuestion;
                    if(response.AnswerText != null)
                        assessmentResponse.Answer_Text__c = response.AnswerText;
                    if(response.AnswerNumber != null)
                        assessmentResponse.Answer_Number__c = Integer.valueof(response.AnswerNumber);
                    ListOFAssessmentResponse.add(assessmentResponse);
                }
                system.debug('ListOFAssessmentResponse==>'+ListOFAssessmentResponse);
                Insert ListOFAssessmentResponse;
                
            }
            
            
        }catch(exception e){
            system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
        }
        
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
    }
    
}