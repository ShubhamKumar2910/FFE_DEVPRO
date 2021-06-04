public class contactNameFormat {
    
    public static void NameFormat(List<Contact> newList){
        try{
            system.debug('Contact List:::::'+newList);
            List<Contact> nameList = new List<Contact>();
            for(Contact con : newList){
                con.FirstName = con.FirstName.substring(0,1).toUpperCase() + con.FirstName.substring(1).toLowerCase(); 
                con.LastName = con.LastName.substring(0,1).toUpperCase() + con.LastName.substring(1).toLowerCase();
            }  
        }
        catch(Exception e){
            HandleBusinessException.captureError('contactNameFormat', 'NameFormat', e);
        }
    }
}