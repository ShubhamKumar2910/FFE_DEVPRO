/*
*@purpose       : To check for changes in bank information and college/course information and send email appropriately
*@param         : trigger newlist and oldlist
*@returnType    : -
*/ 
public class ChangeInBankInfoMail {
    
    private static Map<Id, Contact> makeMapFromSObjectList(List<Contact> lstSobject) {
        
        if (lstSobject == null) return null;
        Map<Id, Contact> theMap = new Map<Id, Contact>();
        for (Contact s : lstSobject) {
            theMap.put((Id)s.get('Id'), s);
        }
        return theMap;
    }
    
    public static void onAfterUpdate(List<Contact> oldList,List<Contact> newList){
        
        Map<id,Contact> newContactMap           =       makeMapFromSObjectList(newList);
        Map<id,Contact> oldContactMap           =       makeMapFromSObjectList(oldList);
        Map<id,Contact> bankContactMap          =       new Map<id,Contact>();
        Map<id,Contact> courseContactMap        =       new Map<id,Contact>();
        
        for(Contact c : newlist){
            
            if(oldContactMap.get(c.id).Bank_Account_Holder_s_Name__c != newContactMap.get(c.id).Bank_Account_Holder_s_Name__c
               ||oldContactMap.get(c.id).Branch_Address__c != newContactMap.get(c.id).Branch_Address__c
               ||oldContactMap.get(c.id).Bank_Name__c != newContactMap.get(c.id).Bank_Name__c
               ||oldContactMap.get(c.id).X11_character_IFSC_Code_of_the_Branch__c != newContactMap.get(c.id).X11_character_IFSC_Code_of_the_Branch__c
               ||oldContactMap.get(c.id).Full_Bank_Account_No_With_all_digits__c != newContactMap.get(c.id).Full_Bank_Account_No_With_all_digits__c){
                   
                   bankContactMap.put(c.id,c);  
               }
            
            if(oldContactMap.get(c.id).Course__c != newContactMap.get(c.id).Course__c 
               ||oldContactMap.get(c.id).college_name__c != newContactMap.get(c.id).college_name__c
               ||oldContactMap.get(c.id).Branch_Stream__c != newContactMap.get(c.id).Branch_Stream__c){
                   
                   courseContactMap.put(c.id,c);
               }
        }
        
        if(bankContactMap.size()>0){
            
            List<String> accTeamIds          =      Utility.getGroupUsers(System.Label.AccountTeamPublicGroupName);
            
            contactBankChanges(newContactMap,oldContactMap,newList,accTeamIds);
        }
        
        if(courseContactMap.size()>0){
            
            Map<id,College_Master__c> newcollegeNamesMap        =           getCollegeNamesMap(newlist);
            Map<id,College_Master__c> oldcollegeNamesMap        =           getCollegeNamesMap(oldlist);
            
            List<String> ffeStaffIds         =      Utility.getGroupUsers(System.Label.FFEStaffPublicGroupName);
            
            contactCourseChanges(newcollegeNamesMap,oldcollegeNamesMap,newContactMap,oldContactMap,newList,ffeStaffIds);   
        }      
    }
    
    public static void contactBankChanges(Map<id,Contact> newContactMap,Map<id,Contact> oldContactMap,List<Contact> newList,List<String> accTeamIds){
        
        try{
            
            List<Messaging.SingleEmailMessage> emails           =       new List<Messaging.SingleEmailMessage>();
            String htmlBody = '';
            String subject  = '';
            
            htmlBody = 'Dear Account Team,<p>Below bank information has been changed: </p>';
            
            for(Contact c : newlist){
                
                htmlBody += '<table border="1" style="border-collapse: collapse;table-layout: fixed;width: 400px">'+c.FirstName+' '+c.LastName+' (<b>'+c.FFE_ID__c+'</b>)<tr><th></th><th>Previous Value</th><th>New Value</th></tr>';
                
                if(oldContactMap.get(c.id).Bank_Account_Holder_s_Name__c != newContactMap.get(c.id).Bank_Account_Holder_s_Name__c){ 
                    htmlBody += '<tr align="center"><td>Account Holder Name</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).Bank_Account_Holder_s_Name__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).Bank_Account_Holder_s_Name__c) + '</td></tr>';
                }
                
                if(oldContactMap.get(c.id).X11_character_IFSC_Code_of_the_Branch__c != newContactMap.get(c.id).X11_character_IFSC_Code_of_the_Branch__c){
                    htmlBody += '<tr align="center"><td>11 character IFSC Code of the Branch</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).X11_character_IFSC_Code_of_the_Branch__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).X11_character_IFSC_Code_of_the_Branch__c) + '</td></tr>';
                }
                
                if(oldContactMap.get(c.id).Full_Bank_Account_No_With_all_digits__c != newContactMap.get(c.id).Full_Bank_Account_No_With_all_digits__c){
                    htmlBody += '<tr align="center"><td>Full Bank Account No</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).Full_Bank_Account_No_With_all_digits__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).Full_Bank_Account_No_With_all_digits__c) + '</td></tr>';
                }
                
                if(oldContactMap.get(c.id).Bank_Name__c != newContactMap.get(c.id).Bank_Name__c){
                    htmlBody += '<tr align="center"><td>Bank Name</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).Bank_Name__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).Bank_Name__c) + '</td></tr>';
                }
                
                if(oldContactMap.get(c.id).Branch_Address__c != newContactMap.get(c.id).Branch_Address__c){                                                                                                                                                                             
                    htmlBody += '<tr align="center"><td>Branch Address</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).Branch_Address__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).Branch_Address__c) + '</td></tr>';
                }
                
                htmlBody += '</table></br>';
            }
            htmlBody += '<p>Regards,</br>Foundation For Excellence</p>';
            subject = 'Change in Bank Information';
            emails.add(Utility.sendMail(subject,htmlbody,accTeamIds));
            Messaging.sendEmail(emails);
        }catch(exception e){
            
            e.getMessage();
        }
    } 
    
