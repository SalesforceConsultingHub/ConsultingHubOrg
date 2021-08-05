//Contains methods to create sample data for test classes
@isTest
public class TestDataFactory {

    @isTest
    public static Onboarding__c createOnboardingRecord() {
        Onboarding__c ob = new Onboarding__c();
        ob.Name = 'test';
        ob.Trail_Guide__c = UserInfo.getUserId();
        ob.Cloud__c = 'Sales';
        ob.Start_Date__c = System.today();
        ob.Expected_Completion_Date__c = System.today() + 30;
        ob.Availability_Date__c = System.today() + 30;
        insert ob;
        
        return ob;
        
    }
}