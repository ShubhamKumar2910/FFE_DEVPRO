public class FFE_ContactTriggerHandler
{
    public static void formatFieldValue(List<Contact> listContact)
    {
        List<FFE_Field_Data_Tweaking__mdt> listFieldDataTweaking = [SELECT
            Id, 
            FFE_Field_API_Name__c
        FROM
            FFE_Field_Data_Tweaking__mdt
        WHERE
            FFE_Object_Name__c = 'Contact' AND isActive__c = true];
        if(listFieldDataTweaking != null && listFieldDataTweaking.size() > 0)
        {
            for(Contact objCon: listContact)
            {
                for(FFE_Field_Data_Tweaking__mdt objFieldDataTweaking: listFieldDataTweaking)
                {
                    if(objCon.get(objFieldDataTweaking.FFE_Field_API_Name__c) != null && string.isNotBlank(string.valueOf(objCon.get(objFieldDataTweaking.FFE_Field_API_Name__c))))
                    {
                        string strData = string.valueOf(objCon.get(objFieldDataTweaking.FFE_Field_API_Name__c));
                        List<string> listStr = strData.trim().split(' ');
                        for(Integer i = 0; i < listStr.size(); i++)
                        {
                            listStr[i] = listStr[i].toLowerCase();
                            System.debug('Test1***** ' + listStr[i]);
                            if(listStr[i].contains('\n'))
                            {
                                System.debug('Test contains n***** ' + listStr[i]);
                                List<string> listStrNew = listStr[i].trim().split('\n');
                                for(Integer j = 0; j < listStrNew.size(); j++)
                                {
                                    listStrNew[j] = listStrNew[j].capitalize();
                                }
                                listStr[i] = string.join(listStrNew, '\n');
                            }
                            listStr[i] = listStr[i].capitalize();
                            System.debug('Test2***** ' + listStr[i]);
                        }
                        strData = string.join(listStr, ' ');
                        if(objFieldDataTweaking.FFE_Field_API_Name__c == 'X11_character_IFSC_Code_of_the_Branch__c' || objFieldDataTweaking.FFE_Field_API_Name__c == 'Mother_Education__c' || objFieldDataTweaking.FFE_Field_API_Name__c == 'Father_Education__c')
                        {
                            objCon.put(objFieldDataTweaking.FFE_Field_API_Name__c, strData.toUpperCase());
                        }
                        else
                        {
                            objCon.put(objFieldDataTweaking.FFE_Field_API_Name__c, strData);
                        }
                    }
                }
            }
        }
    }
    @Future (callout = true )
    public static void sendStudentApplicationAsAttachment(Id idContact, string strFirstName, string strLastName, string strFFEId, string strEmail)
    {
        Contact con=[select id,Facilitator_Name__r.Anaxee_Facilitator__c from contact where id=:idContact];
        if(con!=null && !con.Facilitator_Name__r.Anaxee_Facilitator__c){//check added to send email only for non vendor Facilitator -- Sumit Gaurav -- 11-06-2019
            PageReference pdf = Page.scholar_profile;
            Attachment attach = new  Attachment();
            pdf.getParameters().put('ScholarId', idContact);
            Blob body;
            Boolean boolErrorFlag = false;
            try
            {
                if(!Test.isRunningTest())
                body = pdf.getContent();
                else
                body = Blob.valueOf('test data');    
                attach.Body = body;
                attach.Name = 'Application_' + strFirstName + '_' + strLastName + '_' + strFFEId + '.pdf';
                attach.IsPrivate = false;
                attach.ParentId = idContact;
                Insert attach;
            }
            catch(Exception e)
            {
                body = Blob.valueOf('Attachment Data missing. Please contact FFE Admin');
                HandleBusinessException.captureError('FFE_ContactTriggerHandler', 'sendStudentApplicationAsAttachment', e);
                boolErrorFlag = true;
            }
            Messaging.SingleEmailMessage mail = new  Messaging.SingleEmailMessage();
            List<string> listSendingTo = new  List<string>();
            listSendingTo.add(strEmail);
            mail.setToAddresses(listSendingTo);
            if(!boolErrorFlag)
            {
                List<Messaging.EmailFileAttachment> attachments = new  List<Messaging.EmailFileAttachment>();
                Messaging.EmailFileAttachment efa = new  Messaging.EmailFileAttachment();
                efa.setFileName(attach.Name);
                efa.setBody(attach.Body);
                efa.setContentType(attach.ContentType);
                attachments.add(efa);
                List<string> listDocDevName = Label.DocumentsToSent.split(';');
                List<Document> listDocs = [SELECT
                    Id, 
                    name, 
                    developername, 
                    contenttype, 
                    body
                FROM
                    Document
                WHERE
                    developername in: listDocDevName];
                if(Test.isRunningTest()){
                    listDocs = [SELECT
                    Id, 
                    name, 
                    developername, 
                    contenttype, 
                    body
                FROM
                    Document];
                }    
                for(Document objDoc: listDocs)
                {
                    Messaging.EmailFileAttachment mefa = new  Messaging.EmailFileAttachment();
                    if(!objDoc.Name.endsWith('.pdf'))
                    {
                        mefa.setFileName(objDoc.Name + '.pdf');
                    }
                    else
                    {
                        mefa.setFileName(objDoc.Name);
                    }
                    mefa.setBody(objDoc.Body);
                    mefa.setContentType(objDoc.ContentType);
                    attachments.add(mefa);
                }
                mail.setFileAttachments(attachments);
            }
            EmailTemplate template = [SELECT
                Id, 
                Subject, 
                HtmlValue
            FROM
                EmailTemplate
            WHERE
                DeveloperName = 'Facilitator_Details'
            limit 1];//Changed Email template name  from StudentEligibleTemplate to Facilitator_Details -- Sumit Gaurav -- 09-June-2020
            mail.setTemplateId(template.Id);
            List<OrgWideEmailAddress> addresses = [SELECT
                Id
            FROM
                OrgWideEmailAddress
            WHERE
                DisplayName = 'Foundation For Excellence'
            limit 1];
            if(addresses != null && !addresses.isEmpty())
            {
                mail.setOrgWideEmailAddressId(addresses[0].Id);
            }
            mail.setTargetObjectId(idContact);
            mail.setSaveAsActivity(true);//cahnged setSaveAsActivity to true to keep track of email -- Sumit Gaurav -- 09-June-2020
            try
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            }
            catch(Exception e)
            {
                HandleBusinessException.captureError('FFE_ContactTriggerHandler', 'sendStudentApplicationAsAttachment', e);
                throw e;
            }
        }
    }
    
    public static void afterUpdate_Send80GForm(List<Id> listDonorIds){
        string strFinYear = Utility.financialYear();
        List<Contact> listDonors = [select id, (select Id from Payment_Orders__r where Is_Email_sent__c = false and Financial_Year__c =:strFinYear and CCAvenue_Payment_Status__c = 'Success' and (Payment_Method__c!='Interest' OR Payment_Method__c!='Foreign Fund Transfer')) From Contact where id in :listDonorIds ];

        List<Id> listPOs = new List<Id>();
        for(Contact objCon: listDonors){
            for(Payment_Order__c objPO: objCon.Payment_Orders__r){
                listPOs.add(objPO.id);
            }
        }   
        if(listPOs != null && listPOs.size()>0){    
            PaymentOrderTriggerHelper.afterUpdate_Send80GForm(listPOs);
        }
    }

    
}