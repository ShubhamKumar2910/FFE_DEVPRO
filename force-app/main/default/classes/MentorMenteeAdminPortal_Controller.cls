global

class MentorMenteeAdminPortal_Controller {

    
   
    public string listOfStates                      {get;set;}
    
    
    public string genderPickListValues              {get; set;}
    public string statusPickListValues		        {get;set;}
    public string languagePickListValues            {get;set;}
    public string countryList                       {get;set;}
   // gourab 
   // 
   // public string examList                        {get;set;}
   // public string ExamRankList                    {get;set;}
    public string ScholarList                       {get;set;}
    public string priorityList                      {get;set;}
    public string corporatePicklistValues           {get;set;}
    public string branchPicklistValues           	{get;set;}
    
    public MentorMenteeAdminPortal_Controller(){
        initialize();        
    }
    
  
   
     @RemoteAction
    public static List<State_Master__mdt> getStateList(String countryName){
        return Utility.getStates(countryName);
    }
    
    @RemoteAction
    public static List<Schema.PicklistEntry> getLanguagePicklistValues(){
        String objectName = 'Contact';
        String fieldName ='Language_Known__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        }   
        return ple;
    }
    
     @RemoteAction
    public static List<Schema.PicklistEntry> getCorporatePicklistValues(){
        String objectName = 'Contact';
        String fieldName ='Corporate__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        }   
        return ple;
    }
    
    
     @RemoteAction
    public static List<Schema.PicklistEntry> getBranchPicklistValues(){
        String objectName = 'Contact';
        String fieldName ='Branch_Stream__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        }   
        return ple;
    }
    
     @RemoteAction
    public static List<Schema.PicklistEntry> getStatusPicklistValues(){
        String objectName = 'Mentor_Mentee_Association__c';
        String fieldName ='Status__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        }   
        return ple;
    }
    
     @RemoteAction
    public static List<Schema.PicklistEntry> getGenderPicklistValues(){
        String objectName = 'Contact';
        String fieldName ='Gender__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        }   
        return ple;
    }
    
    @RemoteAction 
    public static list<Mentor_Mentee_Association__c> getMentorMenteeAssociation (string startDate, string endDate, string country,string branch,list<string> loaction, list<string> language, list<string> gender,string corporate){
 	
        String Query = '';
            
        system.debug('country==='+country+'   status==='+branch);
        system.debug('startDate==='+loaction+'endDate==='+language);
		if(String.isBlank(corporate)){
        Query			= 		'select name, id, mentee_del__r.Name, mentee_del__r.Current_year__c, mentee_del__r.Spoken_Languages__c, mentee_del__r.Branch_Stream__c,mentee_del__r.Language_Known__c, Mentor__r.Name, Status__c, createddate,mentee_del__r.MailingCountry ,mentee_del__r.MailingState,Modules__c from Mentor_Mentee_Association__c where Status__c =\'Requested\' AND mentee_del__r.is_Mentee__c = True AND is_SelfAssesment_Completed__c = True '  ;
           
        if(!String.isBlank(country)){
            Query 		+=		' AND mentee_del__r.MailingCountry =: country';
            
        }
        
        if(!String.isBlank(branch)){
            Query 		+= 		' AND mentee_del__r.Branch_Stream__c =: branch';
            
        }
        
        if(loaction.size() >0){
            Query		+=		' AND mentee_del__r.MailingState IN: loaction';
        }
        if(language.size() >0){
            Query		+=		' AND mentee_del__r.Language_Known__c IN: language';
        }
        
        if(gender.size() >0){
            Query		+=		' AND mentee_del__r.Gender__c IN: gender';
        }
        } else{
           list<Donor_Application_Mapping__c> donorAppLicationList = [select name,id,Student__c from Donor_Application_Mapping__c where Donor__r.Corporate__c =: corporate];
           	system.debug('donorAppLicationList===='+donorAppLicationList); 
            set<string> studentIdSet = new set<string>();
            for(Donor_Application_Mapping__c donorApp : donorAppLicationList){
                studentIdSet.add(donorApp.Student__c);
            }
            
            if(studentIdSet.size() > 0){
                Query = 'select name, id, mentee_del__r.Name,mentee_del__r.Language_Known__c,mentee_del__r.Current_year__c,mentee_del__r.Spoken_Languages__c, Mentor__r.Name, Status__c, createddate,mentee_del__r.MailingCountry ,mentee_del__r.MailingState,Modules__c from Mentor_Mentee_Association__c where Status__c =\'Requested\' AND mentee_del__r.is_Mentee__c = True AND is_SelfAssesment_Completed__c = True AND mentee_del__c =:studentIdSet' ;
            }
            
        }
        
        if(!String.isBlank(startDate)){
            String[] startArr = startDate.split('T');
            string[] startDateArray = startArr[0].split('-');
            
            Integer startYear = Integer.valueOf(startDateArray[0]);
            Integer startMonth = Integer.valueOf(startDateArray[1]);
            Integer startDay = Integer.valueOf(startDateArray[2]);
            date startOfDate = date.newInstance(startYear, startMonth, startDay);
            Query		+=		' AND createdDate >: startOfDate';
        }
        
        if(!String.isBlank(endDate)){
            String[] EndArr = endDate.split('T');
            string[] endDateArray = EndArr[0].split('-');
            
            Integer endYear = Integer.valueOf(endDateArray[0]);
            Integer endMonth = Integer.valueOf(endDateArray[1]);
            Integer endDay = Integer.valueOf(endDateArray[2]);
            date endOfDate = date.newInstance(endYear, endMonth, endDay);
            system.debug('endDate==='+endOfDate);
            Query		+=		' AND createdDate <: endOfDate';
            
        }
        
        
        system.debug('Query====>'+Query);
        try{            
            list<Mentor_Mentee_Association__c> listOfmmAssociation = Database.query(Query);
            system.debug('listOfmmAssociation==>'+listOfmmAssociation);
            return listOfmmAssociation;
        }
        
        catch(exception e){
            system.debug('getLineNumber==='+e.getLineNumber()+'getMessage==='+e.getMessage());
            return null;
        }
        
    }
    
