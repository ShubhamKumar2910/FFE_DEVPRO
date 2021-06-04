public class SessionStatusNotify {
    public static void sendWhatsapp(Map<id,Mentor_Mentee_Association__c> mmaNewMap, Map<id,Mentor_Mentee_Association__c> mmaOldMap){
        System.debug('Into the class for query data'+mmaNewMap);
        System.debug('Into the class for query data'+mmaOldMap);
        
        Set<id> mmaId = new Set<id>();
        String mmaStatus;
        for(Mentor_Mentee_Association__c mma : mmaNewMap.values()){
            System.debug('mma.Status__c '+mma.Status__c);
            System.debug('mmaOldMap.get(mma.Id).Status__c'+mmaOldMap.get(mma.Id).Status__c);
            //if(mma.Status__c  != mmaOldMap.get(mma.Id).Status__c ){
                mmaId.add(mma.Id);
                System.debug('status of mma is changed ');
            //}
        }
        System.debug('Calling future method');
        System.debug('mmaId'+mmaId);
        WhatsappService.sendMsg(mmaId);
    }
    
}