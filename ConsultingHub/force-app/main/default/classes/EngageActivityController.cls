/**
12/29/2020 - VH - This class is used by the EngageActivityComponent.
				  It provides methods to:
				  	- Display all the Engagement Activities (EA) tied to
					  a specific Engagement record
					- Updates the status of each EA or as a bulk
				  	- Gets all the Stages (distinct) of the engagement activities so as to
					  provide the User a filter
**/

public class EngageActivityController {

    @AuraEnabled
    public static List <Engagement_Activity__c> fetchRecords(String p_recordId) {
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        engActList = [SELECT Id,Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                      from Engagement_Activity__c 
                      where Engagement__c =: p_recordId
                      order by Stage_Sort_Order_Formula__c
                     ];
        
        return engActList;
    }

    /**
    12/29/2020 - VH - This method Updates the status of each Eng. Act.
					  based on the given parameters
    **/    
    @AuraEnabled
    public static List<Engagement_Activity__c> updateStatus(String p_recordId, String p_id, 
                                                            String p_status, String p_stage) {
        
        List<Engagement_Activity__c> mList = [SELECT Id,Stage__c from Engagement_Activity__c where Id =: p_id ];
        
        if (!mList.isEmpty()){
            Engagement_Activity__c activity = mList[0];
            activity.Status__c = p_status;
            update activity;
        }
        
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        engActList = getActivitiesByStage(p_recordId,p_stage);
        
        return engActList;
        
    }
    
    /**
    12/29/2020 - VH - This method Updates the status of the selected Eng. Act.
					  as a bulk update based on the given parameters
    **/
    @AuraEnabled
    public static List<Engagement_Activity__c> UpdateBulkStatus(String p_recordId, List<String> p_id_List, 
                                                                String p_status, String p_stage) {
        
        List<Engagement_Activity__c> mList = [SELECT Id,Stage__c,Status__c from Engagement_Activity__c where Id =: p_id_List ];
        
        if (!mList.isEmpty()){
            for(Engagement_Activity__c temp : mList){
                temp.Status__c = p_status;
                update temp;
            }
        }
        
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        engActList = getActivitiesByStage(p_recordId,p_stage);
        
        return engActList;
        
    }    
    
    /**
    12/29/2020 - VH - This method gets the stage picklist 
					  that user can filter the Eng. Act.
    **/
    @AuraEnabled
    public static List<String> getStagePicklist(String p_recordId) {
        
        //get the engagement type id first
        List<ia_Engagement__c> mList = [select Name, Id, Engagement_Type__r.Name,Engagement_Type__r.Id  
                                        from ia_Engagement__c where Id =: p_recordId ];
        ia_Engagement__c engRecord = new ia_Engagement__c();
        engRecord = mList[0] ;
        String eng_type_id = engRecord.Engagement_Type__c ;
        //System.debug('engRecord-------->'+ eng_type_id);
        
        //get the record type id for IA Method 2.0 phase 
        //and use it to filter stages
        List<RecordType> phaseIAMethod2_RT = [select developername,id from recordtype
                                              where 
                                              sObjectType ='ia_Phase__c' 
                                              and developername='IA_Method_2_0'];
        
        String IAMethod2_RT = phaseIAMethod2_RT[0].id;
        
        
        //get phase and stages related to the engagement type id and IA Method 2.0 phase
        List<String> stageNames = new List<String>();           
        List<ia_Deliverable__c> children = new List<ia_Deliverable__c>();
        
        //interate through each phase to get the stage name 
        //related to that phase and put that in a list
        for(ia_Phase__c objPhase: [select Name,(select Name from Deliverables__r ) from ia_Phase__c 
                                   where 
                                   Engagement_Type__c =: eng_type_id and recordTypeId =:IAMethod2_RT  ]) 
        	{
                children = objPhase.Deliverables__r;
                
                String phaseName = objPhase.Name;
                
                if(children.size() >0) {
                    for (ia_Deliverable__c varLoop : children){
                        stageNames.add(varLoop.Name);
                        //System.debug('<------------stageNames-------->varLoop.Name='+varLoop.Name);
                    }	
                }
            }
        
        return stageNames;
    } 
    
