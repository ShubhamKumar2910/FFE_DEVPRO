trigger UpdateCurrentBalanceorBlockFund on Donor_Balance__c (before insert, before update) {
    
   // List<Donor_Balance__c> dbalance = [Select Id,Name,Current_Balance__c,Include_CB__c,GAU_Name__r.Name,Blocked_Funds__c,Include_BF__c From Donor_Balance__c where ID IN: Trigger.New];
    Set<Id> GAUList =  new Set<Id>();
    for(Donor_Balance__c db : Trigger.New){
        GAUList.add(db.GAU_Name__c);
    }
    Map<id, String> GAUMap = new Map<id, String>();
    List<npsp__General_Accounting_Unit__c> GAUNameList = [SELECT Name,Id FROM npsp__General_Accounting_Unit__c WHERE Id IN :GAUList];
    
    for(npsp__General_Accounting_Unit__c gau : GAUNameList){
        
        GAUMap.put(gau.id,gau.Name);
    }
    
    
    
    
    for(Donor_Balance__c db : Trigger.New){
        if(db.Current_Balance__c != null && (GAUMap.get(db.GAU_Name__c) != 'Offline Donation - Corpus Fund (598 - Non FCRA)' || GAUMap.get(db.GAU_Name__c) != 'Offline Donation - Corpus Fund (723 - FCRA)' || GAUMap.get(db.GAU_Name__c) != 'Corpus Fund - Non FCRA' || GAUMap.get(db.GAU_Name__c) != 'Corpus Fund - FCRA')){
            db.Include_CB__c = 'CB';
        }
        
        system.debug('@@1 '+db.GAU_Name__r.Name);
        system.debug('@@2 '+db.GAU_Name__c);
        if((GAUMap.get(db.GAU_Name__c) == 'Offline Donation - Corpus Fund (598 - Non FCRA)' || GAUMap.get(db.GAU_Name__c) == 'Offline Donation - Corpus Fund (723 - FCRA)' || GAUMap.get(db.GAU_Name__c) == 'Corpus Fund - Non FCRA' || GAUMap.get(db.GAU_Name__c) == 'Corpus Fund - FCRA') && db.Current_Balance__c != null){
            if(db.Blocked_Funds__c != null){
               db.Blocked_Funds__c = db.Blocked_Funds__c+db.Current_Balance__c;
            }else{
                db.Blocked_Funds__c = db.Current_Balance__c;
            }
            db.Include_BF__c = 'BF';
            db.Current_Balance__c = 0;
        }
        
        if(db.Blocked_Funds__c != null){
            db.Include_BF__c = 'BF';
        }
    }

}