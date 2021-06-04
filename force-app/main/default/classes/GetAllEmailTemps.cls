global class GetAllEmailTemps {
    @Remoteaction
    public static List<EmailTemplate> ffeEmailTemps(){
        List<EmailTemplate> emailTempList =[SELECT Name FROM EmailTemplate ];
        // ApexPages.currentPage().getParameters().get('url');
        return emailTempList ;
    }
    
    Webservice static String getConIdAndTempName(List<String> mmaId){
        system.debug('MMA Id'+mmaId);
        set<id> menteeId = new set<id>();
        set<id> mentorId = new set<id>();
        List<Mentor_Mentee_Association__c> conRec = [Select Mentor__c,mentee_del__c From Mentor_Mentee_Association__c where id in :mmaId] ; 
        
        for(Mentor_Mentee_Association__c con : conRec){
            if(con.mentee_del__c != null){
                menteeId.add(con.mentee_del__c);
            }
            if(con.Mentor__c != null){
                mentorId.add(con.Mentor__c);
            }
        }
        system.debug('menteeId'+menteeId);
        system.debug('mentorId'+mentorId);
        return 'Success';
    }
    @Remoteaction
    public static String sendEmail(string emailTempName){
        System.debug('Email NAme'+emailTempName);
        return 'Success';
    }
}