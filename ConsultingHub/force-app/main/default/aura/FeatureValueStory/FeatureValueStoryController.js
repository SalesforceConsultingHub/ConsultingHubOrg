({
	doInit : function(component, event, helper) {
        helper.showLoader(component, event, helper);
		helper.initBusinessValueLevers(component, event, helper);
    },
    
    handleModeChange : function(component, event, helper) {
        helper.resetAttributes(component, event, helper);
        
        
    },
    
    handleBusinessValueLeverChange : function(component, event, helper) {
        
        helper.showLoader(component, event, helper);
        helper.resetData(component, event, helper);
        helper.initBusinessImpactOptions(component, event, helper);
    },
    
    handleBusinessImpactChange : function(component, event, helper) {
        helper.initBusinessPriorityDatatable(component, event, helper);
        helper.initProductFeatureDatatable(component, event, helper);
        helper.showLoader(component, event, helper);
        helper.fetchBusinessPriorities(component, event, helper);
        //vh changes
        //call code to fetch associations here
        helper.matchBusinessPriority(component, event, helper);
    },
    
    updateSelectedBusinessPriorities: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedBusinessPriorityIds = [];
        for (var i = 0; i < selectedRows.length; i++) {
            selectedBusinessPriorityIds.push(selectedRows[i].Id);
        }
        component.set('v.selectedBusinessPriorityIds', selectedBusinessPriorityIds);
        if(component.get('v.modeValue') == 'option1'){
        	helper.matchBusinessPriority(component, event, helper);
        }
    },
    
    updateSelectedProductFeatures: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedIds = [];
        for (var i = 0; i < selectedRows.length; i++) {
            selectedIds.push(selectedRows[i].Id);
        }
        component.set('v.selectedProductFeatureIds', selectedIds);
        if(component.get('v.modeValue') == 'option2'){
            helper.matchProductFeatures(component, event, helper);
        }
    },
    
    handleAssociation: function (component, event, helper) {
        
        helper.showLoader(component, event, helper);
        helper.addBusinessPrioritiesAndProdFeatures(component, event, helper);
    },
    
    //////////////////////////////////////////////////////////////////////////////
    //
    handleProdBusUnitChange : function(component, event, helper) {
        
        helper.showLoader(component, event, helper);
        helper.resetData(component, event, helper);
        helper.initProductArea(component, event, helper);
    },
    
    handleProductAreaChange : function(component, event, helper) {
        helper.initBusinessPriorityDatatable2(component, event, helper);
        helper.initProductFeatureDatatable2(component, event, helper);
        helper.showLoader(component, event, helper);
        helper.fetchProductFeatures(component, event, helper);
    },
})