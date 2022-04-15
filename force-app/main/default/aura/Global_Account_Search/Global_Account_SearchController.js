({
    doInit : function(component, event, helper) {
        //document.getElementById('show').style.display = 'none';
        component.set("v.Show_Result",false);
        component.set("v.missingAccounts",false); //2943 // SFDC-7193 aded owner region,owner sub region and owner industry
        var cols = [
            "",
            "Account Name",
            "Account #",
            "Account type",
            "Account Owner Region",
            "Account Owner Sub Region",
            "Account Industry",
            "Billing Country",
            "Current Account Owner Name",
            "Current Account Owner Role",
            "Active/InActive",
            "New Account Owner",
            "New Account Owner Role",
            "Reason To Move",
            "Move Date",
            "Validation Comments"
            
        ];
        component.set("v.columns",cols);
        helper.initData(component);
    },
    handleRecordSelect: function(component,event,helper){
        var user = component.get("v.selectedLookUpRecord");
        var userId;
        if(!$A.util.isEmpty(user)){
            userId = String(user.Id);
        }
        component.set("v.accountOwner",userId);
    },
    search: function(component, event, helper) {
        //document.getElementById('show').style.display = 'block';
        helper.getSearchResults(component,event,helper);
        
    },
    process: function(component, event, helper) {
        console.log("entered on process");
        var result = component.get("v.resultList");
        var requestItems = [];
        var requestItemsToDisplay = [];
        var skippedRequestItems = [];
        var hasErrors = false;
        var hasDateError = false;
        var hasSameOwner = false;
        //var today = new Date();
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        for(var companyIndex in result){
            var company = result[companyIndex];
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                if(account.selected){
                    
                    var realignmentRequestItem = {};
                    realignmentRequestItem.sobjectType = 'Realignment_Request_Item__c';
                    realignmentRequestItem.Account__c = account.Account_id;
                    realignmentRequestItem.New_Account_Owner__c = account.Request_Item_New_Owner != null ? account.Request_Item_New_Owner.Id : null;
                    realignmentRequestItem.New_Account_Owners_Manager__c = account.Request_Item_New_Owner.ManagerId != null ? account.Request_Item_New_Owner.ManagerId : null;
                    realignmentRequestItem.Previous_Account_Owner__c = account.Account_Current_Owner != null ? account.Account_Current_Owner.Id : null;
                    realignmentRequestItem.Previous_Account_Owners_Manager__c = account.Account_Current_Owner != null && account.Account_Current_Owner.ManagerId != null ? account.Account_Current_Owner.ManagerId : null;
                    realignmentRequestItem.Reason_for_Move__c = account.Request_Item_Reason;
                    realignmentRequestItem.Validation_Comments__c = account.Request_Item_Validation;
                    realignmentRequestItem.Move_Date__c = account.Request_Item_Move_Date;
                    realignmentRequestItem.Request_Status__c = 'New';                    
                    realignmentRequestItem.Opportunity_Updation_Flag__c = account.opportunityUpdation;
                    
                    account.Is_Request_Item_Move_Date = false;
                    account.Is_Request_Item_New_Owner_Blank = false;
                    account.Is_Request_Item_Reason_Blank = false;
                    if($A.util.isEmpty(realignmentRequestItem.New_Account_Owner__c)){
                        hasErrors = true;
                        account.Is_Request_Item_New_Owner_Blank = true;
                    }
                    if($A.util.isEmpty(realignmentRequestItem.Reason_for_Move__c)){
                        hasErrors = true;
                        account.Is_Request_Item_Reason_Blank = true;
                    }
                    
                    if($A.util.isEmpty(realignmentRequestItem.Move_Date__c) || realignmentRequestItem.Move_Date__c < today){
                        hasDateError = true;
                        account.Is_Request_Item_Move_Date = true;
                    }
                    if(realignmentRequestItem.New_Account_Owner__c == realignmentRequestItem.Previous_Account_Owner__c){
                        //realignmentRequestItem.Not_Processed = true;
                        realignmentRequestItem.Validation_Comments__c = 'Current Owner and New Owner are the same, record will be auto processed.';
                    }
                    var requestItemString = JSON.stringify(realignmentRequestItem);
                    var requestItemCopy = JSON.parse(requestItemString);
                    requestItemCopy.Account__r = {'Id' : realignmentRequestItem.Account__c, 'sobjectType' :'Account', 'Name' : account.Account_Name};
                    requestItemCopy.New_Account_Owner__r = {'Id' : realignmentRequestItem.New_Account_Owner__c, 'sobjectType' :'User', 'Name' : account.Request_Item_New_Owner != null ? account.Request_Item_New_Owner.Name : null};
                    requestItemCopy.Previous_Account_Owner__r = {'Id' : realignmentRequestItem.Previous_Account_Owner__c, 'sobjectType' :'User', 'Name' : account.Account_Current_Owner != null ? account.Account_Current_Owner.Name : null};
                   
                    // Commented the below code as part of SFDC-7321 - starts
                   /*if(realignmentRequestItem.Not_Processed){
                        requestItemCopy.Request_Status__c = 'Not Processed';
                        requestItemCopy.Validation_Comments__c = 'Current Owner and New Owner are the same, record will not be processed.';
                        skippedRequestItems.push(requestItemCopy);
                    }
                    else{
                        requestItems.push(realignmentRequestItem);
                        requestItemsToDisplay.push(requestItemCopy);
                    } */
                     // Commented the below code as part of SFDC-7321 - ends
                    requestItems.push(realignmentRequestItem);
                    requestItemsToDisplay.push(requestItemCopy);
                }
            }
        }
        
        if(requestItems.length<1 && skippedRequestItems.length<1){
            var message = 'Please choose at least one Account to process the request.';
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);
        }else if(hasErrors){
            component.set("v.resultList",result);
            var message = 'One or more selected accounts have required fields missing.';
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);
        }else if(hasDateError){
            component.set("v.resultList",result);
            var message = 'Move Date should not be past date.' ;
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);
        }else{
            var result = [];
            result.push.apply(result, skippedRequestItems);
            result.push.apply(result, requestItemsToDisplay);
            component.set("v.realignmentRequetItems", result);
            
            component.set("v.showProcessingResult", true);
            if(requestItems.length>0){
                helper.handleSelectedAccounts(component, event, helper, requestItems, skippedRequestItems);
            }
        }
    },
    
    clear:function(component, event, helper) {
        console.log('clear');
        helper.showSpinner(component);
        component.set("v.accountName",'');
        component.set("v.accountNumber",'');
        component.set("v.selectedLookUpRecord",null);
        component.set("v.resultList",null);
        component.set("v.Show_Result",false);
        component.set("v.accountOwner",'');
        //component.set("v.accountType",'');
        //SFDC-7193
        component.set("v.accountOwnerRegion", '');
        component.set("v.accountOwnerSubRegion", '');
        component.set("v.accountIndustry", '');
        //SFDC-7193
        component.set("v.matchingAccounts",false);
        helper.hideSpinner(component);
        
    },
    handleProcessResultChange : function(component, event, helper){
        var showProcessingResult = component.get("v.showProcessingResult");
        if(!showProcessingResult){
            $A.enqueueAction(component.get("c.clear"));
        }
    },
    enterPress : function(component, event, helper){
        if (event.getParams().keyCode == 13) {
            $A.enqueueAction(component.get("c.process"));
        }
    },
    
    selectAll : function(component, event, helper){
        var result = component.get("v.resultList");
        for(var companyIndex in result){
            var company = result[companyIndex];
            company.selected = true;
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                account.selected = true;
            }
        }
        component.set("v.resultList", result);
    },
    
    selectMatching : function(component, event, helper){
        var result = component.get("v.resultList");
        for(var companyIndex in result){
            var company = result[companyIndex];
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                if(account.isSearchResult){
                    account.selected = true;
                }
            }
        }
        component.set("v.resultList", result);
    },
    
    clearAll : function(component, event, helper){
        var result = component.get("v.resultList");
        for(var companyIndex in result){
            var company = result[companyIndex];
            company.selected = false;
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                account.selected = false;
            }
        }
        component.set("v.resultList", result);
    },
    
    openMassOwnerAssignmentModal : function(component, event, helper){
        if(!helper.isAnyRecordSelected(component)){
            var message = 'Please select one or more Companies to assign new Owner/Reason/Move Date.';//SFDC-7193 Changed Account to Company
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);
        }else{
            component.set("v.showMassOwnerAssignmentModal", true);
        }
    },
    
    // handleaAccountTypeChange : function(component, event, helper){
    //     if(!$A.util.isEmpty(component.get("v.accountType"))){
    //         component.set("v.matchingAccounts", true);
    //         component.set("v.matchingAccountsDisabled", true);
    //     }
    //     else{
    //         component.set("v.matchingAccounts", false);
    //         component.set("v.matchingAccountsDisabled", false);
    //     }
    // },
    //SFDC-7193 commented function to use below resuable function(handleAccountInputs) for owner region,owner sub region and industry changes
    
      handleAccountInputs: function (component, event, helper) {
        var parentRegion = component.find('ownerRegion').get('v.value');
        console.table(parentRegion);
        component.set('v.OwnerSubRegion', component.get('v.RegiontodependentSubRegion')[parentRegion]);
         // if(!$A.util.isEmpty(component.get("v.accountOwnerRegion"))) 
         if(parentRegion!='')          
          {
            //   if(parentRegion=='APJ') {
            //     component.set('v.accountOwnerRegion', 'APAC');
            //   }else  component.set('v.accountOwnerRegion', parentRegion);
             console.log('region selected and OwnerSubRegionDisabled Visible',component.find('ownerRegion').get('v.value')); 
             component.set("v.OwnerSubRegionDisabled", false);

          }else
          {
              console.log('region deselected and OwnerSubRegionDisabled Not visible');
              component.set("v.OwnerSubRegionDisabled", true);

          }
        if (!$A.util.isEmpty(component.get("v.accountType")) ||
            !$A.util.isEmpty(component.get("v.accountOwnerRegion")) ||
           ( !$A.util.isEmpty(component.get("v.accountOwnerRegion")) && !$A.util.isEmpty(component.get("v.accountOwnerSubRegion"))) ||
            !$A.util.isEmpty(component.get("v.accountIndustry"))
        ) {
            console.log('matchingAccounts made mandatory'); 
            component.set("v.matchingAccounts", true);
            component.set("v.matchingAccountsDisabled", true);
        }
        else {
            console.log('matchingAccounts made not mandatory'); 
            component.set("v.matchingAccounts", false);
            component.set("v.matchingAccountsDisabled", false);
        }
    },  
    
    
})