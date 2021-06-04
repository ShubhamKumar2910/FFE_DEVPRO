@isTest
public class WebServiceButtonHelper_Test {
    
    public static testmethod void mailAndApproval(){
         id applicationRecordType   = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_RENEWAL_APPLICATION).getRecordTypeId(); 
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact con = Utility_Test.insertNewStudentRec('ABC','ZYX',null,null,'7829483829',null,null,70,90,'cet','2016');
            insert con;
            Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
            app.Student__c = con.id;
            insert app;
            
            WebServiceButtonHelper.sendEmailWithTemplateThroughCustomButton(con.id,app.id);
            WebServiceButtonHelper.submitSobjectApprovalProcess(app.id, auser.id, 'Student_scholarship_status'); 
              WebServiceButtonHelper.priceList(app.id);
            app.RecordTypeId = applicationRecordType;
            update app;
            WebServiceButtonHelper.priceList(app.id);
            WebServiceButtonHelper.send_SMS_during_Events(new List<String>{con.id},'message');
            WebServiceButtonHelper.send_SMS('7829483829');
            WebServiceButtonHelper.send_80G_form_SMS('7829483829',Constants.MAIL_SENT_SUCCESS_MSG);
            WebServiceButtonHelper.runBatch();
            WebServiceButtonHelper.sendBulk80GForm(con.id);
            
            Contact donor = Utility_Test.insertNewDonorId('jay','donor');
            insert donor;
            WebServiceButtonHelper.saveAttachement(con.id,'2019-20');
            //Payment_Order__c pyord = createPaymentOrder();
            WebServiceButtonHelper.saveAttachementForUtilization(con.id,'2019-20');
            
        }
        test.stopTest();
    }
    
    @isTest
    public static void method1() {
        Contact donor = Utility_Test.insertNewDonorId('jay','donor');
        insert donor;
        
        Contact con = Utility_Test.insertNewStudentRec('ABC','ZYX',null,null,'7829483829',null,null,70,90,'cet','2016');
        insert con;
        
        Application__c app = Utility_Test.insertNewApplication('Disbursed','Submitted');
        
        app.Student__c = con.id;
        app.DM_Financial_Year__c  = '';
        
        insert app;
        
        Donor_Application_Mapping__c newDAM     =  new Donor_Application_Mapping__c();
        newDAM.Donor__c = donor.id;
        newDam.Application__c = app.id;
        newDam.Student__c = con.id;
        newDam.Ext_Financial_year__c = '2019-20';
        insert newDAM;
        
        Business_Account_Utilization__c bau = new Business_Account_Utilization__c(Application__c=app.id); 
        insert bau;
        Business_Account__c ba = new Business_Account__c(Name='FCRA',Account_No__c='789878675612');
        insert ba;
        Donation_Program__c prg = new Donation_Program__c(Approval_Status__c='New',Name='Engineering'); 
        insert prg;
        
        npsp__General_Accounting_Unit__c gau = new npsp__General_Accounting_Unit__c(name='ASP - FCRA -Engineering',Business_Account__c=ba.id,Program__c=prg.id); 
        insert gau;
        Donor_Balance__c db = new Donor_Balance__c(Donor_Name__c=donor.id,GAU_Name__c=gau.id,Current_Balance__c=100); 
        insert db;
        
        Fund_Utilization__c fau = new Fund_Utilization__c(Application__c=app.id,Business_Account_Utilization__c=bau.id,Donor__c=donor.id,Donor_Balance__c=db.id,General_Accounting_Unit__c=gau.id,Refunded_Amount__c=10000);    
        insert fau;
        
        
        Test.startTest();
        
        WebServiceButtonHelper.checkForDonAppMapping(donor.id,'2019-20');
        newDam.Ext_Financial_year__c = '2020-21';
        update newDam;
        WebServiceButtonHelper.checkForDonAppMapping(donor.id,'2019-20');
        
        WebServiceButtonHelper.checkForFundUtilization(donor.id,'2019-20');
        WebServiceButtonHelper.refundAmount(gau.id,donor.id,'',1000,'',null);
        WebServiceButtonHelper.refundAmount(gau.id,donor.id,'',1000,db.id,1000);
        BeneficiaryDetailController bdc = new BeneficiaryDetailController();
        FundUtilizationController fuc = new FundUtilizationController();
        
        Test.stopTest();
        
    }
    
}