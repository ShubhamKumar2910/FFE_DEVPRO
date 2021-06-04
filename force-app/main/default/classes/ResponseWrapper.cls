public class ResponseWrapper{
    public cls_Batch Batch;
    public class cls_Batch {
        public Integer BatchId;	//26
        public String BatchStatus;	//Success
        public String BatchReason;	//Valid data
    }
    
    public static ResponseWrapper parse(String json){
		return (ResponseWrapper) System.JSON.deserialize(json, ResponseWrapper.class);
	}
}