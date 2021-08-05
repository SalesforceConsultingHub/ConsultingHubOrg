({

    /* 12/29/2020 - VH - This method is called everytime a picklist value changes;
                         engagement activities are filtered by the chosen picklist value.
                         Note: - default is all
    */
    handleStageActivityChange: function(component) {
        var stageToSearchActivityFor = component.find("stagePickList").get("v.value");
        var recordId = component.get("v.recordId");
		var action = component.get("c.getActivitiesByStage");
        action.setParams({"p_recordId": recordId, "p_stage":stageToSearchActivityFor}); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.engActList", response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    /* 12/29/2020 - VH - This method is called on load and is used to get
                         all the stages (distinct) which the User can filter by
    */
    handleStagePicklist_promise : function(component) {

        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            
            var recordId = component.get("v.recordId");
            var stageOpts =[];

            var action = component.get("c.getStagePicklist");
			action.setParams({"p_recordId": recordId});
            action.setCallback(this, function(response) {
    
                var state = response.getState();
                if (response.getState() == "SUCCESS") {
                    //resolve (
                    var allValues = response.getReturnValue();
        
                    //for each picklist value, create a option
                        for (var i = 0; i < allValues.length; i++) {
                            stageOpts.push({
                                class: "optionClass",
                                label: allValues[i],
                                value: allValues[i]                    
                            });
                        }
                        component.set("v.stagePicklistvalues", allValues);
                    resolve( );
                    //);
                }if(response.getState()=='ERROR') {
                	console.log('ERROR in handleStagePicklist_promise', response.getError() ); 
                	reject( response.getError() );
            	}
            });
            $A.enqueueAction(action);
        }));
        return p;
	},
    /* 05/31/2021 - VH - see JS Helper for detailed comments on below methods
    */
    handleGetCurrentStageOnly_promise : function(component) {

        var p = new Promise( $A.getCallback( function( resolve , reject ) {

            var recordId = component.get("v.recordId");
            //this action gets the current stage
            var action = component.get("c.getCurrentStage");
			action.setParams({"p_recordId": recordId});
            action.setCallback(this, function(response) {
            var currentStage;
			var state = response.getState();
                if (response.getState() == "SUCCESS") {
                    var stageValues = response.getReturnValue();
                    //for each picklist value, create a option
                    for (var i = 0; i < stageValues.length; i++) {
                        currentStage = stageValues[i];
                    }
                    component.set("v.currentStage", currentStage);
                    //alert('currentStage='+currentStage);
                    resolve( );
                }if(response.getState()=='ERROR') {
                    console.log('ERROR in handleGetCurrentStageOnly_promise', response.getError() ); 
                    reject( response.getError() );
                }
            });
            $A.enqueueAction(action);
		}));
        return p;
    },
    /* 12/29/2020 - VH - This method is called on load and is used to display 
                         all the engagement activities below stage picklist and sets up columns 
                         and row actions
    */
	handleStageActivities_promise : function(component) {
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var actions = [
                { label: 'Move to "In Progress"', name: 'In Progress' },
                { label: 'Move to "Complete"', name: 'Complete' },
                { label: 'Move to "To Do"', name: 'To Do' },
                { label: 'Move to "Skip"', name: 'Skip' },
                { label: 'View', name: 'View' },
                { label: 'Edit', name: 'Edit' }
            ];
            
            component.set('v.mycolumns', [
                {label: 'Stage', fieldName: 'Stage__c', type: 'text'},
                {label: 'Description', fieldName: 'Activity_Description__c', type: 'text',wrapText: true },
                {label: 'Output', fieldName: 'Output__c', type: 'text',wrapText: true },
                {label: 'Status', fieldName: 'Status_Formula__c', type: 'text'},
                { type: 'action', typeAttributes: { rowActions: actions } }
            ]);
            
            var recordId = component.get("v.recordId");
    
            //get the current stage
            var currentStage = component.get("v.currentStage");

            if ( currentStage != null &&
                (currentStage == 'Not Started' || currentStage == 'Completed' ) ){
                currentStage = 'All';
            }
            
            var recordId = component.get("v.recordId");
            var action = component.get("c.getActivitiesByStage");
            action.setParams({"p_recordId": recordId, "p_stage":currentStage}); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records =response.getReturnValue();
                    component.set("v.engActList", records);
                    $A.get('e.force:refreshView').fire();
                    resolve( );
                }if(response.getState()=='ERROR') {
                    console.log('ERROR in handleStageActivities_promise', response.getError() ); 
                    reject( response.getError() );
                }
            });
            $A.enqueueAction(action);
                        
		}));
        return p;
	},
    /* 05/31/2020 - VH - This method loads upto three engagement activities
                         for a stage which has an engagement activity status of 
                         in 'In Progress'
    */
    handleCurrentStageActivities_promise : function(component) {
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var actions = [
                { label: 'Move to "In Progress"', name: 'In Progress' },
                { label: 'Move to "Complete"', name: 'Complete' },
                { label: 'Move to "To Do"', name: 'To Do' },
                { label: 'Move to "Skip"', name: 'Skip' },
                { label: 'View', name: 'View' },
                { label: 'Edit', name: 'Edit' }
            ];
            
            component.set('v.mycolumns2', [
                {label: 'Stage', fieldName: 'Stage__c', type: 'text'},
                {label: 'Description', fieldName: 'Activity_Description__c', type: 'text',wrapText: true },
                {label: 'Output', fieldName: 'Output__c', type: 'text',wrapText: true },
                {label: 'Status', fieldName: 'Status_Formula__c', type: 'text'},
                { type: 'action', typeAttributes: { rowActions: actions } }
            ]);
            
            var recordId = component.get("v.recordId");
            //get the current stage
            var currentStage = component.get("v.currentStage");
            
            var action = component.get("c.getCurrentStageActivities");
            action.setParams({"p_recordId": recordId, "p_stage":currentStage}); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records =response.getReturnValue();
                    component.set("v.currStgActList", records);
                    $A.get('e.force:refreshView').fire();
                    resolve( );
                }if(response.getState()==='ERROR') {
                    console.log('ERROR in handleCurrentStageActivities_promise', response.getError() ); 
                    reject( response.getError() );
                }
            });
            $A.enqueueAction(action);

		}));
        return p;        
	},
    /* 05/31/2020 - VH - This method loads upto three engagement activities
                         for the stage after ( or next stage) of the stage in 
                         handleCurrentStageActivities_promise()
    */
    handleNextStageActivities_promise : function(component) {
		var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var actions = [
                { label: 'Move to "In Progress"', name: 'In Progress' },
                { label: 'Move to "Complete"', name: 'Complete' },
                { label: 'Move to "To Do"', name: 'To Do' },
                { label: 'Move to "Skip"', name: 'Skip' },
                { label: 'View', name: 'View' },
                { label: 'Edit', name: 'Edit' }
            ];
            
            component.set('v.mycolumns3', [
                {label: 'Stage', fieldName: 'Stage__c', type: 'text'},
                {label: 'Description', fieldName: 'Activity_Description__c', type: 'text',wrapText: true },
                {label: 'Output', fieldName: 'Output__c', type: 'text',wrapText: true },
                {label: 'Status', fieldName: 'Status_Formula__c', type: 'text'},
                { type: 'action', typeAttributes: { rowActions: actions } }
            ]);
            
            var recordId = component.get("v.recordId");
            //get the current stage
            var currentStage = component.get("v.currentStage");
            
            var action = component.get("c.getNextStageActivities");
            action.setParams({"p_recordId": recordId, "p_stage":currentStage}); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var records =response.getReturnValue();
                    component.set("v.nextStgActList", records);
                    $A.get('e.force:refreshView').fire();
                    resolve( );
                }if(response.getState()==='ERROR') {
                    console.log('ERROR in handleCurrentStageActivities_promise', response.getError() ); 
                    reject( response.getError() );
                }
            });
            $A.enqueueAction(action);

        }));
        return p; 
	},
    /* 05/31/2021 - VH - In order to determine the next stage, currentstage
     					 is used as reference 
    */
	handleNextStage_promise : function(component, event, helper) {
        
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var recordId = component.get("v.recordId");
            
            var currentStage = component.get("v.currentStage");
            var action = component.get("c.getNextStage");
            action.setParams({"p_recordId": recordId, "p_stage":currentStage}); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();  
                    component.set("v.nextStage", res[0]);
                    resolve( );
                }if(response.getState()==='ERROR') {
                    console.log('ERROR in handleNextStage_promise', response.getError() ); 
                    reject( response.getError() );
                }
            });
            
            $A.enqueueAction(action);

        }));
        return p; 
	},
	/* 12/29/2020 - VH - This method is called on each individual Engagement Activities
                         row action
    */
    handleRowAction_promise: function ( component,event ) {
		
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var action = event.getParam( 'action' );
            var row = event.getParam( 'row' );
            var recId = row.Id;
            var stageToSearchActivityFor = component.find("stagePickList").get("v.value");
            var recordId = component.get("v.recordId");
            switch ( action.name ) {
                case 'In Progress':
                    var rowAction = component.get("c.updateStatus");
                    rowAction.setParams({"p_recordId": recordId, "p_id":recId,
                                         "p_status":"In Progress","p_stage":stageToSearchActivityFor
                                        });
                    rowAction.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.engActList", response.getReturnValue());
                            $A.get('e.force:refreshView').fire();
                            resolve( );
                        }if(response.getState()==='ERROR') {
                            console.log('ERROR in handleRowAction_promise - In Progress case', response.getError() ); 
                            reject( response.getError() );
                        }
                    });
                    
                    $A.enqueueAction(rowAction);
                    
                    //app event stuff ********* DO NOT DELETE yet *********
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire(); 
                    
                    break;
                case 'Complete':
                    var rowAction = component.get("c.updateStatus");
                    rowAction.setParams({"p_recordId": recordId, "p_id":recId,
                                         "p_status":"Complete","p_stage":stageToSearchActivityFor
                                        });
                    rowAction.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.engActList", response.getReturnValue());
                            $A.get('e.force:refreshView').fire();
                            resolve( );
                        }if(response.getState()==='ERROR') {
                            console.log('ERROR in handleRowAction_promise - Complete case', response.getError() ); 
                            reject( response.getError() );
                        }
                    });
                    
                    $A.enqueueAction(rowAction);
                    
                    //app event stuff //********* DO NOT DELETE yet *********
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire(); 
                    
                    break;
                 case 'To Do':
                    var rowAction = component.get("c.updateStatus");
                    rowAction.setParams({"p_recordId": recordId, "p_id":recId,
                                       "p_status":"To Do","p_stage":stageToSearchActivityFor
                                      });
                    rowAction.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.engActList", response.getReturnValue());
                            $A.get('e.force:refreshView').fire();
                        	resolve( );
                        }if(response.getState()==='ERROR') {
                            console.log('ERROR in handleRowAction_promise - To Do case', response.getError() ); 
                            reject( response.getError() );
                        }
                    });
                    
                    $A.enqueueAction(rowAction);
                    
                    //app event stuff //********* DO NOT DELETE yet *********
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire(); 
                    
                    break;
                case 'Skip':
                    var rowAction = component.get("c.updateStatus");
                    rowAction.setParams({"p_recordId": recordId, "p_id":recId,
                                       "p_status":"Skip","p_stage":stageToSearchActivityFor
                                      });
                    rowAction.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.engActList", response.getReturnValue());
                            $A.get('e.force:refreshView').fire();
                            resolve( );
                        }if(response.getState()==='ERROR') {
                            console.log('ERROR in handleRowAction_promise - Skip case', response.getError() ); 
                            reject( response.getError() );
                        }
                    });
                    
                    $A.enqueueAction(rowAction);
                    
                    //app event stuff //********* DO NOT DELETE yet *********
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire(); 
                    
                    break;
                case 'Edit':
                    var editRecordEvent = $A.get("e.force:editRecord");
                    editRecordEvent.setParams({
                        "recordId": recId
                    });
                    editRecordEvent.fire();
                    break;
                case 'View':
                    var viewRecordEvent = $A.get("e.force:navigateToURL");
                    viewRecordEvent.setParams({
                        "url": "/" + recId
                    });
                    viewRecordEvent.fire();
                    break; 
            }
        }));
        return p; 
    },
	/* 12/29/2020 - VH - This method is called when 'Mark selected Complete' button
                         is clicked. Selected Engagement Activities are ALL updated 
                         to 'Complete' status
    */
    handleMarkSelectedComplete_promise: function(component) {
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var stageToSearchActivityFor = component.find("stagePickList").get("v.value");
            
            var recordId = component.get("v.recordId");
            var selectedList = component.get("v.selectedRows");
            var action = component.get("c.UpdateBulkStatus");
            //alert('selectedList='+selectedList);
            action.setParams({"p_recordId": recordId, "p_id_List":selectedList,
                              "p_status":"Complete","p_stage":stageToSearchActivityFor
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.engActList", response.getReturnValue());
                    
                    //once data is updated in bulk, need to uncheck all selected rows
                    var selectedList = [];
                    component.set("v.selectedRows", selectedList);
                    //component.set("v.renderLtngDataTable", true);
                    var ltngDataTable = component.find("ltngDataTable");
                    if(ltngDataTable){
                        ltngDataTable.set("v.selectedRows", selectedList);            
                    }
                    $A.get('e.force:refreshView').fire();
                    
                    //app event stuff //DO NOT DELETE YET
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire();                  
                    resolve( );
                }if(response.getState()==='ERROR') {
                    console.log('ERROR in handleMarkSelectedComplete_promise ', response.getError() ); 
                    reject( response.getError() );
                }
            });
            
            $A.enqueueAction(action);
		}));
        return p; 
    },
	/* 12/29/2020 - VH - This method is called when 'Mark selected In Progress' button
                         is clicked. Selected Engagement Activities are ALL updated 
                         to 'In Progress' status
    */
    handleMarkSelectedInProgress_promise: function(component,event) { 
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var stageToSearchActivityFor = component.find("stagePickList").get("v.value");
            
            var recordId = component.get("v.recordId");
            var selectedList = component.get("v.selectedRows");
            var action = component.get("c.UpdateBulkStatus");
            //alert('selectedList='+selectedList);
            action.setParams({"p_recordId": recordId, "p_id_List":selectedList,
                              "p_status":"In Progress","p_stage":stageToSearchActivityFor
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.engActList", response.getReturnValue());
                    
                    //once data is updated in bulk, need to uncheck all selected rows
                    var selectedList = [];
                    component.set("v.selectedRows", selectedList);
                    //component.set("v.renderLtngDataTable", true);
                    var ltngDataTable = component.find("ltngDataTable");
                    if(ltngDataTable){
                        ltngDataTable.set("v.selectedRows", selectedList);            
                    }
                    $A.get('e.force:refreshView').fire();
    
                    //app event stuff
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire();                
                    resolve( );
                }if(response.getState()==='ERROR') {
                    console.log('ERROR in handleMarkSelectedInProgress_promise ', response.getError() ); 
                    reject( response.getError() );
                }
            });
            
            $A.enqueueAction(action);
        }));
        return p; 
    },
    /* 12/29/2020 - VH - This method is called when 'Mark selected Skip' button
                         is clicked. Selected Engagement Activities are ALL updated 
                         to 'Skip' status
    */
    handleMarkSelectedSkip_promise: function(component) { 
        var p = new Promise( $A.getCallback( function( resolve , reject ) {
            var stageToSearchActivityFor = component.find("stagePickList").get("v.value");
            
            var recordId = component.get("v.recordId");
            var selectedList = component.get("v.selectedRows");
            var action = component.get("c.UpdateBulkStatus");
            //alert('selectedList='+selectedList);
            action.setParams({"p_recordId": recordId, "p_id_List":selectedList,
                              "p_status":"Skip","p_stage":stageToSearchActivityFor
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.engActList", response.getReturnValue());
                    
                    //once data is updated in bulk, need to uncheck all selected rows
                    var selectedList = [];
                    component.set("v.selectedRows", selectedList);
                    //component.set("v.renderLtngDataTable", true);
                    var ltngDataTable = component.find("ltngDataTable");
                    if(ltngDataTable){
                        ltngDataTable.set("v.selectedRows", selectedList);            
                    }
                    $A.get('e.force:refreshView').fire();
                    
                    //app event stuff
                    //var appEvent = $A.get("event.c:RefreshCurrentStageCompEvent");
                    //appEvent.fire();                  
                    resolve( );
                }if(response.getState()==='ERROR') {
                    console.log('ERROR in handleMarkSelectedSkip_promise ', response.getError() ); 
                    reject( response.getError() );
                }
            });
            
            $A.enqueueAction(action);
        }));
        return p;
    },

})