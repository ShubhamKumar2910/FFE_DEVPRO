public class SMS_Service_CTRL{
    
    //to convert contact List to contact Map
    private static Map<Id, Contact> makeMapFromSObjectList(List<Contact> lstSobject) {
        
        if (lstSobject == null) return null;
        Map<Id, Contact> theMap = new Map<Id, Contact>();
        for (Contact s : lstSobject) {
            theMap.put((Id)s.get('Id'), s);
        }
        return theMap;
    }
    
    /*
*@purpose : calls sendSingle / sendBulk SMS class and converts List<String> to String for respective condtion.
*@parameter : List<String>, String
*/
    public static void singleListOfString_To_String(List<String> singleList,String textMessage){
        if(singleList.size() > 1){
            SMS_Service_Helper.sendBulkSMS(singleList,textMessage);
           // Constants.SMS_TRIGGER_RUNNING = true;
        }
        else{
            String contactNumber1 = string.join(singleList,'');
            SMS_Service_Helper.sendSingleSMS(contactNumber1,textMessage);
           // Constants.SMS_TRIGGER_RUNNING = true;
          } 
    }
    
 
/*
 *@ purpose: Sends SMS when Student,Facilitator,Donor Register for FFE 
 *@ parameter : Trigger.new from Contact trigger 
 */     
    
    public static void onAfterInsert(List<Contact> conList){
        
        List<String> contactNumberWith_or_WithoutFacilitator_for_student   = new List<String>();
        List<String> contactNumberWithFacilitator                          = new List<String>();
        List<String> DonorNumbers                                          = new List<String>();
        List<String> FacilitatorNumbers                                    = new List<String>();
        
        for(Contact con: conList){
            
            if(con.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId() && con.Internal_Status__c == Constants.ELIGIBLE){
                contactNumberWith_or_WithoutFacilitator_for_student.add(String.valueOf(con.MobilePhone));
            }
            if(con.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId()){
                DonorNumbers.add(String.valueOf(con.MobilePhone));
            }
            if(con.RecordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId()){
                FacilitatorNumbers.add(String.valueOf(con.MobilePhone));
            }
            
            if(con.Facilitator_Name__c!=null || con.Refered_by_Facilitator_Id__c!=null){
                contactNumberWithFacilitator.add(String.valueOf(con.MobilePhone));
            }
           
        }
        
        //SMS notification when student register for scholarship
        if(!contactNumberWith_or_WithoutFacilitator_for_student.isEmpty())
            singleListOfString_To_String(contactNumberWith_or_WithoutFacilitator_for_student,constants.when_Student_register_for_sholarship_text);
                
        //SMS notification when Donor register for FFE
        if(!DonorNumbers.isEmpty())
            singleListOfString_To_String(DonorNumbers,constants.On_new_Donor_Registration_text);
        
        //SMS notification when Facilitator Register with FFE
        if(!FacilitatorNumbers.isEmpty())
            singleListOfString_To_String(FacilitatorNumbers,constants.Welcome_Mail_to_Facilitator_text);
        
        //try to add time delay here, ask amritesh once and about 1 message or 2
        
        //SMS notification when facilitator is auto assigned through prelim page
        if(!contactNumberWithFacilitator.isEmpty())
            singleListOfString_To_String(contactNumberWithFacilitator,constants.When_facilitator_assigned_to_Student_text);
        
    }
    
    
    public static void onAfterUpdateContact(List<Contact> oldList, List<Contact> newList){
        
        Map<id,Contact> newContactMap                 =       makeMapFromSObjectList(newList);
        Map<id,Contact> oldContactMap                 =       makeMapFromSObjectList(oldList);
        List<String> contactNumberWithFacilitator     =       new List<String>();
        List<String> contactNumberSelected		      =       new List<String>();
        
        for(Contact con:newContactMap.values()){                               
            
            if(oldContactMap.get(con.id).Facilitator_Name__c != newContactMap.get(con.id).Facilitator_Name__c && (string.isBlank(oldContactMap.get(con.id).Facilitator_Name__c) || oldContactMap.get(con.id).Facilitator_Name__c == null) && newContactMap.get(con.id).Facilitator_Name__c !=null){
                contactNumberWithFacilitator.add(String.valueOf(con.MobilePhone));
            }
            
            if(oldContactMap.get(con.id).Internal_Status__c != Constants.SELECTED_APPLICATION && newContactMap.get(con.id).Internal_Status__c == Constants.SELECTED_APPLICATION){
                contactNumberSelected.add(String.valueOf(con.MobilePhone));
            }
            
        }
        
        //SMS notification when facilitator assigned to student manually
        if(!contactNumberWithFacilitator.isEmpty())
            singleListOfString_To_String(contactNumberWithFacilitator,constants.When_facilitator_assigned_to_Student_text);
          
        
        //SMS notification when scholarship application gets selected
        if(!contactNumberSelected.isEmpty())
            singleListOfString_To_String(contactNumberSelected,constants.When_scholarship_application_gets_selected_text);       
    
    }
    
    
    public static void onAfterUpdateApplication(Map<id,Application__c> oldMap,Map<id,Application__c> newMap){
        Constants.APPLICATION_TRIGGER_RUNNING          =	   true;        
        List<String> contactNumberApproved   	       =       new List<String>();
        
        for(Application__c app : newMap.values()){
            if(oldMap.get(app.id).External_Status__c != Constants.APPROVED_STATUS && newMap.get(app.id).External_Status__c == Constants.APPROVED_STATUS){
                contactNumberApproved.add(String.valueOf(app.Students_Mobile_number__c));
            }
        }
        
        //SMS notification When scholarship application gets Approved for Scholarship
        if(!contactNumberApproved.isEmpty())
            SMS_Service_Helper.sendBulkSMS(contactNumberApproved,constants.When_scholarship_application_gets_Approved_text);
    
    }
    
    
    
    /*
    * Purpose : Document missing SMS notification for student
    */
    public static void uploadDocumentSMS(String contactNumber){
        SMS_Service_Helper.sendSingleSMS(contactNumber,constants.Document_missing_notification_text);
    }
    
       
    /*
    * Purpose : 80G form SMS notification for donor
    */
    public static void send_80G_form_SMS(String DonorNumber){
        SMS_Service_Helper.sendSingleSMS(DonorNumber,constants.X80G_certificate_text);
    }    
    
    
    /*
* Purpose : SMS notification to Facilitator regarding Students assigned to them.
*/   
    //public static void studentsAssignedToFacilitator(Set<String> facilitatorNumbers){
    //    List<String> facilitator_num = new List<String>();
     //   facilitator_num.addAll(facilitatorNumbers);
     //   SMS_Service_Helper.sendBulkSMSThroughBatch(facilitator_num,constants.Student_s_Assigned_text);       
   // }
    
     /*
* Purpose :  SMS notification to Facilitator regarding Scholarship transferred to them.
*/     
    public static void scholarshipTransferredSMSToFacilitator(List<String> facilitatorsNumber){
        singleListOfString_To_String(facilitatorsNumber,constants.On_transfer_of_Scholarship_to_Students_text);
        
    }
    
        /*
    * Purpose : SMS notification to student regarding Scholarship transferred.
    */     
    public static void scholarshipTransferredSMSToStudent(List<String> studentsNumber){
        singleListOfString_To_String(studentsNumber,constants.On_transfer_of_Scholarship_to_Student_text);
        
    }
}