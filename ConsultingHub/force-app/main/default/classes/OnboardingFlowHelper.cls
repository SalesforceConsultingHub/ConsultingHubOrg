public class OnboardingFlowHelper {
	
    @InvocableMethod(label='Query Learning Records' description='Gets learning records based on Learning Domains selected')
    public static List<List<Learning__c>> getLearningFromSelectedDomains(List<List<Onboarding_Domain__c>> selections) {
        system.debug('selections='+selections);
        List<Id> selectedOnboardingDomains = new List<Id>();
        for( Onboarding_Domain__c dom :selections[0] ) {
            if(dom != null) {
                selectedOnboardingDomains.add(dom.Id);
            }
            
        }
        System.debug('selectedOnboardingDomains='+selectedOnboardingDomains);
        
        Set<Id> associatedLearningIds = new Set<Id>();
        
        for( Learning_Domain__c ld : [	select 	Id, Learning__c, Onboarding_Domain__c 
                                      	from 	Learning_Domain__c 
                                      	where 	Onboarding_Domain__c IN :selectedOnboardingDomains] )
        {
            associatedLearningIds.add(ld.Learning__c);
        }
        
        List<Learning__c> learnings = [	select	Id, Name, Expected_Hours_to_Complete__c , Must_Complete__c  
                                       	from	Learning__c
                                      	where	Id IN :associatedLearningIds];
	
        List<List<Learning__c>> returnedLearnings = new List<List<Learning__c>>{learnings};
        System.debug(returnedLearnings);
        return returnedLearnings;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Module__c> getAssignedModules(String OnboardingId)
    {
        List<Module__c> modulesToReturn = new List<Module__c>();
        try
        {
            modulesToReturn = [Select Id, Name, Sort_Order__c, Must_Complete_By__c, Hours_Required__c 
                               From Module__c 
                               Where Onboarding__c =: OnboardingId
                               ORDER BY Sort_Order__c ASC];
        }
        catch(Exception ex)
        {
            System.debug('Exception: ' + ex);
        }
        
        return modulesToReturn;
    }
    
    @AuraEnabled
    public static void updateModules(List<Module__c> modules)
    {
        try
        {
            update modules;
        }
        catch(Exception ex)
        {
            System.debug('Exception: ' + ex);
        }
        
    }
}