({
	/* 	12/29/2020 - VH - see JS Helper for detailed coments on below methods
		06/05/2021 - original approach of using setTimeout had to be removed
                     because methods were still getting asynchronously getting
                     executed despite staggered setTimeouts. 
                     With the use of Promise and chaining, synchronous
                     execution is guranteed and dependencies were getting executed
                     in the proper order.
    */
	doInit : function(component, event, helper) {
        helper.handleStagePicklist_promise(component)
        .then(() => helper.handleGetCurrentStageOnly_promise(component) )
		.then(() => helper.handleStageActivities_promise(component) )
        .then(() => helper.handleCurrentStageActivities_promise(component) )
        .then(() => helper.handleNextStageActivities_promise(component) )
        .then(() => helper.handleNextStage_promise(component) )
        ;
	},
    onStageActivityChange: function(component, event, helper) {
		helper.handleStageActivityChange(component);
	},
    markSelectedComplete: function(component, event, helper) {
        helper.handleMarkSelectedComplete_promise(component)
        .then(() => helper.handleStagePicklist_promise(component) )
        .then(() => helper.handleGetCurrentStageOnly_promise(component) )
		.then(() => helper.handleStageActivities_promise(component) )
        .then(() => helper.handleCurrentStageActivities_promise(component) )
        .then(() => helper.handleNextStageActivities_promise(component) )
        .then(() => helper.handleNextStage_promise(component) )
        ;
    },
    markSelectedInProgress: function(component, event, helper) {
        helper.handleMarkSelectedInProgress_promise(component)
        .then(() => helper.handleStagePicklist_promise(component) )
        .then(() => helper.handleGetCurrentStageOnly_promise(component) )
		.then(() => helper.handleStageActivities_promise(component) )
        .then(() => helper.handleCurrentStageActivities_promise(component) )
        .then(() => helper.handleNextStageActivities_promise(component) )
        .then(() => helper.handleNextStage_promise(component) )
        ;
    },
	markSelectedSkip: function(component, event, helper) {
         helper.handleMarkSelectedSkip_promise(component)
        .then(() => helper.handleStagePicklist_promise(component) )
        .then(() => helper.handleGetCurrentStageOnly_promise(component) )
		.then(() => helper.handleStageActivities_promise(component) )
        .then(() => helper.handleCurrentStageActivities_promise(component) )
        .then(() => helper.handleNextStageActivities_promise(component) )
        .then(() => helper.handleNextStage_promise(component) )
        ;
    },
    handleRowAction: function (component, event, helper) {
		helper.handleRowAction_promise(component,event)
		.then(() => helper.handleStagePicklist_promise(component) )
        .then(() => helper.handleGetCurrentStageOnly_promise(component) )
		.then(() => helper.handleStageActivities_promise(component) )
        .then(() => helper.handleCurrentStageActivities_promise(component) )
        .then(() => helper.handleNextStageActivities_promise(component) )
        .then(() => helper.handleNextStage_promise(component) )
        ;
    },    
    handleSelectedRow: function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        var obj =[] ; 
        for (var i = 0; i < selectedRows.length; i++){
            obj.push(selectedRows[i].Id);
            }
        component.set("v.selectedRows",obj);
	}
})