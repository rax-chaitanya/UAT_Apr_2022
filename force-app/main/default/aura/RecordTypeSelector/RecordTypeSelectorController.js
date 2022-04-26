({
    selectRecordType : function(component, event, helper) {        
        
        var typeId=event.target.id;        
        var createRecordEvent = $A.get("e.force:createRecord");  
        createRecordEvent.setParams({  
            "entityApiName" : "Case",  
            "recordTypeId" : typeId  
        });  
        createRecordEvent.fire(); 
    }, 
    // New code here
    openIntakeBoard : function(component, event, helper) {        
        
        var urlval = $A.get("$Label.c.JiraIntakeBoard");;
        window.open(urlval, '_blank');
    }, 
    
})