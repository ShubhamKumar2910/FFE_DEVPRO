@isTest
private class DN_DonorAllocation_Test {
    
    static testmethod void donorAllocationTestData(){
        
        User testUser = Utility_Test.createUser('donorallocation@testuser.com');
        System.runAs(testUser){
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor; 
            
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            insert student;
            List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper> wrp = new List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper>();

            Test.startTest();
            DN_DonorAllocation_Helper.createDonorStudentMapping(donor.Id, wrp);
            DN_DonorAllocation_Helper.getDonorDetails();  
            
            List<String> studentState1 = new List<String>{'Karnataka'};                
            List<String> collegeCity1 = new List<String>{'Bangalore'};                    
            List<String> collegStates1 = new List<String>{'Karnataka'};                        
            List<String> collegeNames = new List<String>{'DummyCollege'};                            
            List<String> Courses = new List<String>{'BE/B.Tech'};            
            List<String> Ratings = new List<String>{'A+'};
            
            collegeFilterWrpper  searchFilter = new collegeFilterWrpper();
            searchFilter.studentState  =  studentState1;
            searchFilter.collegeCity   =  collegeCity1;
            searchFilter.collegStates  =  collegStates1;
            searchFilter.collegeName   =  collegeNames;
            searchFilter.Course        =  Courses;
            searchFilter.collegeRating =  Ratings;
            searchFilter.genderList     = new List<String>{'Male'};
            searchFilter.branchList     = new List<String>{'Computer Science'};
            searchFilter.maxIncome    = double.valueOf('60.000');
            searchFilter.minIncome    =double.valueOf('62.000');
            DN_DonorAllocation_Helper.getFilteredStudents(searchFilter,donor.Id);
            Test.stopTest();
            
        }
    }
    
    static testmethod void testFileredDonorList(){
        
        User testUser = Utility_Test.createUser('donorallocation@testuser.com');
        System.runAs(testUser){
            
            List<Contact> donors    = new List<Contact>();
            for(integer i=0;i<10;i++){
                Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com');              
                donor.MailingCity   = 'Bangalore';
                donor.MailingState  = 'Karnataka';
                donors.add(donor);
            }
            insert donors; 
            
            List<Contact> students  = new List<Contact>();
            for(integer i=0;i<10;i++){
                Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
                student.Internal_Status__c  = 'Awaiting for Fund';
                student.MailingCity         = 'Bangalore';
                student.MailingState        = 'Karnataka';
                if(i< 5){
                    student.Course__c           = 'MBBS';
                }else{
                    student.Course__c           = 'BE/B.Tech';
                }                
                students.add(student);
            }
            insert students; 
            
            List<Payment_Order__c> orders   = new List<Payment_Order__c>();
            for(Integer i=0;i<10;i++){
                orders.add(Utility_Test.createPaymentOrder(donors[i].Id,'OrderNo'+i));
            }
            insert orders;
            
            List<Donation_Program__c> programs  = new List<Donation_Program__c>();
            programs.add(Utility_Test.createDonationProgram('Engineering','Engineering'));
            programs.add(Utility_Test.createDonationProgram('Medical','Medical'));
            insert programs;
            
            LIst<Program_Frequency__c> progrmFreqs  = new LIst<Program_Frequency__c>();
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[0].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[1].Id,20000,0));
            insert progrmFreqs;
                
            List<Contact> dummyDonors   = [Select id,AccountId,FirstName,RecordTypeId,LastName,Email,Phone,MobilePhone,
                           Google_login_ID__c,Facebook_login_ID__c
                           from Contact where Id=:donors];
            
            /*List<Donor_Student_Mapping__c> mappings   =  new List<Donor_Student_Mapping__c>();
             
            for(integer i=0;i<10;i++){
                mappings.add(new Donor_Student_Mapping__c(Student__c= students[i].Id,Donor__c=donors[i].Id));
            }
            insert mappings;*/ 
            
            List<npsp__General_Accounting_Unit__c> gaus = new List<npsp__General_Accounting_Unit__c>();
            gaus.add(Utility_Test.createGAU('ASP-Eng',programs[0].Id));
            gaus.add(Utility_Test.createGAU('ASP-Med',programs[1].Id));            
            insert gaus;
                        
