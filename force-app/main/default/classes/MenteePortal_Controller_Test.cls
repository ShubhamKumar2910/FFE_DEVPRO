@istest
public class MenteePortal_Controller_Test {
    
    @istest public static void MenteePortal_ControllerTest()
    { 
        Self_Assessment_Template__c saTemp = new Self_Assessment_Template__c();
        Self_Assessment_Response__c saRespo = new Self_Assessment_Response__c();
        Self_Assessment_Question__c saQues = new Self_Assessment_Question__c();
        
        saTemp.Name = 'Communication Skills';
        insert  saTemp;
        
        saQues.Question__c = 'I can communicate effectively on a one-to-one basis';
        saQues.Self_Assessment_Template__c = saTemp.Id;
        insert  saQues;
        
        saRespo.Answer_Number__c = 4;
        saRespo.Self_Assessment_Question__c = saQues.Id;
        saRespo.FinalAnswer__c = 'four';
        insert  saRespo;
        
        
        MenteePortal_Controller menteeCtrl = new MenteePortal_Controller();
}
    
    
    @istest public static void getMentorContactDetailsTest()
    {
        contact conMentor = new contact();
        conMentor.FirstName = 'Aakash';
        conMentor.LastName = 'Jain';
        conMentor.RecordTypeId = '0121e000000L5TF';
        insert conMentor;

        String ans = MenteePortal_Controller_Test.getHashCode( conMentor.Id);
       
        MenteePortal_Controller.getMentorContactDetails(ans);
    }
    
    @istest public static void saveMentorDetailsTest()
    {
        contact mentor = new contact();
        mentor.FirstName = 'Aakash';
        mentor.LastName = 'Jain';
        mentor.Spoken_Languages__c = 'English';
        insert mentor;
        
        list<string> languageList = new list<string>();
        languageList.add('Hindi');
        languageList.add('English');
        
        MenteePortal_Controller.saveMentorDetails(mentor, languageList);
    }
    

