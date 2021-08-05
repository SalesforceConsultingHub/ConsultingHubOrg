/**
 * @description       : Tests for GetRelatedRACI
 * @author            : Charles Gallagher
 * @last modified on  : 05-05-2021
 * @last modified by  : Charles Gallagher
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   05-05-2021   Charles Gallagher  Initial Version
**/

@isTest
public class GetRelatedRACITest 
{
    @isTest(SeeAllData=true)
    static void testGettingRACI()
    {
        //Dependant on there being an IA Method 2.0 Type because this type has further automation attached to it on the 
        //Engagement Trigger
        ia_Engagement_Type__c engagementType = [Select Id From ia_Engagement_Type__c Where Name = 'IA Method 2.0' Limit 1];
        
        //Create test ia_Engagement__c 
        ia_Engagement__c testEngagement = new ia_Engagement__c();
        testEngagement.Name = 'Test Engagement';
        testEngagement.Implementation_Type__c = 'New';
        testEngagement.Project_Type__c = 'Customer';
        testEngagement.Status__c = 'Scheduled';
        testEngagement.Engagement_Type__c = engagementType.Id;
        
        insert testEngagement;
        
        //Get related Engagement_Activity__c and Stage activity
        Engagement_Activity__c ea = [Select Id, Activity__c From Engagement_Activity__c Where Engagement__c =: testEngagement.Id Limit 1];
        
        //Create Stake Holder
        Stakeholder__c stakeHolder = new Stakeholder__c();
        stakeHolder.Name = 'Test';
        insert stakeHolder;
        
        //Create RACI
        RACI__c raci = new RACI__c();
        raci.Activity__c = ea.Activity__c;
        raci.Stakeholder__c = stakeHolder.Id;
        raci.RACI__c = 'R - Responsible';
        insert raci;
        
        Test.startTest();
        
        List<RACI__c> returnedRACI = GetRelatedRACI.getRACI(ea.Id);
                
        Test.stopTest();
        
        RACI__c chosenRACI = [Select Id, Name, Stakeholder__c, RACI__c FROM RACI__c WHERE Id =: raci.Id];
        RACI__c raciToCheckAgainst;
        
        for(RACI__c temp : returnedRACI)
        {
            if(temp.Id == raci.Id)
            {
                raciToCheckAgainst = temp;
            }
        }

        System.assertEquals(chosenRACI.Name, raciToCheckAgainst.Name);
        System.assertEquals(chosenRACI.Stakeholder__c, raciToCheckAgainst.Stakeholder__c);
        System.assertEquals(chosenRACI.RACI__c, raciToCheckAgainst.RACI__c);
    }

}