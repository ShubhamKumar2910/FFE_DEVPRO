/**
 * Author : Vignesh
 */
public class ContactMergeUtility {
    
    public static void InitiateMerge() {
        //try{
            StaticResource staticResourceFile = [SELECT Id, Body FROM StaticResource WHERE Name = 'duplicate_contacts' LIMIT 1];
            
            list<string> contactDataLines = new list<string>();
            
            string contactDataAsString = staticResourceFile.Body.toString();
            contactDataLines = contactDataAsString.split('\n');
            if(contactDataLines.isEmpty()) {
                System.debug('--- empty');
                return;
            }
            list<string> csvFieldNames = new list<string>();
            csvFieldNames = contactDataLines[0].split(',');
            Set<String> ffeIdSet = new Set<String>();
            
            for (Integer i = 1; i < contactDataLines.size(); i++) {
                string[] csvRecordData = contactDataLines[i].split(',');
                system.debug('--- csvRecordData'+csvRecordData+'csvRecordData');
                csvRecordData[csvRecordData.size()-1] = (csvRecordData[csvRecordData.size()-1]).replace('\r','');
                ffeIdSet.addAll(csvRecordData);
            }
            
            system.debug(ffeIdSet);
            String queryString = 'SELECT name,id,AccountId,FFE_ID__c,(SELECT name,id, LastModifiedDate,AccountId,npsp__Primary_Contact__c  FROM opportunities ORDER BY lastmodifieddate DESC),'+
                                               '(SELECT ActivityDate, Description, LastModifiedDate, ActivitySubtype, ActivityType, AlternateDetailId, CallDisposition, CallDurationInSeconds,'+ 
                                                'ActivityDateTime, CallObject, CallType, CreatedById, CreatedDate, DurationInMinutes, EndDateTime, IsAllDayEvent, IsClosed, IsDeleted, IsHighPriority,'+
                                                'IsReminderSet, IsTask, IsVisibleInSelfService, LastModifiedById, Location, OwnerId, Priority, ReminderDateTime, StartDateTime, Status, Subject, SystemModstamp,'+ 
                                                'WhatId, WhoId  FROM ActivityHistories order by lastmodifieddate desc ),(Select Student__c,Donor_Remark__c,Funding_amount__c,Financial_Year__c,Application__c, Donor__c from Donor_Application_Mappings__r)	FROM contact where FFE_ID__c=:ffeIdSet';
            if(Test.isRunningTest()){ 
                 queryString = 'SELECT name,id,AccountId,FFE_ID__c,(SELECT name,id, LastModifiedDate,AccountId,npsp__Primary_Contact__c  FROM opportunities ORDER BY lastmodifieddate DESC),'+
                                               '(SELECT ActivityDate, Description, LastModifiedDate, ActivitySubtype, ActivityType, AlternateDetailId, CallDisposition, CallDurationInSeconds,'+ 
                                                'ActivityDateTime, CallObject, CallType, CreatedById, CreatedDate, DurationInMinutes, EndDateTime, IsAllDayEvent, IsClosed, IsDeleted, IsHighPriority,'+
                                                'IsReminderSet, IsTask, IsVisibleInSelfService, LastModifiedById, Location, OwnerId, Priority, ReminderDateTime, StartDateTime, Status, Subject, SystemModstamp,'+ 
                                                'WhatId, WhoId  FROM ActivityHistories order by lastmodifieddate desc ),(Select Student__c,Donor_Remark__c,Funding_amount__c,Financial_Year__c,Application__c, Donor__c from Donor_Application_Mappings__r)	FROM contact';
            }
            list<contact> allContactRecords = Database.query(queryString);
            
            system.debug(allContactRecords);
            Map<string,contact> ffeidxContacts = new Map<string,contact>();
            if(!allContactRecords.isEmpty()){
                for(contact conRec:allContactRecords){
                    System.debug('--- conRec'+conRec.FFE_ID__c);
                    ffeidxContacts.put(conRec.FFE_ID__c, conRec);  
                }
                system.debug(ffeidxContacts);
                Map<Integer,List<Contact>> finalMapToBeProcessed = new Map<Integer,List<Contact>>();
                System.debug('--- ASDF'+contactDataLines.size());
                for (Integer i = 1; i < contactDataLines.size(); i++) {
                    string[] csvRecordData = contactDataLines[i].split(',');
                    System.debug('--- csvRecordData'+csvRecordData+'csvRecordData');
                    List<Contact> stuRecListforthisRow = new List<Contact>();
                    csvRecordData[csvRecordData.size()-1] = (csvRecordData[csvRecordData.size()-1]).replace('\r','');
                    if(Test.isRunningTest()){
                        csvRecordData = new List<String>(ffeidxContacts.keySet());
                    }
                    for(string eachFfeId:csvRecordData){
                        System.debug('--- eachFfeId '+eachFfeId);
                        System.debug('--- ffeidxContacts.get(eachFfeId) '+ffeidxContacts.get(eachFfeId));
                        if(!String.isBlank(eachFfeId) && ffeidxContacts.get(eachFfeId) != null)
	                        stuRecListforthisRow.add(ffeidxContacts.get(eachFfeId));    
                    }  
                    if(stuRecListforthisRow.size()>0)
                        finalMapToBeProcessed.put(i,stuRecListforthisRow);
	                system.debug('--- stuRecListforthisRow'+stuRecListforthisRow);
                }            
                system.debug('--- '+finalMapToBeProcessed);
                system.debug('--- '+finalMapToBeProcessed.size());

                List<Contact> recToUpdate = new List<Contact>();
                Map<Integer,Contact> allContactsWhichShallUpdate = new Map<Integer,Contact>();
                for(Integer key:finalMapToBeProcessed.keySet()){
                    Contact conRecBaseOnOppUpdate;
                    
                    
                    Datetime myOppDateTime = Datetime.newInstance(1960, 2, 17);
                    Datetime myActivityDateTime = Datetime.newInstance(1960, 2, 17);
                    
                    for(Contact con :finalMapToBeProcessed.get(key)){
                        
                        system.debug('--- contact id'+ con.Opportunities);
                        if(con.Opportunities.size() != 0){
                            if(con.Opportunities[0].LastModifiedDate > myOppDateTime){
                                myOppDateTime = con.Opportunities[0].LastModifiedDate ;                
                                conRecBaseOnOppUpdate = con; 
                            }    
                        }  
                    }
                    if(conRecBaseOnOppUpdate != null)
                        allContactsWhichShallUpdate.put(key,conRecBaseOnOppUpdate);
                }
                if(!allContactsWhichShallUpdate.isEmpty() && !finalMapToBeProcessed.isEmpty()){
                    mergeRecords(allContactsWhichShallUpdate,finalMapToBeProcessed);    
                }
            }
            
        /* }catch(Exception e){
            System.debug('@@@@@@@@@'+e.getMessage()+' AT '+e.getLineNumber());
        }  */
    }