    /**
    12/29/2020 - VH - This method gets the Eng. Act. by Stage
    **/
    @AuraEnabled
    public static List <Engagement_Activity__c> getActivitiesByStage(String p_recordId, String p_stage) {
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        if ( p_stage == 'All'){
            engActList = fetchRecords(p_recordId);
        }else{
            engActList = [SELECT Id,Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                          from Engagement_Activity__c 
                          where Engagement__c =: p_recordId and Stage__c =: p_stage
                          order by Stage_Sort_Order_Formula__c
                         ];
        }
        
        return engActList;
    }
    
    /**
    05/30/2021 - VH - This method gets "three" current stage activities (if applicable) 
					  by going to the Stage which has at least one activity
					  in 'In Progress'.
                      ** NOTE - logic for stage is in getCurrentStage() whis is fed into
					  this method
                      
    **/
    @AuraEnabled
    public static List <Engagement_Activity__c> getCurrentStageActivities(String p_recordId, String p_stage) {
        Integer i = 0;
        Integer index = 0;
        Integer listSize = 0;
        Integer indexPlusThree = 0;
        
        System.debug('-------------------> getCurrentStageActivities ');
        
		List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        if ( p_stage == 'Not Started'){
            engActList = fetchRecords(p_recordId);
        }else{
            engActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                          from Engagement_Activity__c 
                          where Engagement__c =: p_recordId and Stage__c =: p_stage
                          order by Stage_Sort_Order_Formula__c
                         ];
        }
        
        listSize = engActList.size();
        
        //System.debug('--> p_stage='+p_stage+',p_list='+listSize);
        
        List <Engagement_Activity__c> currStgActList = new List <Engagement_Activity__c>();
            
