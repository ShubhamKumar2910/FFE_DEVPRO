/*@Author: Jayanth B
* Use: This class is used to display donor logos in record pages
*/
public class AttachmentTriggerHelper {
    
    public static void afterInsertOfAttachment(List<Attachment> attchmentList){
        try{
            Map<String,String> donorAttachmentForLogos  = new Map<String,String>();
            Map<String,String> primaryLogo              = new Map<String,String>();
            Map<String,String> secondaryLogo            = new Map<String,String>();
            
            for(Attachment attch : attchmentList){
                donorAttachmentForLogos.put(attch.ParentId,attch.id);
                
                String attachmentName = '';
                if(attch.Name.contains(system.label.Primary_logo)){
                    attachmentName = system.label.Primary_logo;
                }else if(attch.Name.contains(system.label.Secondary_Logo)){
                    attachmentName = system.label.Secondary_Logo;
                }else{
                    attachmentName = attch.Name;
                }
                
                if(attachmentName == system.label.Primary_logo){
                    primaryLogo.put(attch.ParentId+attachmentName,attch.id);   
                }
                
                if(attachmentName == system.label.Secondary_Logo){
                    secondaryLogo.put(attch.ParentId+attachmentName,attch.id);
                }
            }
            
            List<Contact> conList = [Select id,Primary_Donor_logo_attachment_Id__c,Secondary_Donor_logo_attachment_id__c from Contact where id=:donorAttachmentForLogos.keyset()];
            List<contact> updateAttachmentsIds = new List<contact>();
            
            for(Contact con : conList){
                if(con.Primary_Donor_logo_attachment_Id__c == null)
                    con.Primary_Donor_logo_attachment_Id__c = primaryLogo.get(con.id+system.label.Primary_logo);
                if(con.Secondary_Donor_logo_attachment_id__c == null)
                    con.Secondary_Donor_logo_attachment_id__c = secondaryLogo.get(con.id+system.label.Secondary_Logo);
                updateAttachmentsIds.add(con);
            }
            
            if(!updateAttachmentsIds.isEmpty()){
                update updateAttachmentsIds;
            }
        }Catch(Exception e){
            HandleBusinessException.captureError('AttachmentTriggerHelper', 'afterInsertOfAttachment', e);
            
        }
    }
    
    public static void countAttachments(list<Attachment> attList, list<Attachment> oldAttList){
        try{
            
        
        system.debug('@@@@@@@@@@@@'+attList);
        system.debug('@@@@@@@@@@@@'+oldAttList);
        
        set<id> attids = new set<id>();
        system.debug('sucsssssssssssssssssssssssssssssssssssssssssssssssss');
        if(oldAttList != null && !trigger.isupdate){
            for(Attachment att:oldAttList){
                system.debug('Parrrrrrrrrrrrrr  del list'+att);
                
                if(att.ParentId != null){
                    attids.add(att.ParentId); 
                }
            }       
            
        }
        if(attList != null){
            for(Attachment att:attList){
                system.debug('Parrrrrrrrrrrrrr'+att.ParentId);
                if(att.ParentId != null){
                    system.debug('par not null');
                    system.debug('par app');
                    
                    attids.add(att.ParentId); 
                    
                }
                
            }            
            
        }
        system.debug('@@@@@@@@@@@@'+attids);
        
        
        if(attids != null){
            list<Application__c> queryOnAppListToUpdate = [SELECT Id,Number_of_Attachments__c, (SELECT Id, Name FROM Attachments) FROM Application__c where id IN: attids];
            system.debug('111111111111111111'+queryOnAppListToUpdate);
            for(Application__c app:queryOnAppListToUpdate){
                system.debug('1111111111111');
                app.Number_of_Attachments__c = app.Attachments.size();  
                
                
            }
            
            update queryOnAppListToUpdate;    
        }
        }Catch(Exception e){
            System.debug('@@@@@@@@'+e.getMessage()+' AT '+e.getLineNumber()+ 'STACKTRACE'+e.getStackTraceString());
                         
        }
        
    }
}