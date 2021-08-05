@isTest
public class FeatureValueStoryControllerTest {
    @isTest static void fetchValuesTest1(){
        Test.startTest();
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        insert bp;
        Test.stopTest();
		List<String> m_list =  FeatureValueStoryController.fetchBusinessValueLevers();
        System.debug('------> fetchValuesTest1 m_list.size()='+m_list.size());
        System.assertEquals(1, m_list.size(), 'fetchBusinessValueLeversTest -> size is one');
    }
    
    @isTest static void fetchValuesTest2(){
        Test.startTest();
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        insert bp;
        Test.stopTest();
        String selectBusValueLever = 'Enhance Strategic Capabilities1';
		List<String> m_list2 =  FeatureValueStoryController.fetchBusinessImpacts(selectBusValueLever);
        System.debug('fetchValuesTest2 m_list2.size()='+m_list2.size());
        System.assertEquals(1, m_list2.size(), 'fetchBusinessImpacts -> size is one');
    }
    
	@isTest static void fetchValuesTest3(){
        Test.startTest();
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST2';
        bp2.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        insert bp;
        insert bp2;
        
        Test.stopTest();
        
        String selectBusValueLever = 'Enhance Strategic Capabilities1';
        String selectBusImpact = 'Agility & Flexibility1';
        List<Business_Priorities__c> m_bus_priorities = FeatureValueStoryController.fetchBusinessPriorities(selectBusValueLever,selectBusImpact);
        System.debug('fetchValuesTest3 m_bus_priorities.size()='+m_bus_priorities.size());
        System.assertEquals(2, m_bus_priorities.size(), 'fetchBusinessImpacts -> size is one');
        
    }
    
    @isTest static void matchBP_with_PF(){
                
        Test.startTest();
        List<String> bp_List = new List<String>();
        //add business priority
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST2';
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
        
        bp_List.add(bp.Id);
        bp_List.add(bp2.Id);
        
        //add Business_Priority_Product_Features__c
        Business_Priority_Product_Features__c bpf = new Business_Priority_Product_Features__c();
        bpf.Business_Priority__c = bp.Id ;
        bpf.Product_Feature__c = pf.Id;
        bpf.External_Id__c ='a491U0000001mg0QAAa631U0000004ZWFQA2';
        
        insert bpf;
        
        Test.stopTest();
        
        List<Business_Priority_Product_Features__c> m_BP_PF = FeatureValueStoryController.matchBusinessPrioritywithProductFeature(bp_List);
        System.debug('matchBP_with_PF m_BP_PF.size.size()='+m_BP_PF.size());
        System.assertEquals(1,m_BP_PF.size(), 'matchBP_with_PF -> size is 1');
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
        
        Boolean productMode = true;
        
        FeatureValueStoryController.addBusinessPrioritiesAndProdFeatures(bpIds,pfIds,m_engage.Id,productMode);
        List<ia_Engagement_Value__c> engValues = [select Id, Name from ia_Engagement_Value__c ];
        
        productMode = false;
        
        Engagement_Product_Feature__c m_eng_prod_feat = new Engagement_Product_Feature__c();
        m_eng_prod_feat.Product_Feature__c = pf.Id;
        //m_eng_prod_feat.Engagement__c = 'a481F0000001kuMQAQ';
        m_eng_prod_feat.Engagement__c = m_engage.Id;
        insert m_eng_prod_feat;
            
        FeatureValueStoryController.addBusinessPrioritiesAndProdFeatures(bpIds,pfIds,m_engage.Id,productMode);
        List<Engagement_Product_Feature__c> epf_Values = [select Id, Name from Engagement_Product_Feature__c ];
        
        Test.stopTest();
        
        System.debug('---> addBP_And_PF_Test engValues.size()='+engValues.size() );
        System.debug('---> addBP_And_PF_Test epf_Values.size()='+epf_Values.size() );
        
        System.assertEquals(2,engValues.size(), '11111 matchBP_with_PF engValues.size()-> size is 2');
        
    }
    
	@isTest static void fetchProdBusUnit_Test(){
                
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
        
        List<String> pf_queryList = FeatureValueStoryController.fetchProdBusUnit();
        System.debug('pf  size()='+ pf_queryList.size());
        System.assertEquals(1,pf_queryList.size(), 'fetchProdBusUnit_Test -> size is 1');
    }
    
    @isTest static void fetchProdArea_Test(){
                
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
        
        List<String> pf_queryList = FeatureValueStoryController.fetchProductArea('Service Cloud');
        System.debug('fetchProdArea ------------> size()='+ pf_queryList.size());
        System.assertEquals(1,pf_queryList.size(), 'fetchProdArea -> size is 1');
    }
    
	
    @isTest static void fetchProdFeatures_Test(){
                
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
        
        List<Product_Feature__c> pf_queryList = FeatureValueStoryController.fetchProductFeatures('Service Cloud','Knowledge');
        System.debug('fetchProdArea ------------> size()='+ pf_queryList.size());
        System.assertEquals(2,pf_queryList.size(), 'fetchProdFeatures_Test -> size is 2');
    }
    
    @isTest static void matchProductFeatureWithBusinessPriority_Test(){
                
        Test.startTest();
        List<String> bp_List = new List<String>();
        //add business priority
        Business_Priorities__c bp = new Business_Priorities__c();
        bp.Business_Impact__c = 'Agility & Flexibility1';
        bp.Business_Value_Driver__c ='TEST';
        bp.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        Business_Priorities__c bp2 = new Business_Priorities__c();
        bp2.Business_Impact__c = 'Agility & Flexibility1';
        bp2.Business_Value_Driver__c ='TEST2';
        bp2.Business_Value_Lever__c ='Enhance Strategic Capabilities1';
        
        insert bp;
        insert bp2;
        
		bp_List.add(bp.Id);
        bp_List.add(bp2.Id);

        //add product feature
        List<String> pf_List = new List<String>();
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
        
        //add Business_Priority_Product_Features__c
        Business_Priority_Product_Features__c bpf = new Business_Priority_Product_Features__c();
        bpf.Business_Priority__c = bp.Id ;
        bpf.Product_Feature__c = pf.Id;
        bpf.External_Id__c ='a491U0000001mg0QAAa631U0000004ZWFQA2';
        
        insert bpf;
        
        Test.stopTest();
        
        List<Business_Priorities__c> m_BP_PF = FeatureValueStoryController.matchProductFeatureWithBusinessPriority(pf_List);
        System.debug('<<<<<<<<------ matchProductFeatureWithBusinessPriority_Test size()='+m_BP_PF.size());
        System.assertEquals(1,m_BP_PF.size(), 'matchProductFeatureWithBusinessPriority_Test -> size is 1');
    }
}