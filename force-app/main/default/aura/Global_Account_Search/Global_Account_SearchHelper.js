({
initData : function(component) {
    
    var initData = component.get('c.getInitData');
    initData.setCallback(this, function(response){
        this.hideSpinner(component);

        console.log( 'chap getReturnValue'+response.getReturnValue());
        console.log( 'Data - ' + JSON.stringify( response.getReturnValue() ) );
        console.log( 'chap response'+response.getState());
        if(response.getState() == 'SUCCESS'){
            var returnValue = response.getReturnValue();
            component.set("v.ReasonOptions", returnValue.Reasons);
            component.set("v.showWarning", returnValue.showWarning);
            component.set("v.warningMessage", returnValue.warningMessage);
            component.set("v.today", returnValue.Today);
            component.set("v.isValidUser", returnValue.isValidUser);
            //component.set("v.Type", returnValue.Type);
            //
            //SFDC-7193 Commented Type and added owner region,owner sub region and Industry from init method to component variables
            console.log( 'chap'+returnValue.OwnerRegion);
            component.set("v.OwnerRegion", returnValue.OwnerRegion);
            //component.set("v.OwnerSubRegion", returnValue.OwnerSubRegion);
            component.set("v.RegiontodependentSubRegion", returnValue.RegiontodependentSubRegion);              
            component.set("v.Industry", returnValue.Industry);
            
            if(!returnValue.isValidUser){
                component.set("v.showWarning", true);
                component.set("v.warningMessage", 'You do not have access to this app.');
            }
        }
    });
    $A.enqueueAction(initData);
},

getSearchResults : function(component,event,helper) {
    var acName= component.get("v.accountName");
    var acNumber= component.get("v.accountNumber");
    acNumber = acNumber.replace(/\s/g, "");
    //var accType = component.get("v.accountType");
    //SFDC-7193 Commented Type and added owner region,owner sub region and Industry to pick data and search 
    //   
    //var accOwnerRegion = component.get("v.accountOwnerRegion");
    var accOwnerRegion;
    if(component.find('ownerRegion').get('v.value') == 'APJ'){
            accOwnerRegion = 'APAC'; // adding this due to difference for owner region api and lable on user object for APJ
    }else accOwnerRegion = component.get("v.accountOwnerRegion");
    console.log( 'chap while sending data to apex---'+accOwnerRegion);
    //var accOwnerSubRegion = component.get("v.accountOwnerSubRegion");
    var accOwnerSubRegion = component.get("v.accountOwnerSubRegion");
    accOwnerSubRegion = accOwnerSubRegion.replace(/\s+/g, '_');
    console.log( 'chap while sending data to apex accOwnerSubRegion---'+accOwnerSubRegion);
    var accIndustry = component.get("v.accountIndustry");

    var acOwner;
    var matchingAccounts = component.get("v.matchingAccounts");
    if(component.get("v.accountOwner")!=null && component.get("v.accountOwner")!=''){
        
        acOwner = component.get("v.accountOwner");
        //alert(acOwner);
    }
    var resultintCount=0;

    
    //if($A.util.isEmpty(acName) && $A.util.isEmpty(acNumber) && $A.util.isEmpty(accType) && $A.util.isEmpty(acOwner)){  
    //SFDC-7193  Updated below if condition to check Acc owner region instead of Acc type 
        if($A.util.isEmpty(acName) && $A.util.isEmpty(acNumber) && $A.util.isEmpty(accOwnerRegion) && $A.util.isEmpty(acOwner)){   

        var message = 'Please enter value in filter to search for Companies';//SFDC-7193 Replace account with company
        var title = 'Error';
        var type='error';
        this.showMessage(component,type,title,message);
    }
    //else if(!$A.util.isEmpty(accType) && $A.util.isEmpty(acOwner)){   
    //SFDC-7193  Updated below if condition to check accname is mandatory if acc owner region is selected
    // instead of accowner when acctype is selected,also update error message
   /* else if(!$A.util.isEmpty(accOwnerRegion) && $A.util.isEmpty(acName) && $A.util.isEmpty(acOwner)){ 
        var message = 'If Company Owner Region is selected Please enter value in Company Name or Company Owner to search for Companies';
        var title = 'Error';
        var type='error';
        this.showMessage(component,type,title,message);
        // SFDC-7193 Commented below and updated to set Acc name is mandatory when acc owner region is selected
        // component.set("v.accountOwnerMandatory", true);
        component.set("v.accountNameMandatory", true);

        
    }*/ //commented on Mohamed req

    else if( (!$A.util.isEmpty(accOwnerRegion) ) 
    && $A.util.isEmpty(acName)
     && $A.util.isEmpty(acOwner)
     && ($A.util.isEmpty(accIndustry) || $A.util.isEmpty(accOwnerSubRegion))
     && $A.util.isEmpty(acNumber)

     ){
        var message = 'Owner Sub-region and Industry are mandatory if Owner Region is selected or Use Company name, Company Number with Owner Region to search for Companies';
        var title = 'Error';
        var type='error';
        this.showMessage(component,type,title,message);

    }
        else{
                // SFDC-7193 Commented below and updated to remove accName mandatory false if all conditions are not satisfied
            //component.set("v.accountOwnerMandatory", false);
            component.set("v.accountNameMandatory", false);
            var action = component.get("c.getSearchResults");
            var accountNumbers = acNumber.split(',');
            if(!$A.util.isEmpty(accOwnerRegion) && !$A.util.isEmpty(accOwnerSubRegion) &&!$A.util.isEmpty(accIndustry))
            { resultintCount = $A.get("$Label.c.GAR_Initial_Search_Count");}
            
            action.setParams({
                "accName" : acName,
                "accNumbers" : accountNumbers,
                //"accType" : accType,//SFDC-7193 Commented to not send accType as Param since it is not required anymore
                //and added owner region,owner sub region,acc industry
                "accOwnerRegion": accOwnerRegion,
                "accOwnerSubRegion": accOwnerSubRegion,
                "accIndustry": accIndustry,
                "accOwner" : acOwner,
                "matchingAccounts" : matchingAccounts,
                "recLimit" : resultintCount,

            });
            action.setCallback(this,function(response){
                this.hideSpinner(component);
                if(response.getState() == 'SUCCESS'){
                    
                    if($A.util.isEmpty(response.getReturnValue())){
                        var message = 'No search results found with your search criteria. Please search again with different criteria'
                        var type = 'info';
                        var title = 'Information';
                        this.showMessage(component,type,title,message);
                        //SFDC-7193 Commented below that are making values null when no search results are not returned
                        /* component.set("v.accountName",'');
                        component.set("v.accountNumber",'');
                        component.set("v.selectedLookUpRecord",null);
                        component.set("v.accountOwner",'');*/
                        component.set("v.resultList",null);
                        component.set("v.Show_Result",false);
                        
                    }
                    else{
                        var returnValue = response.getReturnValue();
                        console.log('success data....'+returnValue);
                        component.set("v.Show_Result",true);
                        component.set("v.resultList",returnValue.result);
                        component.set("v.resultCount",returnValue.count);
                        component.set("v.totalresultCount",returnValue.totalCount);//SFDC-7420

                        component.set("v.missingAccounts", returnValue.missingAccounts);
                    }
                }else{
                    var message = 'Error while accessing results. Please contact System Administrator'
                    var type = 'error';
                    var title = 'Error';
                    this.showMessage(component,type,title,message);
                }
            });
            $A.enqueueAction(action);
            this.showSpinner(component);
        }
},
handleSelectedAccounts : function(component, event, helper, requestItems, skippedRequestItems) {
    //alert('selected accounts length'+acountIds.length);
    var processAction = component.get("c.processRealignmentRequest");
    processAction.setParams({"requestItems" : requestItems});
    processAction.setCallback(this, function(response){
        this.hideSpinner(component);
        if(response.getState() == 'SUCCESS'){
            var returnValue = response.getReturnValue();
            var result = [];
            result.push.apply(result, skippedRequestItems);
            result.push.apply(result, returnValue);
            component.set("v.realignmentRequetItems", result);
        }
        else{
            var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    alert("Error message: " + 
                            errors[0].message);
                }
            } else {
                console.log("Unknown error");
            }
        }
    });
    $A.enqueueAction(processAction);
    this.showSpinner(component);
},

isAnyRecordSelected : function(component){
    var result = component.get("v.resultList");
    for(var companyIndex in result){
        var company = result[companyIndex];
        if(company.selected){
            return true;
        }
        company.selected = false;
        for(var accountIndex in company.Account_Info){
            var account = company.Account_Info[accountIndex];
            if(account.selected){
                return true;
            }
        }
    }
    return false;
},
showSpinner : function(component){
    component.set("v.showSpinner", true)
},

hideSpinner : function(component){
    component.set("v.showSpinner", false)
},
showMessage : function(component,type,title,msg){
    $A.createComponent(
        "c:GAR_Notice",
        {
            "message": msg
        },
        function(newNotice, status, errorMessage){
            //Add the new button to the body array
            if (status === "SUCCESS") {
                var notice = component.find('notice');
                var body = notice.get("v.body");
                while(body.length>0){
                    var cmp = body.pop();
                    cmp.destroy();
                }
                body.push(newNotice);
                notice.set("v.body", body);
            }
        }
    );
},
})