    public static void contactCourseChanges(Map<id,College_Master__c> newcollegeNamesMap,Map<id,College_Master__c> oldcollegeNamesMap,Map<id,Contact> newContactMap,Map<id,Contact> oldContactMap,List<Contact> newList,List<String> ffeStaffIds){
        
        try{
            
            List<Messaging.SingleEmailMessage> emails           =       new List<Messaging.SingleEmailMessage>();
            String htmlBody = '';
            String subject  = '';
            
            htmlBody = 'Dear FFE Staff,<p>Below course/college information has been changed:</p>';
            
            for(Contact c : newlist){
                
                htmlBody +='<table border="1" style="border-collapse: collapse;table-layout: fixed;width: 400px">'+c.FirstName+' '+c.LastName+' (<b>'+c.FFE_ID__c+'</b>)<tr><th></th><th>Previous Value</th><th>New Value</th></tr>';                          
                
                if(oldContactMap.get(c.id).college_name__c != newContactMap.get(c.id).college_name__c){
                    
                    if(oldContactMap.get(c.id).college_name__c==null)
                        htmlBody +=  '<tr align="center"><td>College</td><td> </td><td>' + Utility.checkIfNull(newcollegeNamesMap.get(newContactMap.get(c.id).college_name__c).Name) + '</td></tr>';
                    
                    else if(newContactMap.get(c.id).college_name__c==null)
                        htmlBody +=  '<tr align="center"><td>College</td><td>'+ Utility.checkIfNull(oldcollegeNamesMap.get(oldContactMap.get(c.id).college_name__c).Name)+'</td><td> </td></tr>';
                    
                    else
                        htmlBody +=  '<tr align="center"><td>College</td><td>' + Utility.checkIfNull(oldcollegeNamesMap.get(oldContactMap.get(c.id).college_name__c).Name)  + '</td><td>' + Utility.checkIfNull(newcollegeNamesMap.get(newContactMap.get(c.id).college_name__c).Name) + '</td></tr>';
                }
                
                if(oldContactMap.get(c.id).Course__c != newContactMap.get(c.id).Course__c){
                    htmlBody += '<tr align="center"><td>Course</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).Course__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).Course__c) + '</td></tr>';
                }
                
                if(oldContactMap.get(c.id).Branch_Stream__c != newContactMap.get(c.id).Branch_Stream__c){
                    htmlBody += '<tr align="center"><td>Branch</td><td>' + Utility.checkIfNull(oldContactMap.get(c.id).Branch_Stream__c)  + '</td><td>' + Utility.checkIfNull(newContactMap.get(c.id).Branch_Stream__c) + '</td></tr>';
                }
                
                htmlBody += '</table></br>';
            }
            htmlBody += '<p>Regards,</br>Foundation For Excellence</p>';
            subject = 'Change in Course/College Information';
            emails.add(Utility.sendMail(subject,htmlbody,ffeStaffIds));
            Messaging.sendEmail(emails);
        }catch(exception e){
            
            e.getMessage();
        }
    }
    /*
*@purpose       : To get collegeNames
*@param         : List of contact records
*@returnType    : Map of contact collegenames
*/  
    public static Map<id,College_Master__c> getCollegeNamesMap(List<Contact> listvalues){
        
        Set<id> ids                     =       new Set<id>();
        
        for(contact c : listvalues)
            ids.add(c.college_name__c);
        
        Map<id,College_Master__c> collegeNamesMap       =           new Map<id,College_Master__c>([Select id,name 
                                                                                                   from college_master__c 
                                                                                                   where id in:ids]);
        
        return collegeNamesMap;            
    }
}