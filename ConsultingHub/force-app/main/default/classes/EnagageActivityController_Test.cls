/**
02/23/2021 - VH - Test class for EngageActivityController
                  known issues - meets 85% code coverage
                               - need to import data prior to deploying apex
                               - as dependcies exist on data which could not
                               - easily be created on test class
**/
@isTest
public class EnagageActivityController_Test {

    /* TO DO soon*/
    
    @isTest
    public static void testAll() {
        
        Test.startTest();
        
        //--------------------------------------------
        //----------- initial test data setup --------
        //--------------------------------------------

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

        insert testEng;
        
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
        
        //add to Engagement Activity
        Engagement_Activity__c engAct1 = new Engagement_Activity__c();
        Engagement_Activity__c engAct2 = new Engagement_Activity__c();
        
        engAct1.Engagement__c = testEng.Id;
        engAct1.Activity__c = stageAct1.Id;
        engAct1.Status__c = 'To Do';
        
        
        insert engAct1;
        
        engAct2.Engagement__c = testEng.Id;
        engAct2.Activity__c = stageAct2.Id;
        engAct2.Status__c = 'To Do';
        
        insert engAct2;
        
        //--------------------------------------------
        //----------- fetch records test----- --------
        //--------------------------------------------

        List<Engagement_Activity__c> engActList = EnagageActivityController.fetchRecords(testEng.id);

        Test.stopTest();
        
        System.assertEquals(2, engActList.size());
        
        //--------------------------------------------
        //----------- updateStatus test --------------
        //--------------------------------------------
		
        List<Engagement_Activity__c> engActList_ind = EnagageActivityController.updateStatus(
            										testEng.id,
        											engAct1.Id,
        											'In Progress',
        											'Kickoff');
        Engagement_Activity__c afterUpdate_engActList2 = [SELECT Id,Status__c from Engagement_Activity__c
                                                          WHERE Id =: engAct1.Id
                                                         ];
        System.assertEquals('In Progress', afterUpdate_engActList2.Status__c);
        
        //--------------------------------------------
        //----------- UpdateBulkStatus test --------------
        //--------------------------------------------
        //we will work with the initial list that fetched the records i.e. engActList
        List<String> engActListString = new List<String>();
        engActListString.add(engActList[0].Id);
        engActListString.add(engActList[1].Id);
        
        List<Engagement_Activity__c> engActList_bulk = EnagageActivityController.UpdateBulkStatus(
            										testEng.id,
        											engActListString,
        											'Complete',
        											'Kickoff');
        List<Engagement_Activity__c> afterUpdate_engActList_bulk = [SELECT Id,Status__c from Engagement_Activity__c
                                                          WHERE Id =: engActListString
                                                         ];
        System.assertEquals('Complete', afterUpdate_engActList_bulk[0].Status__c );
        System.assertEquals(2, afterUpdate_engActList_bulk.size());
        
        //--------------------------------------------
        //----------- getStagePicklist test ----------
        //--------------------------------------------
        List<String> mList = EnagageActivityController.getStagePicklist(testEng.id);
		
        //may need to revist how this needs to be tested
    }

}