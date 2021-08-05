/**
 * @description       : Tests GetRelatedModules
 * @author            : Charles Gallagher
 * @last modified on  : 05-26-2021
 * @last modified by  : Charles Gallagher
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Charles Gallagher  Initial Version
**/
@isTest
public class GetRelatedModulesTest 
{
	static testMethod void getModulesTest()
    {
        Onboarding__c onboard = TestDataFactory.createOnboardingRecord();
        
        Learning__c learningRecord = new Learning__c();
        learningRecord.Name = 'testLearning';
        learningRecord.Expected_Hours_to_Complete__c = 1;
        learningRecord.Priority__c = 1;
        insert learningRecord;
        
        List<Module__c> modulesToInsert = new List<Module__c>();
        
        Module__c test1 = new Module__c();
        test1.Hours_Required__c = 1;
        test1.Learning__c = learningRecord.Id;
        test1.Name = 'Test 1';
        test1.Must_Complete_By__c = Date.today();
        test1.Onboarding__c = onboard.Id;
        test1.Sort_Order__c = 1;
		modulesToInsert.add(test1);
        
        Module__c test2 = new Module__c();
        test2.Hours_Required__c = 1;
        test2.Learning__c = learningRecord.Id;
        test2.Name = 'Test 2';
        test2.Must_Complete_By__c = Date.today();
        test2.Onboarding__c = onboard.Id;
        test2.Sort_Order__c = 2;
        modulesToInsert.add(test2);
        
        insert modulesToInsert;
        
        List<Module__c> modulesReturned = GetRelatedModules.getModules(onboard.Id);
        
        System.assertEquals(2, modulesReturned.size());
        System.assertEquals('Test 1', modulesReturned[0].Name);
        System.assertEquals('Test 2', modulesReturned[1].Name);
    }
}