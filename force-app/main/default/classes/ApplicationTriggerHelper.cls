public class ApplicationTriggerHelper
{
    private static ApplicationTriggerHelper instance;
    public static ApplicationTriggerHelper getInstance()
    {
        if(instance == null)
        {
            instance = new  ApplicationTriggerHelper();
        }
        return instance;
    }
    public void onAfterApplicationClose(List<Application__c> appList)
    {
        SavePoint sp = Database.setSavepoint();
        try
        {
            Set<string> studentID = new  Set<string>();
            for(Application__c app: appList)
            {
                if(app.Application_Stage__c == Constants.APP_STAGE_CLOSED)
                {
                    studentID.add(app.Student__c);
                }
            }
            if(studentID.size() > 0)
            {
                List<Application__c> applicationList = [SELECT
                    id, 
                    Application_Stage__c, 
                    Semester__c, 
                    Name, 
                    Internal_Status__c, 
                    Student__c, 
                    Student__r.From_IITBAA__c, 
                    Student__r.Email
                FROM
                    Application__c
                WHERE
                    Student__c = : studentID AND Student__r.From_IITBAA__c = : true
                ORDER BY
                    Semester__c];
                Map<string, Set<string>> ApplicationUniquesCheck = new  Map<string, Set<string>>();
                Map<string, string> applicationIDtoActivate = new  Map<string, string>();
                Map<string, string> applicationName = new  Map<string, string>();
                Map<string, string> applicationInternalStatus = new  Map<string, string>();
                Map<string, boolean> checkIsAppActive = new  Map<string, boolean>();
                List<Contact> updateContactList = new  List<Contact>();
                for(Application__c ap: applicationList)
                {
                    if(!checkIsAppActive.containsKey(ap.Student__r.Email))
                    {
                        if(ap.Application_Stage__c == Constants.ACTIVE_APPLICATION)
                        {
                            checkIsAppActive.put(ap.Student__r.Email, true);
                        }
                    }
                    if(ap.Application_Stage__c == Constants.APP_STAGE_OPEN)
                    {
                        ApplicationUniquesCheck.put(string.valueof(ap.Student__r.Email) + '@@' + string.valueof(ap.Semester__c.replace('semester', '').replace('Semester', '').replace(' ', '').replace('st', '').replace('nd', '').replace('rd', '').replace('th', '')), new Set<string>{string.valueof(ap.Semester__c.replace('semester', '').replace('Semester', '').replace(' ', '').replace('st', '').replace('nd', '').replace('rd', '').replace('th', ''))});
                        applicationIDtoActivate.put(string.valueof(ap.Student__r.Email) + '@@' + string.valueof(ap.Semester__c.replace('semester', '').replace('Semester', '').replace(' ', '').replace('st', '').replace('nd', '').replace('rd', '').replace('th', '')), ap.id);
                        applicationName.put(string.valueof(ap.Student__r.Email) + '@@' + string.valueof(ap.Semester__c.replace('semester', '').replace('Semester', '').replace(' ', '').replace('st', '').replace('nd', '').replace('rd', '').replace('th', '')), ap.Name);
                        applicationInternalStatus.put(string.valueof(ap.Student__r.Email) + '@@' + string.valueof(ap.Semester__c.replace('semester', '').replace('Semester', '').replace(' ', '').replace('st', '').replace('nd', '').replace('rd', '').replace('th', '')), ap.Internal_Status__c);
                    }
                }
                Set<string> alreadyActivated = new  Set<string>();
                List<Application__c> updateApplicationList = new  List<Application__c>();
                for(Application__c ap: applicationList)
                {
                    if(!alreadyActivated.contains(ap.Student__r.Email) && !checkIsAppActive.containsKey(ap.Student__r.Email))
                    {
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@1') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@1').contains('1'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@1'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@1'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@1'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@1')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@2') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@2').contains('2'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@2'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@2'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@2'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@2')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@3') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@3').contains('3'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@3'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@3'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@3'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@3')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@4') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@4').contains('4'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@4'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@4'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@4'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@4')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@5') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@5').contains('5'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@5'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@5'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@5'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@5')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@6') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@6').contains('6'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@6'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@6'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@6'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@6')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@7') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@7').contains('7'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@7'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@7'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@7'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@7')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@8') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@8').contains('8'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@8'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@8'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@8'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@8')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@9') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@9').contains('9'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@9'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@9'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@9'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@9')));
                            continue;
                        }
                        if(ApplicationUniquesCheck.containsKey(ap.Student__r.Email + '@@10') && ApplicationUniquesCheck.get(ap.Student__r.Email + '@@10').contains('10'))
                        {
                            alreadyActivated.add(ap.Student__r.Email);
                            updateApplicationList.add(new  Application__c(id = applicationIDtoActivate.get(ap.Student__r.Email + '@@10'), Application_Stage__c = Constants.ACTIVE_APPLICATION));
                            updateContactList.add(new  Contact(id = ap.Student__c, Internal_status__c = applicationInternalStatus.get(ap.Student__r.Email + '@@10'), Active_Application_Name__c = applicationName.get(ap.Student__r.Email + '@@10'), Active_Application_ID__c = applicationIDtoActivate.get(ap.Student__r.Email + '@@10')));
                        }
                    }
                }
                if(!updateApplicationList.isempty())
                {
                    Update updateApplicationList;
                }
                if(!updateContactList.isempty())
                {
                    Update updateContactList;
                }
                Constants.APPLICATION_TRIGGER_RUNNING = true;
            }
        }
        catch(Exception e)
        {
            database.rollback(sp);
            HandleBusinessException.captureError('ApplicationTriggerHelper', 'onAfterApplicationClose', e);
        }
    }
    public void onAfterInsert(List<Application__c> appList)
    {
        Id studentPrelimRecordType = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
        Id studentRenewalRecordType = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_RENEWAL_APPLICATION).getRecordTypeId();
        set<string> facilitatorList = new  set<string>();
        Map<string, string> studentInternalStatusFromApp = new  Map<string, string>();
        Map<string, string> currentYearFieldUpdate = new  Map<string, string>();
        Map<string, string> studentApplicationStage = new  Map<string, string>();
        Map<string, string> studentApplicationID = new  Map<string, string>();
        Map<string, string> applicationFiscalYear = new  Map<string, string>();
        for(Application__c ap: appList)
        {
            if(ap.RecordTypeId == studentPrelimRecordType)
            {
                facilitatorList.add(ap.Facilitator_ID__c);
            }
            if(ap.RecordTypeId == studentPrelimRecordType || ap.RecordTypeId == studentRenewalRecordType)
            {
                //Internal status update
                if(ap.Internal_Status__c != null && ap.Application_Stage__c != null)
                {
                    studentInternalStatusFromApp.put(string.valueOf(ap.Student__c), string.valueOf(ap.Internal_Status__c));
                }
                //Current Year field update 
                if(ap.Year__c != null && ap.RecordTypeId == studentPrelimRecordType )// Added check to update student Current year only for prelim application -- Sumit Gaurav - 17-July-2020
                {
                    currentYearFieldUpdate.put(string.valueOf(ap.Student__c), string.valueOf(ap.Year__c));
                }
                //Current Year field update
                if(ap.RPT_Financial_Year__c != null && ap.RecordTypeId == studentPrelimRecordType )// Added check to update student Financial year only for prelim application  -- Sumit Gaurav - 17-July-2020
                {
                    applicationFiscalYear.put(string.valueOf(ap.Student__c), string.valueOf(ap.RPT_Financial_Year__c));
                }
                //application name and id field update in student
                if(ap.Application_Stage__c != null && ap.Application_Stage__c == Constants.ACTIVE_APPLICATION && ap.Student__c != null)
                {
                    studentApplicationStage.put(string.valueOf(ap.Student__c), string.valueOf(ap.name));
                    studentApplicationID.put(string.valueOf(ap.Student__c), string.valueOf(ap.id));
                }
            }
        }
        // for updating internal status and currentyear data
        if(!studentInternalStatusFromApp.isEmpty())
        {
            Map<id, Contact> conMap = new  Map<id, Contact>([SELECT
                id, 
                Financial_year__c, 
                Internal_Status__c, 
                Current_year__c
            FROM
                Contact
            WHERE
                id = : studentInternalStatusFromApp.keySet()]);
            List<Contact> updateContactList = new  List<Contact>();
            for(Contact con: conMap.values())
            {
                con.Internal_Status__c = studentInternalStatusFromApp.get(string.valueOf(con.id));//Internal status value from application to Contact
                if(currentYearFieldUpdate.ContainsKey(string.valueOf(con.id))){
                    con.Current_year__c = currentYearFieldUpdate.get(string.valueOf(con.id));// year value from application to contact
                }
                if(applicationFiscalYear.ContainsKey(string.valueOf(con.id))){
                    con.Financial_year__c = applicationFiscalYear.get(string.valueOf(con.id));//updates fiscal year from student
                }
                updateContactList.add(con);
            }
            if(updateContactList != null)
            {
                Update updateContactList;
            }
        }
        //for updating Application data
        if(!studentApplicationStage.isEmpty())
        {
            Map<id, Contact> conMap = new  Map<id, Contact>([SELECT
                id, 
                Active_Application_Name__c, 
                Active_Application_ID__c
            FROM
                Contact
            WHERE
                id = : studentApplicationStage.keySet()]);
            List<Contact> updateContactList = new  List<Contact>();
            for(Contact con: conMap.values())
            {
                con.Active_Application_Name__c = studentApplicationStage.get(string.valueOf(con.id));
                con.Active_Application_ID__c = studentApplicationID.get(string.valueOf(con.id));
                updateContactList.add(con);
            }
            if(updateContactList != null)
            {
                Update updateContactList;
            }
        }
        if(facilitatorList.size() > 0)
        {
            AP_FacilitatorAssignment_helper.studentCountForFacilitator(facilitatorList);
        }
    }
    /*
    * purpose    : To Update Facilitator Load Count when Application is Closed
    * Parameter  : Trigger.new
    */
    public void applicationStageClosed(List<Application__c> appList)
    {
        Constants.APPLICATION_TRIGGER_RUNNING = true;
        set<string> facilitatorList = new  set<string>();
        for(Application__c ap: appList)
        {
            if(ap.Application_Stage__c == Constants.APP_STAGE_CLOSED && ap.RecordTypeId == Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId())
            {
                facilitatorList.add(ap.Facilitator_ID__c);
            }
        }
        if(facilitatorList.size() > 0)
        {
            AP_FacilitatorAssignment_helper.studentCountForFacilitator(facilitatorList);
        }
    }
    /*
    * purpose    : Update parent contact "Internal Status" field value if child application "Internal Status" gets updated.
    * Parameter  : Trigger.oldMap and Trigger.newMap
    */
    public void onBeforeUpdate(Map<Id, Application__c> oldMap, Map<Id, Application__c> newMap)
    {
        string strReqd = '';
        List<PrelimForm_Attachment__mdt> listPrelimAttachments = [SELECT
            Id, 
            Attachment_Name__c
        FROM
            PrelimForm_Attachment__mdt];
        List<Renewal_Form_Attachments__mdt> listRenewalAttachments = [SELECT
            Id, 
            Attachment_Name__c
        FROM
            Renewal_Form_Attachments__mdt];
        Id studentPrelimRecordType = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
        Id studentRenewalRecordType = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_RENEWAL_APPLICATION).getRecordTypeId();
        for(Application__c a: newMap.values())
        {
            if(a.RecordTypeId == studentPrelimRecordType || a.RecordTypeId == studentRenewalRecordType)
            {
                if(a.Internal_Status__c == Constants.SELECTED_APPLICATION && a.Email__c != null)
                {
                    if(oldMap.get(a.id).Internal_Status__c != newMap.get(a.id).Internal_Status__c)
                    {
                        a.External_Status__c = Constants.APP_EXTERNAL_STATUS;
                    }
                }
            }
            if(a.External_Status__c == 'Document Missing' && string.isNotBlank(a.Comment_s_for_Student__c))
            {
                string strComm = a.Comment_s_for_Student__c;
                if(a.RecordTypeId == studentPrelimRecordType)
                {
                    for(PrelimForm_Attachment__mdt objPrelim: listPrelimAttachments)
                    {
                        if(strComm.contains(objPrelim.Attachment_Name__c))
                        {
                            strReqd += objPrelim.Attachment_Name__c + ';';
                        }
                    }
                }
                else if(a.RecordTypeId == studentRenewalRecordType)
                {
                    for(Renewal_Form_Attachments__mdt objRenewal: listRenewalAttachments)
                    {
                        if(strComm.contains(objRenewal.Attachment_Name__c))
                        {
                            strReqd += objRenewal.Attachment_Name__c + ';';
                        }
                    }
                }
                if(strComm != null && strComm.containsIgnoreCase('Profile Picture'))
                    strReqd += 'Profile Picture;';
                a.Missing_Documents__c = strReqd.removeEnd(';');
            }
        }
    }
    public void onAfterUpdate(Map<Id, Application__c> oldMap, Map<Id, Application__c> newMap)
    {
        Id studentPrelimRecordType = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId();
        Id studentRenewalRecordType = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_RENEWAL_APPLICATION).getRecordTypeId();
        Map<string, string> studentInternalStatusFromApp = new  Map<string, string>();
        Map<string, string> studentApplicationStage = new  Map<string, string>();
        Map<string, string> studentApplicationID = new  Map<string, string>();
        for(Application__c app: newMap.values())
        {
            //Internal status field update
            if(app.Application_Stage__c != null && app.Application_Stage__c == Constants.ACTIVE_APPLICATION && app.Student__c != null && app.Internal_Status__c != null && (app.RecordTypeId == studentPrelimRecordType || app.RecordTypeId == studentRenewalRecordType) && (oldMap.get(app.id).Internal_Status__c != newMap.get(app.id).Internal_Status__c || oldMap.get(app.id).Application_Stage__c != newMap.get(app.id).Application_Stage__c))
            {
                studentInternalStatusFromApp.put(string.valueOf(app.Student__c), string.valueOf(app.Internal_Status__c.replace('_', ' ')));
            }
            else if(app.Application_Stage__c != null && app.Application_Stage__c == Constants.APP_STAGE_CLOSED && app.Student__c != null && oldMap.get(app.id).Application_Stage__c != newMap.get(app.id).Application_Stage__c && (app.RecordTypeId == studentPrelimRecordType || app.RecordTypeId == studentRenewalRecordType))
            {
                studentInternalStatusFromApp.put(string.valueOf(app.Student__c), string.valueOf(app.Internal_Status__c.replace('_', ' ')));
            }
            //application name and id field update in student
            if(app.Application_Stage__c != null && app.Application_Stage__c == Constants.ACTIVE_APPLICATION && app.Student__c != null && (app.RecordTypeId == studentPrelimRecordType || app.RecordTypeId == studentRenewalRecordType))
            {
                studentApplicationStage.put(string.valueOf(app.Student__c), string.valueOf(app.name));
                studentApplicationID.put(string.valueOf(app.Student__c), string.valueOf(app.id));
            }
            else if(app.Application_Stage__c == null || (app.Application_Stage__c != null && app.Application_Stage__c != Constants.ACTIVE_APPLICATION && oldMap.get(app.id).Application_Stage__c != newMap.get(app.id).Application_Stage__c) && (app.RecordTypeId == studentPrelimRecordType || app.RecordTypeId == studentRenewalRecordType) && app.Internal_Status__c != null)
            {
                studentApplicationStage.put(string.valueOf(app.Student__c), null);
                studentApplicationID.put(string.valueOf(app.Student__c), null);
            }
        }
        //for updating internal status 
        if(!studentInternalStatusFromApp.isEmpty())
        {
            Map<id, Contact> conMap = new  Map<id, Contact>([SELECT
                id, 
                Internal_Status__c, 
                Current_year__c
            FROM
                Contact
            WHERE
                id = : studentInternalStatusFromApp.keySet()]);
            List<Contact> updateContactList = new  List<Contact>();
            for(Contact con: conMap.values())
            {
                con.Internal_Status__c = studentInternalStatusFromApp.get(string.valueOf(con.id));//Internal status value form application to Contact
                updateContactList.add(con);
            }
            if(updateContactList != null)
            {
                Constants.Contact_TRIGGER_RUNNING = false;
                Update updateContactList;
            }
        }
        // for updating application data
        if(!studentApplicationStage.isEmpty())
        {
            Map<id, Contact> conMap = new  Map<id, Contact>([SELECT
                id, 
                Active_Application_Name__c, 
                Active_Application_ID__c
            FROM
                Contact
            WHERE
                id = : studentApplicationStage.keySet()]);
            List<Contact> updateContactList = new  List<Contact>();
            for(Contact con: conMap.values())
            {
                con.Active_Application_Name__c = studentApplicationStage.get(string.valueOf(con.id));
                con.Active_Application_ID__c = studentApplicationID.get(string.valueOf(con.id));
                updateContactList.add(con);
            }
            if(updateContactList != null)
            {
                Constants.Contact_TRIGGER_RUNNING = true;
                Update updateContactList;
            }
        }
    }
}