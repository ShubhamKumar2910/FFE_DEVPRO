/*
* Purpose: Test class for ChangeInBankInfoMail Class
* 
*/
@isTest
public class ChangeInBankInfoMail_Test {
    
    public static testmethod void studentCriteria(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            npsp__Trigger_Handler__c handlerObj = new npsp__Trigger_Handler__c(npsp__Active__c = true, npsp__Asynchronous__c = false, 
                                                                               npsp__Class__c = 'TDTM_Handler', npsp__Load_Order__c = 1, 
                                                                               npsp__Object__c = 'Contact', npsp__Trigger_Action__c= 'BeforeInsert; BeforeUpdate; BeforeDelete; AfterInsert; AfterUpdate; AfterDelete; AfterUndelete',
                                                                               npsp__User_Managed__c = true);
            insert handlerObj;
            
            College_Master__c cm = new College_Master__c();
            cm.Name = 'CBIT';
            insert cm;
            
            College_Master__c cm1 = new College_Master__c();
            cm1.Name = 'NIIT';
            insert cm1;
            
            Contact con = Utility_Test.insertNewStudentRec('ABC','XYZ',null,'abc@gmail.com',null,null,null,null,null,null,null);
            con.College_Name__c = cm1.id;
            insert con;
            con.Bank_Account_Holder_s_Name__c = 'AAA';
            con.Bank_Branch_Phone_No__c = '2233445566';
            con.Bank_City__c = 'BBB';
            con.Bank_Name__c = 'CCC';
            con.Bank_Pincode__c = '234578';
            con.Bank_State__c = 'DDD';
            con.College_Name__c = cm.id;
            con.X11_character_IFSC_Code_of_the_Branch__c = 'aaaa1';
            con.Branch_Address__c = 'aaaa';
            con.Full_Bank_Account_No_With_all_digits__c = 'A12143435';
            con.Branch_Stream__c = 'MBBS';
            con.Course__c ='FFF';
            update con;
        }
        test.stopTest();
    }
}