({
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){ 
        /*
        alert('IN Helper');
        var Action = component.get("c.getAllFiles");
        Action.setCallback(this, function(Response) {
            var State = Response.getState();
            var result = Response.getReturnValue();
            //alert('Docs List====='+JSON.stringify(result));
            //alert('State====='+State);
            if (State === "SUCCESS") {
                //alert('in success=====');
                component.set("v.files", result);
                if(result.length <1){
                    component.set("v.isNull", true);
                }
                var Mlevel = JSON.stringify(result[0].Membership_Level__c);
                if(Mlevel != null ){
                    if(Mlevel = "1"){
                    component.set("v.memberShipLevel", 'Elite Partner');
                } else if(Mlevel = "2"){
                    component.set("v.memberShipLevel", 'Executive Partner');  
                }else if(Mlevel = "3"){
                    component.set("v.memberShipLevel", 'Premier Partner');  
                }  else { 
                    component.set("v.memberShipLevel", 'Associate Partner');
                }
                }
                //alert('memberShipLevel====='+component.get("v.memberShipLevel"));
                var pageSize = component.get("v.pageSize");
                var totalRecordsList = result;
                var totalLength = totalRecordsList.length;
                component.set("v.totalRecordsCount", totalLength);
                component.set("v.startPage",0);
                component.set("v.endPage",pageSize-1);
                var PaginationLst = [];
                for(var i=0; i < pageSize; i++){
                    if(totalLength > i){
                        PaginationLst.push(result[i]);    
                    } 
                }
                component.set('v.PaginationList', PaginationLst);
                //alert('PaginationList====='+component.get("v.PaginationList"));
                component.set("v.selectedCount" , 0);
                component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));
            }
        });
        $A.enqueueAction(Action);  
    },
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
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
    },
    // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        //alert('Files in Prevoious====='+JSON.stringify(sObjectList));
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
        */
    }
    
})