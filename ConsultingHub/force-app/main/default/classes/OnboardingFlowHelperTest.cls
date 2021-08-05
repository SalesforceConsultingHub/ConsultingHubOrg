@isTest 
public class OnboardingFlowHelperTest {
    static testMethod void testGetLearningFromSelectedDomains() {
       	Onboarding_Domain__c ob = new Onboarding_Domain__c();
       	ob.Name = 'testDomain';
        insert ob;
        
        Learning__c learningRecord = new Learning__c();
        learningRecord.Name = 'testLearning';
        learningRecord.Expected_Hours_to_Complete__c = 1;
        learningRecord.Priority__c = 1;
        insert learningRecord;
        
        Learning_Domain__c ld = new Learning_Domain__c();
        ld.Learning__c = learningRecord.Id;
        ld.Onboarding_Domain__c = ob.Id;
        insert ld;
        
        List<List<Onboarding_Domain__c>> selections = new List<List<Onboarding_Domain__c>> {new List<Onboarding_Domain__c>{ob}};
        
        
        Test.startTest();
        
        OnboardingFlowHelper.getLearningFromSelectedDomains(selections);
        
        Test.stopTest();
      
    }
    
    static testMethod void getAssignedModulesTest()
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
        
        List<Module__c> modulesReturned = OnboardingFlowHelper.getAssignedModules(onboard.Id);
        
        System.assertEquals(2, modulesReturned.size());
        System.assertEquals('Test 1', modulesReturned[0].Name);
        System.assertEquals('Test 2', modulesReturned[1].Name);
        System.assertEquals(1 , modulesReturned[0].Sort_Order__c);
        System.assertEquals(2 , modulesReturned[1].Sort_Order__c);
    }
    
    static testMethod void updateModulesTest()
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
        
        List<Module__c> modulesToUpdate = new List<Module__c>();
        Module__c test1Get = [Select Id, Name From Module__c Where Id =: test1.Id];
        test1Get.Name = 'Test 1 Update';
        modulesToUpdate.add(test1Get);
        
        Module__c test2Get = [Select Id, Name From Module__c Where Id =: test2.Id];
        test2Get.Name = 'Test 2 Update';
        modulesToUpdate.add(test2Get);
        
        OnboardingFlowHelper.updateModules(modulesToUpdate);
        
        Module__c test1Updated = [Select Id, Name From Module__c Where Id =: test1.Id];
		System.assertEquals('Test 1 Update', test1Updated.Name);
        
        Module__c test2Updated = [Select Id, Name From Module__c Where Id =: test2.Id];
        System.assertEquals('Test 2 Update', test2Updated.Name);
        
    }
}