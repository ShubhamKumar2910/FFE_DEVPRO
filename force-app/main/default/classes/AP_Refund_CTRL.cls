/*
* @purpose: This class is used as controller refund page 
*/ 
public class AP_Refund_CTRL {
    
    public RefundWrap rWrap	    {get; set;}
    public boolean isDisplay    {get;set;}
    public string refundedID  	{get; set;}
    public AP_Refund_CTRL(){
        
        try{
            string refundId	= apexpages.currentpage().getparameters().get('refId');
            refundedID = refundId;
            isDisplay                   =true;
            Refund__c	refundRec		= new Refund__c();
            refundRec					= [Select id,Application__c,Application__r.Scholarship_Amount__c,Refund_Status__c,Refunded_Amount__c,Refund_Transaction_No__c
                                           from Refund__c where Id =:refundId];
            
            List<Fund_Utilization__c>	utilizations	= new List<Fund_Utilization__c>();
            
            utilizations	= [Select id,Donor_Balance__c,Donor_Balance__r.Current_Balance__c,Donor_Balance__r.id,Refunded_Amount__c,IsRefunded__c,Donor__c,Disbursed_Amount__c,
                               General_Accounting_Unit__c from Fund_Utilization__c where Application__c =:refundRec.Application__c];
            
            rWrap				= new RefundWrap();
            rWrap.refund		= new Refund__c();
            rWrap.fundUtilz		= new List<Fund_Utilization__c>();
            rWrap.refund		= refundRec;
            rWrap.fundUtilz		= utilizations;
            
        }catch(Exception e){}        
        
    }
    
    public void doSave(){
        SavePoint sp = Database.setSavepoint();
        try{
            if(rWrap.refund.Refunded_Amount__c <= rWrap.refund.Application__r.Scholarship_Amount__c){
            // pagereference	p = new pagereference('/'+rWrap.refund.Id);
            Double totalRefund	= 0;
            for(Fund_Utilization__c r :	rWrap.fundUtilz){
                if(r.Refunded_Amount__c != null)
                    totalRefund	+=	r.Refunded_Amount__c;
            }
            
            if(totalRefund != rWrap.refund.Refunded_Amount__c || totalRefund == 0){
                if(totalRefund == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter donor balance to refund.'));
                    //return null;
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sum of all donor balance to refund should be equal to refunded amount.'));
                    //return null;
                }
            }else{
                //update Refurnd record
                update new Refund__c(id=rWrap.refund.id,Refund_Status__c=Constants.Refund_received,Refunded_Amount__c=rWrap.refund.Refunded_Amount__c,Refund_Transaction_No__c=rWrap.refund.Refund_Transaction_No__c);
                
                //update Fundutilizations and Donor Balances
                List<Fund_Utilization__c> fundUtilizationList = new List<Fund_Utilization__c>();
                List<Donor_Balance__c> DonorBalanceList = new List<Donor_Balance__c>();
                for(Fund_Utilization__c r :	rWrap.fundUtilz){
                    fundUtilizationList.add(new Fund_Utilization__c(id=r.id,IsRefunded__c=true,Refunded_Amount__c=r.Refunded_Amount__c));
                    DonorBalanceList.add(new Donor_Balance__c(id=r.Donor_Balance__r.id,Current_Balance__c=r.Donor_Balance__r.Current_Balance__c+r.Refunded_Amount__c,Refunded_Amount__c=r.Refunded_Amount__c));	
                }
                
                if(!fundUtilizationList.isEmpty())
                    update fundUtilizationList;
                
                if(!DonorBalanceList.isEmpty())
                    update DonorBalanceList;
                
                //update application internal status
                update new Application__c(id=rWrap.refund.Application__c,Internal_Status__c=Constants.Refunded);
                
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Amount refunded successfully.'));
                isDisplay = false;
            }
            // p.setRedirect(false);
            // return p;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Refunding amount can\'t be more than approved amount'));
}
        }catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('AP_Refund_CTRL', 'doSave', e);
        } 
    }
    
    /*public pagereference doCancel(){
        pagereference p = new Pagereference('/'+rWrap.refund.Id);
        p.setRedirect(true);
        return p;
    }  */  
    
    public class RefundWrap {
        public Refund__c refund						{get; set;}
        public List<Fund_Utilization__c> fundUtilz	{get; set;}
    }
}