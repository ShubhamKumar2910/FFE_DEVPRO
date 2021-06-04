@isTest
public class MentorDetailPageController_Test {
    @testSetup  static void allTestData(){
        List<Contact> conList = new List<Contact>();
        test.startTest();
        Contact conMentor = new Contact();
        conMentor.FirstName =  'Ajeet';
        conMentor.LastName =  'Kumar';
        conMentor.Is_Mentor__c =  true;
        conMentor.Email = 'Ajeet@mailinator.com';
        conList.add(conMentor) ;
        
        Contact conMentee = new Contact();
        conMentee.FirstName =  'Aakash';
        conMentee.LastName =  'Jain';
        conMentee.Email = 'aakash@mailinator.com';
        conList.add(conMentee);
       
        insert conList;
        
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        mma.mentee_del__c = conMentee.Id;
        mma.Mentor__c = conMentor.Id;
        mma.Status__c = 'Approved';
        insert mma;
        Session__c ss = new Session__c();
        ss.Mentor_Mentee_Association__c = mma.Id;
        ss.Description__c = 'Test Description';
        insert ss;
        test.stopTest();
    }
    
    @isTest public static void registerMentorFromGoogleTest(){
        MentorDetailPageController.registerMentorFromGoogle('Aakash','Jain','aakash2510jain@gmail.com','aakash@123');
        
    }
    @isTest public static void registerMentorFromFacebookTest(){
        MentorDetailPageController.registerMentorFromFacebook('Aakash Jain','aakash2510jain@gmail.com','aakash@123');
        
    }
    @isTest public static void getMentorDetailsTest(){
        Contact mentorDetail = [Select id from contact where FirstName = 'Ajeet'];
        string ans = getHashCode(mentorDetail.Id);
        MentorDetailPageController.getMentorDetails(ans);
        MentorDetailPageController.mentorSignOut(mentorDetail.Id);
        MentorDetailPageController.updateMentorDetails(mentorDetail);
    }
    @isTest public static void getMenteeDetailsTest(){
        Contact mentorDetail = [Select id from contact where FirstName = 'Ajeet'];
        string ans = getHashCode(mentorDetail.Id);
        MentorDetailPageController.getMenteeDetails(ans);
      //  MentorDetailPageController.getMenteeDetails
    }
    @isTest public static void getProgramDetailsTest(){
        Program__c prgrm = new Program__c();
        prgrm.Name = 'Communication Skills';
        prgrm.Skills__c = 'Communication Skills';
        insert prgrm;
        
        Attachment att = new Attachment();
        att.ParentId = prgrm.Id;
        String newBody = 'Att body';
        att.Body = EncodingUtil.base64Decode(newBody);
        att.Name = 'test';
        insert att; 
        MentorDetailPageController.getProgramDetails();
        
    }
    
    @isTest public static void getAllSessionsTest(){
        Program__c prgrm = new Program__c();
        prgrm.Name = 'Communication Skills';
        prgrm.Skills__c = 'Communication Skills';
        insert prgrm;
        
         
        
        Mentor_Mentee_Association__c mmaRec = [Select Id from Mentor_Mentee_Association__c limit 1];
        test.startTest();
        Session__c ss = new Session__c();
        ss.Mentor_Mentee_Association__c = mmaRec.Id;
        ss.Description__c = 'Test Description';
        insert ss;
        
        Attachment att = new Attachment();
        att.ParentId = ss.Id;
        String newBody = 'Att body';
        att.Body = EncodingUtil.base64Decode(newBody);
        att.Name = 'test';
        insert att;
        
        Feedback__c fd = new Feedback__c();
        fd.Mentee_Rating__c = 'Helpfull';
        fd.Mentor_Rating__c = 'sincere students';
        fd.Feedback_given_by__c = 'MENTEE';
        fd.Session__c = ss.Id;
        insert fd;
        
        MentorDetailPageController.getAllSessions(mmaRec.Id);
        test.stopTest();
    }
    @isTest public static void createNewSessionTest(){
        String mmaRecName = [Select Name from Mentor_Mentee_Association__c limit 1].Name;

        MentorDetailPageController.createNewSession('11-05-2021', 11, 00, 03, 00,'coding','Introduction on coding',mmaRecName, 'www.salesforce.com');
            //createNewSession('11-05-2021', 11, 00, 02, 00, 'sessionDescription', 'agenda', mmaRec.Id);
        
    }
    @isTest public static void updateSessionTest(){
        Mentor_Mentee_Association__c mmaRec = [Select Id from Mentor_Mentee_Association__c limit 1];
        Session__c ss = new Session__c();
        ss.Mentor_Mentee_Association__c = mmaRec.Id;
        ss.Description__c = 'Test Description';
        insert ss;
        
        MentorDetailPageController.updateSession('11-05-2021', 12, 00, 03, 00, ss.Id);
        
    }
         @isTest public static void markSessionAsCompletedTest(){
        Mentor_Mentee_Association__c mmaRec = [Select Id from Mentor_Mentee_Association__c limit 1];
        Session__c ss = new Session__c();
        ss.Mentor_Mentee_Association__c = mmaRec.Id;
        ss.Description__c = 'Test Description';
        insert ss;
        MentorDetailPageController.markSessionAsCompleted(ss);
        
    }
    @isTest public static void submitFeedBackTest(){
        Session__c Session = [Select Id from Session__c limit 1];
         
        MentorDetailPageController.submitFeedBack(Session.Id, 'feedBackDescription', '10');
        
    }
    @isTest public static void doUploadProfilePicTest(){
        Contact conMentor = [Select Id from Contact where FirstName = 'Ajeet' limit 1];
         
        MentorDetailPageController.doUploadProfilePic(conMentor.Id, 'attachmentBody', 'attachmentName');
        MentorDetailPageController mentorDtlPgCtrl = new MentorDetailPageController();
        mentorDtlPgCtrl.checkUserAuth();
        mentorDtlPgCtrl.getDocumentBaseURL();
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