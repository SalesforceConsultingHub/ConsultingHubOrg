({
	/* 03/15/2021 - VH - see JS Helper for detailed coments on below methods
    */
	getCurrentStage : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        //alert("recordId="+recordId);
        var action = component.get("c.getCurrentStage");
        action.setParams({"p_recordId": recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				var res = response.getReturnValue();  
				//alert('response='+res[0]);
                component.set("v.currentStage", res[0]);
            }
        });
        
        $A.enqueueAction(action);   
   
	},
})