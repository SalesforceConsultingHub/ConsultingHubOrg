/**
02/23/2021 - VH - Test class for EngageActivityTrigger
                  Code coverage is 100%

**/
@isTest
public class EngagementTrigger_Test {
    
        //--------------------------------------------
        //----------- initial test data setup --------
        //--------------------------------------------

    @isTest
    public static void testInsertUpdate() {
        //build IA Method 2.0 Engagement Type
        ia_Engagement_Type__c engType = new ia_Engagement_Type__c();
        
        engType.Name = 'IA Method 2.0';
        engType.Status__c = 'Active';
        
        insert engType;
        
        //build Engagement
        ia_Engagement__c testEng = new ia_Engagement__c();
        testEng.Name = 'Testing 123';
        testEng.Implementation_Type__c = 'New';
        testEng.Project_Type__c = 'Customer';
        testEng.Status__c = 'Scheduled';
        testEng.Engagement_Type__c = engType.Id;

		//build ia_Deliverable__c
        ia_Deliverable__c stage = new ia_Deliverable__c();
        stage.name = 'Kickoff';
        
        insert stage;
        //build stage activities
        List<Stage_Activity__c> stageActivities_list = new List<Stage_Activity__c>();
        Stage_Activity__c stageAct1 = new Stage_Activity__c();
        stageAct1.Output__c='Sample output 1';
        stageAct1.Resources_and_Templates__c='Resources_and_Templates__c 1';
        stageAct1.Description__c ='Test description 1';
        stageAct1.Stage__c = stage.Id;
        
        insert stageAct1; //insert first stage activity
        
        Stage_Activity__c stageAct2 = new Stage_Activity__c();
        stageAct2 = new Stage_Activity__c();
        stageAct2.Output__c='Sample output 2';
        stageAct2.Resources_and_Templates__c='Resources_and_Templates__c 2';
        stageAct2.Description__c ='Test description 2';
        stageAct2.Stage__c = stage.Id;
        
        insert stageAct2; //insert second stage activity
        
        Test.startTest();
        Database.insert(testEng);
        List<Engagement_Activity__c> engActList = [select Id from Engagement_Activity__c
                                                  where Engagement__c=: testEng.id];
        System.assertEquals(2, engActList.size());
        Test.stopTest();
        
    }

    @isTest
    public static void testUpdate() {
        //build IA Method 2.0 Engagement Type
        ia_Engagement_Type__c engType = new ia_Engagement_Type__c();
        
        engType.Name = 'IA Method 2.0';
        engType.Status__c = 'Active';
        
        insert engType;
        
        //build Engagement
        ia_Engagement__c testEng = new ia_Engagement__c();
        testEng.Name = 'Testing 123';
        testEng.Implementation_Type__c = 'New';
        testEng.Project_Type__c = 'Customer';
        testEng.Status__c = 'Scheduled';
        //testEng.Engagement_Type__c = engType.Id;

		//build ia_Deliverable__c
        ia_Deliverable__c stage = new ia_Deliverable__c();
        stage.name = 'Kickoff';
        
        insert stage;
        //build stage activities
        List<Stage_Activity__c> stageActivities_list = new List<Stage_Activity__c>();
        Stage_Activity__c stageAct1 = new Stage_Activity__c();
        stageAct1.Output__c='Sample output 1';
        stageAct1.Resources_and_Templates__c='Resources_and_Templates__c 1';
        stageAct1.Description__c ='Test description 1';
        stageAct1.Stage__c = stage.Id;
        
        insert stageAct1; //insert first stage activity
        
        Stage_Activity__c stageAct2 = new Stage_Activity__c();
        stageAct2 = new Stage_Activity__c();
        stageAct2.Output__c='Sample output 2';
        stageAct2.Resources_and_Templates__c='Resources_and_Templates__c 2';
        stageAct2.Description__c ='Test description 2';
        stageAct2.Stage__c = stage.Id;
        
        insert stageAct2; //insert second stage activity
        
        Test.startTest();
        Database.insert(testEng);
        List<Engagement_Activity__c> engActList = [select Id from Engagement_Activity__c
                                                  where Engagement__c=: testEng.id];
        System.assertEquals(0, engActList.size());
        
        testEng.Engagement_Type__c = engType.Id;
        Database.update(testEng);
        List<Engagement_Activity__c> engActList2 = [select Id from Engagement_Activity__c
                                                  where Engagement__c=: testEng.id];
        System.assertEquals(2, engActList2.size());
        Test.stopTest();
        
    }

}