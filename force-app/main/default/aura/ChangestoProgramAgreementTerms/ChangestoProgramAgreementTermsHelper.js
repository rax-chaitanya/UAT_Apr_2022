({
    getData : function(component){
        var initialrow = component.get("v.initialRows");
        // console.log(initialrow +'hhhhhh');
        // call apex class method
        var action = component.get("c.getPatRecords");
        action.setParams({
            "initialRows" : initialrow  
        });
        
        
        action.setCallback(this,function(response){
            var state = response.getState();	
            //console.log(response.getReturnValue()+'chappp')
            
            if(state == "SUCCESS"){
                console.log(response.getReturnValue()+'chappp')
                var PatWrapper = response.getReturnValue();
                if(PatWrapper.success){
                    // set total rows count from response wrapper
                    component.set("v.totalRows",PatWrapper.totalRecords);  
                    
                    var patList = PatWrapper.patList;
                    // play a for each loop on list of record and set Record URL in custom 'patName ' field
                    patList.forEach(function(pat){
                        pat.patName = '/partners/s/detail/'+pat.Id;
                    });
                    // set the updated response on accountData aura attribute
                    component.set("v.patData",patList);
                    var initialData = component.get("v.patData");
                    if(initialData.length==0){
                        component.set("v.norecords",true)                        
                    }
                    
                }
                
            }
            else if(state == "ERROR"){
                var errors = response.getError();                
                if (errors) {                    
                    if (errors[0] && errors[0].message) {                        
                        console.log("Error message: " +errors[0].message);                        
                    }                    
                } else {                    
                    console.log("Unknown error");                    
                }                
            }
        });
        $A.enqueueAction(action);
    },
    
    loadData : function(component){
        return new Promise($A.getCallback(function(resolve){
            var limit = component.get("v.initialRows");
            var offset = component.get("v.currentCount");
            var totalRows = component.get("v.totalRows");
            if(limit + offset > totalRows){
                limit = totalRows - offset;
            }
            var action = component.get("c.loadPatRecords");
            action.setParams({
                "rowLimit" :  limit,
                "rowOffset" : offset
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                var newData = response.getReturnValue();
                // play a for each loop on list of new Records and set Record URL in custom 'patName' field
                newData.forEach(function(pat){
                    pat.patName = '/partners/s/detail/'+pat.Id;
                });
                resolve(newData);
                var currentCount = component.get("v.currentCount");
                currentCount += component.get("v.initialRows");
                // set the current count with number of records loaded 
                component.set("v.currentCount",currentCount);
            });
            $A.enqueueAction(action);
        }));
    }
})