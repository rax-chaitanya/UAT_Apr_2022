({
    doInit : function(component, event, helper) {
        $A.createComponent(
            "c:LibrariesList",
            {
                
            },
            function(newCmp){
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    NavigateComponent : function(component,event,helper) {
        $A.createComponent(
            "c:FoldersList",
            {
                "res" : event.getParam("result"),
                "res1" : event.getParam("resource"),
                "LN" : event.getParam("lib"),
                
            },
            function(newCmp){
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    }
})