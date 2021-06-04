/*
* Purpose: Test class for DonationAllocationAmtCalculation Class
*/
@isTest
public class DonationAllocationAmtCalculation_Test {
    
    public static Contact createDonor(String lastname){
        
        id donorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        
        Contact con  = new Contact();
        con.LastName = lastname;
        con.RecordTypeId = donorRecordType;
        return con;
    }
    
    public static testmethod void calculateAmt(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact con = createDonor('Donor');
            insert con;
            Payment_Order__c order = Utility_Test.createPaymentOrder(con.id,'DN14927710012471989614899');
            insert order;
            Donation_Program__c dp = Utility_Test.createDonationProgram('Engineering','Engineering');
            insert dp;
            npsp__General_Accounting_Unit__c ga = Utility_Test.createGAU('ASP - Engineering',dp.Id);
            insert ga;
            Program_Frequency__c pf = Utility_Test.createProgramFrequency('Lumpsum 200000 [INR]',dp.Id,200000,100000);
            insert pf;
            opportunity op = Utility_Test.createOpportunity('SM Donation',pf.Id,order.Id,'Pledged',800000,'2017-12-27');
            insert op;
            npsp__Allocation__c gau = Utility_Test.createGauAllocation(800000,ga.Id,op.Id);
            insert gau;
            
            DonationAllocationAmtCalculation.checkOpportunityStage(order.Order_No__c,op.id,con.id);
        }
        test.stopTest();
    }
    
    public static testmethod void calculateAmt1(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact con = createDonor('Donor');
            insert con;
            Payment_Order__c order = Utility_Test.createPaymentOrder(con.id,'DN14927710012471989614899');
            insert order;
            Donation_Program__c dp = Utility_Test.createDonationProgram('Engineering','Engineering');
            insert dp;
            npsp__General_Accounting_Unit__c ga = Utility_Test.createGAU('ASP - Engineering',dp.Id);
            insert ga;
            Program_Frequency__c pf = Utility_Test.createProgramFrequency('Lumpsum 200000 [INR]',dp.Id,200000,100000);
            insert pf;
            opportunity op = Utility_Test.createOpportunity('SM Donation',pf.Id,order.Id,'Pledged',800000,'2017-12-27');
            insert op;
            opportunity op1 = Utility_Test.createOpportunity('SM1 Donation',pf.Id,order.Id,'Pledged',1800000,'2017-12-27');
            insert op1;
            opportunity op2 = Utility_Test.createOpportunity('SM2 Donation',pf.Id,order.Id,'Pledged',600000,'2017-12-27');
            insert op2;
            
            DonationAllocationAmtCalculation.checkOpportunityStage(order.Order_No__c,op1.id,con.id);
            
        }
        test.stopTest();
    }
    
    public static testmethod void calculateAmt2(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact con = createDonor('Donor');
            insert con;
            Payment_Order__c order = Utility_Test.createPaymentOrder(con.id,'DN14927710012471989614899');
            insert order;
            Donation_Program__c dp = Utility_Test.createDonationProgram('Engineering','Engineering');
            insert dp;
            npsp__General_Accounting_Unit__c ga = Utility_Test.createGAU('ASP - Engineering',dp.Id);
            insert ga;
            Program_Frequency__c pf = Utility_Test.createProgramFrequency('Lumpsum 200000 [INR]',dp.Id,200000,100000);
            insert pf;
            opportunity op1 = Utility_Test.createOpportunity('SM1 Donation',pf.Id,order.Id,'Pledged',1800000,'2017-12-27');
            insert op1;
            opportunity op2 = Utility_Test.createOpportunity('SM2 Donation',pf.Id,order.Id,'Pledged',180000,'2017-11-27');
            insert op2;
            opportunity op3 = Utility_Test.createOpportunity('SM2 Donation',pf.Id,order.Id,'Pledged',18000,'2017-10-27');
            insert op3;
            npsp__Allocation__c gau = Utility_Test.createGauAllocation(800000,ga.Id,op1.Id);
            insert gau;
            
            DonationAllocationAmtCalculation.checkOpportunityStage(order.Order_No__c,op1.id,con.id);
            DonationAllocationAmtCalculation.checkOpportunityStage(order.Order_No__c,null,con.id);
            DonationAllocationAmtCalculation.checkOpportunityStage(null,op1.id,con.id);//to return Error Message
            
            
        }
        test.stopTest();
    }
    
    public static testmethod void calculateAmt3(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            Contact con = createDonor('Donor');
            insert con;
            //Contact con1 = Utility_Test.insertSingleStudent('FirstName','lastName');
            //insert con1;
            Payment_Order__c order = Utility_Test.createPaymentOrder(con.id,'DN14927710012471989614899');
            insert order;
            Donation_Program__c dp = Utility_Test.createDonationProgram('Engineering','Engineering');
            insert dp;
            npsp__General_Accounting_Unit__c ga = Utility_Test.createGAU('ASP - Engineering',dp.Id);
            insert ga;
            Program_Frequency__c pf = Utility_Test.createProgramFrequency('Lumpsum 200000 [INR]',dp.Id,200000,100000);
            insert pf;
            opportunity op1 = Utility_Test.createOpportunity('SM1 Donation',pf.Id,order.Id,'Posted',1800000,'2017-12-27');
            insert op1;
            opportunity op2 = Utility_Test.createOpportunity('SM1 Donation',pf.Id,order.Id,'Posted',800000,'2017-12-27');
            insert op2;
            npsp__Allocation__c gau = Utility_Test.createGauAllocation(800000,ga.id,op1.id);
            insert gau;
            npsp__Allocation__c gau1 = Utility_Test.createGauAllocation(800,ga.id,op2.id);
            insert gau1;
            DonationAllocationAmtCalculation.checkOpportunityStage(order.Order_No__c,op1.id,con.id);
        }
    }
    
}