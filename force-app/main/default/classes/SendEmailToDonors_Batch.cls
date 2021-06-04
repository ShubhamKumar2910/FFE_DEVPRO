global class SendEmailToDonors_Batch implements Database.Batchable<sObject>, Schedulable, Database.Stateful
{
    global Map<Id, string> errorMap
    {
        get;set;
    }
    global Map<Id, SObject> IdToSObjectMap
    {
        get;set;
    }
    global SendEmailToDonors_Batch()
    {
        errorMap = new  Map<Id, string>();
        IdToSObjectMap = new  Map<Id, SObject>();
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string strFinYear = Utility.financialYear();
        //string strQuery = 'SELECT Id,(SELECT id, StageName FROM Opportunities__r limit 1),Is_Email_sent__c,Donor_Reminder_Email_Check_Flag__c, Email__c,Donor__r.Email FROM Payment_Order__c WHERE Donor__r.X80G_Not_Required__c = false AND Financial_Year__c =:strFinYear AND CCAvenue_Payment_Status__c=\'Success\' AND Is_Email_sent__c = false';006O000000CuvOc
        //string strQuery =  'SELECT Id, CCAvenue_Payment_Status__c, Mailling_Address__c, Financial_Year__c, Is_Email_sent__c, PAN__c, Mobile__c, Donor__r.Email, Donor__r.DN_Citizenship__c, Donor__r.X80G_Not_Required__c, (SELECT id, StageName FROM Opportunities__r limit 1) FROM Payment_Order__c WHERE Is_Email_sent__c = false AND Financial_Year__c =:strFinYear AND CCAvenue_Payment_Status__c=\'Success\' AND Donor__r.X80G_Not_Required__c = false AND id = \'a0xO000000F4iIM\'' ; 
        string strQuery = 'SELECT Id,Name,Quick_Donation__c, CCAvenue_Payment_Status__c, Mailling_Address__c, Financial_Year__c, Is_Email_sent__c, PAN__c, Mobile__c, Donor__r.Email,Donor__r.MailingAddress,Donor__r.DN_PAN__c, Donor__r.DN_Citizenship__c, Donor__r.X80G_Not_Required__c, (SELECT id,Is_Program_Frequency_Unknown__c, StageName FROM Opportunities__r limit 1) FROM Payment_Order__c WHERE Is_Email_sent__c = false AND Financial_Year__c =:strFinYear AND CCAvenue_Payment_Status__c=\'Success\'';
        return Database.getQueryLocator(strQuery);
    }
    global void execute(Database.BatchableContext BC, List<Payment_Order__c> scope)
    {
        List<Payment_Order__c> listPaymentOrdersToBeUpdated = new  List<Payment_Order__c>();
        for(Payment_Order__c objPaymentOrder: scope)
        {
            if(((((objPaymentOrder.Donor__r.DN_Citizenship__c == 'Indian' && string.isBlank(objPaymentOrder.Donor__r.DN_PAN__c)) || objPaymentOrder.Donor__r.DN_Citizenship__c != 'Indian') || objPaymentOrder.Donor__r.MailingAddress != null) || (((!objPaymentOrder.Quick_Donation__c && (objPaymentOrder.Opportunities__r != null && objPaymentOrder.Opportunities__r.size() > 0 && objPaymentOrder.Opportunities__r[0].Is_Program_Frequency_Unknown__c)) || objPaymentOrder.Quick_Donation__c))) && ((objPaymentOrder.Opportunities__r != null && objPaymentOrder.Opportunities__r.size() > 0 && objPaymentOrder.Opportunities__r[0].StageName == 'Posted')) && !objPaymentOrder.Donor__r.X80G_Not_Required__c)
            {
                objPaymentOrder.Donor_Reminder_Email_Check_Flag__c = true;
                listPaymentOrdersToBeUpdated.add(objPaymentOrder);
            }
        }
        if(listPaymentOrdersToBeUpdated != null && listPaymentOrdersToBeUpdated.size() > 0)
        {
            List<Database.SaveResult> dsrs = Database.Update(listPaymentOrdersToBeUpdated, false);
            Integer index = 0;
            for(Database.SaveResult dsr: dsrs)
            {
                if(!dsr.isSuccess())
                {
    SendEmailToDonors_Batch objSendEmailToDonorsBatch = new  SendEmailToDonors_Batch();
        database.executebatch(objSendEmailToDonorsBatch, 200);                string errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(listPaymentOrdersToBeUpdated[index].Id, errMsg);
                    IdToSObjectMap.put(listPaymentOrdersToBeUpdated[index].Id, listPaymentOrdersToBeUpdated[index]);
                }
                index++;
            }
        }
    }
    global void execute(SchedulableContext SC)
    {
        Database.executeBatch(new  SendEmailToDonors_Batch(), 100);
    }
    global void finish(Database.BatchableContext BC)
    {
        if(!errorMap.isEmpty() || Test.isRunningTest())
        {
            AsyncApexJob a = [SELECT
                id, 
                ApexClassId, 
                JobItemsProcessed, 
                TotalJobItems, 
                NumberOfErrors, 
                CreatedBy.Email
            FROM
                AsyncApexJob
            WHERE
                id = : BC.getJobId()];
            string body = 'Your batch job ' + 'SendEmailToDonors_Batch ' + 'has finished. \n' + 'There were ' + errorMap.size() + ' errors. Please find the error list attached.';
            string finalstr = 'Id, Name, Error \n';
            string subject = 'Send Email to Donors errors';
            string attName = 'Errors.csv';
            for(Id id: errorMap.keySet())
            {
                string err = errorMap.get(id);
                Payment_Order__c objPaymentOrder = (Payment_Order__c)IdToSObjectMap.get(id);
                string recordString = '"' + id + '","' + objPaymentOrder.Name + '","' + err + '"\n';
                finalstr = finalstr + recordString;
            }
            Messaging.SingleEmailMessage email = new  Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa = new  Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            email.setSubject(subject);
            List<string> listEmails = Label.ErrorSendEmail.split(',');
            email.setToAddresses(listEmails);
            email.setPlainTextBody(body);
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{efa});
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }
    }
}