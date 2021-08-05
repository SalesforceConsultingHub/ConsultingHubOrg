({
	doInit : function(component, event, helper) {
        helper.initBusinessPriorityValues(component, event, helper);
        helper.initProductFeatureDatatable(component, event, helper);
        helper.initBusinessPriorityDatatable(component, event, helper);
   	},
    
    handleChangeBusinessPriority : function(component, event, helper) {
        helper.showLoader(component, event, helper);
        var selectedBusinessPriority = component.find('businessPriorityCombobox').get('v.value');
        component.set("v.selectedBusinessPriority", selectedBusinessPriority);
        console.log('selectedBusinessPriority='+selectedBusinessPriority);
        component.set("v.selectedProductFeature", "");
        
        helper.fetchBusinessPrioritiesForSelectedCloud(component, event, helper);
    },
    
    handleChangeProductFeature : function(component, event, helper) {
        var selectedProductFeature = component.find('productFeatureCombobox').get('v.value');
        component.set("v.selectedProductFeature", selectedProductFeature);
        component.set("v.selectedBusinessPriority", "");
        console.log('selectedProductFeature='+selectedProductFeature);
    },
    
    showAllProductFeatures : function(component, event, helper) {
        helper.showLoader(component, event, helper);
        //component.set("v.showAllFeatures", true);
        helper.matchBusinessPriority(component, event, helper);
    },
    
    updateSelectedBusinessFeaturesCount: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedBusinessFeaturesIds = [];
        for (var i = 0; i < selectedRows.length; i++) {
        	console.log(selectedRows[i].Id);
            selectedBusinessFeaturesIds.push(selectedRows[i].Id);
        }
        component.set('v.selectedBusinessPriorityIds', selectedBusinessFeaturesIds);
        component.set('v.selectedBusinessPrioritiesRowsCount', selectedRows.length);
    },
    
    updateSelectedProductFeatureCount: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedProductFeatureIds = [];
        for (var i = 0; i < selectedRows.length; i++) {
        	console.log(selectedRows[i].Id);
            selectedProductFeatureIds.push(selectedRows[i].Id);
        }
        component.set('v.selectedProductFeatureIds', selectedProductFeatureIds);
        component.set('v.selectedProductFeatureRowsCount', selectedRows.length);
    },
    
    handleAssociation: function (component, event, helper) {
    	console.log(component.get('v.selectedProductFeatureIds'));
        helper.showLoader(component, event, helper);
        helper.handleAssociationHelper(component, event, helper);
        
    },
    
    searchTableBusinessPriority: function (component, event, helper) {
        helper.searchTableBusinessPriorityHelper(component, event, helper);

    },
    

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_Associations':
                helper.handleShowModal(component, event, helper, row);
                break;
        }
    }

})