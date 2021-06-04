global class AluminiToDonorBatch implements Database.Batchable<sObject>, Schedulable{
    
    public static Messaging.SingleEmailMessage[] AlumniToDonorEmailMessageList = new Messaging.SingleEmailMessage[]{};
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> idSet = new Set<String>();
        
        
        string financialYr=Utility.financialYear();
       ID studentRecordType = SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        
        return Database.getQueryLocator('SELECT id,Course__c,RecordTypeId,Current_year__c,Active_Application_ID__c,Is_Active_Alumni__c,Internal_Status__c,Financial_year__c from Contact where RecordTypeId=:studentRecordType and Financial_year__c!=:financialYr');
    
    }
    global void execute(Database.BatchableContext BC, List<Contact> contactList){   
        try{
            System.debug(contactList.size());
            Integer currentYear = System.Today().year();
            
            String currentFinancialYear=Utility.financialYear();
            ID donorRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Donor_Donor).getRecordTypeId();
            List<Contact> contactToUpdateList = new List<Contact>();
            Set<Id> finalYrNotDisbursedID = new Set<Id> ();
            EmailTemplate AlumniToDonor = [SELECT id, Developername FROM EmailTemplate WHERE Developername = : Constants.AluminiToDonor Limit 1];
        
            for(Contact con:contactList){
                String getGraduatedYear = String.valueOf(Utility.sessionEndYear(con.Financial_year__c));
                if(!String.IsBlank(con.Course__c) && !String.IsBlank(con.Current_year__c)){
                    
                    //Checking if student is in final year then convert to alumni
                    if((con.Course__c=='BE/B.Tech' && con.Current_year__c=='4th Year') || (con.Course__c=='Integrated MTech' && con.Current_year__c=='5th Year') || (con.Course__c=='MBBS' && con.Current_year__c=='Year III (Part 2), Sem 9') || (con.Course__c=='BPharm' && con.Current_year__c=='4th Year') || (con.Course__c=='Law' && con.Current_year__c=='5th Year')){
                        if(con.Internal_Status__c=='Disbursed'){
                            contactToUpdateList.add(new  Contact(ID = con.id, RecordTypeId = donorRecordTypeID, Is_Active_Alumni__c = true,DN_Donor_Category__c='Alumni Scholar',DN_Citizenship__c='Indian',DN_Year_Of_Graduation__c= getGraduatedYear));
                            AlumniToDonorEmailMessageList.add(Utility.sendEmailWithTemplateBulk(con.id, AlumniToDonor.id));
                        }
                        else{
                            finalYrNotDisbursedID.add(con.id);
                        }
                    }else{//Move student to next year
                        String nextYear=Utility.returnNextCurrentYear(con.Current_year__c,con.Course__c);
                        if(!String.IsBlank(nextYear)){
                            con.Current_year__c=nextYear;
                            con.Financial_year__c=currentFinancialYear;
                            contactToUpdateList.add(con);
                        }
                    }
                }
            }
            //Check if atleast one application with disbursed status
            if(finalYrNotDisbursedID.size()>0){
                for(Contact con:[Select id,Financial_year__c,(select id,Internal_Status__c from Applications__r where Internal_Status__c='Disbursed' ) from Contact where id IN :finalYrNotDisbursedID]){
                     String getGraduatedYear = String.valueOf(Utility.sessionEndYear(con.Financial_year__c));
                    if(con.Applications__r!=null && con.Applications__r.size()>0){
                        contactToUpdateList.add(new  Contact(ID = con.id, RecordTypeId = donorRecordTypeID, Is_Active_Alumni__c = true,DN_Donor_Category__c='Alumni Scholar',DN_Citizenship__c='Indian',DN_Year_Of_Graduation__c=getGraduatedYear));
                        AlumniToDonorEmailMessageList.add(Utility.sendEmailWithTemplateBulk(con.id, AlumniToDonor.id));
                    }
                }
            }
            //System.debug(contactToUpdateList);
            
            if(!contactToUpdateList.isEmpty()){
                Constants.Contact_TRIGGER_RUNNING = true;
                Update contactToUpdateList;
            }
            
            try{
                if(AlumniToDonorEmailMessageList != null){
                    Messaging.sendEmail(AlumniToDonorEmailMessageList);
                }
            }catch(Exception e){
                HandleBusinessException.captureError('AluminiToDonorBatch', 'Execute', e);
            }
            
        }catch(Exception e){
            system.debug('Exception==='+e);
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    global void execute(SchedulableContext SC)
    {
        Database.executeBatch(new  AluminiToDonorBatch(), 100);
    }
}