global class DataCorrectionforYear_Batch implements Database.Batchable<SObject>{
     
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> FinancialYear = new List<String>();
        Set<String> ids  = new Set<String>();
        FinancialYear.add('2019-20');
        FinancialYear.add('2020-21');
         
        
        
        ID studentRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        
        String query ='select id,Current_year__c,Course__c,Financial_year__c from Contact where RecordTypeId=:studentRecordType AND Financial_year__c NOT IN : FinancialYear';                         
        system.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        List<Contact> studentListToUpdate = new List<Contact>();
        for(Contact con : scope) {
            Map<string,string> mapToReturnCurrentYearAndCourse = new  Map<string,string>();
            
            
            mapToReturnCurrentYearANdCourse = Utility.getCorrectData(con.Course__c,con.Current_year__c,con.Financial_year__c,2019);
            System.debug('test map'+mapToReturnCurrentYearANdCourse);
            if(mapToReturnCurrentYearANdCourse.size()>0) {
                String currentYear = mapToReturnCurrentYearANdCourse.get('CurrentYear');
                String financialYear = mapToReturnCurrentYearANdCourse.get('FinancialYear');
                Contact updateCon = new Contact();
                updateCon.Current_year__c = currentYear;
                
                updateCon.Financial_year__c = financialYear;
                updateCon.id = con.id;
                studentListToUpdate.add(updateCon);
                
                
            }
            
        }
        if(!studentListToUpdate.isEmpty()) {
            UPDATE studentListToUpdate;
        }
        
    }
    global void finish(Database.BatchableContext BC) { 
        
    }
    
}