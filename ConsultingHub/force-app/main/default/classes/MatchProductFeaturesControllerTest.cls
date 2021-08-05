@isTest
public class MatchProductFeaturesControllerTest {
    
        
	@isTest static void fetchBusinessPriorities_Test(){
        Test.startTest();
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        bp.VCM_Clouds__c  = 'Platform';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST2';
        bp2.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        bp2.VCM_Clouds__c  = 'Platform';
        
        insert bp;
        insert bp2;
        
        Test.stopTest();
        
        List<String> m_bus_priorities = MatchProductFeaturesController.fetchBusinessPriorities();
        System.debug('..1-->MatchProductFeaturesControllerTest-->fetchBusinessPriorities_Test m_bus_priorities.size()='+m_bus_priorities.size());
        System.assertEquals(1, m_bus_priorities.size(), 'fetchBusinessPriorities_Test -> size is one');
        
    }
    
    	@isTest static void fetchBusinessPrioritiesForSelectedCloud_Test(){
        Test.startTest();
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        bp.VCM_Clouds__c  = 'Platform';
        bp.Strategic_Focus__c = 'Improve Operating Model';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST2';
        bp2.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        bp2.VCM_Clouds__c  = 'Platform';
        bp2.Strategic_Focus__c = 'Improve Operating Model';
            
        insert bp;
        insert bp2;
        
        Test.stopTest();
        
        List<Business_Priorities__c> m_bus_priorities = MatchProductFeaturesController.fetchBusinessPrioritiesForSelectedCloud('Platform');
        System.debug('..1-->MatchProductFeaturesControllerTest-->fetchBusinessPrioritiesForSelectedCloud_Test m_bus_priorities.size()='+m_bus_priorities.size());
        System.assertEquals(2, m_bus_priorities.size(), 'fetchBusinessPrioritiesForSelectedCloud_Test -> size is two');
        
    }
    
    @isTest static void matchBusinessPrioritywithProductFeature_Test(){
                
        Test.startTest();
        List<String> pf_List = new List<String>();

        //add product feature
        Product_Feature__c pf = new Product_Feature__c();
        pf.Business_Unit__c = 'Service Cloud';
        pf.Product_Area__c ='Knowledge';
        
        Product_Feature__c pf2 = new Product_Feature__c();
        pf2.Business_Unit__c = 'Service Cloud';
        pf2.Product_Area__c ='Knowledge';
        
        insert pf;
        insert pf2;
        
        pf_List.add(pf.Id);
        pf_List.add(pf2.Id);
        
        Test.stopTest();
        Boolean showAll = true;
        
        List<Product_Feature__c> pf_queryList = MatchProductFeaturesController.matchBusinessPrioritywithProductFeature('Service Cloud',showAll);
        System.debug('---> 1 --> matchBusinessPrioritywithProductFeature_Test ------------> size()='+ pf_queryList.size());
        System.assertEquals(2,pf_queryList.size(), 'matchBusinessPrioritywithProductFeature_Test -> size is 2');
        
        showAll = false;
        List<Product_Feature__c> pf_queryList2 = MatchProductFeaturesController.matchBusinessPrioritywithProductFeature('Service Cloud',showAll);
        System.debug('---> 1 --> matchBusinessPrioritywithProductFeature_Test ------------> size()='+ pf_queryList2.size());
        System.assertEquals(2,pf_queryList2.size(), 'matchBusinessPrioritywithProductFeature_Test -> size is 2');
    }
    
