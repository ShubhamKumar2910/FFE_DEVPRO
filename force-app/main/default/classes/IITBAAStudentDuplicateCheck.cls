/*
*  Name         : IITBAAStudentDuplicateCheck
*  Company      : Et marlabs
*  Purpose      : Duplication check of IITBAA students sent, whether they exist as FFE scholar or not.
*  Developer    : Jayanth B
*  Created      :  19/1/2018
*  Modified by  :
*  Modified at  : 
***************************************************************************
*/
public class IITBAAStudentDuplicateCheck {
    
    public static String duplicateCheck(Set<String> duplicateCheckString, String duplicateCheckType){
        
        String studentRTypeId                     = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
		List<Contact> listOfDuplicateStudents 	  = new List<Contact>();
        String Query                          	  = '';
        boolean isIITBAA                          = false;
        
        Query                                     = 'Select id,Email,MobilePhone,Student_ID__c,Aadhar_number__c,From_IITBAA__c,recordTypeID From Contact where recordTypeID=:studentRTypeId';
        
        if(duplicateCheckType == 'Email'){            
            Query += ' AND Email =:duplicateCheckString';
        }
        
        if(duplicateCheckType == 'Mobile'){
            Query += ' AND MobilePhone =:duplicateCheckString';
        }
        
        if(duplicateCheckType == 'Aadhar'){            
            Query += ' AND Aadhar_number__c =:duplicateCheckString';
        }
        
        if(duplicateCheckType == 'UniqueStudentID'){
            Query += ' AND Student_ID__c =:duplicateCheckString';
        }
        Query += ' AND  From_IITBAA__c=:isIITBAA LIMIT 1';
        try{            
            listOfDuplicateStudents = Database.query(Query);
            
            for(Contact con : listOfDuplicateStudents){
                if(duplicateCheckType == 'Email'){
                    return String.valueOf(con.Email);
                }else if(duplicateCheckType == 'Mobile'){
                    return String.valueOf(con.MobilePhone);
                }else if(duplicateCheckType == 'Aadhar'){
                    return String.valueOf(con.Aadhar_number__c);
                }else if(duplicateCheckType == 'UniqueStudentID'){
                    return String.valueOf(con.Student_ID__c);
                }                
            }
            return null;
        }
        catch(Exception e){
            HandleBusinessException.captureError('IITBAAStudentDuplicateCheck', 'duplicateCheck', e);
            return 'Exception';
        }
    }
}