@isTest
public class DonorApplicationMappingTriggerTest {

    public static testmethod void execute(){
     contact donor =   Utility_Test.updateContact('FirstName','lastName','9487389347','jauab@gmail.com','7829483829','jynth87126@gmail.com','jhaja@gna.com');
      insert donor;
    
     Contact std = Utility_Test.insertSingleStudent('avc','assasa');   
     insert std;

 	 Application__c app = new Application__c();   
        app.student__c = std.Id;
     insert app;   
        
     Donor_Application_Mapping__c dam = new Donor_Application_Mapping__c();
        dam.Donor__c = donor.id;
        dam.Student__c = std.id;
        dam.Application__c = app.id;
    insert dam;    
        delete dam;
    }
}