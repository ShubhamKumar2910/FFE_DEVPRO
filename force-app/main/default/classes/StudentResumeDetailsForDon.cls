public class StudentResumeDetailsForDon {
    
    @RemoteAction
    public static String getResumeDetails(){
        List<Attachment> resumeAttachments = [SELECT id,parentId,Description from Attachment where Description ='Student Resume Upload'];
        system.debug(resumeAttachments);
        
        Map<String,String> attachIDs = new Map<String,String>();
        for(Attachment att: resumeAttachments){
            attachIDs.put(att.parentId,att.Id);
        }

        List<contact> studentList = [Select id,FFE_ID__c,Name,MobilePhone,Email,Gender__c,X10th__c,X12th__c,Course__c,Branch_Stream__c From contact Where Id=:attachIDs.keySet() and Placement_Info__c=:'Not Placed'];
        List<studentWithAttachment> studentwithAttachmentList = new List<studentWithAttachment>();
        for(contact con : studentList){
            studentWithAttachment studentWithAtt =  new studentWithAttachment();
            studentWithAtt.stdid = con.id;
            studentWithAtt.FFEID= con.FFE_ID__c;
            studentWithAtt.Name = con.Name;
            studentWithAtt.MobilePhone = con.MobilePhone;
            studentWithAtt.Email = String.valueOf(con.Email);
            studentWithAtt.Gender = con.Gender__c;
            studentWithAtt.X10th = String.valueOf(con.X10th__c);
            studentWithAtt.X12th = String.valueOf(con.X12th__c);
            studentWithAtt.Course = con.course__c;
            studentWithAtt.Branch = con.Branch_Stream__c;
            studentWithAtt.AttachmentLink = attachIDs.get(con.id);
            studentwithAttachmentList.add(studentWithAtt);
        }system.debug(studentwithAttachmentList.size());
        return JSON.serializePretty(studentwithAttachmentList);
    }
    
    public class studentWithAttachment{
        public boolean isSelected;
        public String stdid;
        public String FFEID;
        public String Name;
        public String MobilePhone;
        public String Email;
        public String Gender;
        public String X10th;
        public String X12th;
        public String Course;
        public String Branch;
        public String AttachmentLink; 
        
        public studentWithAttachment(){
            isSelected = false;
            stdid = '';
            FFEID= '';
            Name = '';
            MobilePhone = '';
            Email = '';
            Gender = '';
            X10th = '';
            X12th = '';
            Course = '';
            Branch = '';
            AttachmentLink = '';
        }
    }
    
}