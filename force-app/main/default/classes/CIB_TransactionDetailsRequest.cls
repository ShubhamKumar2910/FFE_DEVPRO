public class CIB_TransactionDetailsRequest {
    
    public cls_BusinessAccountUtilizationDetail[] BusinessAccountUtilizationDetail;
    public class cls_BusinessAccountUtilizationDetail {
        public String SFTRANID;	//BATXN-004
        public String BankTransactionReferenceNo;	//CMS39850955
        public String BankTxnDate;	//30-11--0001
        public String APITXNStatus;	//Processed
        public String APITXNReason;	//c
        public String SFUniqueID;	//a176F00000TKz1D
        public Integer BridgeBatchId;	//1
    }
    public static CIB_TransactionDetailsRequest parse(String json){
        return (CIB_TransactionDetailsRequest) System.JSON.deserialize(json, CIB_TransactionDetailsRequest.class);
    }
    
}