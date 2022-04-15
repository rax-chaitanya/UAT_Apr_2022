({    
    getDocList: function(component,event) {
        var action;      
        var attributeValue = component.get("v.res");  
        var splitValues = attributeValue.split('-');  
        if(splitValues.length>0){			         
            if(splitValues[0] != 'null'){ 
                action = component.get('c.getFolderData');
                action.setParams({ parentFolderId : splitValues[0]});
            }
            else{ 
                action = component.get('c.getContentDocument');
                action.setParams({ parentId : splitValues[1] });
            }
        }
        //else
        //{
        // action = component.get('c.getFolderData');
        // action.setParams({ parentFolderId : attributeValue1});
        //}
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.docs1', actionResult.getReturnValue());            
            
        });
        $A.enqueueAction(action);        
    },
    getVideosList: function(component,event) { 
        var action;           
        action = component.get('c.recentVideos');
        action.setCallback(this, function(actionResult) {
            component.set('v.docs3', actionResult.getReturnValue());            
            
        });
        $A.enqueueAction(action);        
    }       
    
})