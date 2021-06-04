/* Description: Reusable methods
* 
*/
public class Utility_Test {
    /*
    *@purpose    : get Test User record for Test Class
    *@peturn Type: User
    */
    public static User createUser(string dummyusername){
        String user_id = userinfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User dummyUser = new User(Alias = 'abcuser', Email='tfistandarduser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_IN', ProfileId = p.Id,TimeZoneSidKey='Asia/Kolkata',UserName=dummyusername);
        return dummyUser;
    }
    
    
    /*
    *@purpose     : Inserting contact object withdonor recordtype
    *@peturn Type : Contact
    */
    public static Contact insertNewContact(String FirstName,String lastName,String Phone,String Email,String MobilePhone,String googleLogin,String faceBookLogin){
        id donorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        Contact newDonor     =  new Contact();
        newDonor.FirstName   = FirstName;
        newDonor.LastName    = lastName;
        newDonor.Phone       = Phone;
        newDonor.Email       = Email;
        newDonor.MobilePhone = MobilePhone;
        newDonor.Google_login_ID__c=googleLogin;
        newDonor.Facebook_login_ID__c=faceBookLogin;
        newDonor.RecordTypeId   = donorRecordType;
        return newDonor;
    }
    
     /*
    *@purpose     : Inserting contact object with Mentor recordtype
    *@peturn Type : Contact
    */
    public static Contact insertNewMentor(String FirstName,String lastName,String Phone,String Email,String MobilePhone){
        id mentorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
        Contact newMentor     =  new Contact();
        newMentor.FirstName   = FirstName;
        newMentor.LastName    = lastName;
        newMentor.Phone       = Phone;
        newMentor.Email       = Email;
        newMentor.MobilePhone = MobilePhone;
        newMentor.RecordTypeId   = mentorRecordType;
        return newMentor;
    }
    
      /*
    *@purpose     : Inserting Mentor Mentee Association
    *@peturn Type : Mentor Mentee Association
    */
    public static Mentor_Mentee_Association__c insertNewMentorMenteeAssociation(String mentorId,String menteeId){
        Mentor_Mentee_Association__c newMMA     =  new Mentor_Mentee_Association__c();
        newMMA.mentee_del__c = menteeId;
        newMMA.Mentor__c = mentorId;
        newMMA.Status__c = 'Approved';
        newMMA.Modules__c = 'Time Management and Commitment';
        return newMMA;
    }
    
       /*
    *@purpose     : Inserting session
    *@peturn Type : session
    */
    public static Session__c insertNewSession(String mmaId){
        Session__c newSession     =  new Session__c();
        newSession.Mentor_Mentee_Association__c = mmaId;
        newSession.Status__c = 'Created';
        newSession.Status__c = 'Approved';
        return newSession;
    }
    
      /*
    *@purpose     : Inserting Feedback
    *@peturn Type : Feedback  */
    
    public static Feedback__c insertNewFeedback(String Description, String sessionId, String menteeRating, String mentorRating, string feedbackGiven){
        Feedback__c newFeedback     =  new Feedback__c();
        newFeedback.Feedback_given_by__c = feedbackGiven;
        newFeedback.Description__c = Description;
        newFeedback.Mentee_Rating__c = menteeRating;
		newFeedback.Mentor_Rating__c = mentorRating;
		newFeedback.Session__c = sessionId;
        return newFeedback;
    }
    
    
    
    /*
    *@purpose     : This method is used for insert and update  records
    *@peturn Type : Contact
    */
    public static Contact updateContact(String FirstName,String lastName,String Phone,String Email,String MobilePhone,String googleLoginId,String facebookLogin){
        id donorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        Contact newDonor     =  new Contact();
        newDonor.FirstName   = firstName;
        newDonor.LastName    = lastName;
        newDonor.Email       = email;
        newDonor.Phone       = Phone;
        newDonor.MobilePhone = MobilePhone;
        newDonor.Google_login_ID__c=googleLoginId;
        newDonor.Facebook_login_ID__c=facebookLogin;
        
        //insert newDonor;
        return newDonor;
    }
    
