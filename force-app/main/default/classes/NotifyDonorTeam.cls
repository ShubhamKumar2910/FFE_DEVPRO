public class NotifyDonorTeam {
    
    /*
*@ purpose : To Convert List - Map
*/
    @TestVisible
    private static Map<Id, Contact> makeMapFromSObjectList(List<Contact> lstSobject) {
        
        if (lstSobject == null) return null;
        Map<Id, Contact> theMap = new Map<Id, Contact>();
        for (Contact s : lstSobject) {
            theMap.put((Id)s.get('Id'), s);
        }
        return theMap;
    }
    
    // Wrapper Class - Related
    public static NotifyDonorTeam.paymentWrapper publicGroupCreation(){
        
        NotifyDonorTeam.paymentWrapper paywrap = new  NotifyDonorTeam.paymentWrapper();
        
        List<String> UserList = new List<String>();
        
        OrgWideEmailAddress ot =  [Select id,DisplayName,Address from OrgWideEmailAddress Where Address =:'crm@ffe.org'];
        paywrap.OrgmailAddr.add(ot); 
        List<EmailTemplate> emailTmpList = [SELECT Id,Name FROM EmailTemplate WHERE name =:Label.Donor_Notification OR name =:Label.Failed_Notification];
        
        for(EmailTemplate et :emailTmpList){
            if(et.Name == Label.Donor_Notification_Template){
                paywrap.EmailTemplate =  et.id;
            }else{
                paywrap.FailEmailTemplate =  et.id;
            }
        }
        
        // Fetch Public Group Users
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =:Label.Donor_Team_For_Public_Group];
        for (GroupMember gm : g.groupMembers) {
            UserList.add(gm.userOrGroupId);
        }
        User[] usr = [SELECT email,MobilePhone FROM user WHERE id IN :UserList];
        for(User u : usr) {
            paywrap.mailAddresses.add(u.email);
            paywrap.mobile.add(u.MobilePhone);
        }
        
        List<String> nonScholarEmlList =  System.Label.EmailTodonorForNonScholar.split(',');
        List<String> ScholarEmlList =  System.Label.EmailToDonorForScholar.split(',');
        List<String> ScholarSMSList = System.Label.SMSToDonorForScholar.split(',');
        List<String> nonScholarSMSList =System.Label.SMSToDonorFornonScholar.split(',');
        
        
        
        List<String> paymentOrderMail =System.Label.PaymentOrderEmails.split(',');
        List<String> paymentOrderSMS =System.Label.PaymentOrderSMS.split(',');
        List<String> paymentOrderMailForNonScholar =System.Label.PaymentOrderEmails_For_Non_Scholar.split(',');
        List<String> paymentOrderSMSForNonScholar =System.Label.PaymentOrderSMS_For_Non_Scholar.split(',');
        
        paywrap.scholarEmailAddresses.addall(ScholarEmlList);
        paywrap.nonScholarEmailAddresses.addall(nonScholarEmlList);
        paywrap.scholarSMS.addall(ScholarSMSList);
        paywrap.nonScholarSMS.addall(nonScholarSMSList);
        paywrap.mailAddresses.addall(paymentOrderMail);
        paywrap.mobile.addall(paymentOrderSMS);
        paywrap.mailAddressesforNonScholar.addall(paymentOrderMailForNonScholar);
        paywrap.mobileforNonScholar.addall(paymentOrderSMSForNonScholar);
        return paywrap;
    }
    
    
    /*
*@ purpose : If Donor has trying to changes his PAN,Mobile,Phone,Email, Mailing Address then FFE Public group got Notify.
*@Parameter  : Trigger.old , Trigger.New
*/ 
    
    public static void donorFieldChangesUpdate(List<Contact> oldList,List<Contact> newList){
        
        String finalString = '';
        //called wrapper Class 
        NotifyDonorTeam.paymentWrapper paywrap2= NotifyDonorTeam.publicGroupCreation();
        Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
            Integer i = 1;
        
        boolean isScholar= false;
        boolean isnotScholar = false;
        for(Contact con : newList){
            
            Id donerRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
            Map<Id,Contact> conOldRecordMap = NotifyDonorTeam.makeMapFromSObjectList(oldList);
            
            if(con.RecordTypeId == donerRecType && ( 
                con.MobilePhone !=conOldRecordMap.values().MobilePhone || con.Phone !=conOldRecordMap.values().Phone 
                ||con.Email !=conOldRecordMap.values().Email )) {
                   
                    if(newList.size()>1){
                        finalString = i+') '+con.FirstName +' '+ con.LastName +', '+con.FFE_ID__c+'  '; 
                        i = i+1;
                    }else{
                        finalString = con.FirstName +' '+ con.LastName +', '+con.FFE_ID__c+' donor has changed his/her profile details, please check email for details.'; 
                    }
                    if(con.DN_Donor_Category__c == 'Alumni Donor' || con.DN_Donor_Category__c =='Alumni Scholar'){
                        Messaging.SingleEmailMessage mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(paywrap2.EmailTemplate,con.Id,null,paywrap2.scholarEmailAddresses,paywrap2.OrgmailAddr);
                        mailList.add(mail);
                        isScholar= true;
                    }else{
                        Messaging.SingleEmailMessage mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(paywrap2.EmailTemplate,con.Id,null,paywrap2.nonScholarEmailAddresses,paywrap2.OrgmailAddr);
                        mailList.add(mail);
                        isnotScholar = true;
                    }
                    
                } 
        }
        
        if(newList.size()>1){
            finalString = finalString + ' donors has changed there profile details, please check email for details.'; 
        }
        Messaging.sendEmail(mailList);
        Set<String> smsSet = new Set<String>();
        if(isScholar)
            smsSet.addAll(paywrap2.scholarSMS);
        if(isnotScholar)
            smsSet.addAll(paywrap2.nonScholarSMS);
        List<String> smsList = new List<string>();
        smsList.addall(smsSet);
        Constants.Contact_TRIGGER_RUNNING = true;
        SMS_Service_CTRL.singleListOfString_To_String(smsList,finalString);
    }
    /*
*@ purpose : When donor is created then send Email & SMS to the donor.
*@Parameter  : Trigger.old , Trigger.New
*/ 
    public static void donorCreateNotification(List<Contact> oldList,List<Contact> newList){
        
        try{
            String Msg = '';
            boolean isScholar= false;
            boolean isnotScholar = false;
            List<String>  EmailListForNonScholar  = System.Label.EmailToDonorTeam_for_Donor_Registration.split(',');
            List<String>  SMSListForNonScholar    = System.Label.SMSToDonorTeam_for_Donor_Registration.split(',');
            List<String>  EmailListForScholar     = System.Label.EmailToDonorTeam_for_Donor_Registration_ScholarTeam.split(',');
            List<String>  SMSListForScholar       = System.Label.SMSToDonorTeam_for_Donor_Registration_ScholarTeam.split(',');
            
            List<EmailTemplate> emailTmpList = [SELECT Id,Name FROM EmailTemplate WHERE name =:Label.New_Donor_Creation];
            List<OrgWideEmailAddress> ot =  [Select id,DisplayName,Address from OrgWideEmailAddress Where Address =:'crm@ffe.org'];
            Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
                
                for(Contact con : newList){
                    Id donerRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
                    if(con.RecordTypeId == donerRecType){
                        if(con.DN_Donor_Category__c == 'Alumni Donor' || con.DN_Donor_Category__c =='Alumni Scholar'){
                            Messaging.SingleEmailMessage mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(String.valueOf(emailTmpList[0].id),con.Id,null,EmailListForScholar,ot);
                            mailList.add(mail);
                            Msg = con.FirstName+' '+con.LastName+', '+con.FFE_ID__c+' ';
                            isScholar = true;
                        }
                        else {
                            Messaging.SingleEmailMessage mail = Utility.sendMailWithTemplateforBusinessAccountUtilization(String.valueOf(emailTmpList[0].id),con.Id,null,EmailListForNonScholar,ot);
                            mailList.add(mail);
                            Msg = con.FirstName+' '+con.LastName+', '+con.FFE_ID__c+' ';
                            isnotScholar = true; 
                        } 
                    }                   
                }
            Msg = Msg + System.label.DonorRegisterNotifyDonorTeam;
            // for Mail Send
            Messaging.sendEmail(mailList);
           // for SMS Send
            if(isScholar)
                SMS_Service_CTRL.singleListOfString_To_String(SMSListForScholar,Msg);
            if(isnotScholar)
                SMS_Service_CTRL.singleListOfString_To_String(SMSListForNonScholar,Msg);    
        }
        catch(Exception e){
            HandleBusinessException.captureError('NotifyDonorTeam', 'donorCreateNotification', e);
        } 
        
    }
    
    // Wrapper Class
    public class paymentWrapper{
        
        public   string EmailTemplate; 
        public   string FailEmailTemplate;
        public   List<OrgWideEmailAddress> OrgmailAddr;
        public   List<string> mailAddresses; 
        public   List<string> scholarEmailAddresses;
        public   List<String> nonScholarEmailAddresses;
        public   List<string> scholarSMS;
        public   List<String> nonScholarSMS;
        public   List<string> mobile;
        public   List<string> mailAddressesforNonScholar;
        public   List<string> mobileforNonScholar;
        
        public paymentWrapper(){
            FailEmailTemplate = '';
            EmailTemplate = '';
            OrgmailAddr = new List<OrgWideEmailAddress>();
            mailAddresses =new List<string>();
            scholarEmailAddresses = new List<string>();
            nonScholarEmailAddresses = new List<string>();
            scholarSMS = new List<string>();
            nonScholarSMS = new List<string>();
            mobile = new List<string>();
            mailAddressesforNonScholar = new List<string>();
            mobileforNonScholar = new List<string>();
        }
        
    }
}