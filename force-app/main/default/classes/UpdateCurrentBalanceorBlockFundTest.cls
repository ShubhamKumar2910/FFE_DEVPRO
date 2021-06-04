@isTest
public class UpdateCurrentBalanceorBlockFundTest{

    public static testmethod void execute(){
       Contact con =  Utility_Test.insertNewContact('Jayanth','christopher','7823483829','jayanthdf7829@gmail.com','3262787878',null,null);
       insert con;
       
       Business_Account__c ba = new Business_Account__c(Name='FCRA',Account_No__c='789878675612');
       insert ba;
        
       Donation_Program__c prg = new Donation_Program__c(Approval_Status__c='New',Name='Corpus Fund'); 
       insert prg;
        
       npsp__General_Accounting_Unit__c gau = new npsp__General_Accounting_Unit__c(name='Offline Donation - Corpus Fund (598 - Non FCRA)',Business_Account__c=ba.id,Program__c=prg.id); 
       insert gau;
       
       
        
       Donor_Balance__c db = new Donor_Balance__c(Donor_Name__c=con.id,GAU_Name__c=gau.id,Current_Balance__c=20); 
       insert db;
    }
}