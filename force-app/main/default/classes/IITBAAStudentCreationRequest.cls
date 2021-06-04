//
//Used for IITBAA student details(request of wrapper sent by IITBAA to SF).
//

public class IITBAAStudentCreationRequest{
	public cls_Request[] Request;
	public class cls_Request {
		public cls_StudentDetail StudentDetail;
		public cls_Applications[] Applications;
	}
	public class cls_StudentDetail {
		public String FirstName;	//Jayanth1
		public String LastName;	//B
		public String Email;	//abc@test.com
		public String Gender;	//Male
		public String Phone;	//7829483829
		public String AadharNumber;	//123456789012
		public String AcademicStartYear;	//1st year
		public String MailingStreet;	//Udayapura
		public String MailingCity;	//bangalore
		public String MailingState;	//karnataka
		public String MailingCountry;	//india
		public String MailingPostalCode;	//560082
		public String Course;	//BE/B.Tech
		public String Branch;	//Computer Science and Engineering
		public String BankAccountHolderName;	//Jayanth B
		public String BankAccountNumber;	//123456786543
		public String BankName;	//Axis
		public String BankIFSCCode;	//AX1234
		public String BankCity;	//Bangalore
		public String BankState;	//Karnataka
		public String BankPinCode;	//560082
		public String StudentUniqueID;	//123434
	}
	public class cls_Applications {
		public String ApplicationType;	//New
		public String CourseName;	//BE/B.Tech
		public String CurrentYear;	//1st Year
		public String BranchName;	//Computer Science and Engineering
		public Integer CollegeFee;	//10000
		public Integer HostelExpense;	//10000
		public Integer BookExpense;	//2000
		public Integer TransportationExpense;	//10000
		public Integer UniformExpense;	//1040
        public String  Semester;
		public String ExistingApplicationID;	//12342342
	}
	public static IITBAAStudentCreationRequest parse(String json){
		return (IITBAAStudentCreationRequest) System.JSON.deserialize(json, IITBAAStudentCreationRequest.class);
	}

}