@isTest
public class DN_BalanceCalculationForDonor_Test {

    public static testmethod void executeTest(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
        Contact Donor = Utility_Test.insertNewDonorId('Donor','Test');
        insert Donor;
        
        Donation_Program__c donationPrg = Utility_Test.createDonationProgram('Engineering','Engineering');    
        insert donationPrg;
        
        Program_Frequency__c prgFrequency = new Program_Frequency__c();
        prgFrequency.Program__c = donationPrg.id;
        prgFrequency.Minimum_Amount__c=20000;
        insert prgFrequency;    
            
            
        npsp__General_Accounting_Unit__c  gau = Utility_Test.createGAU('ASP - Engineering',donationPrg.Id);    
        insert gau;
            
        Donor_Balance__c donorbalance = new Donor_Balance__c();
        donorbalance.Donor_Name__c = Donor.Id;
        donorbalance.GAU_Name__c =gau.id;
        donorbalance.Current_Balance__c = double.valueOf('23.000');
        donorbalance.Blocked_Funds__c   =double.valueOf('56.000');
        insert donorbalance;    
        
       
        List<Opportunity> oppList = new List<Opportunity>();    
        opportunity op = new opportunity();
        op.Name='Jayanth';
        op.StageName = 'Pledged';
        op.Amount = double.valueOf('56.000');
        op.CloseDate = date.valueOf('2017-12-27');
        op.Program_Frequency__c = prgFrequency.id;    
        op.npsp__Primary_Contact__c =  Donor.Id;   
        insert op;
        oppList.add(op);

        npsp__Allocation__c gauAllocation = Utility_Test.createGauAllocation(double.valueOf('56.000'),gau.id,op.id);
        insert    gauAllocation;
            
        DN_BalanceCalculationForDonor.donorBalanceCal(oppList,Donor.Id);    
        DN_BalanceCalculationForDonor.donorBalanceCal(null,null);//To cover Catch block 
   
        }
        test.stopTest();
    }
}