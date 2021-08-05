({
	initBusinessValueLevers : function(component, event, helper) {
    	var action = component.get("c.fetchBusinessValueLevers");
        action.setParams({});
        var opts = [];
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                //for each picklist value, create a option
                for (var i = 0; i < allValues.length; i++) {
                    
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]                    
                    });
                }
                component.set("v.businessLeverOptions", opts);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    
    initBusinessImpactOptions : function(component, event, helper) {
        var action = component.get("c.fetchBusinessImpacts");
        action.setParams({
            selectBusValueLever: component.find('businessValueLeverCombobox').get('v.value')
		});
        var opts = [];
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                //for each picklist value, create a option
                for (var i = 0; i < allValues.length; i++) {
                    
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]                    
                    });
                }
                component.set("v.businessImpactOptions", opts);
                component.set("v.disableChildPicklist", false);
                
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    fetchBusinessPriorities : function(component, event, helper) {
        var action = component.get("c.fetchBusinessPriorities");
        action.setParams({
            selectBusValueLever : component.find('businessValueLeverCombobox').get('v.value'),
            selectBusImpact : component.find('businessImpactCombobox').get('v.value')
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.businessPrioritiesList", allValues);
            }
            helper.hideLoader(component, event, helper);
            component.set("v.showDatatables", true);
            
        });
        $A.enqueueAction(action);
    },
    
    matchBusinessPriority : function(component, event, helper) {
        //alert('matchBusinessPriority-->' +JSON.stringify(component.get("v.selectedBusinessPriorityIds"), null, 4) );
        var action = component.get("c.matchBusinessPrioritywithProductFeature");
        action.setParams({
            bpIds : component.get("v.selectedBusinessPriorityIds")
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.productFeatureList", allValues);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    addBusinessPrioritiesAndProdFeatures : function(component, event, helper) {
        var prodMode = false;
        if(component.get('v.modeValue') == 'option2'){
            prodMode = true;
        }
        var action = component.get("c.addBusinessPrioritiesAndProdFeatures");
        action.setParams({
            bpIds : component.get('v.selectedBusinessPriorityIds'),
            pfIds : component.get('v.selectedProductFeatureIds'),
            currentEngagementId : component.get('v.recordId'),
            productMode : prodMode
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
            }
            helper.hideLoader(component, event, helper);
            $A.get('e.force:refreshView').fire();
            helper.resetAttributes(component, event, helper);
            
        });
        $A.enqueueAction(action);
    },
    
    //Initialize datatable with columns to be displayed after the search is performed
    initBusinessPriorityDatatable : function(component, event, helper) {
    	component.set('v.businessPrioritiesColumns', [
            {label: 'Business Priority Name', fieldName: 'Name', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Value Driver', fieldName: 'Business_Value_Driver__c', type: 'text', sortable: true, wrapText: true},
            
		]);
    },
            
            
       //Initialize datatable with columns to be displayed after the search is performed
    initProductFeatureDatatable : function(component, event, helper) {
    	component.set('v.productFeatureColumns', [
            {label: 'Product Feature Name', fieldName: 'Product_Feature_Name__c', type: 'text', sortable: true},
            {label: 'Business Unit', fieldName: 'Product_Feature_Business_Unit__c', type: 'text', sortable: true},
            {label: 'Product Area', fieldName: 'Product_Feature_Product_Area__c', type: 'text', sortable: true},
            {label: 'Product Sub Area', fieldName: 'Product_Feature_Product_Subarea__c', type: 'text', sortable: true},
         ]);
    },     
            
     /////////////////////////////////////////////////////////////////////////////////////////////
     ///////////////////////////////////////////////////////////////////////////////////////////////
     ///////////////////////////////////////////////////////////////////////////////////////////////
     ///////////////////////////////////////////////////////////////////////////////////////////////
     //
     
    initProdBusUnit : function(component, event, helper) {
    	var action = component.get("c.fetchProdBusUnit");
        action.setParams({});
        var opts = [];
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                //for each picklist value, create a option
                for (var i = 0; i < allValues.length; i++) {
                    
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]                    
                    });
                }
                component.set("v.prodBusUnitOptions", opts);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    
    initProductArea : function(component, event, helper) {
    	var action = component.get("c.fetchProductArea");
        action.setParams({
            selectedBusUnit :component.find('prodBusUnitCombobox').get('v.value')
        });
        var opts = [];
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                //for each picklist value, create a option
                for (var i = 0; i < allValues.length; i++) {
                    
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]                    
                    });
                }
                component.set("v.productAreaOptions", opts);
                component.set("v.disableChildPicklist", false);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    fetchProductFeatures : function(component, event, helper) {
        var action = component.get("c.fetchProductFeatures");
        action.setParams({
            selectedProdBusUnit : component.find('prodBusUnitCombobox').get('v.value'),
            selectedProdArea : component.find('prodAreaCombobox').get('v.value')
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.productFeatureList2", allValues);
            }
            helper.hideLoader(component, event, helper);
            component.set("v.showDatatables", true);
        });
        $A.enqueueAction(action);
    },
    
    matchProductFeatures : function(component, event, helper) {
        var action = component.get("c.matchProductFeatureWithBusinessPriority");
        action.setParams({
            pfIds : component.get("v.selectedProductFeatureIds")
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.businessPrioritiesList", allValues);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    //Initialize datatable with columns to be displayed after the search is performed
    initProductFeatureDatatable2 : function(component, event, helper) {
    	component.set('v.productFeatureColumns', [
            {label: 'Product Feature Name', fieldName: 'Name', type: 'text', sortable: true, wrapText: true},
            {label: 'Product Sub Area', fieldName: 'Product_Sub_Area__c', type: 'text', sortable: true, wrapText: true}
		]);
    },
    
    //Initialize datatable with columns to be displayed after the search is performed
    initBusinessPriorityDatatable2 : function(component, event, helper) {
    	component.set('v.businessPrioritiesColumns', [
            {label: 'Business Priority Name', fieldName: 'Name', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Value Lever', fieldName: 'Business_Value_Lever__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Impact', fieldName: 'Business_Impact__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Value Driver', fieldName: 'Business_Value_Driver__c', type: 'text', sortable: true, wrapText: true},
            
            
		]);
    },
    
    //Show loader 
	showLoader : function(component, event, helper) {
		component.set("v.showLoader", true);
	},
    //Hide loader
    hideLoader : function(component, event, helper) {
		component.set("v.showLoader", false);
	},
            
            resetData : function(component, event, helper) {
        component.set('v.businessPrioritiesList',null);
        component.set('v.productFeatureList',null);
            component.set('v.productFeatureList2',null);
            },
            
    resetAttributes : function(component, event, helper) {
        component.set('v.businessPrioritiesList',null);
        component.set('v.businessPrioritiesColumns',null);
        component.set('v.productFeatureList',null);
            component.set('v.productFeatureList2',null);
        component.set('v.productFeatureColumns',null);
            component.set('v.businessImpactOptions',null);
            component.set('v.productAreaOptions',null);
            component.set("v.disableChildPicklist", true);
            component.set("v.showDatatables", false);
            
           
            
            if(component.get('v.modeValue') == 'option1'){
            component.find('businessValueLeverCombobox').set('v.value', null)
           helper.initBusinessValueLevers(component, event, helper);
    	} else {
             component.find('prodBusUnitCombobox').set('v.value', null)
            helper.initProdBusUnit(component, event, helper);
        }
	},
            
})