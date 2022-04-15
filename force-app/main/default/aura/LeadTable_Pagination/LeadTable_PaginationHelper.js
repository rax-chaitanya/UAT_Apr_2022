({
	/*
     * Initially this Method will be called and will fetch the records from the Salesforce Org 
     * Then we will hold all the records into the attribute of Lightning Component
     */
    doFetchLead : function(component) {              
        // this function call on the component load first time     
        // get the page Number if it's not define, take 1 as default
        var page = component.get("v.page") || 1;
        var pageSize = component.get("v.pageSize");
        // get size of all the records and then hold into an attribute "totalRecords"
        component.set("v.totalRecords", component.get("v.LeadData").length);
        // set star as 0
        component.set("v.startPage",0);        
        component.set("v.endPage",pageSize-1);
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(component.get("v.LeadData").length> i)
                PaginationList.push(component.get("v.LeadData")[i]);    
        }
        component.set('v.PaginationList', PaginationList);
        component.set('v.isSending',false);	        
        component.set("v.page", page);         
        component.set("v.pages", Math.ceil(component.get("v.LeadData").length / pageSize));
    },
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component, event){
        var page = component.get("v.page") || 1;
        var direction = event.getSource().get("v.label");
        page = direction === "Previous" ? (page - 1) : (page + 1);
        
        var sObjectList = component.get("v.LeadData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        
        component.set("v.page", page);
        component.set("v.pages", Math.ceil(component.get("v.LeadData").length / pageSize));
        
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){          
        var page = component.get("v.page") || 1;
        var direction = event.getSource().get("v.label");
        page = direction === "Previous" ? (page - 1) : (page + 1);        
        
        var sObjectList = component.get("v.LeadData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        
        component.set("v.page", page);         
        component.set("v.pages", Math.ceil(component.get("v.LeadData").length / pageSize));
    }
})