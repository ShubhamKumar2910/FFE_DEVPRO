public class MergeDuplicate {
    
    public static void main(){
        try{
            
            StaticResource staticResourceFile = [SELECT Id, Body FROM StaticResource WHERE Name = 'TestData' LIMIT 1];
            
            list<string> contactDataLines = new list<string>();
            
            string contactDataAsString = staticResourceFile.Body.toString();
            contactDataLines = contactDataAsString.split('\n');
            
            list<string> csvFieldNames = new list<string>();
            csvFieldNames = contactDataLines[0].split(',');
            List<String> allFFEIDs = new List<String>();
            Set<String> ffeIdSet = new Set<String>();
            
            for (Integer i = 1; i < contactDataLines.size(); i++) {
                string[] csvRecordData = contactDataLines[i].split(',');
                ffeIdSet.addAll(csvRecordData);
            }
            system.debug(ffeIdSet);
            list<contact> cont = [select name,id,FFE_ID__c,(select name,id from opportunities),(SELECT ActivityDate, Description from ActivityHistories) from contact where FFE_ID__c =:ffeIdSet];  
            system.debug(cont);
            map<string,contact> ffeidxContacts = new map<string,contact>();
            for(contact conRec:cont){
                system.debug('@@@@@@@@@@@'+conRec);
                system.debug('@@@@@@@@@@@'+conRec.opportunities);
                system.debug('@@@@@@@@@@@'+conRec.ActivityHistories);
                ffeidxContacts.put(conRec.FFE_ID__c, conRec);  
                
            }
            system.debug(ffeidxContacts);
            
            
            Map<Integer,List<Contact>> finalMapToBeProcessed = new Map<Integer,List<Contact>>();
            system.debug(finalMapToBeProcessed); 
            
            for (Integer i = 1; i < contactDataLines.size(); i++) {
                string[] csvRecordData = contactDataLines[i].split(',');
                
                List<Contact> stuRecListforthisRow = new List<Contact>();
                for(string eachFfeId:csvRecordData){
                    //system.debug('eachFfeId'+eachFfeId);
                    //system.debug('eachFfeIdvalues'+ffeidxContacts.get(eachFfeId));
                    if(ffeidxContacts.containsKey(eachFfeId))
                        stuRecListforthisRow.add(ffeidxContacts.get(eachFfeId));
                }
                system.debug('stuRecListforthisRow'+stuRecListforthisRow);
                finalMapToBeProcessed.put(i,stuRecListforthisRow);
            }
            system.debug('fffffffffffff'+finalMapToBeProcessed);
            List<Contact> conRecToDelete = new List<Contact>();
            List<Contact> recToUpdate = new List<Contact>();
            
            for(Integer key:finalMapToBeProcessed.keySet()){
                Contact conRecToUpdate;
                recToUpdate.add(conRecToUpdate);
                Integer noOfOpp = 0;
                system.debug('qqqqqqqqqqqqqqqqq');
                for(Contact con :finalMapToBeProcessed.get(key)){
                    if(noOfOpp < con.Opportunities.size()){
                        noOfOpp = con.Opportunities.size(); 
                        system.debug('@@@@@@@@@');
                        conRecToUpdate=con;  
                    }
                }
                
            }            
            system.debug(recToUpdate);
        }catch(Exception e){
            System.debug('@@@@@@@@@'+e.getMessage()+' AT '+e.getLineNumber());
        }
    }
    
}