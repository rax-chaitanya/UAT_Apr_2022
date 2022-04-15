({
    doInit: function(component,event,helper) {      
        helper.getMenu(component);
    },
    GoTofolder : function(component, event, helper) { 
        var a = event.currentTarget.dataset.val;
        var LName = event.target.id;
        var folderId ;
        if(!a.includes('null') && a.includes('-')){
            var keySize = a.split('-').length; 
            var ids = a.split('-'); 
            folderId = ids[keySize-1];
            
        }
        else{
            folderId = a;
        }  
        var evt = $A.get("e.c:LibrariesEvent");
        evt.setParams({ "result": folderId});
        evt.setParams({ "resource": a});
        evt.setParams({"lib":LName});
        evt.fire();
    },
    GoToHomePage:function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/marketing-toolkit'  
        });
        urlEvent.fire();
    }
})