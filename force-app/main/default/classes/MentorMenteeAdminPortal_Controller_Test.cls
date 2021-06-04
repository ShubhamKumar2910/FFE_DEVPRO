@isTest public class MentorMenteeAdminPortal_Controller_Test {
    @testSetup static void dataForTest(){
        contact mentor = new Contact();
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
        
        mentor.FirstName = 'Ajeet';
        mentor.LastName = 'Kumar';
        mentor.Is_Mentor__c = true;
        mentor.Corporate__c = 'Capgemini';
        mentor.is_SelfAssesment_Completed__c = true;
        insert mentor;
        
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        mma.mentee_del__c = mentee.Id;
        mma.Mentor__c = mentor.Id;
        insert mma;
        
    }
    @isTest static void getStateListTest(){
        List<State_Master__mdt> stateList = MentorMenteeAdminPortal_Controller.getStateList('India');
    }
    @isTest static void getLanguagePicklistValuesTest(){
        MentorMenteeAdminPortal_Controller.getLanguagePicklistValues();
    }
    @isTest static void getCorporatePicklistValuesTest(){
        MentorMenteeAdminPortal_Controller.getCorporatePicklistValues();
    }
    @isTest static void getStatusPicklistValuesTest(){
        MentorMenteeAdminPortal_Controller.getStatusPicklistValues();
    }
    @isTest static void getGenderPicklistValuesTest(){
        MentorMenteeAdminPortal_Controller.getGenderPicklistValues();
    }
    @isTest static void getMentorMenteeAssociationTest(){
        contact mentor = new Contact();
        contact mentee = new Contact();
        
        mentee =[Select id from contact Where is_Mentee__c= true];
        mentor = [Select id from contact where Is_Mentor__c = true]  ;
        
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();         
        mma.Status__c = 'Requested';
        mma.Modules__c = 'Communication Skills';
        mma.mentee_del__c = mentee.Id;
        mma.Mentor__c = mentor.Id;
        insert mma;
        
        List<String> loaction = new List<String>();
        loaction.add('Delhi');
        loaction.add('Karnataka');
        
        List<String> language = new List<String>();
        language.add('English');
        language.add('Hindi');
        
        List<String> gender = new List<String>();
        gender.add('Male');
        gender.add('Female');
        
        String country = 'India';
        String status = 'Requested';
        String corporate = 'Capgemini';
        String startDate ='10-05-2021';
        String endDate ='15-05-2021';
        
        MentorMenteeAdminPortal_Controller.getMentorMenteeAssociation(startDate, endDate, country, status, loaction, language, gender, corporate);
    }
    @isTest static void saveMentorMenteeAssociationTest(){
        list<Mentor_Mentee_Association__c> mmaList = [Select Mentor__c,Status__c From Mentor_Mentee_Association__c];
        MentorMenteeAdminPortal_Controller.saveMentorMenteeAssociation(mmaList);
    }
    @isTest static void getMentorDetailsTest(){
        
        List<String> loaction = new List<String>();
        loaction.add('Delhi');
        loaction.add('Karnataka');
        
        List<String> language = new List<String>();
        language.add('English');
        language.add('Hindi');
        
        List<String> gender = new List<String>();
        gender.add('Male');
        gender.add('Female');
        
        String country = 'India';
        
        MentorMenteeAdminPortal_Controller.getMentorDetails(country, loaction, language, gender);
    }
    @isTest static void initializeTest(){
        MentorMenteeAdminPortal_Controller mmaCtrl = new MentorMenteeAdminPortal_Controller();
    }
     @isTest static void getMentorsAvailableTest(){
        String mentorName = [Select Name from contact where Is_Mentor__c = true].Name  ;
        MentorMenteeAdminPortal_Controller.getMentorsAvailable(mentorName);
    }
        @isTest static void searchByCorpTest(){
        String menteeCorporateName = [Select Corporate__c from contact where Is_Mentor__c = true].Corporate__c  ;
        MentorMenteeAdminPortal_Controller.searchByCorp(menteeCorporateName);
    }
}