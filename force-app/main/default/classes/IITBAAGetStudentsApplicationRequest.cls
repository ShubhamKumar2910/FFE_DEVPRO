public class IITBAAGetStudentsApplicationRequest {

	public cls_Applications[] Applications;
	public class cls_Applications {
		public String Email;	//testqw1@gmail.com
		public String StudentUniqueID;	//78ff9012
		public String FFEUID;	//DEV-FFEUID017862
		public String StudentSFID;	//0030l00000Bt2k6AAB
		public String ExistingApplicationID;	//719f2d1
		public String ApplicationSFID;	//APPLN-034508
	}
	public static IITBAAGetStudentsApplicationRequest parse(String json){
		return (IITBAAGetStudentsApplicationRequest) System.JSON.deserialize(json, IITBAAGetStudentsApplicationRequest.class);
	}
   
}