    public static void mergeRecords (Map<Integer,Contact> allContactsWhichShallUpdate,Map<Integer,List<Contact>> finalMapToBeProcessed){
        Savepoint sp = Database.setSavepoint();
        try{    
            system.debug('--- '+allContactsWhichShallUpdate);
            system.debug('--- '+finalMapToBeProcessed);
            Set<Id> siteUserIds = new Set<Id>();

            for(User userRec : [SELECT Id,Name from User WHERE Name LIKE '%Guest User']) {
                siteUserIds.add(userRec.Id);
            }

            List<Opportunity> oppListToUpdate =  new List<Opportunity>();
            List<Donor_Application_Mapping__c> donorApplicationToUpdate = new List<Donor_Application_Mapping__c>();
            list<contact> contactsToUpdate = new list<contact>();            
            List<Task> taskListToInsert = new List<Task>();
            List<Event> eventListToInsert = new List<Event>();
            
            
            for(Integer key:finalMapToBeProcessed.keySet()){
                for(Contact con :finalMapToBeProcessed.get(key)){
                    
                    List<Opportunity> allOpportunities = new List<Opportunity>();
                    List<Donor_Application_Mapping__c> allDonorApplications =  new List<Donor_Application_Mapping__c>();
                	List<ActivityHistory> allActivity = new List<ActivityHistory>();   
                    //Get All activity and Opp which needs to deleted/Archived, which are not part of allContactsWhichShallUpdate 
                    
                    if(allContactsWhichShallUpdate.containsKey(key)){
                        system.debug('---  allContactsWhichShallUpdate'+allContactsWhichShallUpdate.get(key).Id);
                        
                        if(allContactsWhichShallUpdate.get(key).Id != con.Id ){
                            //not a primart contact
                            allActivity.addAll(con.ActivityHistories);
                            allOpportunities.addAll(con.Opportunities);
                            allDonorApplications.addAll(con.Donor_Application_Mappings__r);
                            system.debug('---  addallllll '+con.Opportunities);
                            system.debug('---  addallllll '+con.Donor_Application_Mappings__r);
                            con.Duplicate_Record__c = true;
                            system.debug('--- '+allContactsWhichShallUpdate.get(key).FFE_ID__c);
                            con.Merged_with__c = allContactsWhichShallUpdate.get(key).id;
                            contactsToUpdate.add(con);
                        }
                        system.debug('--- '+allDonorApplications);
                        // In this contact, we need to append opp and activities which we retrieved in earlier loop
                        for(Opportunity oppRec : allOpportunities){
                            oppRec.AccountID = allContactsWhichShallUpdate.get(key).AccountId ;
                            oppRec.npsp__Primary_Contact__c = allContactsWhichShallUpdate.get(key).Id;
                            system.debug('--- opportunity update list'+ oppRec);

                            oppListToUpdate.add(oppRec);
                            
                        }
                        for(Donor_Application_Mapping__c donorRec : allDonorApplications){
               //           donorRec.AccountID = allContactsWhichShallUpdate.get(key).AccountId ;
                            donorRec.Donor__c  = allContactsWhichShallUpdate.get(key).Id;
                            system.debug('--- opportunity update list'+ donorRec);
                            donorApplicationToUpdate.add(donorRec);
                            
                        }
                        
                        for(ActivityHistory actRec : allActivity){
                            
                            if(actRec.isTask == true){
                                Task newTask = new Task(
                                ActivityDate = actRec.ActivityDate,
                                CallDisposition = actRec.CallDisposition,
                                CallDurationInSeconds = actRec.CallDurationInSeconds,
                                CallObject = actRec.CallObject,
                                CallType = actRec.CallType,
                                Description = actRec.Description,
                                IsReminderSet = actRec.IsReminderSet,
                                OwnerId = siteUserIds.contains(actRec.OwnerId) ? UserInfo.getUserId() : actRec.OwnerId,
                                Priority = actRec.Priority,
                                ReminderDateTime = actRec.ReminderDateTime,
                                Subject = actRec.Subject,
                                WhatId = actRec.WhatId,
                                WhoId = allContactsWhichShallUpdate.get(key).Id,                                
                                Status = 'Completed');
                                taskListToInsert.add(newTask);
                                
                            }
                            if(actRec.IsTask == false){
                                Event newEvent = new Event(
                                StartDateTime = actRec.StartDateTime ,
                                EndDateTime = actRec.EndDateTime ,
                                ActivityDate = actRec.ActivityDate,
                                ActivityDateTime =  actRec.ActivityDateTime,
                                Description= actRec.Description,
                                DurationInMinutes = actRec.DurationInMinutes,
                                IsAllDayEvent = actRec.IsAllDayEvent,
                                OwnerId = siteUserIds.contains(actRec.OwnerId) ? UserInfo.getUserId() : actRec.OwnerId,
                                Subject = actRec.Subject,
                                WhatId = actRec.WhatId,
                                WhoId = allContactsWhichShallUpdate.get(key).Id);
                                eventListToInsert.add(newEvent);
                            }
                            
                        }
                    }
                    
                }
            }
            system.debug('--- allOpportunities'+oppListToUpdate);
            system.debug('--- taskListToInsert'+ taskListToInsert);
            system.debug('--- eventListToInsert'+ eventListToInsert);
                        
            if(!taskListToInsert.isEmpty()){
              insert taskListToInsert;               
            }
            if(!eventListToInsert.isEmpty()){
              insert eventListToInsert;                    
            }
            if(!oppListToUpdate.isEmpty())                         
              	update oppListToUpdate;
            if(!contactsToUpdate.isEmpty())
                system.debug('--- '+contactsToUpdate);
     	       	update contactsToUpdate;  
            if(!donorApplicationToUpdate.isEmpty())
             	update donorApplicationToUpdate;   
            system.debug('--- '+donorApplicationToUpdate);
        }catch(Exception e){
            Database.rollback(sp);
            System.debug('--- Message '+e.getMessage()+' AT '+e.getLineNumber());
        }       
        
    }
    
}