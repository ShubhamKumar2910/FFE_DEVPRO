/************************************************************************************************************
Apex ClassName - FundUtilizationController
Version - 1.0 
Created Date - 07-July-2020  
Developed By - 
Test Class - WebServiceButtonHelper_Test
Function -  The class is called from FundUtilizationDetailsInExcel VF page 
Modification Log :
-----------------------
* Developers                   Date                   Description
* ----------                  -----                  ------------------------*/
public class FundUtilizationController {
    private List <Fund_Utilization__c> fundutilizationList;
    public String conId{get;set;}
    public string financialYear{get;set;}
    public FundUtilizationController() {
        conId = Apexpages.currentpage().getparameters().get('id');
        financialYear = Apexpages.currentpage().getparameters().get('fyear');
        fundutilizationList  = [Select id,Name,Application__r.FFE_UID__c,Application__r.Student_Name_for_Email__c,Application__r.Year__c,
                                Application__r.Course__c,Application__r.Branch__c,Application__r.Amount_Requested__c,Application__r.Donor_Name__c,Business_Account_Utilization__r.Name,Business_Account_Utilization__r.Date__c,
                                Business_Account_Utilization__r.Bank_Txn_ID__c from Fund_Utilization__c Where Donor__c =:conId  AND Application__r.RPT_Financial_Year__c =: financialYear AND Application__r.Internal_Status__c = 'Disbursed'];
    }
    
    public List<Fund_Utilization__c> getFundUtilizationList(){
        return fundutilizationList;
    }
}