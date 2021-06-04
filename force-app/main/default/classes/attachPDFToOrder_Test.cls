/* description :Generates a PdF file And Attached to the paymentorder
*  Purpose     : Test class for attachPDFOder
*/
@isTest
private class attachPDFToOrder_Test {

    static testmethod void testGeneratePdf(){
        
        User testUser = Utility_Test.createUser('pdfgenerate@testuser.com');
        System.runAs(testUser){
            
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c dummyOrder = Utility_Test.createPaymentOrder(donor.Id,'OrderNo');
            dummyOrder.Order_Amount__c  = 20000;
            insert dummyOrder;
            
            List<Donation_Program__c> programs  = new List<Donation_Program__c>();
            programs.add(Utility_Test.createDonationProgram('Engineering','Engineering'));
            programs.add(Utility_Test.createDonationProgram('Medical','Medical'));
            programs.add(Utility_Test.createDonationProgram('LLB','LLB'));
            programs.add(Utility_Test.createDonationProgram('TEST','TEST'));
            programs.add(Utility_Test.createDonationProgram('TEST3','TEST3'));
            programs.add(Utility_Test.createDonationProgram('TEST4','TEST4'));
            programs.add(Utility_Test.createDonationProgram('TEST5','TEST5'));
            insert programs;
            
            LIst<Program_Frequency__c> progrmFreqs  = new LIst<Program_Frequency__c>();
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[0].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[2].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[3].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[4].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[0].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[6].Id,20000,0));
            progrmFreqs.add(Utility_Test.createProgramFrequency('lumpsum',programs[1].Id,20000,0));
            insert progrmFreqs;
            
            List<Opportunity> donationList=new List<Opportunity> ();
            for(integer i=0;i<7;i++){
                Opportunity op  = Utility_Test.createOpportunity('Donation'+i, null,dummyOrder.Id,'Posted', 20000+i, String.valueOf(Date.today()));
                op.Program_Frequency__c =progrmFreqs[i].id;
                donationList.add(op);
            }
            insert donationList;
            
            
            
            test.startTest();            
            SendITCertificate.send80GForm(dummyOrder.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(dummyOrder);
            PageReference pageRef = Page.TaxExemptionForm;
            pageRef.getParameters().put('Id', dummyOrder.Id);
            Test.setCurrentPage(pageRef);
            TaxExemptionForm pdf    = new TaxExemptionForm(sc);
            
            NumbersToWordsClass numb = new NumbersToWordsClass();
            numb.numberval  = 1000000;
            numb.convert();
            numb.convert(200000000);
            numb.convert(2000000000);
            SendITCertificate.send80GForm('dummyId');
            test.stopTest();
        }
        
    }
}