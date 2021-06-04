/*
* @description : Send 80G form to donor and attach the form to Payment Order
* 				  as an attachment.
*/ 
global class SendITCertificate {
    
    webservice static string send80GForm(String orderId){
        return sendTaxForm(orderId);
    }
    
    public static string sendTaxForm(string orderId){
        SavePoint sp = Database.setSavepoint();
        try{
            List<String> toEmail = new List<String> ();
            
            //generate and attach the PDF document
            PageReference pdfPage = Page.TaxExemptionForm;
            pdfPage.getParameters().put('id',orderId);
            
            //get the output of the page, as displayed to a user in a browser
            Blob  pdfBlob;
            if(test.isRunningTest()){
                pdfBlob=Blob.valueOf('UNIT.TEST');
                
            }else{
                pdfBlob = pdfPage.getContent();   
            }
            
            Payment_Order__c payment = [select Id,Donor__r.Name,Donor__c From Payment_Order__c where Id =: orderId];
            
            //create the attachment object
            Attachment attach = new Attachment(parentId = orderId, Name = payment.Donor__r.Name+'_80gform.pdf', body = pdfBlob); 
            insert attach;
            
            
            Contact con = [select Id,Name, Email From Contact where Id =: payment.Donor__c];
            toEmail.add(con.Email);
            
            EmailTemplate et = new EmailTemplate();
            et = [select Id from EmailTemplate where DeveloperName =:Constants.IT_CERTIFICATE_TEMPLATE Limit 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSaveAsActivity(false);
            email.setWhatId(payment.Id);
            email.setTemplateId(et.Id);
            email.setTargetObjectId(con.Id);
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
                if(owa.size()>0)
                    email.setOrgWideEmailAddressId(owa[0].id);
                else
                    email.setSenderDisplayName(Constants.FFE_NAME);
            }
            catch(Exception e){
            }
            
            if(!toEmail.isEmpty())
                email.setToAddresses(toEmail);
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Attachment att = [select Name, Body, BodyLength from Attachment where Id =: attach.Id];
            
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(att.Name);
            efa.setBody(att.Body);
            fileAttachments.add(efa);
            
            email.setFileAttachments(fileAttachments);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return Constants.MAIL_SENT_SUCCESS_MSG;
        }catch(Exception e){
            database.rollback(sp);
            return Constants.ERROR_MSG;
        }
    }
}