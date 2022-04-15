({
    doInit: function(component, event, helper) {      
    }, 
    assignLead: function(component, event, helper) {
        var queueDetail = component.get("v.selectedLookUpRecord");
        // Prevent the form from getting submitted
        event.preventDefault();
        // Get the value from the field that's in the form
        var UserID = event.target.getElementsByClassName('assign-user-Id')[0].value;
        var userName = event.target.getElementsByClassName('assign-user-Name')[0].value;
        var LeadId = component.get("v.recordId");
        if(confirm('Confirm lead assignment to the user - ' + userName)) {
            helper.updateOwner(component,event,UserID,LeadId,queueDetail.Id);   
        }
        
    },
    handleRecordSelect: function(component, event, helper) {
        var queueDetail = component.get("v.selectedLookUpRecord");
        component.set("v.counter",0);
        var counter = component.get("v.counter");
        helper.getUsersList(component,event,queueDetail.Id,counter); 
    },
    next: function(component, event, helper) {
        var queueDetail = component.get("v.selectedLookUpRecord");
        var counter = component.get("v.counter");
        var userList = component.get("v.UsersList");
        counter = counter + 1;
        component.set("v.counter",counter); 
        helper.getNextUser(component,event,userList,counter);
    },
    doUpdateStatus : function(component, event, helper) {
        event.preventDefault();
            var UserID = component.find("toggle").get("v.value");
            helper.updateUserStatus(component,event,UserID);
    }
})