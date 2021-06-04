public class DonorApplicationMappingTrigger_Helper {
    
    /*public static void afterdelete(List<Donor_Application_Mapping__c> newList){
        Set<ID> applicationsIDs = new Set<ID>();
        Set<String> deletedFFEUID = new Set<String>();
        for(Donor_Application_Mapping__c dam : newList){
            applicationsIDs.add(dam.Application__c);
            deletedFFEUID.add(dam.Donor_FFEUID__c);
        }
        
        List<Application__c> applicationList = [Select id,DonorID__c,Donor_Name__c,Donor_Remarks__c,(Select id,Donor__r.Name,Donor_FFEUID__c,Donor_Remark__c from Donor_Application_Mappings__r Order By CreatedDate) From Application__c where id=:applicationsIDs];
    
        if(!applicationList.isEmpty()){
        List<Application__c> updateaApplicationList = new List<Application__c>();
        for(Application__c app : applicationList){
            if(app.Donor_Application_Mappings__r.size() == 0){
            updateaApplicationList.add(new Application__c(id=app.id,Donor_Name__c='',DonorID__c='',Donor_Remarks__c=''));
            }else{
            if(deletedFFEUID.contains(app.DonorID__c)){
            updateaApplicationList.add(new Application__c(id=app.id,Donor_Name__c=app.Donor_Application_Mappings__r[0].Donor__r.Name,DonorID__c=app.Donor_Application_Mappings__r[0].Donor_FFEUID__c,Donor_Remarks__c=app.Donor_Application_Mappings__r[0].Donor_Remark__c));    
            }
            }
        }
        
        if(!updateaApplicationList.isEmpty()){
            update updateaApplicationList;
        }
        } 
    
    }*/
    
    public static void afterdelete(List<Donor_Application_Mapping__c> newList){
        Set<ID> applicationsIDs = new Set<ID>();
        Set<String> deletedFFEUID = new Set<String>();
        map<String,String> mapMappedFund = new Map<String,String>();

        for(Donor_Application_Mapping__c dam : newList){
            applicationsIDs.add(dam.Application__c);
            deletedFFEUID.add(dam.Donor_FFEUID__c);
            if(dam.Created_from_Multi_Donor_Feature__c){
            List<String> listGauNames = dam.GAU_Information__c.split(Label.GAUs_delimiter);
            for(String str: listGauNames){
                List<string> listNameAmt = str.trim().split(Label.GAU_Amount_delimiter);
                mapMappedFund.put(dam.donor__c + listNameAmt[0].trim(),listNameAmt[1].trim());
            }
        }

        }

        system.debug('To delete : '+JSON.serialize(mapMappedFund));

         
        List<Application__c> applicationList = [Select id,DonorID__c,Donor_Name__c,Donor_Remarks__c,(Select id,Donor__r.Name,Donor_FFEUID__c,Donor_Remark__c from Donor_Application_Mappings__r Order By CreatedDate) From Application__c where id=:applicationsIDs];
    
        if(!applicationList.isEmpty()){
        List<Application__c> updateaApplicationList = new List<Application__c>();
        for(Application__c app : applicationList){
            if(app.Donor_Application_Mappings__r.size() == 0){
            updateaApplicationList.add(new Application__c(id=app.id,Donor_Name__c='',DonorID__c='',Donor_Remarks__c=''));
            }else{
            if(deletedFFEUID.contains(app.DonorID__c)){
            updateaApplicationList.add(new Application__c(id=app.id,Donor_Name__c=app.Donor_Application_Mappings__r[0].Donor__r.Name,DonorID__c=app.Donor_Application_Mappings__r[0].Donor_FFEUID__c,Donor_Remarks__c=app.Donor_Application_Mappings__r[0].Donor_Remark__c));    
            }
            }
        }
        
        if(!updateaApplicationList.isEmpty()){
            update updateaApplicationList;
        }
        } 

        if(mapMappedFund != null && mapMappedFund.keySet() != null){

        List<Donor_Balance__c> listDonorBalances = [select id,Mapped_Fund__c,Backend_field_for_multi_donor_fund_alloc__c from Donor_Balance__c where Backend_field_for_multi_donor_fund_alloc__c in : mapMappedFund.keySet()];
        for(Donor_Balance__c objDB : listDonorBalances){
            if(objDB.Mapped_Fund__c > 0)
            objDB.Mapped_Fund__c = objDB.Mapped_Fund__c - Decimal.valueOf(mapMappedFund.get(objDB.Backend_field_for_multi_donor_fund_alloc__c));
        }
        if(listDonorBalances != null && listDonorBalances.size() > 0)
        update listDonorBalances;
        }
    
    }
    
    public static void afterInsert(List<Donor_Application_Mapping__c> newList){
        try{
        Set<ID> applicationsIDs = new Set<ID>();
        Map<String,String> donorIDDetailMap = new Map<String,String>();
        Map<String,String> donorNameDetailMap = new Map<String,String>();
        Map<String,String> donorRemarkDetailMap = new Map<String,String>();
        Map<String,String> donorFFEUIDDetailMap = new Map<String,String>();
        
        for(Donor_Application_Mapping__c dam : newList){
            applicationsIDs.add(dam.Application__c);
            donorIDDetailMap.put(dam.Application__c,dam.Donor__c);
            donorRemarkDetailMap.put(dam.Application__c,dam.Donor_Remark__c);
        }
        
        List<contact> donorNameList = [Select id,Name,FFE_ID__c From contact where id=:donorIDDetailMap.values()];
        
        for(Contact con :donorNameList){
            donorNameDetailMap.put(con.id,con.Name);
            donorFFEUIDDetailMap.put(con.id,con.FFE_ID__c);
        }
        
        List<Application__c> applicationList = [Select id,DonorID__c,Donor_Name__c,Donor_Remarks__c,(Select id from Donor_Application_Mappings__r) From Application__c where id=:applicationsIDs];
        
        if(!applicationList.isEmpty()){
        List<Application__c> updateaApplicationList = new List<Application__c>();
        for(Application__c app : applicationList){
            if(app.Donor_Application_Mappings__r.size() == 1){
            updateaApplicationList.add(new Application__c(id=app.id,Donor_Name__c=donorNameDetailMap.get(donorIDDetailMap.get(app.id)),DonorID__c=donorFFEUIDDetailMap.get(donorIDDetailMap.get(app.id)),Donor_Remarks__c=donorRemarkDetailMap.get(app.id)));
        }
        }
        
        if(!updateaApplicationList.isEmpty()){
            update updateaApplicationList;
        }
        } 
        }Catch(Exception e){
            HandleBusinessException.captureError('DonorApplicationMappingTrigger_Helper', 'afterinsert', e);
        }
    }
    
    
    
    public static void afterInsertAndUpdate(List<Donor_Application_Mapping__c> newList){
        Set<ID> DonorID = new Set<ID>();
        for(Donor_Application_Mapping__c dam : newList){
            DonorID.add(dam.Donor__c);
        }
        
        String financialYear = financialYear();
        List<AggregateResult> aggresult = [SELECT Donor__c ID,Student__c from Donor_Application_Mapping__c where Donor__c=:DonorID AND Financial_Year__c=:financialYear group by Student__c,Donor__c];
        Map<String,Integer> studentCountMap = new Map<String,Integer>();
        
        for(AggregateResult agg :aggresult){
            if(!studentCountMap.containsKey(String.valueOf(agg.get('ID')))){
                studentCountMap.put(String.valueOf(agg.get('ID')),1);
            }else{
                studentCountMap.put(String.valueOf(agg.get('ID')),Integer.valueOf(studentCountMap.get(String.valueOf(agg.get('ID'))))+1);
            }
        }
        
        List<Contact> updateMappedStudentCount = new List<Contact>();
        for(ID ids : DonorID){
            updateMappedStudentCount.add(new Contact(id=ids,Mapped_student_count__c=String.valueOf(studentCountMap.get(ids))));
        }
        
        if(!updateMappedStudentCount.isEmpty()){
            update updateMappedStudentCount;
        }
        
    }
      // Get Current Financial Year 
    public static String financialYear(){
        String financialYear ='';
        String currentYear   = String.valueOf(system.today().year());
        String nextYear   = String.valueOf(system.today().year()+1);
        if(system.today().month() > = 1 && system.today().month()<=3){
            financialYear = String.valueOf(system.today().Year() - 1) + '-' + currentYear.substring(2, 4);
        }else if(system.today().month() > = 4 && system.today().month()<=12){
            financialYear = String.valueOf(system.today().Year()) + '-' + nextYear.substring(2, 4);
        }
        return financialYear;
    }
}