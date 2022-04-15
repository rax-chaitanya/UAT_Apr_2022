({
    doInit: function(component,event,helper) {      
        helper.getDocList(component);
        helper.getVideosList(component);
    },
    openSingleFile: function(component, event, helper) {        
        var documentId = component.get("v.document").Id; 
        $A.get('e.lightning:openFiles').fire({            
            recordIds: [documentId]
        });
    },
    GoTofolder : function(component, event, helper) {
        
        var a = event.currentTarget.dataset.val;
        var b = component.get("v.res1");   
        var evt = $A.get("e.c:LibrariesEvent");
        evt.setParams({ "result": a});
        evt.setParams({ "resource": b});
        evt.fire();
    },
})