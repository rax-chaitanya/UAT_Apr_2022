({
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @Slack Developer Tools (Legacy)   :    Diego Castro
    // @date        :    01/06/2018
    // @story       :    Lightning Migration Epic for 02/19/17 release
    // @description :    navigates to the CW Wizard. clicked from a quick action button on an opportunity
    // 					 record page ("Close/Won")
    //@story: SFDC-7006, @Dev: Atheer Bdaiwi, @description: Auto DDI - added RBU to Contract Received message, @date: 03 Feb 22.
    //////////////////////////////////////////////////////////////////////////////////////////////////
    navigateToURL : function(component, event) {
        console.log("navigating to URL");
        //close the hijacked quick action
        $A.get("e.force:closeQuickAction").fire();
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/apex/OpportunityCloseWonWizard?id=" + component.get("v.recordId")
        });
        urlEvent.fire();
    },
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @Slack Developer Tools (Legacy)   :    Diego Castro
    // @date        :    01/06/2018
    // @story       :    Lightning Migration Epic for 02/19/17 release
    // @description :    at the time of writing this, there was no global value provider to pull user info.
    // 					 this means that any user info (like Profile Id) must be grabbed from a server trip.
    // 					 this method grabs user info that pertains to validating whether or not a given user
    // 					 will be able to get to the CW wizard.
    // 					 - related apex class: NavigateCWWizardController.apxc
    //////////////////////////////////////////////////////////////////////////////////////////////////
    getUserInfo : function(component, resolve, reject) {
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.user", response.getReturnValue() );
                if(resolve) {
                    console.log('resolving getting user info');
                    resolve('getting user info succeeded');
                }
            } else {
                console.log(response.getError());
                if(reject) {
                    console.log('rejecting getting the user info action');
                    reject(Error(response.getError()[0].message));
                }
            }
        });
        console.log('Queueing getting the user info');
        $A.enqueueAction(action);
    },
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @Slack Developer Tools (Legacy)   :    Diego Castro
    // @date        :    01/06/2018
    // @story       :    Lightning Migration Epic for 02/19/17 release
    // @description :    validation method that checks whether or not a user can access the CW wizard from the click.
    // 					 bypassed for admins, checks if the opp is in stage 1/2, whether or not the focus area is blank or
    // 					 contains 'Customer Uncertain', if the user's region is in the US, it checks if the current month is past
    // 					 April  -- and if it is, it checks either 1) the current year is past the opp's close date year or 2)
    // 					 whether the current year equals the opp close date year and the current month is greater than the opp's
    // 					 close month.
    //////////////////////////////////////////////////////////////////////////////////////////////////
    validate : function (component, resolve, reject) {
        var user = component.get("v.user"); 
        var adminProfiles = $A.get("$Label.c.Admin_Profiles");
        var adminandintegrationprof = $A.get("$Label.c.System_Admin_Integration_Profiles");
        var dealgovstages=$A.get("$Label.c.DealGovOppStages");
        var opp = component.get("v.simpleRecord");
        console.log("opp.Onica Type,,,,,,,,,,"+opp.Onica_Type__c);
        //console.log("opp,,,,,,,,,,"+JSON.stringify(opp));
        var errorMsgs = [];
        var newline = '\n';
        if (!adminProfiles.includes(user.ProfileId)) {
            console.log("user's profile is NOT in the admin profiles");
            
            var blockedStages = "Stage 1 - Planning & Identification, Stage 2 - Opportunity Development.";
            //var dealgovstages="Stage 2 - Opportunity Development,Stage 3 - Proposal & Quote, Stage 4 - Negotiation & Quote Mod, Stage 5 - Closing the Business";
            var dealgovstages=$A.get("$Label.c.DealGovOppStages");
            if (blockedStages.includes(opp.StageName)) {
                //errorMsgs.push("The opportunity stage name matches one of theses stages: " + blockedStages);
                errorMsgs+= "The opportunity stage name matches one of theses stages: \n" + blockedStages;
            }
            console.log('opp.QuotingSystem__c///////////'+opp.QuotingSystem__c);
            console.log('opp.onica_type__c////////////'+opp.Onica_Type__c);
            console.log('opp.Onica_Primary_Approval__c/////////'+opp.Onica_Primary_Approval__c);
            // @Dev         : Caleb Garcia
            // @date        : 9/10/2021
            // @story       : SFDC-6663
            // @description : Included exception to INTL Record Types to not require SOW Approval fields to closed won. Modified line 90.
            if(opp.Onica_Type__c != null){
                //console.log('oppp approval'+opp.Onica_Primary_Approval__c);
                if (opp.Onica_Primary_Approval__c == null && opp.Onica_Approval_Ready__c == true) {
                    //errorMsgs.push("Please select legal approval.");
                    errorMsgs+= "Opportunity cannot be closed without SOW approval.\n";
                }else if(opp.Onica_Primary_Approval__c!=null ){
                    //console.log('opp.approval not null >>>>>> '+opp.Onica_Primary_Approval__c);
                    var approvalStatus = component.get("v.legalApprovalStatus");
                    //console.log('approvalStatus >>>>> '+approvalStatus);
                    if(approvalStatus!='Completed'){
                        //console.log('in completed condition >>>>> '+approvalStatus);
                        errorMsgs+= "SOW approval must be in completed status.\n";
                    }
                }
            }
            if (!opp.Focus_Area__c || opp.Focus_Area__c.includes("Customer Uncertain"))  {
                //errorMsgs.push("The focus area is blank or contains 'Customer Uncertain' as a selected value.");
                errorMsgs+= "The focus area is blank or contains 'Customer Uncertain' as a selected value.\n";
            }
            
            
            
            /*
            if (user.Region__c == 'AMER') {
                var today = new Date();
                var closeDate = new Date(opp.CloseDate);
                var theYear = today.getUTCFullYear();
                var theMonth = today.getUTCMonth();
                if (theMonth > 4) {
                    var errStr = "The user region is US, it is past April, and ";
                    if (theYear > closeDate.getUTCFullYear()) {
                        errorMsgs.push(errStr += " the current year is greater than the close date year.");
                    }
                    if (theYear == closeDate.getUTCFullYear() && theMonth > closeDate.getUTCMonth()) {
                        errorMsgs.push(errStr + " the current year equals the close date year and the current month is greater than the close date month.");
                    }
                }
            }*/
            
        }
        if(!adminandintegrationprof.includes(user.ProfileId))
        {
            //Added by Chaitanya for SFDC-5273 for Deal governance fields validation on Closed won Navigation Wizard
            if (dealgovstages.includes(opp.StageName)  && opp.Amount>=10000)
            {                
                if(opp.None__c ==false && opp.Offering_discounting_or_exchanging_curre__c==false && opp.Offering_with_non_standard_solution_i_e__c==false && opp.Offering_a_Balance_of_Trade__c==false && opp.Offering_DataPipe_to_Rackspace_solutions__c==false && opp.Offering_net_new_services_discounted_p__c ==false)                   
                {                   
                    errorMsgs+="Please populate the Deal Governance section. \n";
                }
            }
        }
        var opptype = $A.get("$Label.c.CloudOpportunityTypes");
        var Govtopptype = $A.get("$Label.c.GovernmentOpportunityTypes");
        
        console.log("opp.Contract_Received__c>>>>"+opp.Contract_Received__c);
         console.log("opp.Type>>>>"+opp.Type);
         console.log("opp.RecordType>>>>"+opp.RecordType.Name);
        if(!opp.Contract_Received__c && (((opp.RecordType.Name == 'US Cloud'|| opp.RecordType.Name == 'INTL Cloud' ||  opp.RecordType.Name == 'RBU') 
                                          && opptype.includes(opp.Type))||(opp.RecordType.Name =='Government' && Govtopptype.includes(opp.Type)))){
            console.log("Please verify that the contract is signed & uploaded");
            //errorMsgs+= "Please verify that the contract is signed & uploaded.\n";
            errorMsgs+= "Contract has not been uploaded.\n";
            
        }
        
         var ddi = component.get("v.checkddi");
        //alert('222222'+ddi);
        if(ddi==true){
        errorMsgs+= "Opportunity DDI Product Account is not Government Please change the Account as Government and try again.\n";
      
    }
        
        
        if (errorMsgs.length > 0) {
            //alert(errorMsgs);
            //component.set("v.recordError", errorMsgs.join("\n\n"));
            component.set("v.recordError", errorMsgs);
            //component.set("v.errorMessage",errorMsgs);
        }
        if(resolve) {
            //alert(resolve);
            console.log('resolving the validate function');
            resolve('the validaiton succeeded');
           
        }
        if(reject) {
           // alert(reject);
            console.log('rejecting the validation action');
            reject(Error("THERE'S AN ERROR HERE"));
            
        }
    },
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @Slack Developer Tools (Legacy)   :    Diego Castro 
    // @date        :    07/21/2017
    // @story       :    SFDC-495
    // @description :    should probably migrate this method to an abstract compnent that
    // 					 any component that references helpers (or needs to have a server side action
    // 					 occur before client side logic) will inherit from....todo
    //////////////////////////////////////////////////////////////////////////////////////////////////
    promise : function(component, helperFunction) {
        return new Promise($A.getCallback(function(resolve, reject) {
            helperFunction(component, resolve, reject);
        }));
    },
    
})