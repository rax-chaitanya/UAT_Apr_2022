({
    doInit : function(component, event, helper) {
        //helper.doInitHelper(component, event);
        //alert('doInit calling');   
         var Action = component.get("c.getAllFiles");
        //alert('doInit getAllFiles');   
        Action.setCallback(this, function(Response) {
            var State = Response.getState();
            var result = Response.getReturnValue();
            if(result == null){
                component.set("v.isNull", true);
            }
            //alert('isNull====='+component.get("v.isNull"));
            //alert('List====='+result) 
            //alert('Docs List====='+JSON.stringify(result)) 
            if (State === "SUCCESS") { 
                component.set("v.files", result);
                console.log('Docs List====='+JSON.stringify(result));
                console.log('ContentDocumentId'+JSON.stringify(result[0].ContentDocumentid));
            }
        });
        $A.enqueueAction(Action);
        
        
    },
    closeWinow : function(cmp, event) {
        // alert('calling closeWinow') 
        var cmpEvent = cmp.getEvent("logosEvent");
        cmpEvent.setParams({
            isOpenWindow:false
        });
        cmpEvent.fire();
        //alert('firing close window event') 
    },
    /* javaScript function for pagination 
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.files");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },*/
})