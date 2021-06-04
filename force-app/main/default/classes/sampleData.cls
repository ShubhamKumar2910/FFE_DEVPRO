public class sampleData {
    
    public String studFfeId;
    public Contact con {get;set;}
    public String imageURL{get;set;}
    public String donorId{get;set;}
    public Contact donorcon {get;set;}
    public String DonatedAmt {get;set;}
    public String fyear {get;set;}
    public string logoUrl {get;set;}
    public boolean primarydonorLogoEmpty{get;set;}
    public boolean secondarydonorLogoEmpty{get;set;}
    public boolean studentpicAvailable{get;set;}
    public string schlamt{get;set;}
    
    public sampleData(){
        logoUrl = system.label.FFElogo;
        studFfeId = Apexpages.currentpage().getparameters().get('sid');
        donorId = Apexpages.currentpage().getparameters().get('donorId');
        DonatedAmt = Apexpages.currentpage().getparameters().get('donatedamount');
        fyear = Apexpages.currentpage().getparameters().get('fyear');
        schlamt = Apexpages.currentpage().getparameters().get('schamt');
        con = [SELECT Id, Name,Email,Birthdate,mailingpostalcode,mailingstreet,mailingcity,mailingstate,mailingcountry ,FFE_ID__c,Gender__c,X10th__c,X12th__c,Entrance_Test_Rank__c,Branch_Stream__c,
               Course__c,Current_year__c,College_Name__r.Name,Type__c,College_State__c,Father_Name__c,Mother_Name__c,Profile_Pic_Attachment_Id__c,
               Father_Age__c,Mother_Age__c,Father_Education__c,Mother_Education__c,Father_Occupation__c,Mother_Occupation__c,
               Annual_Family_Income__c,Parent_Address__c,Facilitator_Name__r.Name,Facilitator_Name__r.FFE_ID__c,ScholarshipAmount__c,
               Financial_year__c,College_Type__c,Entrance_Test_Name__c,(select Id,Name from Attachments where parentId =:studFfeId and Name =:'ProfilePicture' limit 1)
               FROM Contact WHERE Id=:studFfeId];//Added Entrance_Test_Name__c in query -- Sumit Gaurav 26-05-2020
        donorcon = [select id,Name,FFE_ID__c,Primary_Donor_logo_attachment_Id__c,Secondary_Donor_logo_attachment_id__c from Contact where id=:donorId];
        
        if(donorcon.Primary_Donor_logo_attachment_Id__c==null || donorcon.Primary_Donor_logo_attachment_Id__c==''){
           primarydonorLogoEmpty = false; 
        }else{
            primarydonorLogoEmpty = true;
        }
        if(donorcon.Secondary_Donor_logo_attachment_id__c==null || donorcon.Secondary_Donor_logo_attachment_id__c==''){
            secondarydonorLogoEmpty = false;
        }else{
            secondarydonorLogoEmpty = true;
        }
        
        if(con.Attachments.size()>0)
        imageURL = con.Attachments[0].Id;  
        
        if(con.Profile_Pic_Attachment_Id__c !=null && con.Profile_Pic_Attachment_Id__c!= ''){
           imageURL =  con.Profile_Pic_Attachment_Id__c;
            studentpicAvailable = true;
        }else{
            studentpicAvailable = false;
        }
        
        
        
        }
 
    
}