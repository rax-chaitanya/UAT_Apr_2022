({
    
    displaySurveys : function(component, event, recordId, helper) {        
        var SurveyName = component.get("c.displaySurveys");
        SurveyName.setParams({ "accRecordId" : recordId });
        SurveyName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();                  
                if(storeResponse != null){                    
                    component.set("v.surveyList",storeResponse);
                }else{
                    component.set("v.noOPCSurveys",'You have completed all OPC Surveys.');
                }
            }
        });
        $A.enqueueAction(SurveyName);
    },
    checkfridaymethod: function(component){
        var action=component.get("c.checkfriday");
        action.setCallback(this,function(resp){
            var result=resp.getReturnValue();
            component.set("v.checkfriday",result);
        });
        $A.enqueueAction(action);
    }   
})