    @RemoteAction 
    public static void saveMentorMenteeAssociation(list<Mentor_Mentee_Association__c> mmAssociationList){
        try{
            system.debug('mmAssociation====>'+mmAssociationList);  
        list<Mentor_Mentee_Association__c> mmAssociationListToUpdate = new list<Mentor_Mentee_Association__c>();
        for(Mentor_Mentee_Association__c mmAssociation:mmAssociationList){
            if(mmAssociation.Mentor__c != null){
             	mmAssociation.Status__c = 'Approved';   
                mmAssociation.Mentor_assigned_date__c = date.today();
                mmAssociationListToUpdate.add(mmAssociation);
            }
            
            
        }
        system.debug('mmAssociationListToUpdate==>'+mmAssociationListToUpdate);
	update mmAssociationListToUpdate;   
        }catch(exception e){
            system.debug('getLineNumber==>'+e.getLineNumber()+' getErrormessage====>'+e.getMessage());
        }
  
    }
    
    @RemoteAction
    public static list<Mentor_Mentee_Association__c> searchByFfeId(string ffeId){
        system.debug('ffeId==='+ffeId);
        List<String> ffeIdList = ffeId.split(',');
    	list<Mentor_Mentee_Association__c> mmAssociation =[select name, id, mentee_del__r.Name, mentee_del__r.Current_year__c,mentee_del__r.Language_Known__c,mentee_del__r.Spoken_Languages__c, Mentor__r.Name, Status__c, createddate,mentee_del__r.MailingCountry ,mentee_del__r.MailingState,Modules__c from Mentor_Mentee_Association__c where Status__c ='Requested' AND mentee_del__r.FFE_ID__c =:ffeIdList ];
       // list<contact> conList= [select name,id,MailingCountry, MailingState, Language_Known__c,Corporate__c,Gender__c  from contact where FFE_ID__c =:ffeId];
  		//return conList;
  		return mmAssociation;
        
    }
    
    
    @RemoteAction
    public static list<Mentor_Mentee_Association__c> searchBycorprate(string corpName){

        List<string> conIdList = new List<string>();
       
         	           list<Donor_Application_Mapping__c> donorAppLicationList = [select name,id,Student__c from Donor_Application_Mapping__c where Donor__r.name like: '%'+ corpName +'%'];
          set<string> studentIdSet = new set<string>();
            for(Donor_Application_Mapping__c donorApp : donorAppLicationList){
                studentIdSet.add(donorApp.Student__c);
            }
    	list<Mentor_Mentee_Association__c> mmAssociation =[select name, id, mentee_del__r.Name,mentee_del__r.Language_Known__c,mentee_del__r.Spoken_Languages__c, Mentor__r.Name, Status__c, createddate,mentee_del__r.MailingCountry ,mentee_del__r.MailingState,Modules__c from Mentor_Mentee_Association__c where Status__c ='Requested' AND mentee_del__c =:studentIdSet ];
       // list<contact> conList= [select name,id,MailingCountry, MailingState, Language_Known__c,Corporate__c,Gender__c  from contact where FFE_ID__c =:ffeId];
  		//return conList;
  		return mmAssociation;
        
    }
    
