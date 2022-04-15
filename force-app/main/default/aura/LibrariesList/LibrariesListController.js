({
    doInit: function(component,event,helper) {      
        helper.getLibraries(component);
    },
    GoToLibrary : function(component, event, helper) {
        var LibName = event.target.id;
        var a = event.currentTarget.dataset.val;
        var c;
        var b= a.split('-');
        if(b.length>0){			         
            if(b[0] != 'null'){ 
                c= b[0];
            }
            else{
                c = a;
            }
        } 
        var evt = $A.get("e.c:LibrariesEvent");
        evt.setParams({ 
            "result": a,
            "resource":c,
            "lib":LibName
        });        
        evt.fire();
    }
})