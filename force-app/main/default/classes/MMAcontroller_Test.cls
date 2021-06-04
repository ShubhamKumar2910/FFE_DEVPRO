@isTest public class MMAcontroller_Test {    
    @testSetup public static void allTestData(){
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'Complete Introduction Call';
        validEmailTemplate.DeveloperName = 'Complete_Introduction_Calll';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.Body = 'Hidfsdv vlsbnsbn {!Mentee.Name} jmsodmsomsbms{!Mentor.Name}';
        validEmailTemplate.FolderId = '00l6F000001pqxZQAQ';
        
        insert validEmailTemplate;
    }
    @isTest public static void testStandardSetController (){
        Contact mentee = new Contact();
        Contact mentor = new Contact();
        List<Contact> conList = new List<Contact>();
        
        
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.Email = 'aakash.jain@utilitarianlab.com';
        mentee.is_Mentee__c = true;
        conList.add(mentee);
        
        mentor.FirstName = 'Shubaham';
        mentor.LastName = 'Kumar';
        mentor.Email = 'Shubham.kumar@utilitarianlab.com';
        mentor.Is_Mentor__c = true;
        conList.add(mentor);   
        insert conList;
        
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        List<Mentor_Mentee_Association__c> mmaList = new List<Mentor_Mentee_Association__c>(); 
        List<string> selectedMmmaIdsList = new List<string>();
        mma.mentee_del__c = mentee.Id;
        mma.Mentor__c = mentor.Id;
        mma.Modules__c = 'Career Development';
        mmaList.add(mma);
        insert mmaList;
        set<id> mmaId = new Set<id>();
        mmaId.add(mma.Id);
        selectedMmmaIdsList.add(mma.Id);
        
        
        test.startTest();
        Test.setCurrentPage(Page.MMA_Send_Email);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(mmaList);
        stdSetController.setSelected(mmaList);
        MMAcontroller mmactrl = new MMAcontroller(stdSetController);
        mmactrl.isMentee = true;
        mmactrl.isMentor = true;
        mmactrl.selectedMmaIds = selectedMmmaIdsList;
        mmactrl.selectedEmailtemp = 'Complete Introduction Call';
        mmactrl.getAllEmailTempaltes();
        mmactrl.getEmailTempContent();
        mmactrl.sendEmail();
        //mmactrl.sendEmailNotification(mmaId);
        Test.stopTest();
        
    }
    
}