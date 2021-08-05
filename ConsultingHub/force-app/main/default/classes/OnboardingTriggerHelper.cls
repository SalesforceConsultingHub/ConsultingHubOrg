public class OnboardingTriggerHelper {
    
    //Share onboarding records with Trailguide
    public static void shareOnboardingRecords(List<Onboarding__c> newRecords) {
        
        // Create new sharing object for the custom object Job.
        Onboarding__Share onboardingShr  = new Onboarding__Share();
        List<Onboarding__Share> onboardingShares = new List<Onboarding__Share>();
        
        for(Onboarding__c onboarding :newRecords) {
            if(onboarding.Trail_Guide__c != null) {
                onboardingShr  = new Onboarding__Share();
                // Set the ID of record being shared.
                onboardingShr.ParentId = onboarding.Id;
                
                // Set the ID of user or group being granted access.
                onboardingShr.UserOrGroupId = onboarding.Trail_Guide__c;
                
                // Set the access level.
                onboardingShr.AccessLevel = 'Edit';
                onboardingShares.add(onboardingShr);
            }
        }
        
        // Insert the sharing record and capture the save result. 
        Database.insert(onboardingShares,false);       
    }
    
}