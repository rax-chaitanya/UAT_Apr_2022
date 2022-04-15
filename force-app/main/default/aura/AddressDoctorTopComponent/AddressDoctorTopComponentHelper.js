({
    updateRecordWithAddress: function(component){
        component.set("v.isRunning", true);
        var addrString = JSON.stringify(component.get("v.initRecord"));
        var saveAction = component.get("c.saveRecord");
        var allSelectedAddress = component.get("v.addressResultSet");
        var allSelectedAddressString =[];
        for(var each of allSelectedAddress){
            allSelectedAddressString.push(each);
        }
        var objectName = component.get("v.sObjectName");
        var type = component.get("v.typeOfAddress");
        saveAction.setParams({ "addressObj" : addrString, "recordId" : component.get("v.recordId"), "addresses" : allSelectedAddressString, "objectName" : objectName, "type" : type });
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse.isError){
                console.log("save done "+storeResponse);
                //component.set('v.hasError', true);
                //component.set('v.errorMessage',storeResponse.message);
                this.showErrorMmodal(component, storeResponse.message);    
                }else{
                var index = component.get("v.indexOfAddress");    
                component.get('v.initialRes')[index].eachAddress.street = storeResponse.updatedAddress.street;
                component.get('v.initialRes')[index].eachAddress.city = storeResponse.updatedAddress.city;
                component.get('v.initialRes')[index].eachAddress.country = storeResponse.updatedAddress.country;
                component.get('v.initialRes')[index].eachAddress.province = storeResponse.updatedAddress.province;
                component.get('v.initialRes')[index].eachAddress.zip = storeResponse.updatedAddress.zip;
                component.get('v.initialRes')[index].eachAddress.ifVerified = storeResponse.updatedAddress.ifVerified;
                component.set("v.showAddrCheck", false);
                component.set("v.showAddress", false);   
    			component.set("v.showSearch", false);
                }    
                //component.set("v.isOpen", false);
                //sforce.one.navigateToSObject(storeResponse);
                
            }
            component.set("v.isRunning", false);
        });
        $A.enqueueAction(saveAction);
    },
    showErrorMmodal : function(cmp, message){
        cmp.set('v.hasError', true);
        cmp.set('v.errorMessage', message);
    },
    showAddress : function(component){
        component.set("v.showAddress", true);   
    	component.set("v.showSearch", false);
        component.set("v.showEdit", false);
    },
    showSearch : function(component){
        component.set("v.showAddress", false);   
    	component.set("v.showSearch", true);
        component.set("v.showEdit", false);
    }
})