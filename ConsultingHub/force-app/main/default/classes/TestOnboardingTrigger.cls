@isTest
//Test class for OnboardingTrigger and the helper
public class TestOnboardingTrigger {
    
    @isTest
    static void testOnboardingTrigger() {
        
        Test.startTest();
        //insert onboarding record to invoke the trigger
        Onboarding__c ob = TestDataFactory.createOnboardingRecord();
        Test.stopTest();
        
        
    }


}