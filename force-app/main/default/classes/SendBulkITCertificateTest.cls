@isTest
public class SendBulkITCertificateTest {

     public static testmethod void execute(){
      
         test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
         Contact con =  Utility_Test.insertNewContact('Jayanth','christopher','7823483829','jayanthdf7829@gmail.com','3262787878',null,null);
         insert con;
         
         Payment_Order__c payment = new Payment_Order__c(Donor__c=con.id,Programs__c='Adopt a Scholar - Engineering');
         insert payment;
         
         Opportunity opp = new Opportunity(StageName='Posted',Name='Engineering - Scholar', CloseDate =System.today()+6,Payment_Order__c=payment.id);
         insert opp;
         
         Contributor__c contrb = new Contributor__c(Donation_Amount__c=1000,Donation__c=opp.id,Name='jayanth',Email__c='jayanth.b@etmarlabs.com',MobileNo__c='7829483829',PAN__c='jbaskdhbhbas',PostalCode__c='560092',State__c='KArnataka',Street__c='ban',Country__c='india',City__c='Bangalore');
         insert contrb;
         
         Database.executeBatch(new SendBulkITCertificate(opp.id), 1); 
        }
     }
}