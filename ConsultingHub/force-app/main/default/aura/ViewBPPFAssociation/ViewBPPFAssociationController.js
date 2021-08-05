({
	doInit : function(component, event, helper) {
        helper.initDatatable(component, event, helper);
        helper.fetchExistingAssociationsHelper(component, event, helper);
        
    }
})