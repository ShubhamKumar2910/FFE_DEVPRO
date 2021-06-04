/************************************************************************************************************
Apex ClassName - BeneficiaryDetailController
Version - 1.0 
Created Date - 07-July-2020  
Developed By -
Test Class  - WebServiceButtonHelper_Test
Function -  The class is called from BeneficiaryDetailsInExcel VF page 
Modification Log :
-----------------------
* Developers                   Date                   Description
* ----------                  -----                  ------------------------*/
public class BeneficiaryDetailController {
    
    private List<Donor_Application_Mapping__c> donAppMapping;
    public String conId{get;set;}
    public string financialYear{get;set;}
    
    public BeneficiaryDetailController() {
        conId = Apexpages.currentpage().getparameters().get('id');
        financialYear = Apexpages.currentpage().getparameters().get('fyear');
        
        donAppMapping = [SELECT id,Donor__c,Application__r.FFE_UID__c,Application__r.Year__c,Application__r.Course_Name__c,Application__r.College_Name__c,Application__r.Branch__c,Application__r.Amount_Requested__c,Application__r.Student_Name_for_Email__c,Student__r.Gender__c,Student__r.Birthdate,Student__r.X12th__c,Student__r.Entrance_Test_Name__c,Student__r.Entrance_Test_Rank__c,Student__r.College_City__c,Student__r.College_State__c,Student__r.Father_Name__c,
                         Student__r.Father_Education__c,Student__r.Father_Occupation__c,Student__r.Mother_Name__c,Student__r.Mother_Occupation__c,Student__r.Mother_Education__c,Student__r.Annual_Family_Income__c,Student__r.MailingCity,Student__r.mailingState,Student__r.Facilitator_Name__c,Student__r.Facilitator_Name__r.Name FROM Donor_Application_Mapping__c where Donor__c=:conId AND Financial_Year__c =:financialYear AND Application__r.Internal_Status__c ='Disbursed'];
        
        
        
        
        
    }
    
    
    public List<Donor_Application_Mapping__c> getdonAppMapping(){
        
        return donAppMapping; 
        
        
    }
    
   
}