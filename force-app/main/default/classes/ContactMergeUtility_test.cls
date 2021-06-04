@isTest
public class ContactMergeUtility_test {
    
    @isTest static void myTest() {
        Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
        Contact donor2   = Utility_Test.insertNewContact('dummy', 'Record', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
        contact student  = Utility_Test.insertSingleStudent('dummy','student');
        List<Contact> conList = new List<Contact> {donor,donor2,student};
        insert(conList);
        
        system.debug(donor);
        Opportunity opp = new Opportunity(StageName='Posted',Name='Engineering - Scholar', CloseDate =System.today()+6, contactId = donor.id );
        Opportunity opp2 = new Opportunity(StageName='Posted',Name='Medical - Scholar', CloseDate =System.today()+6, contactId = donor2.id );
        
        Application__c newApplication = Utility_Test.insertNewApplication('Submitted','Eligible');
        newApplication.Student__c = student.Id;
        insert newApplication;
        
		Donor_Application_Mapping__c donorApplication = new Donor_Application_Mapping__c();
        	donorApplication.Donor__c = donor2.Id;
        	donorApplication.Application__c = newApplication.id;
        	donorApplication.Student__c = student.Id;
        insert donorApplication;
        
        
        Event newEvent = new Event(
            StartDateTime = Date.newInstance(2020, 2, 17),
            EndDateTime = Date.newInstance(2020, 2, 18) ,
            Subject = 'Test',
            WhatId = donor.AccountId,
            WhoId = donor2.Id);
        Task newTask = new Task(
            Subject = 'Test Data',
            WhatId = donor.AccountId,
            Priority = 'Normal',
            WhoId = donor2.Id,                                
            Status = 'Completed');
        insert newTask;
        insert newEvent;
        List<Opportunity> oppList = new List<Opportunity> {opp, opp2};
		insert oppList;
        
        opportunity opportunities = [select name, id from opportunity where name='Engineering - Scholar' limit 1];
        system.debug('opportunities@@@@@@@@@@@@@@@@@@@@@@'+opportunities);
        opportunities.name = 'Engineer - Scholar';
        update opportunities;
        
        
        system.debug(opportunities);
        System.debug('@@@@@@'+donor.Opportunities);
        System.debug('@@@@@@'+donor2.Opportunities);
        list<contact> allContactRecords = [SELECT name,id,AccountId,FFE_ID__c,(SELECT name,id, LastModifiedDate,AccountId,npsp__Primary_Contact__c  FROM opportunities ORDER BY lastmodifieddate DESC),
                                           (SELECT ActivityDate, Description, LastModifiedDate, ActivitySubtype, ActivityType, AlternateDetailId, CallDisposition, CallDurationInSeconds, 
                                            ActivityDateTime, CallObject, CallType, CreatedById, CreatedDate, DurationInMinutes, EndDateTime, IsAllDayEvent, IsClosed, IsDeleted, IsHighPriority, 
                                            IsReminderSet, IsTask, IsVisibleInSelfService, LastModifiedById, Location, OwnerId, Priority, ReminderDateTime, StartDateTime, Status, Subject, SystemModstamp, 
                                            WhatId, WhoId  FROM ActivityHistories order by lastmodifieddate desc ) FROM contact];
       
        ContactMergeUtility.InitiateMerge();
    }
}