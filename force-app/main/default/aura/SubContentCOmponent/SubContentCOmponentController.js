({
    openSingleFile: function(component, event, helper) {     
        var documentId = component.get("v.Docitem").fileId;    
        $A.get('e.lightning:openFiles').fire({            
            recordIds: [documentId]
        });
    },
})