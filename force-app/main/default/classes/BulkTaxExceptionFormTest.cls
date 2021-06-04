@isTest
public class BulkTaxExceptionFormTest {
    
    public static testmethod void execute(){
        
        Opportunity opp = new Opportunity(StageName='Posted',Name='Engineering - Scholar', CloseDate =System.today()+6);
        insert opp;
        
        Contributor__c contrb = new Contributor__c(Donation_Amount__c=1000,Donation__c=opp.id);
        insert contrb;
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(contrb);
        PageReference pageRef2 = Page.TransferFunds;
        pageRef2.getParameters().put('Id', contrb.Id);
        Test.setCurrentPage(pageRef2);
        BulkTaxExceptionForm dfT2 = new BulkTaxExceptionForm(sc2);
        dfT2.getmyimageurl();
        
    }
}