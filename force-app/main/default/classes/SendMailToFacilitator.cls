/*
* @Purpose      : Batch class to send details of mapped students to facilitator
*/
global class SendMailToFacilitator implements Database.Batchable<sObject>, Database.Stateful,Schedulable 
{   
   
    global Map<String,List<String>> emailMap = new Map<String,List<String>>();
    global String htmlBody = '';
    static final String htmlHeader = 'Dear Facilitator,<p>Below Student(s) have been assigned to you:</p>';
    static final string htmlFooter = '</table></br><p>Please <a href ="'+Utility.getSystemDetails().Application_Site_URL__c+'">click here</a> to your profile to view the assigned students and start the verification process.</p><p>Regards,</br>Foundation For Excellence</p>';
    static final String subject  = 'Assigned Students';
    static final string name = 'student';
    //global Set<String> facilitatorNumbers = new Set<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        date assignedDate = date.today().addDays(-(integer.valueOf(Utility.getSystemDetails().Facilitator_Batch_CurrentDate__c)));
        return Database.getQueryLocator('Select id,firstname,LastName,Mailingcity,FFE_ID__c,Facilitator_Name__r.MobilePhone,MailingStreet,Mailingstate,Facilitator_Name__r.Working_Mode__c,Facilitator_Name__r.email from Contact where recordtype.developername=:name and Facilitator_Name__c!=null and Facilitator_Assigned_Date__c=:assignedDate');
    }
    
    global void execute(SchedulableContext SC) {
      Database.executeBatch(new SendMailToFacilitator(), 200); 
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> conlist)
    {
        
        for(Contact c : conlist){
            //if(c.Facilitator_Name__r.Working_Mode__c == Constants.ONLINE_WORKINGMODE){
                if(!emailMap.containsKey(c.Facilitator_Name__r.email)){
                    
                    htmlBody = '<table border="1" style="border-collapse: collapse;table-layout: fixed;width: 650px">'
                        +'<tr align="center"><th><b>FFEUID</b></th><th><b>Name</th></b><th><b>Street</b></th><th><b>City</b></th><th><b>State</b></th></tr>'
                        +'<tr align="center"><td> '+ c.FFE_ID__c + '</td>'
                        +'<td> '+Utility.checkIfNull(c.FirstName) +' '+Utility.checkIfNull(c.LastName)+'</td>'
                        +'<td> ' + Utility.checkIfNull(c.MailingStreet) + '</td>'
                        +'<td> ' + Utility.checkIfNull(c.MailingCity) + '</td>'
                        +'<td> ' + Utility.checkIfNull(c.MailingState)  + '</td></tr>';
                        emailMap.put(c.Facilitator_Name__r.email,new List<String>{htmlbody});
                }
                else{
                    htmlBody = '<tr align="center"><td> '+ c.FFE_ID__c + '</td>'
                        +'<td> '+Utility.checkIfNull(c.FirstName) +' '+Utility.checkIfNull(c.LastName)+ '</td>'
                        +'<td> ' + Utility.checkIfNull(c.MailingStreet) + '</td>'
                        +'<td> ' + Utility.checkIfNull(c.MailingCity) + '</td>'
                        +'<td> ' + Utility.checkIfNull(c.MailingState)  + '</td></tr>';
                        emailMap.get(c.Facilitator_Name__r.email).add(htmlbody);
                }
                // to send SMS notification
                //facilitatorNumbers.add(String.valueOf(c.Facilitator_Name__r.MobilePhone));system.debug('number'+c.Facilitator_Name__r.MobilePhone);
            //}
        }
    }
    global void finish(Database.BatchableContext BC){
        try{
            
            List<Messaging.SingleEmailMessage> emailsToSend 			= 		new List<Messaging.SingleEmailMessage>();   
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.FFE_Facilitator Limit 1];
            }
            catch(Exception e){
            }
            
            for(String e : emailMap.keySet()){
                string body = string.join(emailMap.get(e),' ');
                mail = Utility.sendMail(subject,string.valueof(htmlHeader+body+htmlFooter),new List<String>{e});
                if(owa.size()>0)
                    mail.setOrgWideEmailAddressId(owa[0].id);
                else
                    mail.setSenderDisplayName(Constants.FFE_Facilitator);
            	emailstosend.add(mail);
            }
            //SMS_Service_CTRL.studentsAssignedToFacilitator(facilitatorNumbers);
            Messaging.sendEmail(emailsToSend);

        }catch(exception e){
            
            e.getMessage();
        }
    }
}