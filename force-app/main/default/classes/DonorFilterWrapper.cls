/*
 * @purpose	: This wrapper class is used as Donor Filter for Donor
 * 			  allocation page
 */
public class DonorFilterWrapper {
    public List<String> locations;
    public List<String> gaus;
    public List<String> programs;
    public boolean isDonorBalance;    
	public String ffeUID;
    public string countryName;
    
    public DonorFilterWrapper(){
        this.locations		=  new List<String>();
        this.gaus			=  new List<String>(); 
        this.programs		=  new List<String>();
        this.isDonorBalance	= false;
        this.ffeUID         = '';
        this.countryName	= '';
    }
}