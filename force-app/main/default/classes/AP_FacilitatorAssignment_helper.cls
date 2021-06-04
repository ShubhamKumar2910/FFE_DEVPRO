/*
* @Purpose      :  AP_FacilitatorAssignment_CTRL helper class.
* @Author       :  Jayanth B
* @CreatedDate  :  22-03-2017
*/

public class AP_FacilitatorAssignment_helper{
    
    /*
    *@ Purpose        : Get list of Cities for the indian State
    *@ Parameters     : State
    *@ return type    : List<State_City_Master__c>
    */ 
    public Static List<State_City_Master__c> getAllCities(String currentState) { 
            return [select City__c from State_City_Master__c 
                    where State__c=:currentState AND Country__c=:Constants.COUNTRY_IND 
                    Order By City__c LIMIT 40000];
    }    
    
    /*
    *@ Purpose        : to gets student details
    *@ Parameter      : State, City 
    *@ return type    : List<Contact>
    */     
    public Static List<Contact> getStudentDetails(String state, String city,String addressType){
        
        Id studentRecordType                      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        String internalStats                 	  = Constants.SELECTED_APPLICATION;
        string facId		                 	  = '';
        List<Contact> listOfSelectedStudents 	  = new List<Contact>();
        String Query                          	  = '';
        
        Query                                     = 'Select Id,Name,Internal_Status__c,FFE_ID__c,mailingcity,Phone,MobilePhone,Parent_Mobile__c,Parent_Phone__c,MailingState,Refered_by_Facilitator_Id__c,Refered_by_Facilitator_Name__c From Contact '+
            										'where Internal_Status__c =:internalStats AND Active_Application_ID__c != null AND RecordTypeId=:studentRecordType AND (Facilitator_Name__c =null OR Facilitator_Name__c =:facId) AND IsPrelimProcessed__c = false ';
        
        if(!String.isBlank(state)){
            if(addressType == Label.AddressType){            
                Query += ' AND MailingState =:state';
            }else{
                Query += ' AND College_State__c =:state';
            }
        }
        
        if(!String.isBlank(city)){
            if(addressType == Label.AddressType){ 
            Query += ' AND MailingCity =:city';
            }else{
            Query += ' AND College_City__c =:city';    
            }
        }
        Query	+= ' Order by Name LIMIT 2000';
        try{            
            listOfSelectedStudents = Database.query(Query);
        }
        catch(Exception e){}
        
        return listOfSelectedStudents;        
    }

    
    /*
    *@ Purpose        : to get facilitator details
    *@ Parameter      : State, City 
    *@ return type    : List<Contact>
    */     
    public Static List<Contact> getFacilitatorDetails(String state, String city){
        Id facilitatorRecordType           =  Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId(); 
        
        List<Contact> listOfFacilitators   = new List<Contact>();
        String facstatus ='Active';
        String Query 					   = '';
        Query                              = 'Select Id,Name,Email,Working_Mode__c,FFE_ID__c,Phone,MobilePhone,Facilitator_Load__c,mailingcity,MailingState,MailingStreet,MailingPostalCode From Contact where RecordTypeId=:facilitatorRecordType and Facilitator_Status__c=:facstatus';
        
        if(!String.isBlank(state)){            
            Query += ' AND MailingState =:state';
        }
        
        if(!String.isBlank(city)){            
            Query += ' AND MailingCity =:city';
        }
        
        Query	+= ' Order By Name';
        try{
            
            listOfFacilitators = Database.query(Query);
        }
        catch(Exception e){}
        
        return listOfFacilitators;
    }
    