    public static Contact insertNewDonorId(String FirstName,String lastName){
        id donorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        Contact newDonor     =  new Contact();
        newDonor.FirstName   = firstName;
        newDonor.LastName    = lastName;
        newDonor.RecordTypeId=donorRecordType;
        //insert newDonor;
        return newDonor;
    }      
    
    public static List<String> insertNewContactStudent(String FirstName,String lastName){
        id StudentRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        List<String> lstContactStrings = new List<String>();
        for(Integer i=0;i<=3;i++){
            Contact newStudent      =  new Contact();
            newStudent.FirstName    = FirstName+i;
            newStudent.LastName     = lastName+i;
            newStudent.RecordTypeId = StudentRecordType;
            lstContactStrings.add(JSON.serializePretty(newStudent)); 
        }
        return lstContactStrings;
    }
    
    public static Contact insertSingleStudent(String FirstName,String lastName){
        id StudentRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        Contact newStudent      =  new Contact();
        newStudent.FirstName    = FirstName;
        newStudent.LastName     = lastName;
        newStudent.RecordTypeId = StudentRecordType;
        return newStudent;
    }
    
    public static List<String> insertNewContactFacilitator(String FirstName,String lastName){
        id facRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
        List<String> lstContactFac = new List<String>();
        for(Integer i=0;i<=3;i++){
            Contact newFacilitator         =  new Contact();
            newFacilitator.FirstName       = FirstName+i;
            newFacilitator.LastName        = lastName+i;
            newFacilitator.Working_Mode__c = Constants.ONLINE_WORKINGMODE;
            newFacilitator.RecordTypeId     = facRecordType;
            lstContactFac.add(JSON.serializePretty(newFacilitator)); 
        }
        return lstContactFac;
    }
    
    public static Contact insertFacilitator(String FirstName,String lastName){
        id facilitiatorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
        Contact newFacilitator         =  new Contact();
        newFacilitator.FirstName       = FirstName;
        newFacilitator.LastName        = lastName;
        newFacilitator.Working_Mode__c = Constants.ONLINE_WORKINGMODE;
        newFacilitator.RecordTypeId     = facilitiatorRecordType;
        return newFacilitator;
    } 
    
    
    public static Application__c insertNewApplication(string internalStatus, string externalStatus){
        id applicationRecordType   = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 
        Application__c newApp     =  new Application__c();
        newApp.Internal_Status__c     = internalStatus;//'Selected';
        newApp.External_Status__c     = externalStatus;//'Submitted';
        newApp.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        newApp.Application_Stage__c   = Constants.APP_STAGE_OPEN;
        return newApp;
    }
    
    /*public static Donor_Student_Mapping__c insertNewDonorStudentMapping(Contact student, Contact donor){
        
        Donor_Student_Mapping__c newDSM     =  new Donor_Student_Mapping__c();
        newDSM.Donor__c = donor.id;
        newDSM.Student__c = student.id;
        
        return newDSM;
    }*/
    
    public static Contact insertNewStudentRec(String FirstName,String lastName,String Phone,String Email,String MobilePhone,String googleLogin,String faceBookLogin,Decimal XIIth,Decimal maximumMarks,String entranceName,String X12th_Year_Passed){
        id studentRecordType                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        Contact newStudent                  = new Contact();
        newStudent.FirstName                = FirstName;
        newStudent.LastName                 = lastName;
        newStudent.RecordTypeId             = studentRecordType;
        newStudent.Phone                    = Phone;
        newStudent.Email                    = Email;
        newStudent.MobilePhone              = MobilePhone;
        newStudent.Google_login_ID__c       = googleLogin;
        newStudent.Facebook_login_ID__c     = faceBookLogin;
        newStudent.X12th_Marks_Obtained__c  = XIIth;
        newStudent.X12th_Maximum_Marks__c   = maximumMarks;
        newStudent.Entrance_Test_Name__c    = entranceName;
        newStudent.X12th_Year_Passed__c     = X12th_Year_Passed;
        //insert newStudent;
        return newStudent;
    }
    
