global class AluminiToDonorBatch_FFE implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    public static Messaging.SingleEmailMessage[] AlumniToDonorEmailMessageList = new Messaging.SingleEmailMessage[]{};
    Integer currentYear = System.Today().year();
    ID studentRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(Test.isRunningTest())
        {
            return Database.getQueryLocator('SELECT id,(select id,Internal_Status__c, Application_Stage__c from Applications__r),Course__c,Financial_year__c,RecordTypeId,Current_year__c,Active_Application_ID__c,Is_Active_Alumni__c from Contact');
        }
        else
        {
            return Database.getQueryLocator('select id, (select id,Internal_Status__c, Application_Stage__c from Applications__r where Internal_Status__c = \'Disbursed\' AND Application_Stage__c = \'Closed\') from contact where GYear2__c <= :currentYear AND RecordTypeId=:studentRecordType');
        }
    }
    global void execute(SchedulableContext SC)
    {
        Database.executeBatch(new  AluminiToDonorBatch_FFE(), 100);
    }
    global void execute(Database.BatchableContext BC, List<Contact> newList)
    {
        try
        {
            ID DonorRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Donor_Donor).getRecordTypeId();
            List<Contact> aluminiToDonorUpdate = new  List<Contact>();
            EmailTemplate AlumniToDonor = [SELECT
                id, 
                Developername
            FROM
                EmailTemplate
            WHERE
                Developername = : Constants.AluminiToDonor
            Limit 1];
            for(Contact con: newList)
            {
                if(con.Applications__r != null && con.Applications__r.size() > 0)
                {
                    aluminiToDonorUpdate.add(new  Contact(ID = con.id, RecordTypeId = DonorRecordTypeID, Is_Active_Alumni__c = true, DN_Donor_Category__c = 'Scholar', DN_Citizenship__c = 'Indian', DN_Year_Of_Graduation__c = string.valueOf(currentYear)));
                    AlumniToDonorEmailMessageList.add(Utility.sendEmailWithTemplateBulk(con.id, AlumniToDonor.id));
                }
            }
            if(!aluminiToDonorUpdate.isEmpty())
            {
                Constants.Contact_TRIGGER_RUNNING = true;
                Update aluminiToDonorUpdate;
            }
            try
            {
                if(AlumniToDonorEmailMessageList != null)
                {
                    Messaging.sendEmail(AlumniToDonorEmailMessageList);
                }
            }
            catch(Exception e)
            {
                HandleBusinessException.captureError('AluminiToDonorBatch', 'Execute', e);
            }
        }
        catch(Exception e)
        {
        }
    }
    global void finish(Database.BatchableContext BC)
    {
    }
}