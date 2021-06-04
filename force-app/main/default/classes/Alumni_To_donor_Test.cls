@isTest
public class Alumni_To_donor_Test {
    
   public static testmethod void executee(){
        id donorRecordType                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
		id studentRecordType                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
        Contact newStudent                  = new Contact();
        newStudent.FirstName                = 'Test';
        newStudent.LastName                 = '1';
        newStudent.RecordTypeId             = studentRecordType;
        newStudent.Phone                    = '7878787878';
        newStudent.Email                    = 'js@gmail.com';
        newStudent.MobilePhone              = '7878787878';
        newStudent.Google_login_ID__c       = 'js@gmail.com';
        newStudent.Facebook_login_ID__c     = 'js@gmail.com';
        newStudent.DN_PAN__c='89898989';
        newStudent.Aadhar_number__c='898989898989';
        insert newStudent;
        Test.startTest();
        //Alumni_To_Donor_Ctrl adc = new Alumni_To_Donor_Ctrl();
       // Alumni_To_Donor_Ctrl.messageWrapper msg = new Alumni_To_Donor_Ctrl.messageWrapper();
        //Alumni_To_Donor_Ctrl.sendEmail(student.Email);
        //Alumni_To_Donor_Ctrl.createDonorInSFDC(student);
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(MobilePhone= '7878787878',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(DN_PAN__c= '89898989',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Aadhar_number__c='898989898989',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Google_login_ID__c= 'js@gmail.com',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Email= 'js@gmail.com',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Facebook_login_ID__c= 'js@gmail.com',RecordTypeId=studentRecordType));
      
        test.stopTest();
    }
    
    
    public static testmethod void execute(){
      Test.startTest();
        id studentRecordType                = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();

       Contact student = Utility_Test.insertNewStudentRec('sample','sample1','1234567897','js@gmail.com','9090909090','','js@gmail.com',80,100,'Karnataka Common Entrance Test (CET)','2016');
		insert student;
        
        Alumni_To_Donor_Ctrl adc = new Alumni_To_Donor_Ctrl();
        Alumni_To_Donor_Ctrl.messageWrapper msg = new Alumni_To_Donor_Ctrl.messageWrapper();
        Alumni_To_Donor_Ctrl.sendEmail(student.Email);
        Alumni_To_Donor_Ctrl.createDonorInSFDC(student);
        Alumni_To_Donor_Ctrl.updateAlumniEmail(student.Email,'jayanth7829@gmail.com','jhka89898','909090909090','js@gmail.com');
        
         Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'js@gmail.com.com', '9090909090', 'js@gmail.com', 'js@gmail.com'); 
            donor.DN_PAN__c='327812798721';
            donor.Aadhar_number__c='123456789012';
            Alumini_To_Donor_Helper	cntr	= new Alumini_To_Donor_Helper();
            
            Alumini_To_Donor_Helper.createDonorInSFDC(donor);
            
            Alumini_To_Donor_Helper.createDonorInSFDC(Utility_Test.updateContact('sample','sample1','9900887765','sample67@gmail.com','3456756321','test@gmail.com','test1@gmailcom'));
            
            // Duplicate test
         Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(MobilePhone= '7878787878',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(DN_PAN__c= '89898989',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Aadhar_number__c='898989898989',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Google_login_ID__c= 'js@gmail.com',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Email= 'js@gmail.com',RecordTypeId=studentRecordType));
        Alumini_To_Donor_Helper.createDonorInSFDC(new Contact(Facebook_login_ID__c= 'js@gmail.com',RecordTypeId=studentRecordType));
        	Alumini_To_Donor_Helper.checkDupForMobile('7829483829','0030l000005N2bn');
        	Alumini_To_Donor_Helper.checkDupForEmail('jsysnth.b@etmarlabs.com','0030l000005N2bn');
        	Alumini_To_Donor_Helper.checkDupForPan('7829483829','0030l000005N2bn');
        	Alumini_To_Donor_Helper.checkDupForAadhar('786729483829','0030l000005N2bn');
        test.stopTest();
    }
}