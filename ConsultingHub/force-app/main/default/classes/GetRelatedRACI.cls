/**
 * @description       : Gets related RACI records associated to a specific Engagement Activity
 * @author            : Charles Gallagher
 * @last modified on  : 05-05-2021
 * @last modified by  : Charles Gallagher
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   05-05-2021   Charles Gallagher  Initial Version
**/
public class GetRelatedRACI 
{
    @AuraEnabled(cacheable=true)
    public static List<RACI__c > getRACI(Id engagmentActivityId)
    {
        List<RACI__c> listToReturn = new List<RACI__c>();
        try
        {
            //Get the Activity__c related to the engagmentActivity
            Engagement_Activity__c engagmentActivity = [Select Id, Activity__c FROM Engagement_Activity__c WHERE Id =: engagmentActivityId];

            //From the Stage Activty get all the related Stage Activity Assets and IA Asset Ids
            listToReturn = [Select Id, RACI__c, Name, Stakeholder__r.Name FROM RACI__c  Where Activity__c =: engagmentActivity.Activity__c];
            
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());    
        }
        return listToReturn;
    }

}