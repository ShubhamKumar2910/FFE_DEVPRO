@isTest
public class SMS_service_test {

    
        public static testmethod void mailAndApproval(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            
            SMS_Service_Helper.sendSingleSMS('7829483829','hello');
            List<String> contactNumbers = new List<String>{'7829483829','8892612161'};
            SMS_Service_Helper.sendBulkSMS(contactNumbers, 'hello');
            
            System_Details__c setting = new System_Details__c();
            setting.Send_SMS__c = true;
            insert setting;
            Contact facilitator = Utility_Test.insertFacilitator('facilitator','test');
            facilitator.Phone                       = '8894898899';
            facilitator.Email                       = 'facilitatortest@gmail.com';
            facilitator.MobilePhone                 = '8878898899';
            facilitator.Google_login_ID__c          = 'facilitatortest@gmail.com';
            facilitator.Facebook_login_ID__c        = 'facilitatortestfb@fb.com';
            insert facilitator;    
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            insert student;
            Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
            app.Student__c = student.id;
            insert app;
            app.External_Status__c ='Approved';
            update app;
            student.Facilitator_Name__c =  facilitator.id;   
            update student;
            Contact donor = Utility_Test.insertNewContact('FirstName','String lastName','String Phone','jayanth@gmail.com','7829483829','donortest@gmail.com','donortest@gmail.com');
            insert donor;
            List<Contact> conList = new List<Contact>();
            conList.add(donor);
            conList.add(facilitator);
            conList.add(student); 
            
            SMS_Service_CTRL.onAfterInsert(conList);

            
            Contact student1 = Utility_Test.insertNewStudentRec('ABC','ZYX','88983298899','studentdsdstest@gmail.com','7829288975','studentasdtest@gmail.com','studenasttestfb@gmail.com',70,90,'cet','2016');
            insert student1;
            List<Contact> oldList = new List<Contact>();
            oldList.add(student1);
            student1.Facilitator_Name__c =  facilitator.id;   
            update student1;
            List<Contact> newList = new List<Contact>();
            newList.add(student1);
            
            SMS_Service_CTRL.onAfterUpdateContact(oldList,newList);
            List<String> stringList = new List<String>();
            stringList.add('7829483829');
            SMS_Service_CTRL.onAfterInsert(conList);
            SMS_Service_CTRL.send_80G_form_SMS('729483829');
            //SMS_Service_CTRL.studentsAssignedToFacilitator(stringList);
            SMS_Service_CTRL.uploadDocumentSMS('7829483829');
            SMS_Service_CTRL.scholarshipTransferredSMSToFacilitator(new List<String>{'7829483829'});
            SMS_Service_CTRL.scholarshipTransferredSMSToStudent(new List<String>{'7829483829'});
        }
        test.stopTest();
    }
}