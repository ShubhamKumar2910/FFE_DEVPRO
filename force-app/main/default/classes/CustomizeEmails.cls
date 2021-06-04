global class CustomizeEmails {
    Webservice static string sendEmail(string Email,string Msg){
        try{
            String alpha = Email;
            integer length=alpha.length();
            if(alpha.charAt(0)==44 ){
                return 'Please remove the , at the begining of Enter Email id(s)';
            }
            if(alpha.charAt(length-1) ==44){
                return 'Please remove the , at the ending of Enter Email id(s)';
            }
            
            List<String> emailAddress = alpha.split(',');
            Integer emaillength=emailAddress.size();
            if(emaillength==Integer.valueOf(System.label.Number_of_email_s_or_phonenumber_s)){
                return System.label.Email50;
            }
            set<string> emailset=new Set<string>();
            for(String b: emailAddress){
                if(emailset.contains(b)){
                    return 'please remove the duplicate email id- '+b;
                }
                else{
                    emailset.add(b);
                }    
            }
            
            //  string[] ToAddress=new string[]{};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            //  ToAddress.add(Email);
            mail.setToAddresses(emailAddress);
             List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
                if(owa.size()>0)
                    mail.setOrgWideEmailAddressId(owa[0].id);
                else
                    mail.setSenderDisplayName(Constants.FFE_NAME);
            }
            catch(Exception e){
                
            }
            mail.setPlainTextBody(Msg);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
            return label.EmaiSuccess;
        }
        catch(Exception ex){
            HandleBusinessException.captureError('CustomizeEmails', 'sendEmail', ex);
            return label.EmailFailed; 
        }
        
    } 
    
    Webservice static string sendSMS( string phone,string Msg){
        try{
            
            String phonetemp = phone;
             integer length=phonetemp.length();
            if(phonetemp.charAt(0)==44 ){
                
                 return 'please remove the , at the begining of Enter Mobile Number(s)'; 
            }
            if(phonetemp.charAt(length-1) ==44){
                
                return 'please remove the , at the ending of Enter Mobile Number(s)';
            }
            
            List<String> phonelist = phonetemp.split(',');
            Integer phonelength=phonelist.size();
            if(phonelength==Integer.valueOf(System.label.Number_of_email_s_or_phonenumber_s)){
                return label.phone50;
            }
            set<string> phoneset=new Set<string>();
            for(String b: phonelist){
                if(phoneset.contains(b)){
                    System.debug('phone '+b);
                    return 'please remove the duplicate phone number -'+b;
                }
                else{
                    phoneset.add(b);
                }    
            }
            
            if(phonelist!=null && Msg!=null){
                SMS_Service_CTRL.singleListOfString_To_String(phonelist,Msg);
            }
            return label.Phone_Success;
        }
        catch(Exception ex){
            HandleBusinessException.captureError('CustomizeEmails', 'sendSMS', ex);
            return label.Phone_failed; 
        }
        
    }
    
}