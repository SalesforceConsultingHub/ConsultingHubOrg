public class FeatureValueStoryController {

    
    @AuraEnabled
    public static List<String> fetchBusinessValueLevers() {
    	Set<String> businessValueLevers = new Set<String>();
        for(Business_Priorities__c bp :[	select	id, Business_Value_Lever__c
                							from 		Business_Priorities__c ]) 
        {
        	businessValueLevers.add(bp.Business_Value_Lever__c);    
        }
        List<String> businessValueLeversList = new List<String>();
        businessValueLeversList.addAll(businessValueLevers);
        businessValueLeversList.sort();
        return businessValueLeversList;
    }
    
    
    @AuraEnabled
    public static List<String> fetchBusinessImpacts(String selectBusValueLever) {
    	Set<String> businessImpacts = new Set<String>();
        for(Business_Priorities__c bp :[	select	id, Business_Impact__c
                                        	from	Business_Priorities__c 
                                       		where 	Business_Value_Lever__c =:selectBusValueLever]) 
        {
        	businessImpacts.add(bp.Business_Impact__c);    
        }
        List<String> businessImpactsList = new List<String>();
        businessImpactsList.addAll(businessImpacts);
        businessImpactsList.sort();
        return businessImpactsList;
    }
    
    @AuraEnabled
    public static List<Business_Priorities__c> fetchBusinessPriorities( String selectBusValueLever, String selectBusImpact ) {
    	
        return [ 	select		id, Name, Business_Impact__c,Business_Value_Lever__c, Business_Value_Driver__c
                	from 		Business_Priorities__c 
                	where 		Business_Value_Lever__c = :selectBusValueLever
                		and		Business_Impact__c = :selectBusImpact
               		order by	Business_Value_Driver__c];
    }
    
    
    @AuraEnabled
    public static List <Business_Priority_Product_Features__c> matchBusinessPrioritywithProductFeature( List<String> bpIds ) {
        
        return [select	Id, Name, Product_Feature_Name__c, Product_Feature_Business_Unit__c,
               			Product_Feature_Product_Area__c, Product_Feature_Product_Subarea__c 
               from		Business_Priority_Product_Features__c
               where	Business_Priority__c IN :bpIds
               order by Product_Feature_Name__c];
    }
    
    @AuraEnabled
    public static void addBusinessPrioritiesAndProdFeatures( List<String> bpIds, List<String> pfIds, String currentEngagementId, Boolean productMode) {
       List<ia_Engagement_Value__c> engValues = new List<ia_Engagement_Value__c>();
        for(String bpId :bpIds) {
            engValues.add(
                new ia_Engagement_Value__c(
                    Value_Driver__c = bpId, 
                    Engagement__c = currentEngagementId,
                    Engagement_Value_External_Id__c	= bpId + currentEngagementId
                )
            );
        } 
        upsert engValues Engagement_Value_External_Id__c;
        
        List<Engagement_Product_Feature__c> engProdFeatures = new List<Engagement_Product_Feature__c>();
        if(productMode == false) {
            for(Business_Priority_Product_Features__c bppf : [select	Id, Product_Feature__c 
                                                               from		Business_Priority_Product_Features__c
                                                               where	Id IN :pfIds])
            {
                engProdFeatures.add(
                    new Engagement_Product_Feature__c(
                        Product_Feature__c=bppf.Product_Feature__c, 
                        Engagement__c =currentEngagementId,
                        Engagement_Product_Feature_External_Id__c= bppf.Product_Feature__c + currentEngagementId
                    )
                );
            }
        }
        else {
            for(String pfId : pfIds)
            {
                engProdFeatures.add(
                    new Engagement_Product_Feature__c(
                        Product_Feature__c=pfId, 
                        Engagement__c =currentEngagementId,
                        Engagement_Product_Feature_External_Id__c= pfId + currentEngagementId
                    )
                );
            }
        }
        
        upsert engProdFeatures Engagement_Product_Feature_External_Id__c;
    }
    
    /////////////////////////////////////////////////////////////////////////
    //
    //
    
    @AuraEnabled
    public static List<String> fetchProdBusUnit() {
    	Set<String> prodBusUnit = new Set<String>();
        for(Product_Feature__c  pf :[	select	id, Business_Unit__c 
                                     from 	Product_Feature__c  ]) 
        {
        	prodBusUnit.add(pf.Business_Unit__c);    
        }
        List<String> prodBusUnitList = new List<String>();
        prodBusUnitList.addAll(prodBusUnit);
        prodBusUnitList.sort();
        return prodBusUnitList;
    }
    
    @AuraEnabled
    public static List<String> fetchProductArea( String selectedBusUnit) {
    	Set<String> prodBusUnit = new Set<String>();
        for(Product_Feature__c  pf :[	select	id, Product_Area__c  
                                     	from 	Product_Feature__c 
                                    	where 	Business_Unit__c = :selectedBusUnit]) 
        {
        	prodBusUnit.add(pf.Product_Area__c );    
        }
        List<String> prodBusUnitList = new List<String>();
        prodBusUnitList.addAll(prodBusUnit);
        prodBusUnitList.sort();
        return prodBusUnitList;
    }
    @AuraEnabled
    public static List<Product_Feature__c> fetchProductFeatures( String selectedProdBusUnit, String selectedProdArea) {
        return [select	id, Name, Product_Sub_Area__c   
                from 	Product_Feature__c 
                where 	Business_Unit__c = :selectedProdBusUnit
                	and Product_Area__c = :selectedProdArea];
        
    }
    
    
    @AuraEnabled
    public static List <Business_Priorities__c> matchProductFeatureWithBusinessPriority( List<String> pfIds ) {
        Set<String> bpIds = new Set<String>();
        for( Business_Priority_Product_Features__c bppf:
            [	select	Id, Business_Priority__c
               	from	Business_Priority_Product_Features__c
               	where	Product_Feature__c IN :pfIds])
        {
            bpIds.add(bppf.Business_Priority__c);
        }
        
        return [ 	select		id, Name, Business_Impact__c,Business_Value_Lever__c, Business_Value_Driver__c
                	from 		Business_Priorities__c 
                	where 		Id IN:bpIds
               		order by	Business_Value_Lever__c,Business_Impact__c, Business_Value_Driver__c];
    }
    
    //VH changes 
    @AuraEnabled
    public static List<Business_Priority_Product_Features__c> fetchSuggestedAssociations(List<String> bpIds) {
        String str_bpIds ='';
        for (String varStr:bpIds){
            str_bpIds = str_bpIds + varStr +',';
        }
        System.debug('------>concatenated string of bpIds is='+str_bpIds);
        
        List<Business_Priority_Product_Features__c> associationsList = [select	Id, Name, Product_Feature_Name__c, Product_Feature_Business_Unit__c,
                                                                        		Product_Feature_Product_Area__c, Product_Feature_Product_Subarea__c 
                                                                       	from	Business_Priority_Product_Features__c
                                                                       	where	Business_Priority__c in ( :str_bpIds )
                                                                       	order by Product_Feature_Name__c];
		return associationsList;
    }
    
}