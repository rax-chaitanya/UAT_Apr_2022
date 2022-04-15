({
	doInit : function(component, event, helper) {
       
        var accountNumber = component.get("v.accountNumber");
        var action = component.get("c.getAccountId");
        action.setParams({"accNumber":accountNumber});
        
          if(accountNumber == null || accountNumber == ''){
           window.location='/one/one.app';
              return;
          }else{
             action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                
                var returnVal = response.getReturnValue();
                if(returnVal == null){
                    alert('Account has not been found with Account Number '+accountNumber);
                window.location='/one/one.app';
                }else{
                        window.location = '/one/one.app#/sObject/' + returnVal +'/view';
                   }
                
            } 
        });
        $A.enqueueAction(action);  
          }
        
       
    }})