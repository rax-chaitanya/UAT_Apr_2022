({
    doInit : function(component, event, helper) {
        helper.getTheTranscripts(component);
        
        var actions = [
            { label: 'Fill out survey', name: 'open_tab', value : "Id", iconName: 'standard:survey'}
            //,{ label: 'Delete', name: 'delete' }
        ];
        
        component.set(
            'v.mycolumns', 
            [
                {label: 'Chats', fieldName: 'Name', type: 'text', initialWidth: '30%', typeAttributes : { linkify : true} },            
                {label: 'Days Since Chat', fieldName : 'TimeSinceChat__c', type: 'text' , intialWidth: '52%', cellAttributes : {}},
                {label: 'Action', fieldName: 'Id', type: 'action', initialWidth: '12%', typeAttributes : { rowActions: actions }}
            ]);   
        
    },
    
    handleRowAction	: function(component, event, helper) {
        var action = event.getParam("action");
        console.log(action.name);
        var row = event.getParam('row');
        
        var selectedRows = event.getSource().get("v.fieldName");
        
        switch (action.name) {
            case 'open_tab'	: 
                let workspaceAPI = component.find("workspace");
                workspaceAPI.openTab({
                    recordId: row.Id,
                    focus: true
                }).then(function(response) {
                    
                    var toast = $A.get("e.force:showToast");
                    toast.setParams({
                        mode	: "pester",
                        type	: "info",
                        title : "Complete the post chat fields.",
                        message	: "Please complete."  
                    });
                    toast.fire();
                })
                .catch(function(error) {
                    console.log('ERROR!!!: ' + error);
                });    
                break;
        }
        
    },
    
    onfocus	: function(component, event, helper) {
        alert("I am on focus");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        console.log("getting the transcripts");
        //$A.get('e.force:refreshView').fire();
        helper.getTheTranscripts(component);
    },
    
    
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getSource();
        // Display that fieldName of the selected rows
        //for (var i = 0; i < selectedRows.length; i++){
        //alert("You selected: " + selectedRows[i].opportunityName);
        //}
    }
})