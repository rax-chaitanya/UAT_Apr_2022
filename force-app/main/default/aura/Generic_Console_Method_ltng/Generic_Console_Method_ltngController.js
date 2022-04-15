({
    onWorkAccepted : function(component, event, helper) { 
       var wItemId = event.getParam('workItemId');
       if(wItemId.substring(0, 3) == '570') {  
    //   	helper.getaccessQuikrPageValues(component, event, helper);
       } 
    },   
    onWorkClosed : function(component, event, helper) {

        console.log('On Closed Event triggered');
        var wItemId = event.getParam('workItemId');
        console.log('On Closed Event Work item ID - '+wItemId);
        if(wItemId.substring(0, 3) == '570') {
            //helper.openRepChatSurveyLEX(component, event);
            helper.getRepChatSurveyValues(component, event, helper);    
        }   

        
    },
    // END CHAT Code Merge
    onChatEnded: function(cmp, evt, hlp) {  
        hlp.onChatEnded(cmp, evt, hlp);
    }
 })