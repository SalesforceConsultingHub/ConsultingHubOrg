/**
 * @description       : Gets related Modules associated to a specific Onboarding Record
 * @author            : Charles Gallagher
 * @last modified on  : 05-26-2021
 * @last modified by  : Charles Gallagher
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Charles Gallagher  Initial Version
**/
public class GetRelatedModules 
{
	@AuraEnabled(cacheable=true)
    public static List<Module__c> getModules(Id onboardingId)
    {
        List<Module__c> modulesToReturn = new List<Module__c>();
        try
        {
            modulesToReturn = [Select Id, Name, Status__c, Must_Complete_By__c, Hours_Required__c, Actual_Hours_Spent__c 
                               From Module__c 
                               Where Onboarding__c =: onboardingId 
                               ORDER BY Sort_Order__c ASC];
        }
        catch(Exception ex)
        {
            System.debug('Exception: ' + ex);
        }
        return modulesToReturn;
    }
}