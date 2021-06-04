/**
 * Author : Prithvi
 */
global class DeclarationFormController {
    
    public Application__c application {get;set;}
    public Boolean isError {get;set;}
    static final String EMAIL_SUCCESS = 'SUCCESS';
    static final String DECLARATION_FORM_TEMPLATE_NAME = 'Student_Declaration_Form';
    static final String ERROR_MSG = 'Something went wrong';
    static final String FILE_NAME_FORMAT = '_Student Declaration Form_FY';
    static final String DEFAULT_FILE_NAME = 'Student Declaration Form';
    public Decimal chbtTotal {get; set;}
    public DeclarationFormController() {
        isError = false;
        String applicationId = Apexpages.currentpage().getparameters().get('id');
        if(!String.isBlank(applicationId) && (applicationId instanceOf Id)) {
            application = [SELECT Id, Name, RPT_Financial_Year__c, Student__r.Name, Student__r.FFE_ID__c, Course_Name__c, College_Name__c, Calc_Total_College_Fees__c, Amount_Requested__c,
                        Calc_Average_Mess_Fees_per_month__c, Calc_Total_Hostel_Mess_Fees__c, Calc_Uniform_Expenses__c, Calc_Book_Expenses__c, Calc_Others__c, Calc_Transportation_Expenses__c FROM Application__c WHERE Id = :applicationId];
            if(application != null) {
                chbtTotal = getDecimal(application.Calc_Total_College_Fees__c) + getDecimal(application.Calc_Total_Hostel_Mess_Fees__c) + getDecimal(application.Calc_Book_Expenses__c) + getDecimal(application.Calc_Transportation_Expenses__c);
            }
        }else {
            isError = true;
        }
    }

    Webservice static String sendDeclarationEmail(string targetRecordId,String whatId){
        
        try{
            EmailTemplate emailTemplate = [Select id from EmailTemplate where Developername = :DECLARATION_FORM_TEMPLATE_NAME];
            if(emailTemplate != null) {
                if(sendEmail(targetRecordId,emailTemplate.id, whatId) == EMAIL_SUCCESS) {
                    Application__c application = new Application__c(Id = whatId, Declaration_Document_Sent__c = true);
                    update application;
                    return EMAIL_SUCCESS;
                }
            }
                
        }catch(Exception e) {
            System.debug('--- Error message: '+e.getMessage());
        }
        return null;
    }

    @RemoteAction
    public static String doUploadAttachment(String appId, String attachmentBody, String attachmentName, String attachmentId) {
        if(!String.isBlank(appId) && attachmentBody != null) {
            Attachment att = getAttachment(attachmentId);
            String newBody = '';
            if(att.Body != null) {
                newBody = EncodingUtil.base64Encode(att.Body);
            }
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            if(attachmentId == null) {
                att.Name = getFileName(appId); //attachmentName;
                att.parentId = appId;
                att.ContentType = 'application/pdf';
                att.Description = 'Uploaded for Scholar';
            }
            upsert att;
            return att.Id; 
        } else {
            return ERROR_MSG;
        }
    }

    @RemoteAction
    public static Boolean updateApplication(String appId) {
        try{
            Application__c application = new Application__c(Id = appId, Declaration_Document_Received__c = true);
            update application;
            return true;
        }catch(Exception e){
            System.debug('--- Error message: '+e.getMessage());
            return false;
        }
        
    }

    @Testvisible private static string sendEmail(string targetRecordId, String templateId, String whatId){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
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
            mail.setTargetObjectId(targetRecordId); 
            mail.setTemplateId(templateId); 
            mail.setWhatId(whatId);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            return EMAIL_SUCCESS;
        }catch(Exception ex){
            system.debug('message'+ex.getMessage());
            system.debug('line num'+ex.getLineNumber());
            return ERROR_MSG;
        }
    }
     
     
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }

    private static String getFileName(String appId) {
        if(!String.isBlank(appId)) {
            Application__c application = [SELECT Id, RPT_Financial_Year__c, Student__r.FFE_ID__c FROM Application__c WHERE Id = :appId];
            return application.Student__r.FFE_ID__c + FILE_NAME_FORMAT + application.RPT_Financial_Year__c + '.pdf';
        }
        return DEFAULT_FILE_NAME + '.pdf';
    }

    private Decimal getDecimal(Decimal value) {
        if(value != null)
            return value;
        return 0;
    }
}