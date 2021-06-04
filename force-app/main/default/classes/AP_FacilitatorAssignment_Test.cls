/* Description :Facilitator-Student Mapping              
*  purpose     :Test class for Facilitator Assignment
*/

@isTest
private class AP_FacilitatorAssignment_Test {
    
    
    /* Test Method 1 */
    static testmethod void getStudentFacilitators_1(){
        
        User testUser = Utility_Test.createUser('facilitatorAssignment@testuser.com');
        System.runAs(testUser){
            Test.startTest();
            
            //Insert state and city
            State_City_Master__c stateCity   = new State_City_Master__c();
            stateCity.State__c               = 'Karnataka';
            stateCity.City__c                = 'Bangalore';
            
            insert stateCity;
            
            //Insert Student Contact
            Contact ct         = Utility_Test.insertNewStudentRec('sample','sample1','1234567897','sample@gmail.com','3456789321','','sample1@gmail.com',80,100,'Karnataka Common Entrance Test (CET)','2016');
            ct.MailingState    = 'Karnataka';
            ct.MailingCity     = 'Bangalore';
            
            insert ct;            
            //Insert Facilitator Contact
            Contact facCt      = Utility_Test.insertFacilitator('abc','xyz');
            
            insert facCt;
            
            Application__c app               = new Application__c();
            app.Student__c                   = ct.Id;
            app.Application_Stage__c         = 'Active';
            app.Internal_Status__c           = 'Selected';
            
            insert app;
            
            AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper wrap             = new AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper();
            List<AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper> wrapList   = new List<AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper>();
            wrap.studentId                                                           = ct.id;
            wrap.facilitatorId                                                       = facCt.Id;
            
            wrapList.add(wrap);
            
            AP_FacilitatorAssignment_CTRL facCont                                    = new AP_FacilitatorAssignment_CTRL();
            
            AP_FacilitatorAssignment_CTRL.getCities('Karnataka');
            AP_FacilitatorAssignment_CTRL.getStudentDetails('Karnataka','Bangalore','current');
            AP_FacilitatorAssignment_CTRL.getFacilitatorDetails('Karnataka','Bangalore');
            AP_FacilitatorAssignment_CTRL.createFacilitatorMapping(wrapList);
            
            Test.stopTest();
        }       
    }
    
    static testmethod void testFacilitatorLoad(){
        User testUser = Utility_Test.createUser('facilitatorAssignment@testuser.com');
        System.runAs(testUser){
            List<Contact> dummyFaclitators  = new List<Contact>();
            dummyFaclitators.add(Utility_Test.insertFacilitator('dummy','Facilitator'));            
            dummyFaclitators.add(Utility_Test.insertFacilitator('dummy','Facilitator2'));  
             
            insert dummyFaclitators;
            
            List<Contact> dummyStudents =  new List<Contact>();
            for(integer i= 0; i<10;i++){
                Contact dummy   = Utility_Test.insertNewStudentRec('dummy','Student'+i,'1234567897'+i,'sample@gmail.com'+i,'3456789321'+i,'','sample1@gmail.com'+i,80,100,'Karnataka Common Entrance Test (CET)','2016');
                if(i<6){
                    dummy.Facilitator_Name__c   = dummyFaclitators[0].Id;
                }else{
                    dummy.Facilitator_Name__c   = dummyFaclitators[1].Id;
                }
                
                dummyStudents.add(dummy);
            }        
            insert dummyStudents;
            
            List<Application__c> dummyApplns    =  new List<Application__c>();
            for(Contact c : dummyStudents){
                Application__c app          = Utility_Test.insertNewApplication('Selected','Under Review');
                app.Application_Stage__c    = Constants.ACTIVE_APPLICATION;
                app.Student__c              = c.Id;
                dummyApplns.add(app);
            }
            insert dummyApplns;
            
            Test.startTest();
            AP_FacilitatorAssignment_Helper.studentCountForFacilitator(new Set<String>{dummyFaclitators[0].Id,dummyFaclitators[1].Id});  
            Test.stopTest();
            
            String facilitiatorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
            String StudentRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();

            system.assertEquals(2, [Select count() from Contact where RecordTypeId=:facilitiatorRecordType], 'Total facilitator count');
            system.assertEquals(10, [Select count() from Contact where RecordTypeId=:StudentRecordType], 'Total Student count');
        }
    }
    
    static testmethod void testFacilitatorLoad2(){
        User testUser = Utility_Test.createUser('facilitatorAssignment@testuser.com');
        System.runAs(testUser){
            Contact dummyFaclitator      = Utility_Test.insertFacilitator('dummy','Facilitator');            
            insert dummyFaclitator;
                                    
            List<Contact> dummyStudents =  new List<Contact>();
            for(integer i= 0; i<10;i++){
                Contact dummy   = Utility_Test.insertNewStudentRec('dummy','Student'+i,'1234567897'+i,'sample@gmail.com'+i,'3456789321'+i,'','sample1@gmail.com'+i,80,100,'Karnataka Common Entrance Test (CET)','2016');
                dummy.Facilitator_Name__c   = dummyFaclitator.Id;
                dummyStudents.add(dummy);
            }        
            insert dummyStudents;
            
            List<Application__c> dummyApplns    =  new List<Application__c>();
            for(Contact c : dummyStudents){
                Application__c app          = Utility_Test.insertNewApplication('Selected','Under Review');
                app.Student__c              = c.Id;
                dummyApplns.add(app);
            }
            insert dummyApplns;
            
            Test.startTest();            
            AP_FacilitatorAssignment_Helper.studentCountForFacilitator(new Set<String>{dummyFaclitator.Id});
            Test.stopTest();
            
            String facilitiatorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
            String StudentRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            String applicationRecordType   = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.SCHOLARSHIP_APPLICATION).getRecordTypeId(); 

            system.assertEquals(1, [Select count() from Contact where RecordTypeId=:facilitiatorRecordType], 'Total facilitator count');
            system.assertEquals(10, [Select count() from Contact where RecordTypeId=:StudentRecordType], 'Total student count');
            system.assertEquals(10, [Select count() from Application__c where RecordTypeId=:applicationRecordType], 'Total Application count');
        }
    }
    
     static testmethod void testNegativeScrenario(){
        User testUser = Utility_Test.createUser('facilitatorAssignment@testuser.com');
         System.runAs(testUser){
             Test.startTest();
             
             AP_FacilitatorAssignment_Helper.createFacilitatorMapping(new List<AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper>());
             
             
             Test.stopTest();
        }
     }
}