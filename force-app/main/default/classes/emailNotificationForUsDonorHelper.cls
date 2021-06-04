public class emailNotificationForUsDonorHelper {
    
    public static String sendMailtodonors(List<String> finalyr,String emailIds, String EmailMsg,String subjectval){
        system.debug(finalyr);system.debug(emailIds);system.debug(EmailMsg);system.debug(subjectval);
        try{
            Map<String,Donor_Application_Mapping__c> FYearMap = new Map<String,Donor_Application_Mapping__c>();
            String alpha = emailIds;
            integer length=alpha.length();
            if(alpha.charAt(0)==44 ){
                return 'Please remove the , at the begining of Enter Email id(s)';
            }
            if(alpha.charAt(length-1) ==44){
                return 'Please remove the , at the ending of Enter Email id(s)';
            }
            alpha   = alpha.replaceAll('\n', '');
            alpha   = alpha.trim();
            alpha   = alpha.replaceAll(' ', '');
            system.debug(alpha);
            List<String> emailAddress = alpha.split(',');
            Integer emaillength=emailAddress.size();
            if(emaillength==Integer.valueOf(System.label.Number_of_email_s_or_phonenumber_s)){
                return System.label.Email50;
            }
            set<string> emailset=new Set<string>();
            system.debug(emailAddress);
            for(String b: emailAddress){
                system.debug(b);
                if(emailset.contains(b)){
                    return 'please remove the duplicate email id- '+b;
                }
                else{
                    b = b.replaceAll(' ', '');
                    b = b.trim(); 
                    emailset.add(b);
                }    
            }
            system.debug(json.serialize(emailset));
            List<String> emailListUnq = new List<String>();
            emailListUnq.addall(emailset);
            system.debug(emailListUnq);
            Id DonorRecordType  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
            
            List<contact> newList = [Select id,email,Name,FFE_ID__c,MobilePhone,(Select Student__c,Application__r.Year__c,Student__r.Gender__c,Financial_Year__c,donor__c,Student__r.Name,Student__r.FFE_ID__c,Student__r.MailingState,Student__r.Course__c,Student__r.College_Name__r.Name,Student__r.College_City__c,Student__r.College_State__c from Donor_Application_Mappings__r where Student__c!=:null and Financial_Year__c IN :finalyr) from contact where RecordTypeId=:DonorRecordType  and Email IN :emailListUnq];//Added college city & state - Sumit Gaurav - 15-July-2020
            system.debug('newList:::::'+newList); 
            
            Map<String,String> conidwithemaillist = new Map<String,String>();
            
            List<Messaging.SingleEmailMessage> emails  =  new List<Messaging.SingleEmailMessage>();
            List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
            owaList =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.US_donor_Orgwide_address Limit 1]; // form address
            
            for(Contact con : newList){
                conidwithemaillist.put(con.email,con.id);
                String DonorId = con.FFE_ID__c;
                String Name = con.Name;
                String email = con.email;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String htmlBody1 = system.label.WelcomeDonorOne+' '+con.Name+',<br/><br/>'+'Your FFEUID :'+' '+DonorId+' <br/>'+'Your Email id :'+' '+email+'<br/><br/>'+' '+EmailMsg+'<br/>';
                String htmlBody1 = system.label.WelcomeDonorOne+' '+con.Name+',<br/><br/>';
                htmlBody1 = htmlBody1 + EmailMsg;


                Set<String> studList = new Set<String>();
                String subject  = '';
                Map<string,String> financialYearTable = new Map<string,String>();
                Map<string,Integer> financialYearStudentCount = new Map<string,Integer>();// Added to keep count of students per financial year
                
                
                if(con.Donor_Application_Mappings__r.size()>0){
                    for(Donor_Application_Mapping__c dam : con.Donor_Application_Mappings__r){
                        String htmlBody2 = '';
                        String StdNAme = '';if(dam.Student__r.Name!=null)StdNAme = dam.Student__r.Name;else StdNAme =  '-';
                        String FFEID = '';if(dam.Student__r.FFE_ID__c!=null)FFEID = dam.Student__r.FFE_ID__c;else FFEID =  '-';
                        String gender ='';if(dam.Student__r.Gender__c!=null)gender = dam.Student__r.Gender__c;else gender =  '-';
                        String collegeName ='';if(dam.Student__r.College_Name__r.Name!=null)collegeName = dam.Student__r.College_Name__r.Name;else collegeName =  '-';
                        //Added College city & state -- Sumit Gaurav 15-July-2020
                        String collegeCity ='';if(dam.Student__r.College_City__c!=null)collegeCity = dam.Student__r.College_City__c;else collegeCity =  '-';
                        String collegeState='';if(dam.Student__r.College_State__c!=null)collegeState = dam.Student__r.College_State__c;else collegeState =  '-';
                        
                        String course ='';if(dam.Student__r.Course__c!=null)course = dam.Student__r.Course__c;else course =  '-';
                        String courseyearr ='';if(dam.Application__r.Year__c!=null)courseyearr=dam.Application__r.Year__c;else courseyearr='-';
                        
                        if(!financialYearTable.containsKey(dam.Financial_Year__c)){
                            Integer i=1;
                            htmlBody2 += '<table border="1" style="border-collapse: collapse;table-layout: fixed;width: 950px">';
                            htmlBody2 +='<tr><th width="50px">Sl. No.</th><th>Name</th><th>Gender</th><th>Course</th><th>Course Year</th><th>College</th><th>College City</th><th>College State</th></tr>';
                            htmlBody2 += '<tr align="center"><td>' + string.ValueOf(i) + '</td><td>' + StdNAme + '</td><td>' + gender + '</td><td>' + course + '</td><td>' + courseyearr + '</td><td>' + collegeName + '</td><td>' +collegeCity + '</td><td>' + collegeState+'</td></tr></table>';
                            financialYearTable.put(dam.Financial_Year__c,htmlBody2);
                            financialYearStudentCount.put(dam.Financial_Year__c,i);
                            studList.add(dam.Student__r.FFE_ID__c+'@@'+dam.Financial_Year__c);
                            i++;
                        }else{
                            
                            if(!studList.contains(dam.Student__r.FFE_ID__c+'@@'+dam.Financial_Year__c)){
                                Integer i=financialYearStudentCount.get(dam.Financial_Year__c);
                                String htmlBody3 = financialYearTable.get(dam.Financial_Year__c).replace('</table>','');
                                htmlBody3 += '<tr align="center"><td>' + string.ValueOf(i+1) + '</td><td>' + StdNAme + '</td><td>' + gender + '</td><td>' + course + '</td><td>' + courseyearr + '</td><td>' + collegeName + '</td><td>' +collegeCity + '</td><td>' + collegeState+'</td></tr></table>';
                                financialYearTable.put(dam.Financial_Year__c,htmlBody3);
                                financialYearStudentCount.put(dam.Financial_Year__c,i+1);
                                studList.add(dam.Student__r.FFE_ID__c+'@@'+dam.Financial_Year__c);
                            }
                        } 
                        
                    }
                    

                    integer i=0;
                    String htmlBody_new = '';
                    for(String keycheck : financialYearTable.keyset()){
                        if(i==0)
                            htmlBody_new += '<br/><b style="font-size:0.88rem;margin-bottom:10px;">Financial Year : '+keycheck+'</b>'+financialYearTable.get(keycheck);
                        else
                            htmlBody_new += '<br/><b style="font-size:0.88rem">Financial Year : '+keycheck+'</b><br/><br/>'+financialYearTable.get(keycheck);
                        
                        i=i+1;
                    }   
                    

                    
                    system.debug(htmlBody1);
                    
                    htmlBody1 = htmlBody1.replace('SWAP_WITH_TABLE',htmlBody_new);
                    string SWAP_WITH_FFEID = 'Your FFEUID :'+' '+DonorId+' <br/>'+'Your Email id :'+' '+email+'<br/><br/>';
                    htmlBody1 = htmlBody1.replace('SWAP_WITH_FFEID',SWAP_WITH_FFEID);

                    
                    mail.setHtmlBody(htmlBody1);
                    mail.setSaveAsActivity(true);
                    mail.setSubject(subjectval);
                    mail.setTargetObjectId(con.id);
                    //mail.setToAddresses(new List<String>{con.Email});
                    mail.setOrgWideEmailAddressId(owaList[0].Id);
                    //mail.setTreatTargetObjectAsRecipient(false);
                    emails.add(mail);
                }
                
            }    
            
            system.debug(emails);
            if(!emails.isEmpty()){
                Messaging.sendEmail(emails,false);
                //List<String> finalyr,String emailIds, String EmailMsg,String subjectval
                Exceptions__c exTestRec = new Exceptions__c();
                exTestRec.Class_Name__c = 'emailNotificationForUsDonorHelper';
                exTestRec.API_CalloutRequestBody__c = String.valueOf(conidwithemaillist);
                exTestRec.Error_Stack_Trace__c = String.valueOf(finalyr);
                exTestRec.Error_Message__c = string.valueOf(emailIds);
                exTestRec.Error_Type__c = string.valueOf(emailset);
                insert exTestRec;
                return 'Email sent successfully.';   
            }else{
                return 'No students data available for the selected FinancialYear. Pelase contact system admin!.';
            } 
        }
        catch(Exception e){
            HandleBusinessException.captureError('emailNotificationForUsDonorHelper', 'sendMailtodonors', e);
            return 'Someting went wrong. Please contact system admin!.';
        } 
    
    }
    
}