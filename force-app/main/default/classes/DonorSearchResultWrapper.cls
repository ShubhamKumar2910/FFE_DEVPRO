/*
 * @purpose: This class is used as a wrapper for donor search result
*/
public class DonorSearchResultWrapper {
    
    public contact donorInfo;
    public double currentBalance;
    public double blockedBalance;
    public double availableBalance;
    public Integer enggCount;
    public Integer medicalCount;
    public Integer currentYearStudentCount;
    //
    public String gauName;
    public double mappedFund;
    public String donorBalanceId;
    
    public DonorSearchResultWrapper(){
        this.donorInfo      	= new contact();
        this.currentBalance 	= 0;
        this.blockedBalance 	= 0;
        this.availableBalance 	= 0;
        this.enggCount 			= 0;
        this.medicalCount 		= 0;
        currentYearStudentCount = 0;
        //
        this.gauName = '';
        this.mappedFund = 0;
        this.donorBalanceId = '';
        
    }
}