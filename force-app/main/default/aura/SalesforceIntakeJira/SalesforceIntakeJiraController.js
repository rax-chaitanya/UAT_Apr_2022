({
	openIntakeJiraBoard : function(component, event, helper) {        
        
       var urlval = $A.get("$Label.c.JiraIntakeBoard");;
        window.open(urlval, '_blank');
    }
})