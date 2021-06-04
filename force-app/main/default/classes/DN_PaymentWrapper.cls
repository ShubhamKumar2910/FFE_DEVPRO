/*
@Purpose     : Wrapper class to hold Payment Order Info
@CreatedDate : 17/02/2017
@Author      : Amritesh
*/
public class DN_PaymentWrapper {
	
    public Contact donorRecord;
    public double totalOrderAmountINR;
    public double totalOrderAmountUSD;
    public String currencyType;
    public List<programWrapper> programs;
    
    public class programWrapper {
        public Program_Frequency__c frequency;
        public double programAmountINR;
        public double programAmountUSD;
        public integer studentCount;
        
        public programWrapper (){
            this.frequency			= new Program_Frequency__c();
            this.programAmountINR	= 0;
            this.programAmountUSD	= 0;
            this.studentCount		= 0;
        }
    }
    
    public DN_PaymentWrapper(){
        this.donorRecord			= new Contact();
        this.totalOrderAmountINR	= 0;
        this.totalOrderAmountUSD	= 0;
        this.programs				= new List<programWrapper>();
    }
}