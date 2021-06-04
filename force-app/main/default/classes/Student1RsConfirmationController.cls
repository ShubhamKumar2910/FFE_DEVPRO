public class Student1RsConfirmationController {
    public void yesResponse()
    {
        Application__c objApp  = new Application__c();
        objApp.Id = apexpages.currentpage().getparameters().get('Id');
        objApp.Student_Confirmation_on_Receipt__c = true;
        objApp.Date_of_Student_Confirmation__c = Date.Today();
        update objApp;
    }
    public void NoResponse()
    {
        Application__c objApp  = new Application__c();
        objApp.Id = apexpages.currentpage().getparameters().get('Id');
        objApp.Student_Confirmation_on_Receipt__c = false;
        objApp.Date_of_Student_Confirmation__c = Date.Today();
        update objApp;
    }
}