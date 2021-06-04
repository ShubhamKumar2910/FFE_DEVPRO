public class mentorAssigned_helper {
    public static void notifyMenteeAboutMentorAllocation(Map<id, Mentor_Mentee_Association__c> mmaNewMap, Map<id, Mentor_Mentee_Association__c> mmaOldMap){
        
        map<string, Mentor_Mentee_Association__c> mmaRecMap = new map<string, Mentor_Mentee_Association__c>();
        
        for(Mentor_Mentee_Association__c mma :mmaNewMap.Values()){
            if(mma.Status__c == 'Approved' && mma.Status__c != mmaOldMap.get(mma.Id).Status__c){
                mmaRecMap.put('Approved',mma);
            }
        }
        EmailMergeFieldParser.parseModuleCompletedTemplates('menteeAssigned','mentorAssigned',mmaRecMap);
        // SendEmailNotification.sendEmailToIndividuals(conId, 'mentorAssigned');
    }
    
}