({
    doInit : function(component, event, helper) {
         
                               
    }, 
    onTabCreated : function(component, event, helper) {
        setTimeout(function(){helper.openNewTab(component, event, helper)}, 1000);
    }, 
    onTabUpdated : function(component, event, helper) {
        setTimeout(function(){helper.newRefreshed(component, event, helper)}, 1000);
    },
    onTabClosed : function(component, event, helper) {
    }, 
    onTabFocused : function(component, event, helper) {
    },
    onTabRefreshed : function(component, event, helper) {
    }, 
    onTabReplaced : function(component, event, helper) {        
    },
    onAgentSend : function(component, event, helper) {
    }, 
    onChatEnded : function(component, event, helper) {
    },
    onCustomEvent : function(component, event, helper) {
    }, 
    onNewMessage : function(component, event, helper) {
    },
    onStatusChanged : function(component, event, helper) {
    }, 
    onLogout : function(component, event, helper) {
    },
    onWorkAssigned : function(component, event, helper) {
    }, 
    onWorkAccepted : function(component, event, helper) {
    },
    onWorkDeclined : function(component, event, helper) {
    }, 
    onWorkClosed : function(component, event, helper) {
    },
    onWorkloadChanged : function(component, event, helper) {
    }, 
    onLoginSuccess : function(component, event, helper) {
    }
})