/*
* @purpose : This class is used to create/Update Donor Balance record for Donors 
* @Author	: Amritesh 			
*/ 
public class DN_BalanceCalculationForDonor {
    
    /*
     * @purpose	: This method creates/Updates Donor Balance records for the donor
     * 			 new created GAU allocation for donor's Donation. Donor Balance
     * 			 stores GAU wise current balance for the donor,So if any GAU allocation 
     * 			 created for a GAU.It checks if GAU already present in Donor Balance,
     * 			 if Present, update the same GAU with current balance under the Donor Balance record.
     * 			 else, create new donor balance record for the GAU
     * @param	: oppList
     * @param	: donorId
     * @returnType: String		
     */ 
    public static string donorBalanceCal(List<Opportunity> oppList ,string donorId){
        SavePoint sp = Database.setSavepoint();
        try{
            
            Map<Id,AggregateResult> allocationMap;
            Map<Id,Donor_Balance__c> donorBalanceMap;
            Map<String,Donor_Balance__c> donorGAUBalMap	=  new Map<String,Donor_Balance__c>(); // To Store GAU wise Balance
            
            if(oppList.size() > 0){ 
                allocationMap	= new Map<Id,AggregateResult>([Select npsp__General_Accounting_Unit__c Id,SUM(npsp__Amount__c) gausum 
                                                               from npsp__Allocation__c where npsp__opportunity__c IN :opplist 
                                                               AND npsp__opportunity__r.npsp__Primary_Contact__c =:donorId 
                                                               group by npsp__General_Accounting_Unit__c]);                
            }
            
            if(donorId != null){
                donorBalanceMap	= new Map<Id,Donor_Balance__c>([Select Id,Current_Balance__c,GAU_Name__c from Donor_Balance__c
                                                                where Donor_Name__c =: donorId AND GAU_Name__c IN: allocationMap.keySet()]);                
                for(String s : donorBalanceMap.keySet()){
                    donorGAUBalMap.put(donorBalanceMap.get(s).GAU_Name__c, donorBalanceMap.get(s));
                }
            }
            
            List<Donor_Balance__c> balanceUpsertList	= new List<Donor_Balance__c>();
            
            for(String s : allocationMap.keySet()){                
                if(donorGAUBalMap.containsKey(s)){
                    double amt	= donorGAUBalMap.get(s).Current_Balance__c + Double.ValueOf(allocationMap.get(s).get('gausum'));
                    balanceUpsertList.add(new Donor_Balance__c(Id=donorGAUBalMap.get(s).Id,Current_Balance__c=amt));                    
                }else{
                    balanceUpsertList.add(new Donor_Balance__c(Donor_Name__c=donorId,GAU_Name__c=s,Current_Balance__c=Double.ValueOf(allocationMap.get(s).get('gausum'))));
                }
            } 
            
            upsert balanceUpsertList;    // Create/Update Donor's Donor Balance        
            return Constants.SUCCESS_MSG;
        }catch(Exception e){
            HandleBusinessException.captureError('DN_BalanceCalculationForDonor', 'donorBalanceCal', e);
            Database.rollback(sp);
            return Constants.ERROR_MSG;
        }
        
    }
}