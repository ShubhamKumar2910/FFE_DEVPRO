public class mentorMenteeController {
    
    public String pageLoadInstanceString {get;set;}
    public String baseURL {get;set;}
    public mentorMenteeController(){
        baseURL = URL.getSalesforceBaseUrl().getHost();

        onPageLoadData pageLoadInstance = new onPageLoadData();
        
        pageLoadInstance.picklistValues = new Map<String,List<String>>();
         
        
        pageLoadInstance.picklistValues.put('Gender_mentor',picklist_values('Mentor__c','Gender__c'));
        pageLoadInstance.picklistValues.put('Qualification',picklist_values('Mentor__c','Qualification__c'));
        pageLoadInstance.picklistValues.put('Mentor',picklist_values('Mentor__c','Mentor_Before__c'));
        pageLoadInstance.picklistValues.put('Language_mentor',picklist_values('Mentor__c','Languages_Spoken__c'));
        pageLoadInstance.picklistValues.put('Session',picklist_values('Mentor__c','Mentoring_Session_Time__c'));
        pageLoadInstance.picklistValues.put('Gender_student',picklist_values('Student__c','Gender__c'));
        pageLoadInstance.picklistValues.put('Language_student',picklist_values('Student__c','Language__c'));
        pageLoadInstance.picklistValues.put('Mentoring_needs',picklist_values('Student__c','Mentoring_needs__c'));
        pageLoadInstance.picklistValues.put('Branch',picklist_values('Student__c','Branch__c'));
       	
        pageLoadInstance.allProgrammes = [SELECT CreatedDate,Name,Skills__c FROM Program__c];
       
		
   
        
        pageLoadInstanceString = JSON.serialize(pageLoadInstance);
        
    }
    
  
    public static List<Student__c> getStudentDetails(){
        
        List<Student__c> studentDetail	=	new List<Student__c>();
		System.debug('studentDetail==>'+studentDetail);
        return studentDetail;
    }
    @RemoteAction
    public static List<pragrammeWithAttachment> getProgramDetails(){
        try{
            List<pragrammeWithAttachment> listToBeReturned = new List<pragrammeWithAttachment>();
        
            for(Program__c programmeRec: [SELECT CreatedDate,Name,Skills__c, (SELECT Id, Name FROM Attachments) FROM Program__c]){
                System.debug('programmeRec'+programmeRec.Attachments.size());
                if(!programmeRec.Attachments.isEmpty()){
                    listToBeReturned.add(new pragrammeWithAttachment(programmeRec,programmeRec.Attachments[0].Id));
                }else{
                    listToBeReturned.add(new pragrammeWithAttachment(programmeRec,''));
                }
                
            }
            System.debug('listToBeReturned'+listToBeReturned);
            return listToBeReturned;
        }catch(Exception e){
            System.debug('listToBeReturned'+e.getLineNumber()+' AT '+e.getMessage());
			return null;
        }
        
    }
   
    
    public static String[] picklist_values(String object_name, String field_name)
    {
        String[] values = new String[]{};
            String[] types = new String[]{object_name};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results)
        {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues())
            {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        
        system.debug('values'+values);
        return values;
    }
		
    	 
	
    
    
	class onPageLoadData{
    	Map<String, List<String>> picklistValues {get;set;}
        List<QuestionTemplateWrap> selfAssessmentQuestions{get;set;}
        
        List<Program__c> allProgrammes{get;set;}
	}
    class QuestionTemplateWrap{
        public string templateQuestion{get;set;}
    }
    
    class pragrammeWithAttachment{
        public Program__c programmeRec;
        public String attId;
        
        public pragrammeWithAttachment(Program__c programmeRec,String attId){
            this.programmeRec = programmeRec;
            this.attId = attId;
        }
    }
}