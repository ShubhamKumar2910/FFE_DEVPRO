public class TaxExemptionForm {
    public string wordText {get; set;}
    public List<Opportunity> opprecs{get;set;}
    public List<wrapDonationDetails> firstPageOpp{get;set;}
    public List<wrapDonationDetails> secondPageOpp{get;set;}
    public boolean pageBreak{get;set;}
    public String isdisply {get;set;}
    public string notCheck {get;set;}
    
    public TaxExemptionForm(ApexPages.StandardController controller) {
        String paymentId = ApexPages.currentPage().getParameters().get('Id');
        List<Payment_Order__c> po  = [select Id,Order_Amount__c,Cheque_No__c,Cheque_DD_Bank_Name__c from Payment_Order__c where Id=:paymentId];
        NumbersToWordsClass cls = new NumbersToWordsClass();
        wordText = cls.convert(Integer.valueOf(po[0].Order_Amount__c));
        
        if(paymentId != null){
            opprecs =[Select Id,Name,Donation_Program__c,Amount from Opportunity where Payment_Order__c=:paymentId];
        }
        
        Map<String,Decimal> programAmountMap = new Map<String,Decimal> ();
        for(Opportunity opp:opprecs){
            if(!String.IsBlank(opp.Donation_Program__c)){
                if(programAmountMap.containsKey(opp.Donation_Program__c)){
                    if(opp.Amount!=null){
                        Decimal totaldonationAmount = programAmountMap.get(opp.Donation_Program__c);
                        totaldonationAmount=totaldonationAmount+opp.Amount;
                        programAmountMap.put(opp.Donation_Program__c,totaldonationAmount);
                    }
                }else if(opp.Amount!=null){
                    programAmountMap.put(opp.Donation_Program__c,opp.Amount);
                }else{
                    programAmountMap.put(opp.Donation_Program__c,0.00);
                }
            }
        }
        
        firstPageOpp = new List<wrapDonationDetails>();
        secondPageOpp = new List<wrapDonationDetails>();
        pageBreak = false;
        
        if(programAmountMap.size()>0){
            
            for(String op :programAmountMap.keySet()){
            
                if(firstPageOpp.size()<=5){
                    firstPageOpp.add(new wrapDonationDetails(op,programAmountMap.get(op)));
                }else{
                    pageBreak = true;
                    secondPageOpp.add(new wrapDonationDetails(op,programAmountMap.get(op)));
                }
            }
        }
        
        
        if(po[0].Cheque_No__c !=null){
        isdisply = 'block';
        notCheck = 'none';
        }else{
        isdisply = 'none';
        notCheck = 'block';
        }
    }
            
        
    public String getmyimageurl(){  
        //document doc = [SELECT body FROM Document WHERE name='Signature for Tax Excemption form'];
        document doc = [SELECT body FROM Document WHERE DeveloperName='Signature_for_Tax_Excemption_form'];
        string imageid = doc.id; 
        imageid = imageid.substring(0,15);
        return '/servlet/servlet.FileDownload?file=' + imageid;
    } 
    
    public class wrapDonationDetails {
        public String donationProgramName {get; set;}
        public Decimal amount {get; set;}
 
        public wrapDonationDetails(String prgmName,Decimal amt) {
            this.donationProgramName = prgmName;
            this.amount              = amt;
        }
    }
}