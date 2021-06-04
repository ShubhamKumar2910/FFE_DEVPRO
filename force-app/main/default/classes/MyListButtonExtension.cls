public with sharing class MyListButtonExtension
{
    public List<SObject> selected { get; private set; }
    public MyListButtonExtension(ApexPages.StandardSetController controller)
    {
        selected = controller.getSelected();
        String allIds = ApexPages.currentPage().getParameters().get('Id');
        System.debug('allIds'+allIds);
        //List<Mentor_Mentee_Association__c> mmaList = [SELECT Id, Name FROM Contact WHERE Id IN :controller.getSelected()];
        //System.debug('mmaList'+mmaList);
    }
}