@isTest
public class DonorFundTransferTest{

    public static testmethod void execute(){
       Contact con =  Utility_Test.insertNewContact('Jayanth','christopher','7823483829','jayanthdf7829@gmail.com','3262787878',null,null);
       insert con;
       
       Business_Account__c ba = new Business_Account__c(Name='FCRA',Account_No__c='789878675612');
       insert ba;
        
       Donation_Program__c prg = new Donation_Program__c(Approval_Status__c='New',Name='Engineering'); 
       insert prg;
        
       npsp__General_Accounting_Unit__c gau = new npsp__General_Accounting_Unit__c(name='ASP - FCRA -Engineering',Business_Account__c=ba.id,Program__c=prg.id); 
       insert gau;
       
       
        
       Donor_Balance__c db = new Donor_Balance__c(Donor_Name__c=con.id,GAU_Name__c=gau.id,Current_Balance__c=20); 
       insert db;
       
       DonorFundTransfer db1 =  new DonorFundTransfer(new ApexPages.StandardController(db));
       
       
       db1.dbBalance = db;
       db1.destinationDonorDetails();
       
       npsp__General_Accounting_Unit__c gau1 = new npsp__General_Accounting_Unit__c(name='ASP - FCRA -Engineering',Business_Account__c=ba.id,Program__c=prg.id); 
       insert gau1;
       
       Donor_Balance__c db2 = new Donor_Balance__c(Donor_Name__c=con.id,GAU_Name__c=gau1.id,Current_Balance__c=20); 
       insert db2;
       
       DonorFundTransfer db3 =  new DonorFundTransfer(new ApexPages.StandardController(db2));
       
       db3.dbBalance = db;
       db3.destinationDonorDetails();
       
       Donor_Balance__c db4 = new Donor_Balance__c(Donor_Name__c=con.id,GAU_Name__c=gau1.id,Current_Balance__c=0); 
       insert db4;
       
       DonorFundTransfer db5 =  new DonorFundTransfer(new ApexPages.StandardController(db4));
       
       db5.dbBalance = db;
       db5.destinationDonorDetails();
       
    }

}