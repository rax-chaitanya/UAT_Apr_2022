({
    getMenu : function(component,event) {
        var action;
        var a=component.get("v.menu");               
        var b= a.split('-');
        if(b.length>0){			         
            if(b[0] != 'null'){ 
                 action = component.get('c.getFoderNames');
                 action.setParams({ rootID : a});  
            }
            else{
                action = component.get('c.getLibraryNames');
        		action.setParams({ libraryID : b[1]});  
            }
        }       
          
        action.setCallback(this, function(actionResult) { 
            var custs = [];
            var conts = actionResult.getReturnValue(); 
            for(var key in conts){
                custs.push({value:conts[key], key:key});
            }
            component.set('v.menuitems', custs);            
            
        });
        $A.enqueueAction(action); 
    }
})