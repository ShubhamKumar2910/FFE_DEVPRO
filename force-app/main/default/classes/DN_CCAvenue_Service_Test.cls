@isTest
private class DN_CCAvenue_Service_Test {
    
    
    Static testmethod void testINRMakeDonation(){
        
        User testUser = Utility_Test.createUser('ccavenueservice@testuser.com');
        System.runAs(testUser){
            
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Donation_Program__c engPrgm	= Utility_Test.createDonationProgram('Engineering','Engineering');
            insert engPrgm;
            
            Donation_Program__c medicalPrgm	= Utility_Test.createDonationProgram('Medical','Medical');
            insert medicalPrgm;
            
            DN_PaymentWrapper paywrp	= new DN_PaymentWrapper();
            paywrp.programs				= new List<DN_PaymentWrapper.programWrapper>(); 
            paywrp.donorRecord			= donor;
            
            for(integer i=0;i<2;i++){
                DN_PaymentWrapper.programWrapper pFreq = new DN_PaymentWrapper.programWrapper();
                if(i==0){
                    pFreq.frequency					= Utility_Test.createProgramFrequency('Yearly',engPrgm.Id,40000,0);
                    pFreq.frequency.Frequency__c	= 'Recurring';                    
                }else{
                    pFreq.frequency					= Utility_Test.createProgramFrequency('Lumpsum',medicalPrgm.Id,160000,0); 
                    pFreq.frequency.Frequency__c	= 'One_Time';
                }
                pFreq.frequency.Currency__c	= 'INR';
                pFreq.programAmountINR		= 160000;
                pFreq.programAmountINR		= 2000;
                pFreq.studentCount			= 1;
                paywrp.programs.add(pFreq);
            }
            paywrp.totalOrderAmountINR	= 200000;
            paywrp.totalOrderAmountUSD	= 400000;
            paywrp.currencyType			= 'INR';
            
            test.startTest();
            
            DN_CCAvenue_Service	serv	= new DN_CCAvenue_Service();
            serv.createDonationOrderInSFDB(paywrp);
            
            test.stopTest();
        }
    }
    
     Static testmethod void testExceptionINRMakeDonation1(){
        
        User testUser = Utility_Test.createUser('ccavenueservice@testuser.com');
        System.runAs(testUser){
            test.startTest();
            Donation_Program__c engPrgm	= Utility_Test.createDonationProgram('Engineering','Engineering');
            insert engPrgm;
            
            Donation_Program__c medicalPrgm	= Utility_Test.createDonationProgram('Medical','Medical');
            insert medicalPrgm;
            
            DN_PaymentWrapper paywrp	= new DN_PaymentWrapper();
            paywrp.programs				= new List<DN_PaymentWrapper.programWrapper>();            

            for(integer i=0;i<2;i++){
                DN_PaymentWrapper.programWrapper pFreq = new DN_PaymentWrapper.programWrapper();
                if(i==0){
                    pFreq.frequency					= Utility_Test.createProgramFrequency('Yearly',engPrgm.Id,40000,0);
                    pFreq.frequency.Frequency__c	= 'Recurring';                    
                }else{
                    pFreq.frequency					= Utility_Test.createProgramFrequency('Lumpsum',medicalPrgm.Id,160000,0); 
                    pFreq.frequency.Frequency__c	= 'One_Time';
                }
                pFreq.frequency.Currency__c	= 'INR';
                pFreq.programAmountINR		= 160000;
                pFreq.programAmountINR		= 2000;
                pFreq.studentCount			= 1;
                paywrp.programs.add(pFreq);
            }
            paywrp.totalOrderAmountINR	= 200000;
            paywrp.totalOrderAmountUSD	= 400000;
            paywrp.currencyType			= 'INR';
            
            DN_CCAvenue_Service	serv	= new DN_CCAvenue_Service();
            serv.createDonationOrderInSFDB(paywrp);
            
            test.stopTest();
        }
    }
    Static testmethod void testExceptionUSDMakeDonation2(){
        
        User testUser = Utility_Test.createUser('ccavenueservice@testuser.com');
        System.runAs(testUser){
            test.startTest();
            
            DN_PaymentWrapper paywrp	= new DN_PaymentWrapper();
            paywrp.programs				= new List<DN_PaymentWrapper.programWrapper>();            
           
            paywrp.totalOrderAmountINR	= 200000;
            paywrp.totalOrderAmountUSD	= 400000;
            paywrp.currencyType			= 'USD';
            
            DN_CCAvenue_Service	serv	= new DN_CCAvenue_Service();
            serv.createDonationOrderInSFDB(paywrp);
            
            test.stopTest();
        }
    }
    