        @isTest static void addBP_And_PF_Test(){
		
        Test.startTest();
        List<String> bpIds = new List<String>();
        List<String> pfIds = new List<String>();
        
        //add business priority
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST';
        bp2.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        insert bp;
        insert bp2;
        
        //add product feature
        Product_Feature__c pf = new Product_Feature__c();
        pf.Business_Unit__c = 'Service Cloud';
        pf.Product_Area__c ='Knowledge';
        
        Product_Feature__c pf2 = new Product_Feature__c();
        pf2.Business_Unit__c = 'Service Cloud';
        pf2.Product_Area__c ='Knowledge';
        
        insert pf;
        insert pf2;
        
        bpIds.add(bp.Id);
        bpIds.add(bp2.Id);
        
        pfIds.add(pf.Id);
        pfIds.add(pf2.Id);
        
        ia_Engagement__c m_engage = new ia_Engagement__c();
        m_engage.Name = 'Testing 123';
        m_engage.Implementation_Type__c = 'New';
		m_engage.Project_Type__c = 'Customer';
        
        insert m_engage;
        
        //add Business_Priority_Product_Features__c
        Business_Priority_Product_Features__c bpf = new Business_Priority_Product_Features__c();
        bpf.Business_Priority__c = bp.Id ;
        bpf.Product_Feature__c = pf.Id;
        bpf.External_Id__c ='a491U0000001mg0QAAa631U0000004ZWFQA2';
        
        insert bpf;
                
        MatchProductFeaturesController.associateBusinessPrioritywithProductFeature(bpIds,pfIds);
        List<Business_Priority_Product_Features__c> bp_pf = [select Id, Name,Business_Priority__c,
                        									Product_Feature__c,
                        									External_Id__c 
                                                            from Business_Priority_Product_Features__c ];

		/*
		List<ia_Engagement_Value__c> engValues = [select Id, Name from ia_Engagement_Value__c ];
		
        productMode = false;
        
        Engagement_Product_Feature__c m_eng_prod_feat = new Engagement_Product_Feature__c();
        m_eng_prod_feat.Product_Feature__c = pf.Id;
        m_eng_prod_feat.Engagement__c = 'a481F0000001kuMQAQ';
        insert m_eng_prod_feat;
            
        FeatureValueStoryController.MatchProductFeaturesController(bpIds,pfIds,m_engage.Id,productMode);
        List<Engagement_Product_Feature__c> epf_Values = [select Id, Name from Engagement_Product_Feature__c ];
        */
            
        Test.stopTest();
        
        System.debug('---> addBP_And_PF_Test bp_pf.size()='+bp_pf.size() );
        
        System.assertEquals(5,bp_pf.size(), '11111 bp_pf.size()-> size is 5');
        
    }

    
	@isTest static void fetchExistingAssociations_Test(){
		
        Test.startTest();
        List<String> bpIds = new List<String>();
        List<String> pfIds = new List<String>();
        
        //add business priority
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST';
        bp2.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        insert bp;
        insert bp2;
        
        //add product feature
        Product_Feature__c pf = new Product_Feature__c();
        pf.Business_Unit__c = 'Service Cloud';
        pf.Product_Area__c ='Knowledge';
        
        Product_Feature__c pf2 = new Product_Feature__c();
        pf2.Business_Unit__c = 'Service Cloud';
        pf2.Product_Area__c ='Knowledge';
        
        insert pf;
        insert pf2;
        
        bpIds.add(bp.Id);
        bpIds.add(bp2.Id);
        
        pfIds.add(pf.Id);
        pfIds.add(pf2.Id);
        
        ia_Engagement__c m_engage = new ia_Engagement__c();
        m_engage.Name = 'Testing 123';
        m_engage.Implementation_Type__c = 'New';
		m_engage.Project_Type__c = 'Customer';
        
        insert m_engage;
        
        //add Business_Priority_Product_Features__c
        Business_Priority_Product_Features__c bpf = new Business_Priority_Product_Features__c();
        bpf.Business_Priority__c = bp.Id ;
        bpf.Product_Feature__c = pf.Id;
        bpf.External_Id__c ='a491U0000001mg0QAAa631U0000004ZWFQA2';
        
        insert bpf;
                
        List<Business_Priority_Product_Features__c> m_list = MatchProductFeaturesController.fetchExistingAssociations(bp.Id);
           
        Test.stopTest();
        
        System.debug('---> fetchExistingAssociations_Test m_list.size()='+m_list.size() );
        
        System.assertEquals(1,m_list.size(), '11111 fetchExistingAssociations_Test m_list.size()-> size is 2');
        
    }
}