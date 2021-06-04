public class CIBICICI_RequestBody {

	public cls_request Request;
	public class cls_request {
		public cls_BusinessAccountUtilizationDetail[] BusinessAccountUtilizationDetail;
	}
	public class cls_BusinessAccountUtilizationDetail {
		public String SFTRANID;	//BATXN-213015
		public String APITXNStatus;	//POSTED
		public String DisbursementMode;	//NEFT
		public String PayMod;	//N
		public String Amount;	//566366
		public String DebitAccNo;	//362493813112
		public String PayableLocation;	//Bangalore
		public String PrintLocation;	//Bangalore
		public String BeneficiaryName;	//Harissh Kumar Rathode
		public String BeneficiaryAccNo;	//362439381112
		public String BeneficiaryIFSC;	//SBIN00084231
		public String SFUniqueID;	//a176F000300TKz1D
	}
	public static CIBICICI_RequestBody parse(String json){
		return (CIBICICI_RequestBody) System.JSON.deserialize(json, CIBICICI_RequestBody.class);
	}
}