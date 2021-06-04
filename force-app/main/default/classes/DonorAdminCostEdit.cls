/*
* @ purpose : To Transfer Fund/Amount from one DonorBalance(source) to Another DonorBalance(destination).
* @ if Destion DonorBalance is present then updates the record by adding amount to current balance
* @ else creates a new Destination DonorBalance.
*/ 
public class DonorAdminCostEdit {
    
    public Donor_Balance__c dbBalance        {get;set;}
    public Donor_Balance__c dbBalancereduce  {get;set;}
    public String gauName                    {get;set;}
    public Donor_Balance__c donorBalance     = new Donor_Balance__c();
    public String desDonorName               = '';
    public String desGAUName                 = '';
    Public String desDonorBalanceId          = '';
    public boolean isDisplay                 {get;set;}
    public string donorBalanceId            {get; set;}
    
    
    public DonorAdminCostEdit(Apexpages.StandardController stdCon){    
        dbBalance = new Donor_Balance__c();
        dbBalancereduce =  new Donor_Balance__c();
        isDisplay = true;
        if(stdCon!=null){
            donorBalance    = [SELECT id,name,GAU_Name__r.Business_Account__r.Name,Current_Balance__c,GAU_Name__c,Donor_Name__c,Donor_Name__r.Name,GAU_Name__r.Name from Donor_Balance__c where id=:((Donor_Balance__c)stdCon.getRecord()).Id LIMIT 1];
            donorBalanceId  = donorBalance.Id;
            system.debug('@@ '+donorBalance.GAU_Name__r.Name);
            gauName         = String.valueOf(donorBalance.GAU_Name__r.Name);
            system.debug('@@ '+gauName);
            Id profileId = UserInfo.getProfileId();
            String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
            system.debug('Profile Name'+profileName);
            if(profileName != 'System Administrator' && profileName != 'Account Team'){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'This edit is only for System Administrator and Account Team Users'));
                isDisplay = false;
            }

            //if(gauName.containsIgnoreCase('Offline')){
            if((gauName == 'Offline Donation Admin Cost (598)')||(gauName == 'Offline Donation Admin Cost (723)')){
            }else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Allowed only for Offline Donation Admin Cost GAU'));
                isDisplay = false;
            }
        } 
    }    
    
    public void donorAdminCostEditDetails(){
        try{
            if(dbBalance.Current_Balance__c > 0){
                donorBalance.Current_Balance__c = donorBalance.Current_Balance__c + dbBalance.Current_Balance__c;
                
            }
            update donorBalance;
            if(dbBalancereduce.Current_Balance__c > 0){
                donorBalance.Current_Balance__c = donorBalance.Current_Balance__c - dbBalancereduce.Current_Balance__c;
            }
            
             donorBalance.Short_Comments__c = dbBalance.Short_Comments__c;
            update donorBalance;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Save has been successfull'));
                                isDisplay = false;
            //
        }catch(Exception ex){
            HandleBusinessException.captureError('DonorAdminCostEdit', 'destinationDonorDetails', ex);
        }
    }
}