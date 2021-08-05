/*
12/29/2020 - VH - This class is used to copy Stage Activities to
				  Engagement Activities
*/

trigger EngagementTrigger on ia_Engagement__c (after insert, after update) {

    //1. get the engagement type
    //2. based on that get all the Stage Activities
    //3. copy from step 2. into Engagement Activities
    
    if (Trigger.isInsert || Trigger.isUpdate  ) {
        
        Id engagementId;
        
        if (Trigger.isInsert){
            for (ia_Engagement__c varLoop_engage : Trigger.New){
                engagementId = varLoop_engage.Id;
            }
        }else if(Trigger.isUpdate){
            for (ia_Engagement__c varLoop_engage : Trigger.old){
                engagementId = varLoop_engage.Id;
            }
        }
        
        
        ia_Engagement__c engRecord = new ia_Engagement__c();
        engRecord = [ 	SELECT
                     Id, Name,  Engagement_Type__r.Name,
                     Engagement_Type__r.Id,Domain__c 
                     FROM ia_Engagement__c where id=: engagementId ];
        
        //check if User has chosen a value for engagement type ONLY then copy activities
        //if(engRecord.Engagement_Type__r.Id != null  ){
        if(engRecord.Engagement_Type__r.Name != null &&
          engRecord.Engagement_Type__r.Name == 'IA Method 2.0'){
            
            List<Stage_Activity__c> stageActivities_list = new List<Stage_Activity__c>();
            List<Engagement_Activity__c> engageActivities_list = new List<Engagement_Activity__c>();
            
            //query stage activities
            stageActivities_list = [SELECT Id,Output__c, 
                                    Resources_and_Templates__c
                                    FROM Stage_Activity__c 
                                    WHERE 
                                    Domain__c =: engRecord.Domain__c OR
                                    Domain__c = ''
                                   ] ;
            
            //create temp outside loop to avoid
            // unnecessary object creation
            Engagement_Activity__c temp = null;
            
            //iterate over Stage Activity list
            //and copy to egangement activities
            for( Stage_Activity__c loopVar : stageActivities_list) {
                temp = new Engagement_Activity__c();
                temp.Activity__c = loopVar.Id;
                temp.Engagement__c = engRecord.Id;
                temp.Output__c = loopVar.Output__c;
                temp.Resources_and_Templates__c = loopVar.Resources_and_Templates__c;
                
                engageActivities_list.add(temp);
            }
            //insert the copied activities
            insert engageActivities_list;
        }
    }

  
    //Do we want to delete engagement activities 
    //that were previously associated with another engagement type????
}