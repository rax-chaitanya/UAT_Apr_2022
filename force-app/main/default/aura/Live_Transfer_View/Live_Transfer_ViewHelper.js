({  
    // Fetch the users from the Apex controller
    getUsersList: function(component,event,QueueId,counter) {
        var action = component.get('c.getUsers');
        action.setParams({
            groupID: QueueId,
            counter: counter
        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                
                component.set('v.UsersList', actionResult.getReturnValue());
                var userList = actionResult.getReturnValue();
                this.getNextUser(component,event,userList,counter);
                
            }
        });
        $A.enqueueAction(action);
    },
    updateOwner: function(component,event,UserID,LeadId,queueID) {
        //var queueDetail = component.get("v.selectedLookUpRecord");
        console.log("queueDetail "+queueID);
        var action = component.get('c.updateOwner');
        action.setParams({
            UserID:UserID,
            LeadID:LeadId,
            queueId:queueID
        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                alert('Live Transfer Successful');
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } else if(state == 'ERROR') {
                alert('Error while updating Lead Owner - '+JSON.stringify(actionResult.getError()));  
            }
        });
        $A.enqueueAction(action);
    },
    toggleSpinner: function (component,event) {
        console.log('Spinner Loaded');
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    updateUserStatus: function (component,event,UserID){
        var action = component.get('c.updateUserStatus');
        action.setParams({
            userId:UserID,
        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                var counter = component.get("v.counter");
                var userList = component.get("v.UsersList");
                counter = counter + 1;
                component.set("v.counter",counter); 
                this.getNextUser(component,event,userList,counter);
            } else if(state == 'ERROR') {
                alert('Error while updating status - '+JSON.stringify(actionResult.getError()));  
            }
        });
        $A.enqueueAction(action);
    },
    getNextUser: function(component,event,userList,counter){
        if(userList.length>counter){ 
            component.set("v.checked",true);
            component.set("v.displayResult",true);
            component.set("v.hasNext", false);
        } else {
            component.set("v.displayResult",false);
            component.set("v.hasNext", true);
        }
        component.set('v.User',userList[counter]);
    }
})