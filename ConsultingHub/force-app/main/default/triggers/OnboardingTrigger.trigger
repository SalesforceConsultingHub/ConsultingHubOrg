trigger OnboardingTrigger on Onboarding__c (after insert) {

    if(trigger.isInsert && trigger.isAfter) {
        OnboardingTriggerHelper.shareOnboardingRecords(trigger.new);
    }
}