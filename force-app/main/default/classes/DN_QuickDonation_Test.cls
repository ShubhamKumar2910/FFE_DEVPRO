@isTest
public class DN_QuickDonation_Test {

    public static testmethod void execute(){
        
        
        id donorRecordType                	= Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        Contact newStudent                  = new Contact();
        newStudent.FirstName                = 'Test';
        newStudent.LastName                 = '1';
        newStudent.RecordTypeId             = donorRecordType;
        newStudent.MobilePhone              = '7878787878';
        insert newStudent;
        
        Contact newStudent1                  = new Contact();
        newStudent1.FirstName                = 'Test';
        newStudent1.LastName                 = '1';
        newStudent1.RecordTypeId             = donorRecordType;
        newStudent1.DN_PAN__c='89898989';
        insert newStudent1;
        
        Contact newStudent2                  = new Contact();
        newStudent2.FirstName                = 'Test';
        newStudent2.LastName                 = '1';
        newStudent2.RecordTypeId             = donorRecordType;
        newStudent2.Email                    = 'js@gmail.com';
        insert newStudent2;
        
        
        Contact newStudent3                  = new Contact();
        newStudent3.FirstName                = 'Test';
        newStudent3.LastName                 = '1';
        newStudent3.RecordTypeId             = donorRecordType;
        newStudent3.Aadhar_number__c		 ='898989898989';
        insert newStudent3;
        
        Contact newStudent4                  = new Contact();
        newStudent4.FirstName                = 'Test';
        newStudent4.LastName                 = '1';
        newStudent4.RecordTypeId             = donorRecordType;
        insert newStudent4;
        
        
        DN_PaymentWrapper paywrp  = new DN_PaymentWrapper();
        paywrp.programs           = new List<DN_PaymentWrapper.programWrapper>(); 
        paywrp.donorRecord        = newStudent;
        
        DN_PaymentWrapper paywrp1  = new DN_PaymentWrapper();
        paywrp1.programs           = new List<DN_PaymentWrapper.programWrapper>(); 
        paywrp1.donorRecord        = newStudent1;
        
        DN_PaymentWrapper paywrp2  = new DN_PaymentWrapper();
        paywrp2.programs           = new List<DN_PaymentWrapper.programWrapper>(); 
        paywrp2.donorRecord        = newStudent2;
        
        DN_PaymentWrapper paywrp3  = new DN_PaymentWrapper();
        paywrp3.programs           = new List<DN_PaymentWrapper.programWrapper>(); 
        paywrp3.donorRecord        = newStudent3;
        
        DN_PaymentWrapper paywrp4  = new DN_PaymentWrapper();
        paywrp4.programs           = new List<DN_PaymentWrapper.programWrapper>(); 
        paywrp4.donorRecord        = newStudent4;
        
        DN_QuickDonation quickDonationCTRL = new DN_QuickDonation();
        DN_QuickDonation.makeDonation(paywrp);
        
        DN_QuickDonation.makeDonation(paywrp1);
        DN_QuickDonation.makeDonation(paywrp2);
        DN_QuickDonation.makeDonation(paywrp3);
        DN_QuickDonation.makeDonation(paywrp4);
        
        
        DN_QuickDonation.getDonationPrograms();
        DN_QuickDonation.cancelDonation('ids',DN_ServiceConstants.PAYMENT_CANCEL);
        DN_QuickDonation.cancelDonation('ids','DN_ServiceConstants.PAYMENT_CANCEL');
        DN_QuickDonation.getStateList('India');
        DN_QuickDonation.getCityList('Karnataka');
    }
}