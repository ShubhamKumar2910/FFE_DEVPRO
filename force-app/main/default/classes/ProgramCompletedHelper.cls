public class ProgramCompletedHelper {
    public static void notifyMentorAboutPrgrmCmpltion(Map<id, Mentor_Mentee_Association__c> mmaNewMap, Map<id, Mentor_Mentee_Association__c> mmaOldMap){
        system.debug('mmaTrigger@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@NotifyMentorAfterPrgrmCompletion');
        set<Id> conId = new set<Id>();
        for(Mentor_Mentee_Association__c mma :mmaNewMap.Values()){
            if(mma.Status__c == 'Completed' && mma.Status__c != mmaOldMap.get(mma.Id).Status__c){
                System.debug('mma.Status__c::'+mma.Status__c);
                conId.add(mma.Mentor__c);
                System.debug('conId::'+conId);
                //conId.add(mma.mentee_del__c);
            }
        }
        SendEmailNotification.sendEmailToIndividuals(conId, 'NotifyMentorAfterPrgrmCompletion');
    }
    
    public static void notifyMenteeAboutPrgrmCmpltion(Map<id, Mentor_Mentee_Association__c> mmaNewMap, Map<id, Mentor_Mentee_Association__c> mmaOldMap){
        system.debug('mmaTrigger@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@NotifyMenteeAfterPrgrmCompletion');
        set<Id> conId = new set<Id>();
        for(Mentor_Mentee_Association__c mma :mmaNewMap.Values()){
            if(mma.Status__c == 'Completed' && mma.Status__c != mmaOldMap.get(mma.Id).Status__c){
                //conId.add(mma.Mentor__c);
                conId.add(mma.mentee_del__c);
            }
        }
        SendEmailNotification.sendEmailToIndividuals(conId, 'NotifyMenteeAfterPrgrmCompletion');
    }
    
}