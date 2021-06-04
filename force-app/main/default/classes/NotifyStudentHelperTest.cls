@isTest
public class NotifyStudentHelperTest {
    @testSetup
    static void CreateData(){
                
        Donation_Program__c dp  = Utility_Test.createDonationProgram('Test','Medical');
        insert dp;
        npsp__General_Accounting_Unit__c gau =Utility_Test.createGAU('Test',dp.id);
        insert gau;
        List<String> fyYear =Utility_Test.TenFinancialYearexcluding();
        
        Contact conDonor = Utility_Test.insertNewDonorId('Test','Donor');
        conDonor.Email ='testdonor@mailinator.com';
        conDonor.MobilePhone = '8888888';
        insert conDonor;
        
        College_Master__c cm = Utility_Test.createCollegeMaster('Test','Bangalore','AA','KA');
        insert cm;
        
        Contact conStudent = Utility_Test.insertSingleStudent('Test','Student');
        conStudent.MailingState = 'Karnataka';
        conStudent.Course__c = 'BE/B.Tech';
        conStudent.College_Name__c = cm.Id;
        conStudent.Email = 'Teststud@mailinator.com';
        conStudent.MobilePhone = '777777778888';
        conStudent.Financial_year__c = '2017-18';
        insert conStudent;
        
        Application__c ap = Utility_Test.insertNewApplication('Selected','Submitted');
        ap.Student__c = conStudent.Id;
        ap.DM_Financial_Year__c = '2017-18';
        insert ap;
        
        Business_Account__c  ba = new Business_Account__c();
        ba.Name = 'AXIS Bank';
        insert ba;
        
        Business_Account_Utilization__c bau = new Business_Account_Utilization__c();
        bau.Application__c = ap.Id;
        insert bau;
        
        Fund_Utilization__c fu = new Fund_Utilization__c();
        fu.Donor__c = conDonor.Id;
        fu.Application__c = ap.Id;
        fu.General_Accounting_Unit__c = gau.Id;
        fu.Business_Account_Utilization__c = bau.Id;
        insert fu;
    }
    
    static testmethod void mailAndApproval(){
        
        Donation_Program__c dp = [Select Id,Name from Donation_Program__c Limit 1];
        npsp__General_Accounting_Unit__c gau = [Select Id,Name from npsp__General_Accounting_Unit__c Limit 1];
        Contact constud = [Select Id,Name from Contact where Email='Teststud@mailinator.com' Limit 1];
        Contact conDonor = [Select Id,Name from Contact where Email='testdonor@mailinator.com' Limit 1];
        Application__c ap = [Select Id,Name from Application__c Limit 1];
        Business_Account__c ba = [Select Id,Name from Business_Account__c Limit 1];
        Business_Account_Utilization__c bau = [Select Id,Name,Application__c from  Business_Account_Utilization__c limit 1];
        Fund_Utilization__c fu = [Select Id,Donor__c,Application__c,General_Accounting_Unit__c,Business_Account_Utilization__c from Fund_Utilization__c Limit 1];
        
        Test.startTest();
        NotifyStudentHelper.GauNameDetails();
        NotifyStudentHelper.PastTenFinancialYear();
        NotifyStudentHelper.currentTenFinancialYearexcludingThis();
        NotifyStudentHelper.sendNotify('2017-18',gau.Name,'Welcome Email Message',conDonor.Id,'Welcome Student SMS');
        NotifyStudentHelper.sendNotify_New('2017-18',gau.Name,'Welcome Email Message',conDonor.Id,'Welcome Student SMS','true','true');
        Test.stopTest();
    }

}