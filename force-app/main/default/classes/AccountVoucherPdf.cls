public class AccountVoucherPdf {
    public string wordText {get; set;}
    public AccountVoucherPdf(ApexPages.StandardController controller) {
        String paymentId = ApexPages.currentPage().getParameters().get('Id');
        Payment_Order__c po = [select Id, Order_Amount__c from Payment_Order__c where Id=:paymentId];
        
        NumbersToWordsClass cls = new NumbersToWordsClass();
        wordText = cls.convert(Integer.valueOf(po.Order_Amount__c));
    }
}