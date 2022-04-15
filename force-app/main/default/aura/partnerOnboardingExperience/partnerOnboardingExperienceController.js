({
	gotoLink : function(component, event, helper) {
		event.preventDefault();
        var linkId = event.target.getAttribute("id");
        var stepnum = 1;
        if(linkId=="registerLeads"){
            stepnum = 2;
        }
        else if(linkId=="trackLeadsAndOpportunities"){
            stepnum = 3;
        }
        else if(linkId=="compensation"){
            stepnum = 4;
        }
        else if(linkId=="enablementResources"){
            stepnum = 5;
        }
        else if(linkId=="caseManagement"){
            stepnum = 6;
        }
        else if(linkId=="support"){
            stepnum = 7;
        }
       
        var switchEvent = $A.get("e.c:switchStep");
        switchEvent.setParams({"onboardStep":"onboarding",
                              "stepNum":stepnum});
        switchEvent.fire();
	}
})