public class ContactTriggerHelper {
    
    /*
*@ purpose : To Convert List - Map
*/    
    private static Map<Id, Contact> makeMapFromSObjectList(List<Contact> lstSobject) {
        
        if (lstSobject == null) return null;
        Map<Id, Contact> theMap = new Map<Id, Contact>();
        for (Contact s : lstSobject) {
            theMap.put((Id)s.get('Id'), s);
        }
        return theMap;
    }
    
    
    /*
*@Purpose    : To get Facilitators ID from Student Records and to Update Facilitator Load Count
*@Parameter  : Trigger.old , Trigger.New
*/     
    
    public static void onAfterUpdate(List<Contact> oldList,List<Contact> newList)
    {
        
        Map<id,Contact> newContactMap           =       makeMapFromSObjectList(newList);
        Map<id,Contact> oldContactMap           =       makeMapFromSObjectList(oldList);
        
        Set<string> contactList = new Set<string>();
        Map<String,String> studentEmail = new Map<String,String>();
        Map<String,String> FacilitatorEmail = new Map<String,String>();
        Id studentRecordType     =  Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        
        
        for(Contact c : newlist){
            
            if(newContactMap.get(c.id).Facilitator_Name__c != null){
                if(oldContactMap.get(c.id).Facilitator_Name__c!= newContactMap.get(c.id).Facilitator_Name__c){
                    contactList.add(c.Facilitator_Name__c);     
                    if(oldContactMap.get(c.id).Facilitator_Name__c!= null)
                    {
                        contactList.add(oldContactMap.get(c.id).Facilitator_Name__c);
                    }
                }
            }else{
                if(oldContactMap.get(c.id).Facilitator_Name__c!= null)
                {
                    contactList.add(oldContactMap.get(c.id).Facilitator_Name__c);
                }
            }
        }

        
        if(contactList.size() != 0)
            AP_FacilitatorAssignment_helper.studentCountForFacilitator(contactList);
    }
    

}