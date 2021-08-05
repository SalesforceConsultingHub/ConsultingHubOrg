/**
 * @description       : Gets related IA Assets associated to a specific Engagement Activity
 * @author            : Charles Gallagher
 * @last modified on  : 05-03-2021
 * @last modified by  : Charles Gallagher
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   05-03-2021   Charles Gallagher  Initial Version
**/
public class GetRelatedIAAssets 
{
    @AuraEnabled(cacheable=true)
    public static List<ia_Asset__c> getAssets(Id engagmentActivityId)
    {
        List<ia_Asset__c> listToReturn = new List<ia_Asset__c>();
        try
        {
            //Get the Activity__c related to the engagmentActivity
            Engagement_Activity__c engagmentActivity = [Select Id, Activity__c FROM Engagement_Activity__c WHERE Id =: engagmentActivityId];

            //From the Stage Activty get all the related Stage Activity Assets and IA Asset Ids
            List<Stage_Activity_Asset__c> stageActivityAssets = [Select Id, IA_Asset__r.Id  FROM Stage_Activity_Asset__c Where Stage_Activity__c =: engagmentActivity.Activity__c];
            
            //Make a set of all the unique IA Asset Ids
            Set<Id> iaAssetIds = new Set<Id>();
                        
            for(Stage_Activity_Asset__c asset : stageActivityAssets)
            {
                iaAssetIds.add(asset.IA_Asset__r.Id);
            }

            //Gets list of related IA Assets 
            listToReturn = [Select Id, Name, Name__c, Asset_Type__c, Location__c FROM ia_Asset__c WHERE Id IN : iaAssetIds];
            
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
        return listToReturn;
        
    }
}