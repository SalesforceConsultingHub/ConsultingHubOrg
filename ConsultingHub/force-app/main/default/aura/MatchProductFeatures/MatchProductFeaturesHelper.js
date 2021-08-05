({
	initBusinessPriorityValues : function(component, event, helper) {
    	var action = component.get("c.fetchBusinessPriorities");
        action.setParams({});
        var opts = [];
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                opts.push({
                    class: "optionClass",
                    label: "--- None ---",
                    value: ""
                });
                
                //for each picklist value, create a option
                for (var i = 0; i < allValues.length; i++) {
                    
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]                    
                    });
                }
                component.set("v.businessPriorityValues", opts);
                component.set("v.productFeatureValues", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchBusinessPrioritiesForSelectedCloud : function(component, event, helper) {
        var action = component.get("c.fetchBusinessPrioritiesForSelectedCloud");
        action.setParams({
            selectedVCMCloud : component.get("v.selectedBusinessPriority")
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.businessPrioritiesList", allValues);
                component.set("v.businessPrioritiesListOriginal", allValues);
                component.set("v.businessPrioritiesListSize", allValues.length);
            }
            helper.matchBusinessPriority(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    matchBusinessPriority : function(component, event, helper) {
        var action = component.get("c.matchBusinessPrioritywithProductFeature");
        action.setParams({
            selectedVCMCloud : component.get("v.selectedBusinessPriority"),
            showAll : component.get("v.showAllFeatures")
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.productFeatureList", allValues);
                component.set("v.productFeatureListOriginal", allValues);
                component.set("v.productFeatureListSize", allValues.length);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    //Initialize datatable with columns to be displayed after the search is performed
    initBusinessPriorityDatatable : function(component, event, helper) {
    	component.set('v.businessPrioritiesColumns', [
            {label: 'Business Priority Name', fieldName: 'Name', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Value Lever', fieldName: 'Business_Value_Lever__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Impact', fieldName: 'Business_Impact__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Value Driver', fieldName: 'Business_Value_Driver__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Existing Associations', type: 'button', initialWidth: 150, 
                typeAttributes:{label: { fieldName: 'actionLabel'}, title: 'View Associated Product Features', 
                 				name: 'view_Associations', iconName: 'action:view_relationship', class: 'btn_next'}
            },
            
		]);
    },
    
    //Initialize datatable with columns to be displayed after the search is performed
    initProductFeatureDatatable : function(component, event, helper) {
    	component.set('v.productFeatureColumns', [
            {label: 'Product Feature Name', fieldName: 'Name', type: 'text', sortable: true, wrapText: true},
            {label: 'Business Unit', fieldName: 'Business_Unit__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Product Area', fieldName: 'Product_Area__c', type: 'text', sortable: true, wrapText: true},
            {label: 'Product Sub Area', fieldName: 'Product_Sub_Area__c', type: 'text', sortable: true, wrapText: true}
		]);
    },
    
        
    handleAssociationHelper : function(component, event, helper) {
    	var action = component.get("c.associateBusinessPrioritywithProductFeature");
        action.setParams({
            selectedBusinessPrioritiesIds : component.get("v.selectedBusinessPriorityIds"),
            selectedProductFeatureIds :component.get('v.selectedProductFeatureIds')
        });
        
        //callback method invoked when the Apex controller method finishes executing
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                helper.showToastSuccess(component, event, helper);
            }
            else if (status === "ERROR") {
                helper.showToastGenericError(component, event, helper);
            }
            helper.hideLoader(component, event, helper);
        });
        $A.enqueueAction(action);
        
    },

    
    searchTableBusinessPriorityHelper : function(component, event, helper) {
        var allRecords = component.get("v.businessPrioritiesListOriginal");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        console.log("searchFilter="+searchFilter);
        console.log("searchFilter.length="+searchFilter.length);
        var tempArray = [];
        var i;
        if(searchFilter.length > 0) {
            for(i=0; i < allRecords.length; i++){
                if(	(allRecords[i].Name && allRecords[i].Name.toUpperCase().indexOf(searchFilter) != -1) ||
                    (allRecords[i].Business_Impact__c && allRecords[i].Business_Impact__c.toUpperCase().indexOf(searchFilter) != -1 ) || 
                    (allRecords[i].Business_Value_Lever__c && allRecords[i].Business_Value_Lever__c.toUpperCase().indexOf(searchFilter) != -1 ) ||
                    (allRecords[i].Business_Value_Driver__c && allRecords[i].Business_Value_Driver__c.toUpperCase().indexOf(searchFilter) != -1 ) ||
                    (allRecords[i].VCM_Clouds__c && allRecords[i].VCM_Clouds__c.toUpperCase().indexOf(searchFilter) != -1 )
                 )
                {
                    console.log("Name="+allRecords[i].Name);
                    tempArray.push(allRecords[i]);
                }
            }
            component.set("v.businessPrioritiesList",tempArray);
        } else {
            component.set("v.businessPrioritiesList",component.get("v.businessPrioritiesListOriginal"));
        }
    },
    
    showToastSuccess : function(component, event, helper) {
 		
        component.find('notifLib').showToast({
            "title": "Success!",
            "message": "Records associated successfully!"
        });
    },
    
    //show a generic error message
	showToastGenericError : function(component, event, helper) {
 		
        component.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": "An error occured!"
                
            });
    },
    
    //Show loader 
	showLoader : function(component, event, helper) {
		component.set("v.showLoader", true);
	},
    //Hide loader
    hideLoader : function(component, event, helper) {
		component.set("v.showLoader", false);
	},
    
    handleShowModal: function(component, evt, helper, row) {
        var modalBody;
        $A.createComponent("c:ViewBPPFAssociation",  {
            "bpId": row.Id,
        },
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Existing Associations for " + row.Name,
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal"
                   })
               }
           });
    }
})