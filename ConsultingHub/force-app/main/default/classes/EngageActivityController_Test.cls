/**
02/23/2021 - VH - Test class for EngageActivityController
                  known issues - meets 91% code coverage
                               - need to import data prior to deploying apex
                               - as dependcies exist on data which could not
                               - easily be created on test class
**/
@isTest
public class EngageActivityController_Test {

    /* TO DO soon*/
    
    @isTest
    public static void testAll() {
        
        Test.startTest();
        
        //--------------------------------------------
        //----------- initial test data setup --------
        //--------------------------------------------

        
        List<RecordType> phaseIAMethod2_RT = [select developername,id from recordtype
                                              where 
                                              sObjectType ='ia_Phase__c' 
                                              and developername='IA_Method_2_0'];
        
        String IAMethod2_RT = phaseIAMethod2_RT[0].id;
                    
        //build IA Method 2.0 Engagement Type
        ia_Engagement_Type__c engType = new ia_Engagement_Type__c();
        
        engType.Name = 'IA Method 2.0';
        engType.Status__c = 'Active';
        
        insert engType;
        
        
        ia_Phase__c phase = new ia_Phase__c();
        phase.Engagement_Type__c = engType.Id;
        phase.recordTypeId = IAMethod2_RT;
        phase.Name = 'Test Phase';
        insert phase;
        
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
        stage.Stage_Sort_Order__c = 1;
        stage.Phase__c = phase.Id;
        
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

        List<Engagement_Activity__c> engActList = EngageActivityController.fetchRecords(testEng.id);

        Test.stopTest();
        
        System.assertEquals(2, engActList.size());
        
        //--------------------------------------------
        //----------- updateStatus test --------------
        //--------------------------------------------
		
        List<Engagement_Activity__c> engActList_ind = EngageActivityController.updateStatus(
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
        
        List<Engagement_Activity__c> engActList_bulk = EngageActivityController.UpdateBulkStatus(
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
        List<String> mList = EngageActivityController.getStagePicklist(testEng.id);
		
        //may need to revist how this needs to be tested
        
         //--------------------------------------------
        //----------- getCurrentStage test --------------
        //--------------------------------------------
        List<String> currentStageList = EngageActivityController.getCurrentStage(testEng.id);
        System.assertEquals('Completed', currentStageList[0] );
        
        List<Engagement_Activity__c> engActList_ind_2 = EngageActivityController.updateStatus(
            										testEng.id,
        											engAct1.Id,
        											'In Progress',
        											'Kickoff');
        currentStageList = EngageActivityController.getCurrentStage(testEng.id);
        System.assertEquals('Kickoff', currentStageList[0] );
        
        engAct1.Status__c = 'Complete';
        engAct2.Status__c = 'Skip';
        
        update engAct1;
		update engAct2;
        
        currentStageList = EngageActivityController.getCurrentStage(testEng.id);
        System.assertEquals('Completed', currentStageList[0] );
        
        engAct2.Status__c = 'Complete';
        update engAct2;

		currentStageList = EngageActivityController.getCurrentStage(testEng.id);
        System.assertEquals('Completed', currentStageList[0] );

        engAct1.Status__c = 'To Do';
        engAct2.Status__c = 'To Do';
        
        update engAct1;
		update engAct2;

        currentStageList = EngageActivityController.getCurrentStage(testEng.id);
        System.assertEquals('Not Started', currentStageList[0] );

         //--------------------------------------------
        //----------- getCurrentStage activities-------
        //--------------------------------------------
        		        
        engAct1.Status__c = 'To Do';
        //engAct2.Status__c = 'To Do';
        
        update engAct1;
		//update engAct2;
		
        Stage_Activity__c stageAct11 = new Stage_Activity__c();
        //stageAct11 = new Stage_Activity__c();
        stageAct11.Output__c='Sample output 3';
        stageAct11.Resources_and_Templates__c='Resources_and_Templates__c 3';
        stageAct11.Description__c ='Test description 3';
        stageAct11.Stage__c = stage.Id;
        insert stageAct11;
            
        //insert stageAct11; //insert second stage activity
        
        Engagement_Activity__c engAct11 = new Engagement_Activity__c();
        
        engAct11.Engagement__c = testEng.Id;
        engAct11.Activity__c = stageAct11.Id;
        engAct11.Status__c = 'To Do';
        
        insert engAct11;
        
        //calling when stage is not started
        List <Engagement_Activity__c> currAct = EngageActivityController.getCurrentStageActivities(testEng.id,currentStageList[0]);        

                //--------------------------------------------
        //----------- getNextStage activities set up -------
        //--------------------------------------------
		//build ia_Deliverable__c
        ia_Deliverable__c stage2 = new ia_Deliverable__c();
        stage2.name = 'Close';
        stage2.Stage_Sort_Order__c = 2;
        stage2.Phase__c = phase.Id;
        
        insert stage2;
        
        //build stage activities
        List<Stage_Activity__c> stageActivities_list2 = new List<Stage_Activity__c>();
        Stage_Activity__c stageAct3 = new Stage_Activity__c();
        stageAct3.Output__c='next 1';
        stageAct3.Resources_and_Templates__c='next 1';
        stageAct3.Description__c ='next Test description 1';
        stageAct3.Stage__c = stage2.Id;
        
        //insert stageAct3; //insert first stage activity
        
        Stage_Activity__c stageAct4 = new Stage_Activity__c();
        stageAct4 = new Stage_Activity__c();
        stageAct4.Output__c='next 2';
        stageAct4.Resources_and_Templates__c='next 2';
        stageAct4.Description__c ='next 2';
        stageAct4.Stage__c = stage2.Id;
        
        //insert stageAct3; //insert second stage activity
        
        stageActivities_list2.add(stageAct3);
        stageActivities_list2.add(stageAct4);
        
        insert stageActivities_list2;
        
        //add to Engagement Activity
        Engagement_Activity__c engAct_Next1 = new Engagement_Activity__c();
        Engagement_Activity__c engAct_Next2 = new Engagement_Activity__c();
        
        engAct_Next1.Engagement__c = testEng.Id;
        engAct_Next1.Activity__c = stageAct3.Id;
        engAct_Next1.Status__c = 'To Do';
        
        
        insert engAct_Next1;
        
        engAct_Next2.Engagement__c = testEng.Id;
        engAct_Next2.Activity__c = stageAct4.Id;
        engAct_Next2.Status__c = 'To Do';
        
        insert engAct_Next2;
        
        
        List<String> nextStageList0 = EngageActivityController.getNextStage(testEng.id,currentStageList[0]);
        
        List <Engagement_Activity__c> nextAct0 = EngageActivityController.getNextStageActivities(testEng.id,nextStageList0[0]);        
        
        //change status to in progress
        
        engAct1.Status__c = 'In Progress';
        //engAct2.Status__c = 'To Do';
        
        update engAct1;
        
        //calling when in progress so get the current stage again
        List<String> currentStageList2 = EngageActivityController.getCurrentStage(testEng.id);
        System.debug('before------=');
        for(String s: currentStageList2 ){
            System.debug('value------='+s);
        }
        List <Engagement_Activity__c> currAct2 = EngageActivityController.getCurrentStageActivities(testEng.id,currentStageList2[0]);        
        System.assertEquals(3, currAct2.size() );
        
 

        List<String> nextStageList = EngageActivityController.getNextStage(testEng.id,currentStageList2[0]);
        
        List <Engagement_Activity__c> nextAct = EngageActivityController.getNextStageActivities(testEng.id,nextStageList[0]);        
        
        //System.assertEquals(3, currAct2.size() );

        engAct1.Status__c = 'Complete';
        engAct2.Status__c = 'Complete';
        engAct11.Status__c = 'Complete';
        update engAct1;
        update engAct2;
        update engAct11;
        engAct_Next1.Status__c ='Complete';
        engAct_Next2.Status__c ='Complete';
        update engAct_Next1;
        update engAct_Next2;
        
        List<String> currentStageList3 = EngageActivityController.getCurrentStage(testEng.id);

        List <Engagement_Activity__c> currAct3 = EngageActivityController.getCurrentStageActivities(testEng.id,currentStageList3[0]);        
        System.assertEquals('Completed', currentStageList3[0] );
        
        List<String> nextStageList2 = EngageActivityController.getNextStage(testEng.id,currentStageList3[0]);
        
        List <Engagement_Activity__c> nextAct2 = EngageActivityController.getNextStageActivities(testEng.id,nextStageList2[0]);        
        System.assertEquals('Completed', currentStageList3[0] );
    }

}