    public static Payment_Order__c createPaymentOrder(id conid,string orderno){
        
        Payment_Order__c order = new Payment_Order__c();
        order.Donor__c = conid;
        order.Order_No__c = orderno;
        return order;
    }
    
    public static Donation_Program__c createDonationProgram(string name,string program){
        
        Donation_Program__c dp = new Donation_Program__c();
        dp.Name = name;
        dp.Program__c = program;
        return dp;
    }
    
    public static Opportunity createOpportunity(string name,id pfId,id orderId,string stage,double amount,string closeDate){
        
        opportunity op = new opportunity();
        op.Name=name;
        op.Program_Frequency__c = pfId;
        op.Payment_Order__c = orderId;
        op.StageName = stage;
        op.Amount = amount;
        op.CloseDate = date.valueof(closeDate);
        return op;
    }
    
    public static npsp__General_Accounting_Unit__c createGAU(string name,id dpId){
        
        npsp__General_Accounting_Unit__c ga = new npsp__General_Accounting_Unit__c();
        ga.Name    = name;
        ga.Program__c = dpId;
        return ga;
    }
    
    public static npsp__Allocation__c createGauAllocation(double amount,id gaId,id opId){
        
        npsp__Allocation__c gau = new npsp__Allocation__c();
        gau.npsp__Amount__c = amount;
        gau.npsp__General_Accounting_Unit__c = gaId;
        gau.npsp__Opportunity__c = opId;
        return gau;
    }
    
    public static Program_Frequency__c createProgramFrequency(string name,id dpId,double amount,double minAmount){
        
        Program_Frequency__c pf = new Program_Frequency__c();
        pf.Name = name;
        pf.Program__c = dpId;
        pf.Amount__c = amount;
        pf.Minimum_Amount__c = minAmount;
        return pf;
    }
    
    public static Donor_Balance__c createDonorBalance(id donorid,id gauid){
        
        Donor_Balance__c donorbalance = new Donor_Balance__c();
        donorbalance.Donor_Name__c = donorid;
        donorbalance.GAU_Name__c = gauid;
        donorbalance.Current_Balance__c = double.valueOf('23.000');
        donorbalance.Blocked_Funds__c   = double.valueOf('56.000');
        return donorbalance;
    }
    
    public static College_Master__c createCollegeMaster(string name, String collcity, string rating, string collstate){
        College_Master__c colzmaster = new College_Master__c();
        colzmaster.Name              = name;
        colzmaster.College_City__c   = collcity;
        colzmaster.College_Rating__c = rating;
        colzmaster.College_State__c  = collstate;
        return colzmaster;
    }
    
    public static System_Details__c dummyCustomSetting(date startDate, date endtDate){
        System_Details__c sys                   = new System_Details__c();
        sys.Application_Site_URL__c             = 'test';
        sys.Donor_Site_URL__c                   = 'test';
        sys.Months_per_academic_year__c         = 10;
        sys.Renewal_Application_Opening_Date__c = startDate;
        sys.Renewal_Application_Close_Date__c   = endtDate;
        return sys;
    }
    
    public static List<String> TenFinancialYearexcluding(){
        List<String> PreviousTenfinancialYear = new List<String>();
        
        for(integer i=1;i<=9;i++){
            if(system.today().month() > = 1 && system.today().month()<=3){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year()) - (i+2)) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1)).substring(2, 4)); 
            }else if(system.today().month() > = 4 && system.today().month()<=12){
                PreviousTenfinancialYear.add(String.valueOf(Integer.valueOf(system.today().Year())- i +1) + '-' + String.valueOf(Integer.valueOf(system.today().Year()+1) - i+1).substring(2, 4)); 
                
            } 
        }
        return PreviousTenfinancialYear;
    }
}