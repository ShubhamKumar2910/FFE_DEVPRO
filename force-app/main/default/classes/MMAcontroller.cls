public class MMAcontroller {
    public List<EmailTemplate> emailTempList				{get;set;}
    public String selectedEmailtemp							{get;set;}
    public String selectedEmailtempText						{get;set;}
    public Boolean showTextArea								{get;set;}
    public Boolean isMentee									{get;set;}
    public Boolean isMentor									{get;set;}
    public string tempName									{get;set;}	
    List<Mentor_Mentee_Association__c> mmaRecordList		{get;set;}	
    public List<string> selectedMmaIds						{get;set;}
    public string moduleName								{get;set;}
    
    public MMAcontroller(ApexPages.StandardSetController standardController){
        mmaRecordList = standardController.getSelected();
        List<string> emailName = new List<String>();
        showTextArea = false;
        selectedEmailtemp ='--NONE--';
        selectedEmailtempText='';
        emailName.add('Complete Introduction Call');
        emailName.add('Connect with Mentor for Introduction and Session');
        emailName.add('Due Session Reminder');
        emailName.add('Session Reminder to Mentor');
        emailName.add('Complete the Program Reminder For Mentee');
        system.debug('emailName'+emailName);
        system.debug('mmaRecordList'+mmaRecordList);
        emailTempList = [SELECT Name,Id,HTMLvalue FROM EmailTemplate where name in :emailName];
        
        string pageUrl = Apexpages.currentPage().getUrl();								// getting page url
        if(pageUrl.length() > 20){
            string mmaIdsToBeProcessed = pageUrl.substring(21, pageUrl.length() - 1); 		// removing extra piece
            selectedMmaIds = mmaIdsToBeProcessed.split('=&');                          		//splitting by =& ang setting in list<string>
            system.debug('pageUrl=>'+pageUrl);
            system.debug('mmaIdsToBeProcessed=>'+mmaIdsToBeProcessed);
            system.debug('selectedMmaIds=>'+selectedMmaIds);
        }
    }
    
    public List<SelectOption> getAllEmailTempaltes() 
    {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = 0; i < emailTempList.size(); i++)
        {
            SelectOption option = new SelectOption(emailTempList[i].Name,emailTempList[i].Name);
            options.add(option);
        }
        
        return options;
    }
    public void getEmailTempContent(){
        for(EmailTemplate email:emailTempList){
            System.debug(email);
            if(email.Name == selectedEmailtemp){
                selectedEmailtempText = email.HTMLvalue;
                showTextArea = true;
                System.debug(selectedEmailtempText);
                system.debug('Menteeeee'+isMentee);
                system.debug('Menteeeee'+isMentor);
            }
        }
    }
    
    // Initialize setCon and return a list of records
    public List<Mentor_Mentee_Association__c> getMMAList() {
        return null;
        //return (List<Mentor_Mentee_Association__c>) setCon.getRecords();
    }
    
    public void sendEmail(){
        set<Id> menteeId = new set<id>();
        set<Id> mentorId = new set<id>();
        set<Id> mmaId = new set<id>();
        
        system.debug('isMentee'+isMentee);
        system.debug('isMentor'+isMentor);
        system.debug('selectedMmaIds'+selectedMmaIds);
        
        List<Mentor_Mentee_Association__c> mmaIdList = [Select id,Name,mentee_del__c,Mentor__c from Mentor_Mentee_Association__c where Id in :selectedMmaIds];
        
        for(Mentor_Mentee_Association__c mmaRec : mmaIdList){
            if(isMentee == true){
                menteeId.add(mmaRec.mentee_del__c);
            }
            if(isMentor == true){
                mentorId.add(mmaRec.Mentor__c);
            }
            mmaId.add(mmaRec.id);
        }
        
        system.debug('menteeId'+menteeId);
        system.debug('mentorId'+mentorId);
        system.debug('selectedEmailtemp'+selectedEmailtemp);
        sendEmailNotification(mmaId);
    }
    
    public void sendEmailNotification(Set<id> mmaIds){
        List<Mentor_Mentee_Association__c> mmaList = [SELECT Mentee_Email__c,Mentor_Email__c,Mentee_Name__c,Mentor_Name__c FROM Mentor_Mentee_Association__c where Id in:mmaIds] ;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTempRec=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: selectedEmailtemp limit 1];
        
        for (Mentor_Mentee_Association__c mmaRec : mmaList) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> recipients = new List<String>();
            if(isMentee == true) recipients.add(mmaRec.Mentee_Email__c);
            if(isMentor == true) recipients.add(mmaRec.Mentor_Email__c);
            
            system.debug('recipients------'+recipients);
            mail.setToAddresses(recipients);
            mail.setSenderDisplayName('FFE Mentoring Team');
            
            String subject = emailTempRec.Subject;
            system.debug('subject==>'+subject);
            String htmlBody = emailTempRec.HtmlValue;
            
            htmlBody = htmlBody.replace('{!Mentee.Name}', mmaRec.Mentee_Name__c);
            htmlBody = htmlBody.replace('{!Mentor.Name}', mmaRec.Mentor_Name__c);
            htmlBody = htmlBody.replace('{!Module.Name}', moduleName); 
            
            system.debug('htmlBody==>'+htmlBody);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            
            mails.add(mail);
        }
        System.debug('mails==>'+mails);
        system.debug('mails.size()==>'+mails.size());
        Messaging.sendEmail(mails);
    }
}