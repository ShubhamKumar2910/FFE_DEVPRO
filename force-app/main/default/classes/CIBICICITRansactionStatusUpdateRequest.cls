public class CIBICICITRansactionStatusUpdateRequest {
    
    public cls_Response Response;
    public class cls_Response {
        public cls_BusinessAccountUtilizationDetail[] BusinessAccountUtilizationDetail;
    }
    public class cls_BusinessAccountUtilizationDetail {
        public String SFTRANID;	//BATXN-00806
        public String BankTransactionReferenceNo;	//CMS642550389
        public String BankTxnDate;	//10/10/2018
        public String APITXNStatus;	//PROCESSED
        public String APITXNReason;	//c
        public String SFUniqueID;	//a176F00000TKz1D
        public String BridgeBatchId;	//00806
    }
    public static CIBICICITRansactionStatusUpdateRequest parse(String json){
        return (CIBICICITRansactionStatusUpdateRequest) System.JSON.deserialize(json, CIBICICITRansactionStatusUpdateRequest.class);
    }
    
}