    @RemoteAction
    public static list<mentorXloadWrapper> searchByCorp(string corpName){
		system.debug('corpName==>'+corpName);
    	list<contact> mentorList =[select name,id,MailingCountry, Branch_Stream__c, MailingState, Language_Known__c,Spoken_Languages__c,Corporate__c,Gender__c,(select name,id from Mentor_Mentee_Associations1__r  where status__c = 'Approved')  from contact where (RecordType.Name ='Mentor' OR Is_Mentor__c = True) AND Corporate__c like: '%'+corpName+'%'];
       // list<contact> conList= [select name,id,MailingCountry, MailingState, Language_Known__c,Corporate__c,Gender__c  from contact where FFE_ID__c =:ffeId];
  		//return conList;
  		system.debug('mentorList===='+mentorList);
  		list<mentorXloadWrapper> mentorXloadList = new list<mentorXloadWrapper>();
        for(contact mentor:mentorList){
            mentorXloadWrapper mentorXload = new mentorXloadWrapper();
        	  mentorXload.mentor = mentor;  
            mentorXload.load = mentor.Mentor_Mentee_Associations1__r.size();
            
            mentorXloadList.add(mentorXload);
            
        }
        //mentorXloadList.sort();
        return mentorXloadList;
        
    }
    
    
    @RemoteAction  
    public static list<mentorXloadWrapper> getMentorDetails(string country, list<string> loaction, list<string> language, list<string> gender){
        
        string Query;
        Query                                     = 'select name,id,MailingCountry, Branch_Stream__c, MailingState, Language_Known__c,Branch_Areas_of_Practice_Study__c,Spoken_Languages__c,Corporate__c,Gender__c,(select name,id from Mentor_Mentee_Associations1__r  where status__c = \'Approved\')  from contact where (RecordType.Name =\'Mentor\' OR Is_Mentor__c = True) ';
        
        if(!String.isBlank(country)){
                Query += ' AND MailingCountry =: country';
            
        }
        
         if(loaction.size() >0){
                    query+=' AND MailingState IN: loaction';
                }
        
       
        if(language.size() >0){
                    query+=' AND Language_Known__c IN: language';
                }
        
        if(gender.size() >0){
                    query+=' AND Gender__c IN: gender';
                }
       // list<contact> mentorDetails = [select name,id,MailingCountry, MailingState, Language_Known__c,(select name,id from Mentor_Mentee_Associations1__r  where status__c = 'Approved')  from contact where RecordType.Name ='Mentor' AND MailingCountry =:country AND MailingState IN: location AND Language_Known__c IN:language ];
       try{            
            list<contact> mentorDetails = Database.query(Query);
            system.debug('listOfmmAssociation==>'+mentorDetails);
           
           system.debug('mentorDetails==>'+mentorDetails);
        list<mentorXloadWrapper> mentorXloadList = new list<mentorXloadWrapper>();
        for(contact mentee:mentorDetails){
            mentorXloadWrapper mentorXload = new mentorXloadWrapper();
        	  mentorXload.mentor = mentee;  
            mentorXload.load = mentee.Mentor_Mentee_Associations1__r.size();
            
            mentorXloadList.add(mentorXload);
            
        }
        //mentorXloadList.sort();
        return mentorXloadList;
        }
        
        catch(exception e){
            system.debug('getLineNumber==='+e.getLineNumber()+'getMessage==='+e.getMessage());
            return null;
        }
        
    }
    
    
      @RemoteAction  
    public static list<mentorXloadWrapper> getMentorsAvailable(string mentorName){
        
        string Query;
        
        if(!String.isBlank(mentorName)){
            Query	= 'select name,id,MailingCountry,Branch_Stream__c, MailingState, Language_Known__c,Branch_Areas_of_Practice_Study__c,Spoken_Languages__c,Corporate__c,Gender__c,(select name,id from Mentor_Mentee_Associations1__r  where status__c = \'Approved\')  from contact where Name like \'%' + mentorName + '%\' ';
            
        }
        
       
       // list<contact> mentorDetails = [select name,id,MailingCountry, MailingState, Language_Known__c,(select name,id from Mentor_Mentee_Associations1__r  where status__c = 'Approved')  from contact where RecordType.Name ='Mentor' AND MailingCountry =:country AND MailingState IN: location AND Language_Known__c IN:language ];
       try{            
            list<contact> mentorDetails = Database.query(Query);
            system.debug('listOfmmAssociation==>'+mentorDetails);
           
           system.debug('mentorDetails==>'+mentorDetails);
        list<mentorXloadWrapper> mentorXloadList = new list<mentorXloadWrapper>();
        for(contact mentee:mentorDetails){
            mentorXloadWrapper mentorXload = new mentorXloadWrapper();
        	  mentorXload.mentor = mentee;  
            mentorXload.load = mentee.Mentor_Mentee_Associations1__r.size();
            
            mentorXloadList.add(mentorXload);
            
        }
        //mentorXloadList.sort();
        return mentorXloadList;
        }
        
        catch(exception e){
            system.debug('getLineNumber==='+e.getLineNumber()+'getMessage==='+e.getMessage());
            return null;
        }
        
    }
    
    public void initialize(){
        
        listOfStates                    = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
        countryList                     = JSON.serializePretty(Utility.getCountryList());
        languagePickListValues          = JSON.serializePretty(getLanguagePicklistValues());
        statusPickListValues          = JSON.serializePretty(getStatusPicklistValues());
        genderPickListValues          = JSON.serializePretty(getGenderPicklistValues());
        corporatePicklistValues          = JSON.serializePretty(getCorporatePicklistValues());
        branchPicklistValues          = JSON.serializePretty(getBranchPicklistValues());

        
    }
    
    global class mentorXloadWrapper {
        public contact mentor;
        public integer load;
   
    }
}