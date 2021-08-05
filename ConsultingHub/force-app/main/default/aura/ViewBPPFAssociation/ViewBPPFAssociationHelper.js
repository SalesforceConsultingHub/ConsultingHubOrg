({
	fetchExistingAssociationsHelper : function(component, event, helper) {
        var action = component.get("c.fetchExistingAssociations");
        action.setParams({
            "bpId" : component.get("v.bpId")
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.existingAssociations", allValues);
            }
        });
        $A.enqueueAction(action);
    },

    //Initialize datatable with columns to be displayed
    initDatatable : function(component, event, helper) {
    	component.set('v.associationsColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
            {label: 'Product Feature Name', fieldName: 'Product_Feature_Name__c', type: 'text', sortable: true},
            {label: 'Business Unit', fieldName: 'Product_Feature_Business_Unit__c', type: 'text', sortable: true},
            {label: 'Product Area', fieldName: 'Product_Feature_Product_Area__c', type: 'text', sortable: true},
            {label: 'Product Sub Area', fieldName: 'Product_Feature_Product_Subarea__c', type: 'text', sortable: true},
            
            
		]);
    },
})