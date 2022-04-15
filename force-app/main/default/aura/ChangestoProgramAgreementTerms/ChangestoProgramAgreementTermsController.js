({
    onInit : function(component,event,helper){
        //Setting up column information
        component.set("v.patColums",
                      [
                          {
                              label : 'Community Data Name',
                              fieldName : 'patName',
                              type : 'url',
                              initialWidth: 200,
                              typeAttributes:{label:{fieldName:'Name'}}
                          },
                          {
                              label : 'Description',
                              fieldName : 'Description__c',
                              type : 'text',
                              initialWidth: 450,
                              wrapText: true
                              
                          },
                          {
                              label : 'URL',
                              fieldName : 'URL__c',
                              type : 'url',
                               initialWidth: 450,
                              typeAttributes:{label:{fieldName:'URL__c'},target:'_blank'}
                          },
                          {
                              label : 'Created Date',
                              fieldName : 'CreatedDate',
                              type : 'date-local',
                              typeAttributes:{month:'2-digit',day:'2-digit',year:'numeric'}
                          }
                          
                          
                      ]);
        // Call helper to set the data for account table
        helper.getData(component);
    },
    
    handleLoadMore : function(component,event,helper){
        if(!(component.get("v.currentCount") >= component.get("v.totalRows"))){
            //To display the spinner
            event.getSource().set("v.isLoading", true); 
            //To handle data returned from Promise function
            helper.loadData(component).then(function(data){ 
                var currentData = component.get("v.patData");
                var newData = currentData.concat(data);
                component.set("v.patData", newData);               
                //To hide the spinner
                event.getSource().set("v.isLoading", false); 
            });
        }
        else{
            //To stop loading more rows
            component.set("v.enableInfiniteLoading",false);
            event.getSource().set("v.isLoading", false);
            
        }
    },
    
})