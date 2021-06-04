/*
*@description: This class is used as controller to process CCAvenue FCRA transaction response.
*@author: Amritesh
*/
public class DN_HandleFCRACCAvenueResponse_CTRL {
    
    public string payment_Status    {get; set;}
    public string encDonorId        {get; set;}
    public string sfRedirectURL     {get; set;}
    
    public pagereference handleResponse(){
    
        try{
            
            CCAvenue_Details__c ccDetails   = CCAvenue_Details__c.getInstance();
            sfRedirectURL                   = ccDetails.SF_redirect_after_payment__c;
            string resEnc                   = Apexpages.currentPage().getParameters().get('encResp');
            string orderId                  = Apexpages.currentPage().getParameters().get('orderNo');
            
            String PLAIN_TEXT               = DN_CCAvenue_Service.decryptString(resEnc, ccDetails.FCRA_Working_Key__c);
            
            payment_Status                  = DN_CCAvenue_Service.processCCAvenueResponse(PLAIN_TEXT, orderId);
            encDonorId                      = getDonorIdEncrypted(orderId);
            
       }catch(Exception ex){
           HandleBusinessException.captureError('DN_CCAvenueResponse_CTRL', 'DN_CCAvenueResponse_CTRL', ex);
       } 
        
        return null;
     }
    
    private string getDonorIdEncrypted(String orderId){
        try{
            string donorId  = [Select Donor__c from Payment_Order__c where Order_No__c =: orderId].Donor__c; 
            return DN_CCAvenue_Service.encryptString(donorId, DN_ServiceConstants.DN_ORDER_KEY);           
        }catch(Exception ex){
            HandleBusinessException.captureError('DN_CCAvenueResponse_CTRL', 'getDonorIdEncrypted', ex);
            return null;
        }
    }
}