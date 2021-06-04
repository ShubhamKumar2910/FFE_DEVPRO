/*
* @purpose		: Change the stage from 'Pledged' to 'Posted' if sum of 
* 				  GAU Allocations Amount is equal to Donation amount
*/ 
global class DonationAllocationAmtCalculation{
    
    webservice static string checkOpportunityStage(String orderno,id oppid,id contactid){
        
        SavePoint sp = Database.setSavepoint();
        try{            
            Map<id,AggregateResult> aggmap;
            List<Opportunity> opplist 	= new List<Opportunity>();
            
            opplist 					= [Select Name,id,Order_No__c,StageName,amount 
                                           From opportunity 
                                           where Payment_Order__r.Order_No__c =: orderno];
            
            integer oppsize 			= opplist.size()-1;            
            
            aggmap						= new Map<id,AggregateResult>([Select npsp__opportunity__c Id,SUM(npsp__Amount__c) gausum 
                                                                       from npsp__Allocation__c where npsp__opportunity__c IN :opplist group by npsp__opportunity__c]);
            
            for(opportunity op:opplist){
                
                if(aggmap.containsKey(op.id)){
                    
                    if((decimal)aggmap.get(op.id).get('gausum') == op.amount){
                        op.stagename	= Constants.POSTED_STAGE;
                    }
                    else{
                        if(oppid == op.Id)
                        	return 'GAU Allocation for this Donation is not completed.';
                        else
                            return 'GAU Allocation for Donation <b>('+op.Name+')</b> associated with this Order No. <b>('+op.Order_No__c+')</b> is not completed. Please complete GAU allocation for all associated donation.';
                    }
                }
                else{
                    if(oppid == op.Id)
                        return 'There is no GAU Allocation for this Donation.';
                    else
                    	return 'There is no GAU Allocation for Donation <b>('+op.Name+')</b> associated with same Order No. <b>('+op.Order_No__c+')</b>.'; 
                }
            }
            
            update opplist;
            
            string donorBalanceMsg	= DN_BalanceCalculationForDonor.donorBalanceCal(oppList, String.valueOf(contactid));
            
            if(donorBalanceMsg == Constants.ERROR_MSG){
                Database.rollback(sp);
                return Constants.ERROR_MSG;
            }
            
            if(oppsize > 1){
                return 'There are <b>'+oppsize+'</b> other donation associated with this Order No <b>('+orderno+')</b> which will also get posted.';
            }else{
                return 'Donation Posted Successfully.';
            }
        }catch(exception e){
            Database.rollback(sp);
            return Constants.ERROR_MSG;
        }
        return null;
    }
}