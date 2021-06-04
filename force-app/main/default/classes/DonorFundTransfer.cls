/*
* @ purpose : To Transfer Fund/Amount from one DonorBalance(source) to Another DonorBalance(destination).
* @ if Destion DonorBalance is present then updates the record by adding amount to current balance
* @ else creates a new Destination DonorBalance.
*/ 
public class DonorFundTransfer {
    
    public Donor_Balance__c dbBalance        {get;set;}
    public String gauName                    {get;set;}
    public Donor_Balance__c donorBalance     = new Donor_Balance__c();
    public String desDonorName               = '';
    public String desGAUName                 = '';
    Public String desDonorBalanceId          = '';
    public boolean isDisplay                 {get;set;}
    public string donorBalanceId            {get; set;}
    
    
    public DonorFundTransfer(Apexpages.StandardController stdCon){    
        dbBalance = new Donor_Balance__c();
        isDisplay = true;
        if(stdCon!=null){
            donorBalance    = [SELECT id,name,GAU_Name__r.Business_Account__r.Name,Current_Balance__c,GAU_Name__c,Donor_Name__c,Donor_Name__r.Name,GAU_Name__r.Name from Donor_Balance__c where id=:((Donor_Balance__c)stdCon.getRecord()).Id LIMIT 1];
            donorBalanceId  = donorBalance.Id;
            gauName         = String.valueOf(donorBalance.GAU_Name__c);
        } 
    }    
    
    public void destinationDonorDetails(){
        try{
            
            npsp__General_Accounting_Unit__c gau = [SELECT id,Business_Account__r.Name FROM npsp__General_Accounting_Unit__c where id=:dbBalance.GAU_Name__c];
            if(gau.Business_Account__r.Name == donorBalance.GAU_Name__r.Business_Account__r.Name){
                if(donorBalance.GAU_Name__c == dbBalance.GAU_Name__c && donorBalance.Donor_Name__c == dbBalance.Donor_Name__c){
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning,Constants.Fund_Transfer_error_message));
                }else{
                    if(donorBalance.Current_Balance__c == 0 || dbBalance.Current_Balance__c == 0){
                        if(donorBalance.Current_Balance__c == 0)
                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning,Constants.zero_amount_balance_error_message));
                        else
                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning,Constants.Amount_Entry_as_Zero));    
                    }else{
                        if(dbBalance.Current_Balance__c > donorBalance.Current_Balance__c){
                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning,'Amount shoulde be less than or equal to Rs.'+donorBalance.Current_Balance__c+'.'));
                        }else{
                            List<Donor_Balance__c> updateDonorBalance       =  [select id,Current_Balance__c,Donor_Name__c,GAU_Name__c,Donor_Name__r.Name,GAU_Name__r.Name  from Donor_Balance__c where Donor_Name__c=:dbBalance.Donor_Name__c AND GAU_Name__c=:dbBalance.GAU_Name__c LIMIT 1];
                            List<Donor_Balance__c> updateDonorBalances      =  new List<Donor_Balance__c>();
                            if(updateDonorBalance!=null && !updateDonorBalance.isEmpty()){
                                //update here
                                updateDonorBalance[0].Current_Balance__c = Integer.valueOf(updateDonorBalance[0].Current_Balance__c) + Integer.valueOf(dbBalance.Current_Balance__c) ; 
                                updateDonorBalances.add(updateDonorBalance[0]);
                                //add DonorName and GAU NAme
                                desDonorName = updateDonorBalance[0].Donor_Name__c;
                                desGAUName   = updateDonorBalance[0].GAU_Name__c;
                                desDonorBalanceId = updateDonorBalance[0].Id;
                            }else{
                                //insert here
                                Donor_Balance__c insertDonorBalance     =  new Donor_Balance__c(Current_Balance__c = Integer.valueOf(dbBalance.Current_Balance__c),Donor_Name__c = dbBalance.Donor_Name__c ,GAU_Name__c =dbBalance.GAU_Name__c);
                                insert insertDonorBalance;
                                //add DonorName and GAU NAme
                                Donor_Balance__c DesDonorBalance        =  [select id,Current_Balance__c,Donor_Name__c,GAU_Name__c,Donor_Name__r.Name,GAU_Name__r.Name  from Donor_Balance__c where Donor_Name__c=:insertDonorBalance.Donor_Name__c AND GAU_Name__c=:insertDonorBalance.GAU_Name__c LIMIT 1];
                                desDonorName = DesDonorBalance.Donor_Name__c;
                                desGAUName   = DesDonorBalance.GAU_Name__c;
                                desDonorBalanceId = DesDonorBalance.id;
                            }
                            
                            //updateDonorBalances.add(new Donor_Balance__c(id=donorBalance.id,Current_Balance__c = Integer.valueOf(donorBalance.Current_Balance__c) - Integer.valueOf(dbBalance.Current_Balance__c)));
                            updateDonorBalances.add(new Donor_Balance__c(Short_Comments__c=dbBalance.Short_Comments__c,id=donorBalance.id,Current_Balance__c = Integer.valueOf(donorBalance.Current_Balance__c) - Integer.valueOf(dbBalance.Current_Balance__c)));
                            if(!updateDonorBalances.isEmpty()){
                                update updateDonorBalances;
                                
                                insert new GAU_Balance_Transfer__c(Source_donor__c = donorBalance.Donor_Name__c,Source_GAU__c= donorBalance.GAU_Name__c,Available_Balance__c=donorBalance.Current_Balance__c,Destination_donor__c=desDonorName,Destination_GAU__c=desGAUName,Transfered_Fund__c=dbBalance.Current_Balance__c,Donor_Balance__c=donorBalance.id,Destination_Donor_Balance__c=desDonorBalanceId);
                                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Amount of Rs.'+dbBalance.Current_Balance__c+' has been successfully transferred'));
                                isDisplay = false;
                            }
                        }       
                    }
                }   
            }else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning,Constants.FCRA_Duplicate_Err_Msg));
            }
            //
        }catch(Exception ex){
            HandleBusinessException.captureError('DonorFundTransfer', 'destinationDonorDetails', ex);
        }
    }
}