@isTest
public class CIBICICITransactionStatusUpdateTest {

    static testMethod void  updateMethodTest1(){
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/TrasactionStatuses/';
        req.httpMethod = 'POST';
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        
        String JsonMsg = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"CMS642550389","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"1/10/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg1 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"CMS642550389","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00301","BankTransactionReferenceNo":"CMS642550389","BankTxnDate":"1/10/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg1);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg2 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"CMS642550389","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00309","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"1/10/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg2);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg3 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"CMS642550389","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"110/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg3);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg4 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"","BankTransactionReferenceNo":"CMS642550389","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg4);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg5 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg5);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg6 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"sdfsf","BankTxnDate":"1/10/2017","APITXNStatus":"","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg6);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg7 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"ddssdsdsd","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":""},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg7);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg8 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"dfdfds","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg8);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg9 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"dfdfds","BankTxnDate":"","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg9);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg10 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"dfdfds","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"","BridgeBatchId":"00806"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg10);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg11= '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"BATXN-00305","BankTransactionReferenceNo":"dfdfds","BankTxnDate":"1/10/2017","APITXNStatus":"PROCESSED","APITXNReason":"c","SFUniqueID":"a170l000000DLz5","BridgeBatchId":""},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/0/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg11);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        
        Contact std = Utility_Test.insertSingleStudent('Test','test');
        std.Bank_Account_Holder_s_Name__c = 'testbnk';
        std.Full_Bank_Account_No_With_all_digits__c = '8902323232';
        std.X11_character_IFSC_Code_of_the_Branch__c = '233232';
        insert std;
        Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
        app.Student__c = std.id;
        insert app;
        Business_Account_Utilization__c bau = new Business_Account_Utilization__c();
        bau.Bank_Txn_ID__c = 'dfdfds';
        bau.APITXNStatus__c='Processed';
        bau.APITXNReason__c = 'c';
        bau.BridgeBatchId__c = '1';
        bau.Application__c = app.id;
        insert bau;
        
        Business_Account_Utilization__c qbau = [Select id,Name,BridgeBatchId__c,APITXNReason__c,APITXNStatus__c,BankTxnDate__c,Bank_Txn_ID__c from Business_Account_Utilization__c];
        
        String JsonMsg12 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"'+qbau.Name+'","BankTransactionReferenceNo":"'+qbau.Bank_Txn_ID__c+'","BankTxnDate":"10/10/2017","APITXNStatus":"'+qbau.APITXNStatus__c+'","APITXNReason":"c","SFUniqueID":"'+qbau.id+'","BridgeBatchId":"1"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/01/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg12);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        String JsonMsg13 = '{"BusinessAccountUtilizationDetail":[{"SFTRANID":"daddsas","BankTransactionReferenceNo":"qweqw2","BankTxnDate":"10/10/2017","APITXNStatus":"'+qbau.APITXNStatus__c+'","APITXNReason":"c","SFUniqueID":"Processed","BridgeBatchId":"1"},{"SFTRANID":"BATXN-00300","BankTransactionReferenceNo":"CMSd642550389","BankTxnDate":"11/01/2017","APITXNStatus":"Failed","APITXNReason":"c","SFUniqueID":"a170l0000ddz5","BridgeBatchId":"00806"}]}';
        req.requestBody = Blob.valueof(JsonMsg13);
        CIBICICITransactionStatusUpdate.updateBAUTransactionDetails();
        
        
        Test.stopTest();
    }
}