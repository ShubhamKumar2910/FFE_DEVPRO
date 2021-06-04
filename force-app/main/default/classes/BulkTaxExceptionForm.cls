public class BulkTaxExceptionForm {
    public string wordText {get; set;}
    public String isdisply {get;set;}
    public string notCheck {get;set;}
    public BulkTaxExceptionForm(ApexPages.StandardController controller) {
        String contId = ApexPages.currentPage().getParameters().get('Id');
        List<Contributor__c> contributor  = [select Id,Donation_Amount__c,Cheque_No__c,Cheque_DD_Bank_Name__c,Payment_Method__c,Payment_Date__c from Contributor__c where Id=:contId];
        NumbersToWordsClass cls = new NumbersToWordsClass();
        wordText = cls.convert(Integer.valueOf(contributor[0].Donation_Amount__c));
        if(contributor[0].Cheque_No__c !=null){
        isdisply = 'block';
        notCheck = 'none';
        }else{
        isdisply = 'none';
        notCheck = 'block';
        }
    }
    
    public String getmyimageurl(){  
        try{
        document doc = [SELECT body FROM Document WHERE DeveloperName='Signature_for_Tax_Excemption_form'];
        string imageid = doc.id; 
        imageid = imageid.substring(0,15);
        return '/servlet/servlet.FileDownload?file=' + imageid;
        }Catch(Exception e){
            return null;
        }
    } 
}