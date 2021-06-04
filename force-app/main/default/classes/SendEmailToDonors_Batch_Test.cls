@isTest
private class SendEmailToDonors_Batch_Test
{
    public static testmethod void test1()
    {
        Contact con = Utility_Test.insertNewStudentRec('ABC', 'ZYX', null, null, null, null, null, 70, 90, 'cet', '2016');
        con.X80G_Not_Required__c = false;
        con.Email = 'test@test.com';
        Insert con;
        List<Payment_Order__c> paymentList = new  List<Payment_Order__c>();
        Payment_Order__c po = Utility_Test.createPaymentOrder(con.id, 'N14927700918910566918371');
        po.CCAvenue_Payment_Status__c = 'Success';
        po.Is_Email_sent__c = false;
        Insert po;
        test.startTest();
        Database.executeBatch(new SendEmailToDonors_Batch());
        test.stopTest();
    }
}