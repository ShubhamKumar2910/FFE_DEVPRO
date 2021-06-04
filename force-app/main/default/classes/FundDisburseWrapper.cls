/*
 * @purpose	: This class is used as a collection for fund disbursment 
 * 			  to students by donor 
 * 			   
 */ 
public class FundDisburseWrapper {
	
    public Contact 					student;
    public Application__c 			appln;
    public List<fundedAmtByGAU> 	amtFunded;
    public double 					totalFundedAmt;
    public List<String> 			donorBalanceIds;
    
    public FundDisburseWrapper(){
        this.student			= new Contact();
        this.appln				= new Application__c();
        this.amtFunded			= new List<fundedAmtByGAU>();
        this.donorBalanceIds	= new List<String>();
    }
    
    public class fundedAmtByGAU {        
        public Donor_Balance__c	donorbalance;
        public String 			extraFunds;
		
        public fundedAmtByGAU(){
            this.donorbalance	= new Donor_Balance__c();
        }
		        
    }
    
}