    Static testmethod void testErrorResponse(){
        
        User testUser = Utility_Test.createUser('ccavenueservice@testuser.com');
        System.runAs(testUser){
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c dummyOrder	= Utility_Test.createPaymentOrder(donor.Id,'OrderNo');
            insert dummyOrder;
            
            test.startTest();
			
 			String  errorCode ='tracking_id=306003038552&bank_ref_no=1487253552505&order_status=Success&failure_message=&payment_mode=Net Banking&card_name=AvenuesTest&status_code=null&status_message=Y&currency=INR&amount=200000.0&billing_name=ET Anjali&billing_address=Koramangla 1st block&billing_city=Bengaluru&billing_state=Karnataka&billing_zip=560034&billing_country=India&billing_tel=909 090-9090&billing_email=amritesh444@gmail.com&delivery_name=ET Anjali&delivery_address=Koramangla 1st block&delivery_city=Bengaluru&delivery_state=Karnataka&delivery_zip=560034&delivery_country=India&delivery_tel=909 090-9090&merchant_param1=&merchant_param2=&merchant_param3=&merchant_param4=&merchant_param5=&vault=N&offer_type=null&offer_code=null&discount_value=0.0&mer_amount=4000.0&eci_value=null&retry=N&response_code=0&billing_notes=&trans_date=16/02/2017 19:30:17&bin_country=null';            
            DN_CCAvenue_Service.processCCAvenueResponse(errorCode, dummyOrder.id);
            
            test.stopTest();
        }
    }
	
    Static testmethod void testCreatePendingDonation(){
        
        User testUser = Utility_Test.createUser('ccavenueservice@testuser.com');
        System.runAs(testUser){
            
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c dummyOrder	= Utility_Test.createPaymentOrder(donor.Id,'OrderNo');
            insert dummyOrder;
            
            Opportunity donation	= Utility_Test.createOpportunity('Donation', null,dummyOrder.Id,'Pledged', 20000, String.valueOf(Date.today()));
            insert donation;
            
            Donation_Program__c engPrgm	= Utility_Test.createDonationProgram('Engineering','Engineering');
            insert engPrgm;
          
            DN_PaymentWrapper paywrp	= new DN_PaymentWrapper();
            paywrp.programs				= new List<DN_PaymentWrapper.programWrapper>(); 
            paywrp.donorRecord			= donor;
            
            for(integer i=0;i<1;i++){
                DN_PaymentWrapper.programWrapper pFreq = new DN_PaymentWrapper.programWrapper();
                pFreq.frequency					= Utility_Test.createProgramFrequency('Yearly',engPrgm.Id,40000,0);
                pFreq.frequency.Frequency__c	= 'Recurring';                    
                
                pFreq.frequency.Currency__c	= 'INR';
                pFreq.programAmountINR		= 160000;
                pFreq.programAmountINR		= 2000;
                pFreq.studentCount			= 1;
                paywrp.programs.add(pFreq);
            }
            paywrp.totalOrderAmountINR	= 200000;
            paywrp.totalOrderAmountUSD	= 400000;
            paywrp.currencyType			= 'INR';
            
            test.startTest();
            
            DN_CCAvenue_Service	serv	= new DN_CCAvenue_Service();
            serv.createPendingDonationOrder(paywrp,donation.Id,dummyOrder.Id);
            DN_CCAvenue_Service.updatePaymentToAborted(dummyOrder.Id,'Aborted');
            DN_CCAvenue_Service.deleteExistingPaymentOrder(dummyOrder.Id);
            
            test.stopTest();
        }
    }
    
     static testmethod void testingException(){
        User testUser = Utility_Test.createUser('donorprofile@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            DN_CCAvenue_Service serv	= new DN_CCAvenue_Service();
            serv.createDonationOrderInSFDB(new DN_PaymentWrapper());
            DN_CCAvenue_Service.updatePaymentToAborted('dummyId','Cancel');
            DN_CCAvenue_Service.deleteExistingPaymentOrder('dummyId');
            serv.createPendingDonationOrder(new DN_PaymentWrapper(), 'dummyId', 'dummyOrderId');
            DN_CCAvenue_Service.encryptString('dummyText', 'dummyKey');
        }
    }
    
    static testmethod void testRecuuringDonationUpdate(){
        User testUser = Utility_Test.createUser('donorprofile@testuser.com');
        System.runAs(testUser){
            
            Test.startTest();
            
            Contact donor	= Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c dummyOrder	= Utility_Test.createPaymentOrder(donor.Id,'OrderNo');
            insert dummyOrder;
            
            npe03__Recurring_Donation__c recDonation    = new npe03__Recurring_Donation__c();
            recDonation.Name                            = 'dummyDonation';
            recDonation.npe03__Amount__c                = 1000;
            recDonation.npe03__Date_Established__c      = system.today();
            recDonation.npe03__Installment_Period__c    = 'Monthly';        
            recDonation.npe03__Installments__c          = 10;
            recDonation.npe03__Schedule_Type__c         = DN_ServiceConstants.SCHEDULE_TYPE_MULTIPLY;
            recDonation.npe03__Contact__c               = donor.Id;
            recDonation.No_of_Student__c				= 2;
            recDonation.Payment_Order__c				= dummyOrder.Id;
            recDonation.Currency__c						= 'INR';
            
            insert recDonation;
            
            Opportunity donation	= Utility_Test.createOpportunity('1 of Dummy', null,dummyOrder.Id,'Pledged', 20000, String.valueOf(Date.today()));
            donation.npe03__Recurring_Donation__c = recDonation.Id;
            insert donation;
            
            DN_CCAvenue_Service.updateRecurDonationsOrder(new List<npe03__Recurring_Donation__c>{recDonation},dummyOrder.Id);
            
            Test.stopTest();
        }
    }
}