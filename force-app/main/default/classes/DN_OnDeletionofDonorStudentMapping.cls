/*
* @Purpose      : Class called on deletion of donor student mapping
*/
//* This piece of code is not required after the new process= "Donor Application Mapping"*/
public class DN_OnDeletionofDonorStudentMapping {
    
/*@purpose                      : Update ismapped checkbox field in contact on deletion of donor-student mapping.
* @param                        : Trigger oldList of Donor_Student_Mapping
*/   
   /* public static void deleteDonorStudentMapping(List<Donor_Student_Mapping__c> oldList){
        
        SavePoint sp = Database.setSavepoint();
        try{
            Set<Id> contactIdSet = new Set<Id>();
            for(Donor_Student_Mapping__c dsmObj : oldList){
                String cId = dsmObj.Student__c;
                if(!String.isBlank(cId))
                    contactIdSet.add(cId);
            }
            List<Contact> conlist = new List<Contact>();
            List<Contact> updateContactList = new List<Contact>();
            if(!contactIdSet.isEmpty()){
                Map<id,Contact> studentInfoMap = new Map<id,Contact>([Select id,ismapped__c, (select id from Donor_Student_Mappings1__r) from contact where recordtype.developername='Student' and id in: contactIdSet ]);
                for(Id key : studentInfoMap.keySet()){
                    if(studentInfoMap.get(key).Donor_Student_Mappings1__r.isEmpty()){
                        studentInfoMap.get(key).ismapped__c = false;
                        updateContactList.add(studentInfoMap.get(key));
                    }
                }
                if(!updateContactList.isEmpty()){
                    update updateContactList;
                }
            }
        }catch(Exception e){
            HandleBusinessException.captureError('DN_OnDeletionofDonorStudentMapping', 'deleteDonorStudentMapping', e);
            Database.rollback(sp);
        }
    }*/
}