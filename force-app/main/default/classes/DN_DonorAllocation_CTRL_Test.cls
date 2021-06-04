/*
* Purpose: Test class for DN_DonorAllocation_CTRL Class
*/
@isTest
public class DN_DonorAllocation_CTRL_Test {
    
    public static testmethod void dnCtrlTest(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            List<String> studentState1 = new List<String>();
            studentState1.add('Karnataka');
            
            List<String> collegeCity1 = new List<String>();
            collegeCity1.add('Bangalore');
            
            List<String> collegStates1 = new List<String>();
            collegStates1.add('Karnataka');
            
            List<String> collegeNames = new List<String>();
            collegeNames.add('CBIT');
            
            List<String> Courses = new List<String>();
            Courses.add('Medical');
            
            List<String> Ratings = new List<String>();
            Ratings.add('A+');
            
            collegeFilterWrpper  searchFilter = new collegeFilterWrpper();
            searchFilter.studentState  =  studentState1;
            searchFilter.collegeCity   =  collegeCity1;
            searchFilter.collegStates  =  collegStates1;
            searchFilter.collegeName   =  collegeNames;
            searchFilter.Course        =  Courses;
            searchFilter.collegeRating =  Ratings;
            searchFilter.maxIncome    = double.valueOf('60.000');
            searchFilter.minIncome    =double.valueOf('62.000');
            
            Contact donor  = Utility_Test.insertNewDonorId('ABC','XYZ');
            insert donor;
            
            Contact studentCon  = Utility_Test.insertSingleStudent('WER','BRO');
            insert studentCon;
            
            List<String> lstcontact = new List<String>();
            lstcontact.add(studentCon.id);
            
            Donation_Program__c donationprogram = Utility_Test.createDonationProgram('Medical','Medical');
            insert donationprogram;
            
            npsp__General_Accounting_Unit__c generalAccount = Utility_Test.createGAU('ASP - Medical',donationprogram.id);
            insert generalAccount;
            
            List<String> gaus = new  List<String>();
            gaus.add(generalAccount.id);
            
            List<String> donorLocations = new List<String>();
            donorLocations.add('Karnataka');
            
            DonorFilterWrapper  filterWrapper = new DonorFilterWrapper();
            filterWrapper.locations =donorLocations;
            filterWrapper.gaus      =gaus;
            filterWrapper.isDonorBalance = true;
            List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper> wrp = new List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper>();
                        
            DN_DonorAllocation_CTRL dn = new DN_DonorAllocation_CTRL();
            
            DN_DonorAllocation_CTRL.createDonorStudentMapping(donor.Id, wrp);
            DN_DonorAllocation_CTRL.getDonorDetails();
            DN_DonorAllocation_CTRL.getFilteredDonors(filterWrapper);
            DN_DonorAllocation_CTRL.getFilteredStudents(searchFilter,donor.Id);
            DN_DonorAllocation_CTRL.getDonorLocation('Karnataka','India');
            DN_DonorAllocation_CTRL.getStudentCollegeState('Karnataka');
            DN_DonorAllocation_CTRL.getStudentCollegeCity('Bangalore');
            DN_DonorAllocation_CTRL.getStudentCollegeName('CBIT');
        }
        test.stopTest();
    }
}