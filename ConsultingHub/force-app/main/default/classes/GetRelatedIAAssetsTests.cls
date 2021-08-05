/**
 * @description       : Tests for GetRelatedIAAssets
 * @author            : Charles Gallagher
 * @last modified on  : 05-04-2021
 * @last modified by  : Charles Gallagher
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   05-04-2021   Charles Gallagher  Initial Version
**/

@isTest
public class GetRelatedIAAssetsTests {

    @isTest(SeeAllData=true)
    static void testGettingAssets()
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

        //Create an IA Asset to test with 
        ia_Asset__c asset = new ia_Asset__c();
        asset.Name__c = 'Test';
        asset.Asset_Type__c = 'Site';
        asset.Language__c = 'English';
        asset.Location__c = 'http://pages.test.salesforce.com/test/test';
        asset.Status__c = 'New';
        
        insert asset;
        
        //Create Stage_Activity_Asset__c
        Stage_Activity_Asset__c stageAsset = new Stage_Activity_Asset__c();
		stageAsset.IA_Asset__c = asset.Id;
		stageAsset.Stage_Activity__c = ea.Activity__c;
        insert stageAsset;
        
        //Run getAssets
        Test.startTest();
        
        List<ia_Asset__c> returnedAssets = GetRelatedIAAssets.getAssets(ea.Id);
        
        Test.stopTest();
        
        ia_Asset__c iaToCheckAgainst;
        
        for(ia_Asset__c temp : returnedAssets)
        {
            if(temp.Id == asset.Id)
            {
                iaToCheckAgainst = temp;
            }
        }
        
        System.assertEquals(asset.Name__c, iaToCheckAgainst.Name__c);
        System.assertEquals(asset.Asset_Type__c, iaToCheckAgainst.Asset_Type__c);
        System.assertEquals(asset.Location__c, iaToCheckAgainst.Location__c);
    }
}