public class FFE_OpportunityTriggerHandler
{
    static Id ID_opportunityDonationRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
    //@Future
    /*public static void updateDonationType(List<Id> listOpportunityIds)
    {
        List<Opportunity> listNewOpportunities = [SELECT
            Id, 
            RecordTypeId, 
            npsp__Primary_Contact__c, 
            createdDate
        FROM
            Opportunity
        WHERE
            Id in: listOpportunityIds];
        Map<Id, Set<string>> mapDonorAndDonationYears = new  Map<Id, Set<string>>();
        Set<Id> setDonorIds = new  Set<Id>();
        for(Opportunity objOpp: listNewOpportunities)
        {
            if(objOpp.recordTypeId == ID_opportunityDonationRecordType)
            {
                setDonorIds.add(objOpp.npsp__Primary_Contact__c);
            }
        }
        Integer year = Date.today().year();
        if(Test.isRunningTest())
        {
            year = year + 1;
        }
        List<Opportunity> listExistingDonations = [SELECT
            Id, 
            npsp__Primary_Contact__c, 
            createdDate, 
            RecordTypeId
        FROM
            Opportunity
        WHERE
            recordTypeId = : ID_opportunityDonationRecordType AND npsp__Primary_Contact__c in: setDonorIds AND Id not in: TRIGGER.NEW AND CALENDAR_YEAR(CreatedDate) <: year];
        for(Opportunity objOpp: listExistingDonations)
        {
            if(!listOpportunityIds.contains(objOpp.Id))
            {
                if(mapDonorAndDonationYears != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c) != null)
                {
                    Set<string> setYears = mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c);
                    string strCreatedDate = string.valueOf(objOpp.createdDate);
                    strCreatedDate = strCreatedDate.subString(0, 4);
                    setYears.add(strCreatedDate);
                    mapDonorAndDonationYears.put(objOpp.npsp__Primary_Contact__c, setYears);
                }
                else
                {
                    Set<string> setYears = new  Set<string>();
                    string strCreatedDate = string.valueOf(objOpp.createdDate);
                    strCreatedDate = strCreatedDate.subString(0, 4);
                    setYears.add(strCreatedDate);
                    mapDonorAndDonationYears.put(objOpp.npsp__Primary_Contact__c, setYears);
                }
            }
        }
        List<Opportunity> listOppToUpdate = new  List<Opportunity>();
        for(Opportunity objOpp: listNewOpportunities)
        {
            if(objOpp.recordTypeId == ID_opportunityDonationRecordType)
            {
                string strCreatedDate = string.valueOf(objOpp.createdDate);
                strCreatedDate = strCreatedDate.subString(0, 4);
                // if(mapDonorAndDonationYears != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c) != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c).contains(strCreatedDate))
                if(mapDonorAndDonationYears != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c) != null)
                {
                    objOpp.Type = 'Existing Funding';
                }
                else
                {
                    objOpp.Type = 'New Funding';
                }
                listOppToUpdate.add(objOpp);
            }
        }
        if(listOppToUpdate != null && listOppToUpdate.size() > 0)
        {
            Update listOppToUpdate;
        }
    }*/


    public static void updateDonationType(List<Id> listOpportunityIds)
    {
        Set<Id> setDonorIds = new  Set<Id>();
        Set<Opportunity> listOppToUpdate = new  Set<Opportunity>();
        List<Opportunity> listNewOpportunities = [SELECT
            Id, 
            RecordTypeId, 
            npsp__Primary_Contact__c, 
            createdDate, 
            Actual_FY__c
        FROM
            Opportunity
        WHERE
            Id in: listOpportunityIds AND recordTypeId = : ID_opportunityDonationRecordType];

        Map<Id, Set<string>> mapDonorAndFinancialYears = new  Map<Id, Set<string>>();

        for(Opportunity objNewOpp: listNewOpportunities)
        {
            setDonorIds.add(objNewOpp.npsp__Primary_Contact__c);
        }
        List<Opportunity> listExistingDonations = [SELECT
            Id, 
            npsp__Primary_Contact__c, 
            createdDate, 
            RecordTypeId, 
            Actual_FY__c
        FROM
            Opportunity
        WHERE
            recordTypeId = : ID_opportunityDonationRecordType AND npsp__Primary_Contact__c in: setDonorIds AND Id NOT IN: listOpportunityIds];
        for(Opportunity objExisOpp: listExistingDonations)
        {
            if(mapDonorAndFinancialYears != null && mapDonorAndFinancialYears.get(objExisOpp.npsp__Primary_Contact__c) != null)
            {
                Set<string> setYears = mapDonorAndFinancialYears.get(objExisOpp.npsp__Primary_Contact__c);
                setYears.add(String.valueOf(objExisOpp.Actual_FY__c));
                mapDonorAndFinancialYears.put(objExisOpp.npsp__Primary_Contact__c, setYears);
            }
            else
            {
                Set<string> setYears = new  Set<string>();
                setYears.add(String.valueOf(objExisOpp.Actual_FY__c));
                mapDonorAndFinancialYears.put(objExisOpp.npsp__Primary_Contact__c, setYears);
            }
        }
            for(Opportunity objNewOpp: listNewOpportunities)
            {
                objNewOpp.Type = 'New Funding';
                if(mapDonorAndFinancialYears != null && mapDonorAndFinancialYears.get(objNewOpp.npsp__Primary_Contact__c) != null)
                {
                    Set<string> setYears = mapDonorAndFinancialYears.get(objNewOpp.npsp__Primary_Contact__c);
                    for(string financialYear: setYears)
                    {
                        if(String.valueOf(objNewOpp.Actual_FY__c) != financialYear)
                        {
                            objNewOpp.Type = 'Existing Funding';
                            break;
                        }
                    }
                }
                listOppToUpdate.add(objNewOpp);
            }
            
        
        if(listOppToUpdate != null && listOppToUpdate.size() > 0)
            {
                List<Opportunity> listOppToUpdate_n = new List<Opportunity>(listOppToUpdate);

                Update listOppToUpdate_n;
            }
    }
    public static void updatePaymentOrderDonationStage(List<Id> listPaymentOrderIds)
    {
        List<Payment_Order__c> listPaymentOrder = [SELECT
            Id, 
            Donation_Stage__c
        FROM
            Payment_Order__c
        WHERE
            Id in: listPaymentOrderIds];
        for(Payment_Order__c objPaymentOrder: listPaymentOrder)
        {
            objPaymentOrder.Donation_Stage__c = 'Posted';
        }
        if(listPaymentOrder != null && listPaymentOrder.size() > 0)
        {
            Update listPaymentOrder;
        }
    }
}