            List<Opportunity> donations = new List<Opportunity>();
            for(Integer i=0;i<10;i++){
                Opportunity op  = Utility_Test.createOpportunity('Donation'+i, null,orders[i].Id,'Pledged', 20000+i, String.valueOf(Date.today()));
                op.npsp__Primary_Contact__c = dummyDonors[i].Id;
                op.AccountId                = dummyDonors[i].AccountId;
                op.RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(DN_ServiceConstants.GENERAL_DONATION).getRecordTypeId(); 
                if(i<5){
                    op.Program_Frequency__c = progrmFreqs[0].Id;
                }else{
                    op.Program_Frequency__c = progrmFreqs[0].Id;
                }                
                donations.add(op);
            }
            insert donations;
            List<Donor_Balance__c> balances =  new List<Donor_Balance__c>();
            for(Integer i =0;i<10;i++){
                Donor_Balance__c db     = Utility_Test.createDonorBalance(dummyDonors[i].Id,gaus[0].Id);
                db.Current_Balance__c   = 10000;
                db.Blocked_Funds__c     = 5000;
                balances.add(db);
                Donor_Balance__c db2    = Utility_Test.createDonorBalance(dummyDonors[i].Id,gaus[1].Id);
                db2.Current_Balance__c  = 10000;
                db2.Blocked_Funds__c        = 5000;
                balances.add(db2);
            }
            insert balances;
            
            DonorFilterWrapper frw  = new DonorFilterWrapper();
            frw.locations           = new List<String>{'Karnataka'};
            frw.gaus                = new List<String>{programs[0].Id,programs[1].Id};  
            DN_DonorAllocation_Helper.getFileredDonorList(frw);
            
            DonorFilterWrapper frw1 = new DonorFilterWrapper();
            frw1.locations          = new List<String>{'Karnataka'};
            frw1.gaus               = new List<String>{programs[0].Id,programs[1].Id};
            frw1.isDonorBalance     = true;
            DN_DonorAllocation_Helper.getFileredDonorList(frw1);
            
            DonorFilterWrapper frw2 = new DonorFilterWrapper();
            frw2.locations          = new List<String>{'Karnataka'};
            DN_DonorAllocation_Helper.getFileredDonorList(frw2);
            
            DonorFilterWrapper frw3 = new DonorFilterWrapper();
            frw3.locations          = new List<String>{'Karnataka'};
            frw3.isDonorBalance     = true;
            DN_DonorAllocation_Helper.getFileredDonorList(frw3);
            Test.startTest();
            
            DonorFilterWrapper frw4 = new DonorFilterWrapper();
            frw4.isDonorBalance     = true;
            DN_DonorAllocation_Helper.getFileredDonorList(frw4);
            
            DonorFilterWrapper frw5 = new DonorFilterWrapper();
            frw5.isDonorBalance     = false;
            DN_DonorAllocation_Helper.getFileredDonorList(frw5);
            DN_DonorAllocation_Helper.getFileredDonorList_multiDonor(frw5,'Alumni');
            Test.stopTest();
        }
    }

    static testmethod void testNegativeScenario(){
        
        User testUser = Utility_Test.createUser('donorallocation@testuser.com');
        System.runAs(testUser){
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor; 
            
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            student.Internal_Status__c =Constants.AWAITING_FUND_STATUS;
            insert student;
            
            Application__c app = new Application__c();
            app.Student__c = student.id;
            app.Internal_Status__c =Constants.AWAITING_FUND_STATUS;
            app.Application_Stage__c=Constants.ACTIVE_APPLICATION;
            app.Application_owner__c = Userinfo.getUserid();
            insert app;
            
            List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper> wrp = new List<DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper>();

            DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper obj = new DN_DonorAllocation_Helper.ApplicationDonorMappingWrapper();
             obj.donorRemark = 'ahjvds';
             obj.fundingAmount = '12';
             obj.appId = 'asdasd';
            wrp.add(obj);

            Donor_Application_Mapping__c dam = new Donor_Application_Mapping__c();
            dam.Student__c = student.id;
            dam.Donor_Remark__c ='testing';
            dam.Funding_amount__c = 20;
            dam.Application__c =app.id;
            dam.Donor__c = donor.id;
            //insert dam;
            
            Test.startTest();
            
            DN_DonorAllocation_Helper.getDonorDetails();
            DN_DonorAllocation_Helper.getGeneralAccountUnit();
            DN_DonorAllocation_Helper.createDonorStudentMapping('dummyId', wrp);
            DN_DonorAllocation_Helper.getGeneralAccountUnit();
            DN_DonorAllocation_Helper.getStudentCollegeCity('dummyCity');
            DN_DonorAllocation_Helper.getFilteredStudents(new CollegeFilterWrpper(),donor.Id);
            DN_DonorAllocation_Helper.getDonorLocation('dummyCity','dummycountry');
            DN_DonorAllocation_Helper.getStudentCollegeState('dummyState');
            DN_DonorAllocation_Helper.getStudentCollegeName('dummyCollegName');
            DN_DonorAllocation_Helper.getPrograms();
            DN_DonorAllocation_Helper.getPreviousYearAppln(donor.id);

            CollegeFilterWrpper obj1 =new  CollegeFilterWrpper();
            obj1.priorityList = '';
             DN_DonorAllocation_Helper.getFilteredStudents(new CollegeFilterWrpper(),donor.Id);

            Test.stopTest();
            
        }
    }
}