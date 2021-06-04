public class NotifyAboutSession {
    public static void sendNotificationToMentorMentee(map<id,Session__c> newSessionMap){
        set<id> contactId = new set<id>();
        List<contact> menteeRecList = new List<contact>();
        List<contact> mentorRecList = new List<contact>();
        set<id> mmaId = new set<id>();
        
        system.debug('newSessionMap::'+newSessionMap);
        for(Session__c ss : newSessionMap.values()){
            mmaId.add(ss.Mentor_Mentee_Association__c);
        }
        system.debug('mmaId::'+mmaId);
        
        List<Mentor_Mentee_Association__c> mentorMenteeIdList = [Select mentee_del__c, Mentor__c from Mentor_Mentee_Association__c where Id in : mmaId];
        system.debug('mentorMenteeIdList::'+mentorMenteeIdList);
        
        for(Mentor_Mentee_Association__c mma : mentorMenteeIdList){
            contactId.add(mma.mentee_del__c);
            contactId.add(mma.Mentor__c);
        }
        system.debug('contactId::'+contactId);
        List<Contact> conRecList = [Select Name,Phone,Whatsapp_opting__c,is_Mentee__c  From Contact where id in : contactId];
        system.debug('conRecList::'+conRecList);
        
        for(Contact con : conRecList){
            if(con.is_Mentee__c == true){
                menteeRecList.add(con);
            }
            else{
                mentorRecList.add(con);
            }
        }
        system.debug('menteeRecList::'+conRecList);
        system.debug('mentorRecList::'+conRecList);
        
        for(Contact con :menteeRecList){
            if(con.Phone != null && con.Whatsapp_opting__c == true){
                for(Session__c ss : newSessionMap.values()){
                    string startDate = formatDate(ss.Date__c);
                    String startTime = formatTime(ss.Time__c);
                    String endTime = formatTime(ss.End_time__c);
                    String msgBodyForMentee = 'Hi '+ss.Mentee_Name__c+', your session with '+ss.Mentor_Name__c+' is scheduled  on Date '+startDate+ ' which starts at '+startTime+' and ends by '+endTime+ ' and agenda for the session will be '+ss.Agenda__c+', you can join the session from following Link '+ss.Meeting_Link__c;
                    String menteeMob = ss.Mentee_Phone__c;
                    String bodyPayloadMentee = 'From='+EncodingUtil.urlEncode('whatsapp:'+'+14155238886'+'','UTF-8')+'&Body='+EncodingUtil.urlEncode(msgBodyForMentee,'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+menteeMob+'','UTF-8')+'';
                    system.debug('msgBodyForMentee::'+msgBodyForMentee);
                    system.debug('menteeMob::'+menteeMob);
                    system.debug('bodyPayloadMentee::'+bodyPayloadMentee);
                    whatsappCallouts.sendSMSCallout(bodyPayloadMentee);
                }
            }
        }
        
        for(Contact con :mentorRecList){
            if(con.Phone != null && con.Whatsapp_opting__c == true){
                for(Session__c ss : newSessionMap.values()){
                    string startDate = formatDate(ss.Date__c);
                    String startTime = formatTime(ss.Time__c);
                    String endTime = formatTime(ss.End_time__c);
                    String msgBodyForMentor = 'Hi '+ss.Mentor_Name__c+ ', your session with '+ss.Mentee_Name__c+ ' is scheduled on Date '+startDate+ ' which starts at '+startTime+' and ends by '+endTime+ ' and agenda for the session will be '+ss.Agenda__c+', you can join the session from following Link '+ss.Meeting_Link__c;
                    String mentorMob = ss.Mentor_Phone__c;  
                    String bodyPayloadMentor = 'From='+EncodingUtil.urlEncode('whatsapp:'+'+14155238886'+'','UTF-8')+'&Body='+EncodingUtil.urlEncode(msgBodyForMentor,'UTF-8')+'&To='+EncodingUtil.urlEncode('whatsapp:'+mentorMob+'','UTF-8')+'';
                    system.debug('msgBodyForMentor::'+msgBodyForMentor);
                    system.debug('mentorMob::'+mentorMob);
                    system.debug('bodyPayloadMentor::'+bodyPayloadMentor);
                    whatsappCallouts.sendSMSCallout(bodyPayloadMentor);
                }
            }
        }
    }
    public static String formatDate(Date dt) {
        if(dt != null){
            return dt.year() + '-' + dt.month() + '-' + dt.day();    
        }
        else {
            return 'Date';
        }
    }
    public static String formatTime(time tm) {
        if(tm != null){
            String correctedFormat = string.valueof(tm);
            correctedFormat = correctedFormat.substring(0, 5);
            return correctedFormat;
        }
        else{
            return 'error';
        }
    }
}