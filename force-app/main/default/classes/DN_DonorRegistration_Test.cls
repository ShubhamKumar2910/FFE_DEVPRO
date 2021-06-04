@isTest
private class DN_DonorRegistration_Test {
	
    static testmethod void testRegistration(){
        User testUser = Utility_Test.createUser('donorprofile@testuser.com');
        System.runAs(testUser){
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            
            Test.startTest();
            DN_DonorRegistration_CTRL	cntr	= new DN_DonorRegistration_CTRL();
            
            DN_DonorRegistration_CTRL.createDonorInSFDC(donor);
            
            DN_DonorRegistration_Helper.createDonorInSFDC(Utility_Test.updateContact('sample','sample1','9900887765','sample67@gmail.com','3456756321','test@gmail.com','test1@gmailcom'));
            
            DN_DonorRegistration_CTRL.uploadDoc('dummy', 'dummy', 'dummyId', 'dummyId');
            // Duplicate test
            DN_DonorRegistration_Helper.createDonorInSFDC(new Contact(Email='sample@donor.com'));
            DN_DonorRegistration_Helper.createDonorInSFDC(new Contact(Phone='12121212'));
            DN_DonorRegistration_Helper.createDonorInSFDC(new Contact(MobilePhone='12321232'));
            DN_DonorRegistration_Helper.createDonorInSFDC(new Contact(Google_login_ID__c='sample@donor.com'));
            DN_DonorRegistration_Helper.createDonorInSFDC(new Contact(Facebook_login_ID__c='sample@donor.com'));
            
            Test.stopTest();
        }
    }
}