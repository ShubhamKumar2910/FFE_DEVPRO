/**
 * Author : Vighnesh
 */
public class MentorMenteeAuthHelper {
    
    public static Pagereference checkUserAuth(String hashCode) {
        PageReference pg   = new PageReference('/');        
        if(String.isBlank(hashCode))
            return pg;
        
        system.debug('hashCode===>'+hashCode);  
        
        Id currentUserId = getContactId(hashCode);
        System.debug('auth user id ---'+currentUserId);
        // If current user is not an authorized user 
        // then redirect to login page
        if(currentUserId == null) return pg;
        
        return null;
    }

    private static Id getContactId(String hashCode){
        try{
            System.debug('--- hash '+hashCode);
            Contact user =  [SELECT id,RecordTypeId,RecordType.developerName, Last_Hash_Code_Updated__c, Internal_Status__c FROM Contact 
                                WHERE Login_hash_Code__c =: hashCode AND Login_Hash_Code__c != null
                                AND (RecordType.developerName = :Constants.FFE_DONOR_STUDENT OR RecordType.developerName = :Constants.FFE_Mentor OR RecordType.developerName = :Constants.FFE_DONOR_DONOR)];
            
            if(user.Last_Hash_Code_Updated__c.date().daysBetween(system.today()) > 0)
                return null;
            Long milliseconds = DateTime.now().getTime() - user.Last_Hash_Code_Updated__c.getTime();
            Long hours = milliseconds / 1000 / 60 / 60;
            System.debug('---'+hours);
            if(hours > 2) {
                System.debug('token expired ---');
                return null;
            }
            return user.Id;
        }catch(Exception e){HandleBusinessException.captureError('MentorMenteeAuthHelper', 'getContactId', e);}
        return null;
    }
}