    /*
    *@ Purpose     : Mapping Student to Facilitator
    *@ parameter   : Wrapper with StudentID , FacilitatorID 
    *@ return Type : String
    */        
    public static String createFacilitatorMapping(List<AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper> facilitatorStudentList){
        
        Savepoint sp 	= Database.setSavepoint();
        String retMsg	='';
        
        try{            
            List<Contact> studentToUpdateList              = new List<Contact>();
            List<Application__c> applicationToUpdate       = new List<Application__c>();
            Map<String,String> mapOfStudentAndFac          = new Map<String,String>();
            
            for(AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper st: facilitatorStudentList){
                
                mapOfStudentAndFac.put(st.studentId,st.facilitatorId);
            }
            
            List<Contact> ctList                           = new List<Contact>();
            ctList                                         = [Select Id,Facilitator_Name__c,(Select id,Internal_Status__c,External_Status__c From Applications__r where RecordType.Name =:Constants.SCHOLARSHIP_APPLICATION AND Application_Stage__c =:Constants.ACTIVE_APPLICATION) 
                                                              From Contact where Id In: mapOfStudentAndFac.keySet()];
            
            for(Contact ct:ctList){
                
                ct.Facilitator_Name__c        = mapOfStudentAndFac.get(ct.id);
                ct.Internal_Status__c         = Constants.ONLINE_MATCHED_APPLICATION;
                
                for(Application__c ap : ct.Applications__r){
                    
                    ap.External_Status__c     = Constants.INPROGRESS_APPLICATION; 
                    ap.Internal_Status__c     = Constants.ONLINE_MATCHED_APPLICATION;
                    applicationToUpdate.add(ap);
                }     
                studentToUpdateList.add(ct);   
            } 
            
            if(studentToUpdateList.size()>0){
                
                update studentToUpdateList; 
                
                update applicationToUpdate;
                retMsg = Constants.FACILITATORMAPPING_SUCCESSMSG;
                Set<String> facIds	= new Set<string>();
                facIds.addAll(mapOfStudentAndFac.values());
                studentCountForFacilitator(facIds);
            }else{
                retMsg = null;
            }            
        }catch(Exception e){
            HandleBusinessException.captureError('AP_FacilitatorAssignment_helper', 'createFacilitatorMapping', e);
			system.debug('exception'+e.getMessage());            
            Database.rollback(sp);                    
        }
        return retMsg;
    }
    
    
    /*
    *@purpose   : To count number of Students whose Application is Active and update the Facilitator load Count on Facilitator for Particular student  
    *@parameter : Facilitator Id(s)
    */
    public static void studentCountForFacilitator(set<string> facilitatorIds){    
        Set<Id>  facilitatorId = new Set<Id>();
        
        for (Id ids : facilitatorIds){
            if(ids != null){
                facilitatorId.add(ids);
            }
        }
        try{  
            
            Map<ID,Contact> conMap                   = new Map<ID,Contact>();
            Map<Id,Application__c> appMap            = new Map<ID , Application__c>([Select id,Student__r.Facilitator_Name__c
                                                                                     from Application__c 
                                                                                     where Application_Stage__c=:Constants.ACTIVE_APPLICATION AND RecordType.Name=:Constants.SCHOLARSHIP_APPLICATION AND Student__r.Facilitator_Name__c=:facilitatorId]);  
            boolean check =false;
            for(string facKey : facilitatorId){
                if(appMap.size() > 0){
                    
                    check = false;
                    for(string apkey :appMap.KeySet()){
                        string facId	= appMap.get(apkey).Student__r.Facilitator_Name__c;
                        
                        if(facId == facKey){
                            if(conMap.containsKey(facId)){   
                                Contact con = conMap.get(facId);
                                con.Facilitator_Load__c += 1; 
                                conMap.put(facKey, con);   
                                check =true;
                            }
                            else{                      
                                conMap.put(facKey, new Contact(Id=facKey,Facilitator_Load__c=1));  
                                check = true;  
                            }
                        }else{  
                            if(check == false)
                                conMap.put(facKey, new Contact(Id=facKey,Facilitator_Load__c=0));
                        }
                    } 
                }else{      
                    conMap.put(facKey, new Contact(Id=facKey,Facilitator_Load__c=0));
                }  
            }
            Constants.Contact_TRIGGER_RUNNING = true;
            update conMap.values();
        }
        catch(Exception e){
            HandleBusinessException.captureError('AP_FacilitatorAssignment_helper', 'studentCountForFacilitator', e);
            system.debug('exception'+e.getMessage());
        }   
    }
}