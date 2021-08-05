/**
12/29/2020 - VH - This class is used by the EngageActivityComponent.
                  It provides methods to:
                    - Display all the Engagement Activities (EA) tied to
                      a specific Engagement record
                    - Updates the status of each EA or as a bulk
                    - Gets all the Stages (distinct) of the engagement activities so as to
                      provide the User a filter
**/

public class EnagageActivityController {

    @AuraEnabled
    public static List <Engagement_Activity__c> fetchRecords(String p_recordId) {
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        engActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
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
        for(ia_Phase__c objPhase: [select Name,(select Name from Deliverables__r) from ia_Phase__c 
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
            engActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                          from Engagement_Activity__c 
                          where Engagement__c =: p_recordId and Stage__c =: p_stage
                          order by Stage_Sort_Order_Formula__c
                         ];
        }
        
        return engActList;
    }
    
    /**
    03/12/2021 - VH - This method is used by the CurrentStageComponent.
                      It provides methods to:
                        - Display current stage of the engagement
                          based on criteria
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
        //Map<String, Decimal> inProgressMap;
        Decimal highestSortOrder = 0;
        String latestStage ;
        //List<Decimal> listForSorting;
        //Integer listForSortingSize = 0;
        Integer initialCount = 0;        
        
        engActList = [SELECT Id, Name, Stage__c, Status__c, Stage_Sort_Order_Formula__c
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
    
    @AuraEnabled
    public static List <Engagement_Activity__c> getActivitiesByStage2(String p_recordId, String p_stage) {
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        if ( p_stage == 'All'){
            engActList = fetchRecords(p_recordId);
        }else{
            engActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                          from Engagement_Activity__c 
                          where Engagement__c =: p_recordId and Stage__c =: p_stage
                          order by Stage_Sort_Order_Formula__c
                         ];
        }
        
        return engActList;
    }
    @AuraEnabled
    public static List <Engagement_Activity__c> callCurrentStageAct_new(String p_recordId, String p_stage) {
        Integer i = 0;
        Integer index = 0;
        Integer listSize = 0;
        Integer indexPlusThree = 0;
        
        System.debug('-------------------> callCurrentStageAct ');
        
		List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        
        if ( p_stage == 'All'){
            engActList = fetchRecords(p_recordId);
        }else{
            engActList = [SELECT Id, Name, Stage__c,Activity_Description__c,Status_Formula__c,Output__c
                          from Engagement_Activity__c 
                          where Engagement__c =: p_recordId and Stage__c =: p_stage
                          order by Stage_Sort_Order_Formula__c
                         ];
        }
        
        listSize = engActList.size();
        
        System.debug('--> p_stage='+p_stage+',p_list='+listSize);
        
        List <Engagement_Activity__c> currStgActList = new List <Engagement_Activity__c>();
            
        if( p_stage !='Not Started' && p_stage !='Completed' ){
            System.debug('--> 1');
            System.debug('--> listSize='+listSize+',index='+index);
            for( Engagement_Activity__c e : engActList ){
                System.debug('--> 2');
				i++;
                if( e.Status_Formula__c == 'In Progress' ){
                    index = i-1;
                    break;
                }
            }
            if( (listSize-index) >= 3 ){
                System.debug('--> 3');
                indexPlusThree = index+3;
                for( Integer p=index; p < indexPlusThree; p++ ){
                    currStgActList.add(engActList[p]);
                }
                
            }
        }
        System.debug('--> currStgActList size='+currStgActList.size() );
        for(Engagement_Activity__c e : currStgActList ){
            System.debug('--> name='+e.Name +',output='+e.Output__c);
        }
        return currStgActList;
    }
    
    public static void setUptoThreeActivitiesNextStage(String p_stage,List <Engagement_Activity__c> p_list){
        if( p_stage !='Not Started' && p_stage !='Completed' ){
            //nextStgActList
        }
    }
    
    @AuraEnabled
    public static List <Engagement_Activity__c> helloWorld(String p_recordId, String p_stage) {
        
        System.debug('----- helloWorld ');
        
        List<Engagement_Activity__c> engActList = new List<Engagement_Activity__c>();
        return engActList;
    }
}