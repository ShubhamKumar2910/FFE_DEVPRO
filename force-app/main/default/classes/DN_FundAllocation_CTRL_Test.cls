/*
* Purpose: Test class for DN_FundAllocation_CTRL Class
*/
@isTest
public class DN_FundAllocation_CTRL_Test { 
    public static testmethod void studentCriteria(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            Contact donor  = Utility_Test.insertNewDonorId('ABC','XYZ');
            insert donor;
            
            Contact studentCon  = Utility_Test.insertSingleStudent('WER','BRO');
            insert studentCon;
            
            Donation_Program__c dp = Utility_Test.createDonationProgram('Engineering','Engineering');
            insert dp;
            npsp__General_Accounting_Unit__c ga = Utility_Test.createGAU('ASP - Engineering',dp.Id);
            insert ga;
            
            Donor_Balance__c donorbalance = Utility_Test.createDonorBalance(donor.id,ga.id);
            insert donorbalance;
            List<String> dnList= new List<String>();
            dnList.add(string.valueof(donorbalance.id));
            Application__c appParent = Utility_Test.insertNewApplication('Selected', 'Submitted');
            appParent.Student__c=studentCon.id;
            insert appParent;
            String addAppRecordType     = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.ADDITIONAL_APPLICATION).getRecordTypeId();
            Application__c app = Utility_Test.insertNewApplication('Selected', 'Submitted');
            app.Student__c = studentCon.id;
            app.RecordTypeId = addAppRecordType;
            app.Parent_Application__c = appParent.id;
            insert app;
            Application__c app1 = Utility_Test.insertNewApplication('Selected', 'Submitted');
            app1.Student__c = studentCon.id;
            app1.RecordTypeId = addAppRecordType;
            app1.Internal_Status__c =Constants.AWAITING_FUND_STATUS;
            app1.Application_owner__c = Userinfo.getUserid();
            app1.Application_Stage__c = Constants.ACTIVE_APPLICATION;
            insert app1;
            List<id> appList= new List<id>();
            appList.add(app.id);
            List<String> additionalExpense = new List<String>();
            additionalExpense.add(app.RecordTypeId);
            List<Contact> conList = new List<Contact>();
            conList.add(studentCon);
            
            
            FundDisburseWrapper.fundedAmtByGAU funded = new FundDisburseWrapper.fundedAmtByGAU();
            
            FundDisburseWrapper fw = new FundDisburseWrapper();
            fw.student             = studentCon;
            fw.appln               = app;
            fw.amtFunded           = new List<FundDisburseWrapper.fundedAmtByGAU>();
            FundDisburseWrapper.fundedAmtByGAU check = new FundDisburseWrapper.fundedAmtByGAU();
            check.donorbalance = donorbalance;
            check.extraFunds = '10000';
            fw.amtFunded.add(check);
            fw.donorBalanceIds     = dnList;
            
            DN_FundAllocation_CTRL.searchFilterWrapper sw = new DN_FundAllocation_CTRL.searchFilterWrapper();
            sw.studentType =Constants.ALL_AWAITING_STUDENT;
            sw.applType = appList;
            
            DN_FundAllocation_CTRL.searchFilterWrapper sw1 = new DN_FundAllocation_CTRL.searchFilterWrapper();
            sw1.studentType =Constants.ALL_MAPPED_STUDENT;
            sw1.applType = appList;
            
            DN_FundAllocation_CTRL.searchFilterWrapper sw2 = new DN_FundAllocation_CTRL.searchFilterWrapper();
            sw2.studentType =Constants.ALL_UNMAPPED_STUDENT;
            sw2.applType = appList;
            DN_FundAllocation_CTRL.searchFilterWrapper sw3 = new DN_FundAllocation_CTRL.searchFilterWrapper();
            sw3.studentType =Constants.ALL_UNMAPPED_STUDENT;

                DN_FundAllocation_CTRL.searchFilterWrapper sw4 = new DN_FundAllocation_CTRL.searchFilterWrapper();
            sw4.studentType =Constants.ALL_MULTI_DONOR_MAPPED_STUDENT;

            
            DN_FundAllocation_CTRL dnFund = new DN_FundAllocation_CTRL();
            
            
            
            Donor_Application_Mapping__c dam = new Donor_Application_Mapping__c();
            dam.Donor__c=donor.id;
            dam.Student__c=studentCon.id;
            dam.Application__c=appParent.id;
            insert dam;
            DN_FundAllocation_CTRL.getStudentswithApplication(sw);
            DN_FundAllocation_CTRL.getStudentswithApplication(sw1);
            DN_FundAllocation_CTRL.getStudentswithApplication(sw2);
            DN_FundAllocation_CTRL.getStudentswithApplication(sw3);
            DN_FundAllocation_CTRL.getStudentswithApplication_multi(sw);
            DN_FundAllocation_CTRL.getStudentswithApplication_multi(sw1);
            DN_FundAllocation_CTRL.getStudentswithApplication_multi(sw2);
            DN_FundAllocation_CTRL.getStudentswithApplication_multi(sw3);
             DN_FundAllocation_CTRL.getStudentswithApplication_multi(sw4);
            DN_FundAllocation_CTRL.getStudentsByDonorName(donor.Id);
            DN_FundAllocation_CTRL.getDonorStudentMapping(app.Id);
            DN_FundAllocation_CTRL.getDonorStudentMapping_multi(app.Id);
            DN_FundAllocation_CTRL.getGAUWiseDonorBalance(ga.Id,'Individual');
            DN_FundAllocation_CTRL.getDonorByName('ABC');
            DN_FundAllocation_CTRL.disburseFund(fw);
            List<ID> zeroList= new List<ID>();
            DN_FundAllocation_Helper.getAllUnMappedStudents(zeroList);
            DN_FundAllocation_Helper.getAllMappedStudents(zeroList);
            DN_FundAllocation_Helper.getAllAwaitingStudents(zeroList);
            DN_FundAllocation_Helper.getAwatingingApplications(additionalExpense,conList);
            DN_FundAllocation_Helper.getAdditionalExpnsAppln(app.RecordTypeId,studentCon.RecordTypeId);
            DN_FundAllocation_Helper.getDonorBalances(donor.Id);
            test.stopTest();
        }
    }
}