public class MatchProductFeaturesController {

    @AuraEnabled
    public static List<String> fetchBusinessPriorities() {
    	Set<String> businessPriorityVCMClouds = new Set<String>();
        for( Business_Priorities__c bp: [	select 		Id, Name, VCM_Clouds__c  
              								from 		Business_Priorities__c])
        {
            if(String.isNotBlank(bp.VCM_Clouds__c)) {
                businessPriorityVCMClouds.add(bp.VCM_Clouds__c.trim());
            }
        }
        List<String> businessPriorityVCMCloudsList = new List<String>();
        businessPriorityVCMCloudsList.addAll(businessPriorityVCMClouds);
        businessPriorityVCMCloudsList.sort();
        return businessPriorityVCMCloudsList;
    }
    
    
    @AuraEnabled
    public static List <String> fetchProductFeatures() {
    	return null;
    }
    
    @AuraEnabled
    public static List<Business_Priorities__c> fetchBusinessPrioritiesForSelectedCloud( String selectedVCMCloud ) {
    	
        return [ 	select		id, Name, Business_Impact__c,Business_Value_Lever__c, Business_Value_Driver__c, 
                				Strategic_Focus__c, VCM_Clouds__c
                	from 		Business_Priorities__c 
                	where 		VCM_Clouds__c = :selectedVCMCloud
               		order by	Business_Value_Lever__c, Business_Impact__c, Business_Value_Driver__c];
    }
    
    @AuraEnabled
    public static List <Product_Feature__c> matchBusinessPrioritywithProductFeature( String selectedVCMCloud, Boolean showAll ) {
        if(showAll) {
            return	[	SELECT		Id, Name, Business_Unit__c, Product_Area__c, Product_Sub_Area__c  
                     	FROM		Product_Feature__c 
                    	ORDER BY	Business_Unit__c, Product_Area__c, Product_Sub_Area__c];
        }
        else {
            String selectedVCMCloudReplaced = selectedVCMCloud.replace('/','');
    
            List<String> partialMatches = new List<String>();
            for (String fragment : selectedVCMCloudReplaced.split(' '))
            {
                if(fragment.trim().length() > 0){
                    partialMatches.add('%' + fragment + '%');
                }
                    
            }
            return	[	SELECT		Id, Name, Business_Unit__c, Product_Area__c, Product_Sub_Area__c  
                     	FROM		Product_Feature__c  
                     	WHERE		Product_Area__c 	LIKE :partialMatches
                        	OR		Business_Unit__c 	LIKE :partialMatches
                    	ORDER BY	Business_Unit__c, Product_Area__c, Product_Sub_Area__c];
        }
    }
    
    @AuraEnabled
    public static void associateBusinessPrioritywithProductFeature( List<String> selectedBusinessPrioritiesIds, List<String> selectedProductFeatureIds ) {
    	system.debug('selectedBusinessPrioritiesIds='+selectedBusinessPrioritiesIds);
        system.debug('selectedProductFeatureIds='+selectedProductFeatureIds);
        
        List<Business_Priority_Product_Features__c> junctionList = new List<Business_Priority_Product_Features__c>();
        
        for(String bpId :selectedBusinessPrioritiesIds) {
            for(String pfId :selectedProductFeatureIds) {
                junctionList.add( 
                    new Business_Priority_Product_Features__c(
                        Business_Priority__c = bpId,
                        Product_Feature__c = pfId,
                        External_Id__c = bpId + pfId 
                    )
                );
            }
        }
        
        system.debug('junctionList='+junctionList);
        if(junctionList.size() > 0) {
            upsert junctionList External_Id__c;
        }
    }
    
    @AuraEnabled
    public static List<Business_Priority_Product_Features__c> fetchExistingAssociations(String bpId) {
        
        List<Business_Priority_Product_Features__c> associationsList = [select	Id, Name, Product_Feature_Name__c, Product_Feature_Business_Unit__c,
                                                                        		Product_Feature_Product_Area__c, Product_Feature_Product_Subarea__c 
                                                                       	from	Business_Priority_Product_Features__c
                                                                       	where	Business_Priority__c = :bpId
                                                                       	order by Product_Feature_Name__c];
		return associationsList;
    }
    
}