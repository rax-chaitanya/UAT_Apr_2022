({
    doInit: function(component, event, helper) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
        
        var idd = component.get("v.idd");
        var playName = component.get("v.playName");
        var name = component.get("v.name");
        var campaignId = component.get("v.campaignId");
        var ownerId = component.get("v.selectedLookUpRecord.Id");
        var WhoId = component.get("v.ContactId");
        var WhatId = component.get("v.CampaignId");
        component.set("v.tsk.Subject", playName);
        component.set("v.tsk.WhoId", WhoId);
        component.set("v.tsk.OwnerId", ownerId);
        component.set("v.tsk.WhatId", WhatId);
        var date = new Date();
        var months = parseInt(date.getMonth())+1;
        var todaysDate = date.getFullYear()+"-"+months+"-"+date.getDate();
        component.set("v.tsk.ActivityDate", todaysDate);  
        helper.fetchPickListVal(component, 'Status', 'status');
        helper.fetchPickListVal(component, 'Type__c', 'taskType');
        helper.fetchPickListVal(component, 'Sub_Type__c', 'subType');
        helper.fetchPickListVal(component, 'Priority', 'priority');
        helper.getCampaignName(component, WhatId, helper);      
        helper.getContactName(component, WhoId, helper);   
        //var comment = component.get("v.CampaignName");
        
    },
    
    saveTask: function(component, event, helper){
        console.log('inside save');
        var whoId = component.get("v.tsk.WhoId");
        var subject = component.get("v.tsk.Subject");  
        var type = component.get("v.tsk.Type");
        var status = component.get("v.tsk.Status");
        var dueDate = component.get("v.tsk.ActivityDate");
        var priority = component.get("v.tsk.Priority");
        var whatId = component.get("v.tsk.WhatId");
        var isReminderSet = component.get("v.tsk.IsReminderSet");
        var reminderDateTime = component.get("v.tsk.ReminderDateTime");
        var rackerParticipating = component.get("v.tsk.Racker_s_Partcipating__c");  
        var comments = component.get("v.tsk.Description");   
        helper.saveTaskHelper(component);
        var workspaceAPI = component.find("workspace");
    },
    closeModel: function(component, event, helper) { 
        component.set("v.isOpen", false);  
    }
})