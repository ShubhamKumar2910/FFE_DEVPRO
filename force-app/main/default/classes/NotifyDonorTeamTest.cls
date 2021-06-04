@isTest
public class NotifyDonorTeamTest {
    
    static testmethod void ValidateDonor(){
        List<Contact> newList = new List<Contact>();
        List<Contact> oldList = new List<Contact>();
        Id donerRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        Contact con=Utility_Test.insertNewDonorId('Gourab','Hazra');
        con.Has_Donated_First_Time_Donor__c=false;
        con.DN_PAN__c = 'AFGHA1234W';
        con.MobilePhone = '9090785676';
        con.Phone = '8909877658';
        con.RecordTypeId = donerRecType;
        insert con;
        oldList.add(con);
        for(Contact c : oldList){
        c.RecordTypeId = donerRecType;
        c.DN_PAN__c = 'AFGHA1234P';
        c.MobilePhone = '9090785678';
        c.Phone = '8909877650';
        c.DN_Donor_Category__c = 'Alumni Scholar';
        newList.add(c);    
        }
        
        Update newList; 
        test.startTest();
      NotifyDonorTeam.donorFieldChangesUpdate(newList,oldList);
         NotifyDonorTeam.donorCreateNotification(newList,oldList);
        
        test.stopTest();
        
    }

}