@isTest
public class AttachmentTriggerHelperTest {
    
    public static testmethod void validateAttachment(){
        Contact con=Utility_Test.insertNewDonorId('Gourab','Hazra');
        con.Has_Donated_First_Time_Donor__c=false;
        insert con;
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
    	attachment.ParentId = con.Id;
    	attachment.Name = 'Primary logo';
    	attachment.Body = b;
    	
    	insert attachment;
        
    }

}