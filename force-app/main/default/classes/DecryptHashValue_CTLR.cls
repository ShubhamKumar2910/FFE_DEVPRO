public class DecryptHashValue_CTLR {

    public string hashValue {get;set;}
    public string decrytedValue {get;set;}
    public string encrytedValue {get;set;}
    public boolean showResult {get;set;}
    
    public void decodeString(){
        try{
            if(!String.IsBlank(hashValue)){
                encrytedValue=hashValue;
                String keyValue='9876543210123456';
                Blob key = Blob.valueOf(keyValue);
                Blob blobData = EncodingUtil.base64Decode(hashValue);     
                Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, blobData);      
                decrytedValue=decryptedBlob.toString(); 
                hashValue='';
                
                showResult=true;
            }
            else{
                encrytedValue='';
                decrytedValue='';
                showResult=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter hash value'));
            }
        }catch(exception e){
            encrytedValue='';
            decrytedValue='';
            showResult=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, string.valueof(e)));
        }
    }
}