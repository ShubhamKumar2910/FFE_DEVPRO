@isTest
public class CIB_ICICI_TransactionAPICalloutTest {
    public static CIB_ICICI_Service__c cibCustmSettng;
    public static Contact std;
    public static Application__c app ;
    public static Business_Account__c acc;
    public static Business_Account_Utilization__c bau ;
    public static List<String> bauIds = new List<String>();
    
    public static testmethod void executeRestCIB(){
        
        cibCustmSettng    = new CIB_ICICI_Service__c();
        cibCustmSettng.EndPoint_URL__c         = 'http://ffebridgeapp.mahiti.org/api/createbatch';
        cibCustmSettng.MinRange__c             = 200;
        cibCustmSettng.MaxRange__c             = 204;
        cibCustmSettng.UserName__c             = 'ffe';
        cibCustmSettng.Password__c             = '123456';
        insert cibCustmSettng;
        
        std = Utility_Test.insertSingleStudent('Test','test');
        std.Bank_Account_Holder_s_Name__c = 'testbnk';
        std.Full_Bank_Account_No_With_all_digits__c = '8902323232';
        std.X11_character_IFSC_Code_of_the_Branch__c = '233232';
        insert std;
        app= Utility_Test.insertNewApplication('Selected','Submitted');
        app.Student__c = std.id;
        insert app;
        acc = new Business_Account__c(Account_No__c='213698',Name='ICICI');
        insert acc;
        bau = new Business_Account_Utilization__c();
        bau.Bank_Txn_ID__c = 'dfdfds';
        bau.APITXNStatus__c='Not Posted';
        bau.APITXNReason__c = 'c';
        bau.BridgeBatchId__c = '1';
        bau.Application__c = app.id;
        bau.Disbursement_Mode__c = 'NEFT';
        bau.Payable_Location__c ='bangalore';
        bau.Print_Location__c ='bangalore';
        bau.Sender_Account_No__c = acc.id;
        
        insert bau;
        bauIds.add(bau.id);   
    }
    
    public static testmethod void executeRestCIBSuccess(){
        executeRestCIB();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();
    }
    
    public static testmethod void executeRestCIBFailure(){ 
        executeRestCIB();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGeneratorFailuer());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    
    public static testmethod void executeRestCIBAPITXNStatus(){   
        executeRestCIB();
        bau.APITXNStatus__c='Posted';
        update bau;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    
    public static testmethod void executeRestCIBDisbursementMode(){   
        executeRestCIB();bau.Disbursement_Mode__c = '';
        update bau;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    
    public static testmethod void executeRestCIBPayMod(){    
        executeRestCIB();
        bau.Disbursement_Mode__c = 'mmmm';
        update bau;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    public static testmethod void executeRestCIBPayMod1(){    
        executeRestCIB();bau.Disbursement_Mode__c = 'NEFT';
        bau.Sender_Account_No__c = null; 
        update bau;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    public static testmethod void executeRestCIBPaylocation(){    //
        executeRestCIB();bau.Sender_Account_No__c = acc.id; 
        bau.Payable_Location__c= '';
        update bau;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    public static testmethod void executeRestCIBprintLocation(){    //
        executeRestCIB();bau.Payable_Location__c = 'bangalore';
        bau.Print_Location__c = ''; 
        update bau;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    
    public static testmethod void executeRestCIBBenefiNAme(){    //
        executeRestCIB();
        std.Bank_Account_Holder_s_Name__c = '';
        update std;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    
    public static testmethod void executeRestCIBaccnum(){    //
        executeRestCIB();
        std.Full_Bank_Account_No_With_all_digits__c = '';
        update std;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }
    
    public static testmethod void executeRestCIBIFSCcode(){    //
        executeRestCIB();std.X11_character_IFSC_Code_of_the_Branch__c = '';
        update std;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(bauIds);
        Test.stopTest();    
    }

    public static testmethod void executeRestCIBException(){    //
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CIBResponseGenerator());
        CIB_ICICI_TransactionAPICallout.getBAU_TransactionDetails(null);
        Test.stopTest();    
    }    
}