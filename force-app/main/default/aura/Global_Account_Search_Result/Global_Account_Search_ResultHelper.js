({
	changeChildCheck : function(component, event, helper) {
    	var selectedHeaderCheck = event.target.checked;
    	var completeList =component.get("v.resultListToDisplay");
		var parentChecked = event.target.attributes[2].value;
        for(var i=0;i<completeList.length;i++){
            var t2= JSON.stringify(parentChecked);
            if(JSON.stringify(completeList[i].Company_info.Id) == t2){
                for(var j=0; j<completeList[i].Account_Info.length; j++){
                    var acc = completeList[i].Account_Info[j]; 
                    var childToCheck = document.getElementById(acc.Account_id).checked=selectedHeaderCheck;
                }
            }
        }
    },
    processChildCheck:function(component, event, helper){
        
    	var accountChecked = event.target.checked;
        var completeList = component.get("v.resultListToDisplay");
        if(accountChecked){
            
            
        }else{
            var accId = event.target.attributes[2].value;
           for(var i=0;i<completeList.length;i++){
                for(var j=0; j<completeList[i].Account_Info.length; j++){
                    var childAcc = completeList[i].Account_Info[j]; 
                    if(childAcc.Account_id == accId){
                        document.getElementById(completeList[i].Company_info.Id).checked=false;
                        break;
                    }
                    
                }
            }
        }
        console.log("test",accountChecked);
    }
})