        if( p_stage !='Not Started' && p_stage !='Completed' ){
            //iterate to get the index
            for( Engagement_Activity__c e : engActList ){
                if( e.Status_Formula__c == 'In Progress' ){
                    index = i;
                    break;
                }
				i++;
            }
            //check if greater than or equal to 3
            //and then get only 3 from the index
            if( (listSize-index) >= 3 ){
                indexPlusThree = index+3;
                for( Integer p=index; p < indexPlusThree; p++ ){
                    currStgActList.add(engActList[p]);
                }
                
            }else{ //otherwise get remaining from the index to the end of list
                for( Integer p=index; p < listSize; p++ ){
                    currStgActList.add(engActList[p]);
                }
            }
        }else if(p_stage =='Not Started'){ //get only the first three from fetchRecords() (reusing method)
            for( Integer p=0; p < 3; p++ ){
                    currStgActList.add(engActList[p]);
			}
        }
        return currStgActList;
    }
    /**
    05/30/2021 - VH - This method gets "three" Next stage activities (if applicable) 
					  by going to the Next Stage and getting only 3 activities
                      ** NOTE - logic for stage is in getCurrentStage() whis is fed into
					  this method
                      
    **/
    @AuraEnabled
    public static List <Engagement_Activity__c> getNextStageActivities(String p_recordId, String p_stage) {
        Integer i = 0;
        Integer index = 0;
        Integer listSize = 0;
        Integer indexPlusThree = 0;
        String nextStage;
        
        //we need to transform the unsorted stage to sorted stage
        List<String> stagelist = getSortedStagePicklist( p_recordId );
        
        List<Engagement_Activity__c> nextStageActList = new List<Engagement_Activity__c>();
        
        System.debug('-------------------> getNextStageActivities ');
        
        if(p_stage == 'Not Started'){
            //show the first three activities of stage 2
            nextStage = stagelist[1]; //second stage
            nextStageActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                              from Engagement_Activity__c 
                              where Engagement__c =: p_recordId and Stage__c =: nextStage
                              order by Stage_Sort_Order_Formula__c limit 3
                             ];
        }else if(p_stage == 'Completed'){
            //show nothing
        }else{

            //iterate through to find the current stage index
            for (String s:stagelist){
                if( s == p_stage ){
                    index = i;
                    break;
                }
                i++;
            }
            
            if( index == stagelist.size()-1 ){
                //do nothing there is no next stage
            }else{
            	nextStage = stagelist[index+1];
                nextStageActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                              from Engagement_Activity__c 
                              where Engagement__c =: p_recordId and Stage__c =: nextStage
                              order by Stage_Sort_Order_Formula__c limit 3
                             ];
            }
        }
        
        listSize = nextStageActList.size();
                
        //System.debug('--> nextStageActList p_stage='+nextStage+',nextStageActList='+listSize);
        
        return nextStageActList;
    }


    /**
    03/12/2021 - VH - This method is used by the CurrentStageComponent.
                      It provides methods to:
                        - Display current stage of the engagement
                          based on criteria i.e. if there are multiple
						  in progress activities return the later stage (higher sort order)
    **/
	@AuraEnabled
    public static List<String> getCurrentStage(String p_recordId) {
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        List<String> currentStageList = new List<String>();
        String currentStage = 'Not Started';
        Integer toDoCount = 0;
        Integer inProgressCount = 0;
        Integer completeCount = 0;
        Integer skipCount = 0;
        Integer engActCount =0;
        Decimal highestSortOrder = 0;
        String latestStage ;

        Integer initialCount = 0;        
        
        engActList = [SELECT Id, Stage__c, Status__c, Stage_Sort_Order_Formula__c
                      FROM Engagement_Activity__c 
                      where Engagement__c =: p_recordId
                     ];
        engActCount =  engActList.size();
        if ( engActCount >0 ){
            for(Engagement_Activity__c temp:engActList){
                if( temp.Status__c == 'To Do' ){
                    toDoCount+= 1;
                }else if ( temp.Status__c == 'In Progress' ){
                    inProgressCount+=1;
                    //sortOrder = (Decimal)temp.Stage_Sort_Order_Formula__c;
                    //inProgressMap.put(temp.Id, sortOrder);
                    if ( initialCount == 0){
                    	highestSortOrder = temp.Stage_Sort_Order_Formula__c;
                    	latestStage = temp.Stage__c;
                    }else{
                        if(temp.Stage_Sort_Order_Formula__c > highestSortOrder){
                            highestSortOrder = temp.Stage_Sort_Order_Formula__c;
                    		latestStage = temp.Stage__c; 
                        }
                    }
                }else if ( temp.Status__c == 'Complete' ){
                    completeCount+=1;
                }else if ( temp.Status__c == 'Skip' ){
                    skipCount+=1;
                }
                
                initialCount++;
            }
        }
        
        if( engActCount == toDoCount ){
            currentStage = 'Not Started';
        }else if( engActCount == (completeCount + skipCount) ){
            currentStage = 'Completed';
        }else if( inProgressCount > 0 ){
            currentStage = latestStage;
        }
        
        currentStageList.add(currentStage);
        
        return currentStageList;
    }
    
    /**
    05/30/2021 - VH - This method transforms unsorted stages into sorted stages
					  and returns list
                      ** NOTE - logic for stage is in getCurrentStage() whis is fed into
					  this method
                      
    **/
    @AuraEnabled
    public static List<String> getSortedStagePicklist(String p_recordId) {
        
        List<String> unsortedStageList = getStagePicklist( p_recordId );
        List<String> sortedStageList = new List<String>();
               
        //use unsorted query to query and get the sort order to sort
        for(ia_Deliverable__c tempStage : [ select Name, Stage_Sort_Order__c from ia_Deliverable__c 
                                           where Name in : unsortedStageList 
                                           order by Stage_Sort_Order__c
                                   			 ]) {
                sortedStageList.add(tempStage.Name) ;
		}
        
        return sortedStageList;
    }
    /**
    05/30/2021 - VH - This method gets the Next stage
                      ** NOTE - logic for stage is in getCurrentStage() whis is fed into
					  this method
                      
    **/
    @AuraEnabled
    public static List <String> getNextStage(String p_recordId, String p_stage) {
        Integer i = 0;
        Integer index = 0;
        Integer listSize = 0;
        Integer indexPlusThree = 0;
        String nextStage;
        
        List<String> nextStageList = new List<String>();
            
        //we need to transform the unsorted stage to sorted stage
        List<String> stagelist = getSortedStagePicklist( p_recordId );
        
        List<Engagement_Activity__c> nextStageActList = new List<Engagement_Activity__c>();
        
        System.debug('-------------------> getNextStage ');
        
        if(p_stage == 'Not Started'){
            //show the first three activities of stage 2
            nextStage = stagelist[1]; //second stage
            
        }else if(p_stage == 'Completed'){
            nextStage = 'Completed';
        }else{

            //iterate through to find the current stage index
            for (String s:stagelist){
                if( s == p_stage ){
                    index = i;
                    break;
                }
                i++;
            }
            
            if( index == stagelist.size()-1 ){
                //do nothing there is no next stage
                nextStage = 'Completed';
            }else{
            	nextStage = stagelist[index+1];
            }
        }
        
        nextStageList.add(nextStage);
        
        return nextStageList;
    }

}