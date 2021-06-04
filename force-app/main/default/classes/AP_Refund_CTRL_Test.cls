@isTest
public class AP_Refund_CTRL_Test {

        public static testmethod void execute(){
        Contact con =  Utility_Test.insertNewContact('Jayanth','christopher','7823483829','jayanthdf7829@gmail.com','3262787878',null,null);
        insert con;
        
        Business_Account__c ba = new Business_Account__c(Name='FCRA',Account_No__c='789878675612');
        insert ba;
        
        Donation_Program__c prg = new Donation_Program__c(Approval_Status__c='New',Name='Engineering'); 
        insert prg;
        
        //Donation_Program__c prg1 = new Donation_Program__c(Approval_Status__c='New',Name='Medical'); 
        //insert prg1;
        
        npsp__General_Accounting_Unit__c gau = new npsp__General_Accounting_Unit__c(name='ASP - FCRA -Engineering',Business_Account__c=ba.id,Program__c=prg.id); 
        insert gau;
        
        //npsp__General_Accounting_Unit__c gau1 = new npsp__General_Accounting_Unit__c(name='ASP - FCRA -Medical',Business_Account__c=ba.id,Program__c=prg1.id); 
        //insert gau1;
        
        Donor_Balance__c db = new Donor_Balance__c(Donor_Name__c=con.id,GAU_Name__c=gau.id,Current_Balance__c=100); 
        insert db;
        
        //Donor_Balance__c db1 = new Donor_Balance__c(Donor_Name__c=con.id,GAU_Name__c=gau1.id,Current_Balance__c=20000); 
        //insert db1;
        
        Contact student = Utility_Test.insertSingleStudent('jayanth','b');   
        insert student;    
            
		Application__c app = new Application__c(Student__c=student.id,Amount_Requested__c=10000);
        insert app;
            
        Business_Account_Utilization__c bau = new Business_Account_Utilization__c(Application__c=app.id); 
        insert bau;
            
        Fund_Utilization__c fau = new Fund_Utilization__c(Application__c=app.id,Business_Account_Utilization__c=bau.id,Donor__c=con.id,Donor_Balance__c=db.id,General_Accounting_Unit__c=gau.id,Refunded_Amount__c=10000);    
        insert fau;
            
        Refund__c refund = new Refund__c(Application__c=app.id,Student__c=student.id,Refund_Transaction_No__c='TRS1',Refunded_Amount__c=10000);
        insert refund;    
            
        ApexPages.StandardController sc = new ApexPages.StandardController(refund);
        PageReference pageRef = Page.TransferFunds;
        pageRef.getParameters().put('refId', refund.Id);
        Test.setCurrentPage(pageRef);
        Ap_Refund_CTRL dfT = new Ap_Refund_CTRL();
        dfT.doSave();   
            
            
        Fund_Utilization__c fau1 = new Fund_Utilization__c(Application__c=app.id,Business_Account_Utilization__c=bau.id,Donor__c=con.id,Donor_Balance__c=db.id,General_Accounting_Unit__c=gau.id);    
        insert fau1;
            
        Refund__c refund1 = new Refund__c(Application__c=app.id,Student__c=student.id,Refund_Transaction_No__c='TRS1',Refunded_Amount__c=10000);
        insert refund1;    
            
        ApexPages.StandardController sc1 = new ApexPages.StandardController(refund1);
        PageReference pageRef1 = Page.TransferFunds;
        pageRef1.getParameters().put('refId', refund1.Id);
        Test.setCurrentPage(pageRef1);
        Ap_Refund_CTRL dfT1 = new Ap_Refund_CTRL();
        dfT1.doSave();    
    }
}