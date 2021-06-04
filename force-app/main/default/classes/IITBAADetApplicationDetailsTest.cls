@isTest
public class IITBAADetApplicationDetailsTest {

    static testMethod void  updateMethodTest1(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/getApplicationsDetails/';
        req.httpMethod = 'POST';
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        String JsonMsg='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "32wqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034398"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        String JsonMsg1='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "32wqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg1);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        String JsonMsg2='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "eqwqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034398"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg2);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        String JsonMsg3='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID":",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "eqwqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034398"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg3);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        Contact con = new Contact(FirstName='test',LastName='one',Email='test11ew11@gmail.com',Student_ID__c='1233d',recordtypeID=Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId());
        insert con;
        Application__c app = new Application__c(Student__c=con.id,Existing_Application_ID__c='12sda',Internal_Status__c='Disbursed');
        insert app;
        
        String JsonMsg4='{"Applications": [{"Email": "'+con.Email+'","StudentUniqueID":"'+con.Student_ID__c+'",                    "FFEUID": "'+con.FFE_ID__c+'","StudentSFID": "'+con.id+'", "ExistingApplicationID": "'+app.Existing_Application_ID__c+'","ApplicationSFID": "'+app.Name+'"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034398"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg4);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        String JsonMsg5='{"Applications": [{"Email": "","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "32wqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg5);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        
        String JsonMsg6='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "32wqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg6);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        
        String JsonMsg7='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "32wqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg7);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        
        String JsonMsg8='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "", "ExistingApplicationID": "32wqeq","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg8);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        
        String JsonMsg9='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "","ApplicationSFID": "APPLN-034359"},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg9);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        
        String JsonMsg10='{"Applications": [{"Email": "jayanth.b@etmarlabs.com","StudentUniqueID": "123wqe",                    "FFEUID": "DEV-FFEUID017809","StudentSFID": "0030l00000AhTtZ", "ExistingApplicationID": "32wqeq","ApplicationSFID": ""},{    				"Email": "test1@gmail.com",                    "StudentUniqueID": "123ddd",                    "FFEUID": "DEV-FFEUID017822",               "StudentSFID": "0030l00000B9imG",                    "ExistingApplicationID": "eqwqeq",                    "ApplicationSFID": "APPLN-034359"				}				]}';
        req.requestBody = Blob.valueof(JsonMsg10);
        IITBAAGetApplicationDetails.getApplicationsStatuses();
        Test.stopTest();
    }
}