    @istest public static void getMenteeContactDetailsTest()
    {
        contact mentee = new contact();
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.Spoken_Languages__c = 'English';
        insert mentee;
        String ans = MenteePortal_Controller_Test.getHashCode( mentee.Id);
        MenteePortal_Controller.markSelfAssesment(mentee.Id);
        MenteePortal_Controller.getMenteeContactDetails(ans);
    }
    @istest public static void mentorSignOutTest()
    {
        contact mentor = new contact();
        mentor.FirstName = 'Aakash';
        mentor.LastName = 'Jain';
        mentor.Spoken_Languages__c = 'English';
        insert mentor;
        
        MenteePortal_Controller.mentorSignOut(mentor.Id);
    }
    @istest public static void getProgramDetailsTest(){
        
        Program__c prgrm = new Program__c();
        prgrm.Name = 'Stress Management	';
        prgrm.Skills__c = 'Stress Management';  
        insert prgrm;
        
        
        Program__c prgrm1 = new Program__c();
        prgrm1.Name = 'Stress Management	';
        prgrm1.Skills__c = 'Stress Management';  
        insert prgrm1;
        Attachment att = new Attachment();
        att.ParentId = prgrm1.Id;
        att.Name = 'test';
        String newBody = 'Att body';
        att.Body = EncodingUtil.base64Decode(newBody);
        insert att;        
        
        MenteePortal_Controller.getProgramDetails();
    }
    @istest public static void htmlDecodeTest()
    {
        String s = 'absc';
        MenteePortal_Controller.htmlDecode(s);
    }
    @istest public static void getAllSessionTest()
    {
        try{
            contact mentee = new Contact();
            Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
            
            mentee.FirstName = 'Aakash';
            mentee.LastName = 'Jain';
            mentee.is_Mentee__c = true;
            mentee.MailingCountry = 'India';
            mentee.Language_Known__c = 'English';
            mentee.MailingState = 'Karnataka';
            mentee.Corporate__c = 'Capgemini';
            mentee.Gender__c = 'Male';
            insert mentee;
            
            
            mma.Status__c = 'Approved';
            mma.Modules__c = 'Communication Skills';
            mma.mentee_del__c = mentee.Id;
            insert mma;
            
            Session__c ss = new Session__c();
            ss.Mentor_Mentee_Association__c = mma.Id;
            ss.Agenda__c = 'test';
            ss.Description__c = 'test 1';
            insert ss;
            
            String ans = MenteePortal_Controller_Test.getHashCode( mentee.Id);
            
            MenteePortal_Controller.getAllSession(ans);
        }
        catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
        }
        
    }
    @istest public static void submitFeedBackTest()
    {
        contact mentee = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        insert mentee;
        
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        mma.mentee_del__c = mentee.Id;
        insert mma;
        
        
        Session__c ss = new Session__c();
        ss.Agenda__c = 'test';
        ss.Mentor_Mentee_Association__c = mma.Id;
        ss.Description__c = 'test 1';
        insert ss;
        String feedBackDescription = 'Nice and INteractive Session';
        String menteeRating = '5';
        MenteePortal_Controller.submitFeedBack(ss.Id, feedBackDescription, menteeRating);
    }
    @istest public static void doUploadAttachmentTest()
    {
        contact mentee = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        insert mentee;
        
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        mma.mentee_del__c = mentee.Id;
        insert mma;
        
        Session__c ss = new Session__c();
        ss.Agenda__c = 'test';
        ss.Mentor_Mentee_Association__c = mma.Id;
        ss.Description__c = 'test 1';
        insert ss;    
        MenteePortal_Controller.doUploadAttachment(ss.Id,'testing body','Test');
    }
    @istest public static void insertMentorMenteeAssociationTest()
    {
        contact mentee = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        insert mentee;
        
        Program__c prgrm = new Program__c();
        prgrm.Name = 'Stress Management	';
        prgrm.Skills__c = 'Stress Management';  
        insert prgrm;
        
        MenteePortal_Controller.insertMentorMenteeAssociation(mentee.Id, prgrm.id);
    }
    @istest public static void updateMenteeDetailsTest()
    {
        contact mentee = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        insert mentee;
        
        Application__c app = new Application__c();
        app.Application_Type__c = 'New';
        app.Student__c = mentee.Id ;
        insert app ;
        
        MenteePortal_Controller.updateMenteeDetails(mentee);
        MenteePortal_Controller.getMenteeDetails(mentee.Id);
    }
    
    @istest public static void getSelfAssesmentAnswersTest()
    {
        contact mentee = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        insert mentee;
        
        Self_Assessment_Template__c saTemp = new Self_Assessment_Template__c();
        Self_Assessment_Response__c saRespo = new Self_Assessment_Response__c();
        Self_Assessment_Question__c saQues = new Self_Assessment_Question__c();
        
        saTemp.Name = 'Communication Skills';
        insert  saTemp;
        
        saQues.Question__c = 'I can communicate effectively on a one-to-one basis';
        saQues.Self_Assessment_Template__c = saTemp.Id;
        insert  saQues;
        
        saRespo.Self_Assessment_Question__c = saQues.Id;
        saRespo.FinalAnswer__c = 'four';
        insert  saRespo;
        
        MenteePortal_Controller.getSelfAssesmentAnswers();
    }
    /* @istest public static void getSelfAssesmentAnswersTest()
{
SelfAssessmentResponseWrapper
contact mentee = new Contact();
Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         

mentee.FirstName = 'Aakash';
mentee.LastName = 'Jain';
mentee.is_Mentee__c = true;
mentee.MailingCountry = 'India';
mentee.Language_Known__c = 'English';
mentee.MailingState = 'Karnataka';
mentee.Corporate__c = 'TCS';
mentee.Gender__c = 'Male';
insert mentee;

Self_Assessment_Template__c saTemp = new Self_Assessment_Template__c();
Self_Assessment_Response__c saRespo = new Self_Assessment_Response__c();
Self_Assessment_Question__c saQues = new Self_Assessment_Question__c();

saTemp.Name = 'Communication Skills';
insert  saTemp;

saQues.Question__c = 'I can communicate effectively on a one-to-one basis';
saQues.Self_Assessment_Template__c = saTemp.Id;
insert  saQues;

saRespo.Self_Assessment_Question__c = saQues.Id;
saRespo.Answer_Checkbox__c
saRespo.Answer_Date__c
saRespo.FinalAnswer__c = 'four';
insert  saRespo;

MenteePortal_Controller.getSelfAssesmentAnswers();
}*/
    
    @istest public static void menteeRegFormTest()
    {
        contact mentee = new Contact();
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        insert mentee;
        list<string> modulesList = new list<string>();
        list<string> languageList = new list<string>();
        
        modulesList.add('Communication Skills');
        modulesList.add('Stress Management');
        
        languageList.add('English');
        languageList.add('Hindi');
        
        MenteePortal_Controller.menteeRegForm(mentee, modulesList, languageList);
    }
    @istest public static void submitTest()/////////////////////////////////////////////////////////set hashcode in getmentorcontactdetails, markselfassesment
    {
        contact mentee = new Contact();
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        mentee.Email = 'aakash@gmail.com';
        insert mentee;
        contact menteeFFEId = [Select FFE_ID__c from Contact Where Name ='Aakash Jain'];
        
        MenteePortal_Controller.submit(menteeFFEId.FFE_ID__c, 'aakash@gmail.com');
    }
    
    @istest public static void doUploadProfilePicTest()
    {
        contact conMentor = new contact();
        conMentor.FirstName = 'Aakash';
        conMentor.LastName = 'Jain';
        insert conMentor;
        
        
        MenteePortal_Controller.doUploadProfilePic(conMentor.Id, 'attachmentBody', 'attachmentName');
    }
    @istest public static void getDocumentBaseURLTest()
    {
        MenteePortal_Controller menteePort = new MenteePortal_Controller();
        menteePort.getDocumentBaseURL();
    }
     @istest public static void checkUserAuthTest()
    {
        MenteePortal_Controller menteePort = new MenteePortal_Controller();
        menteePort.checkUserAuth();
    }
    @istest public static void insertSelfAssessmentAnswersTest()
    {
        contact mentee = new Contact();
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        mentee.Email = 'aakash@gmail.com';
        mentee.Login_Hash_Code__c = 'asdffvdfv';
        insert mentee;
        
        Self_Assessment_Template__c saTemp = new Self_Assessment_Template__c();
        Self_Assessment_Response__c saRespo = new Self_Assessment_Response__c();
        Self_Assessment_Question__c saQues = new Self_Assessment_Question__c();
        
        saTemp.Name = 'Communication Skills';
        insert  saTemp;
        
        saQues.Question__c = 'I can communicate effectively on a one-to-one basis';
        saQues.Self_Assessment_Template__c = saTemp.Id;
        insert  saQues;
        
        saRespo.Self_Assessment_Question__c = saQues.Id;
        saRespo.FinalAnswer__c = 'four';
        insert  saRespo;
        
        list<Self_Assessment_Response__c> menteeRespond = new list<Self_Assessment_Response__c>();
        Self_Assessment_Response__c menteeResponse = new Self_Assessment_Response__c();
        menteeResponse.Answer_Checkbox__c			 	=	true;
        menteeResponse.Answer_Date__c 					= 	system.today();	
        menteeResponse.Answer_Number__c  				= 	10.0;
        menteeResponse.Answer_Picklist__c 				= 	'picklist value';
        menteeResponse.Answer_Rich_Text__c 				= 	'the answer is submitted in rich text area';
        menteeResponse.Answer_Text__c 					= 	'answer';
        menteeResponse.FinalAnswer__c 					= 	'Final Answer' ;
        
        insert menteeResponse;
        
        
        MenteePortal_Controller.SelfAssessmentResponseWrapper saWrap = new MenteePortal_Controller.SelfAssessmentResponseWrapper();
        saWrap.AnswerCheckbox = 'true';
        saWrap.AnswerNumber = '10.00';
        saWrap.AnswerPicklist = 'picklist value';
        saWrap.AnswerText = 'writing i am ';
        saWrap.Mentee = mentee.Id;
        saWrap.SelfAssessmentQuestion = saQues.Id;
        saWrap.AnswerDate = 11;
        saWrap.AnswerMonth = 05;
        saWrap.AnswerYear = 2021;
        saWrap.respId = menteeResponse.id;
        
        List<MenteePortal_Controller.SelfAssessmentResponseWrapper> saWrapList = new List<MenteePortal_Controller.SelfAssessmentResponseWrapper>();
        saWrapList.add(saWrap);
        
        String ans = MenteePortal_Controller_Test.getHashCode( mentee.Id);
        MenteePortal_Controller.insertSelfAssessmentAnswers(saWrapList, mentee.Login_Hash_Code__c);   
        
    }
    
    public static string getHashCode(String contactId){
        try{
            
            contact contacts = [select name,id,Login_Hash_Code__c,Last_Hash_Code_Updated__c from contact where id =:contactId];
            system.debug('contacts===>'+contacts);
            return contacts.Login_Hash_Code__c;
            
        }catch(Exception ex){
            system.debug('e==='+ex);
            HandleBusinessException.captureError('Signin', 'temporaryDonorLoginURL', ex);
            return Constants.ERROR_MSG;
        }
    }
    
    
}