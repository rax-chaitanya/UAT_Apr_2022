({
    queryOpp: function(component,  event, helper) {
        var recordId = component.get("v.recordId");
        if(recordId!=undefined){
            var action = component.get("c.getDetailsFromOpp");
            action.setParams({recordId: recordId});
            action.setCallback(this, function(response){
                
                if (response.getState() === "SUCCESS") {
                    helper.createOppRecord(component, event, helper,response.getReturnValue());
                }
                
                
                
            });
            
            $A.enqueueAction(action);
        }
    },
    createOppRecord : function (component, event, helper,opp) {
        console.log("-----------------inside createOppRecord-------------- "+opp.QuotingSystem__c);
        var createAcountContactEvent = $A.get("e.force:createRecord");
        var dateVar = new Date();
        var newDay = new Date(dateVar.getFullYear(), dateVar.getMonth()+1, 0);
        //var newDate = dateVar.getFullYear()+"-"+parseInt(dateVar.getMonth())+1+"-"+dateVar.getDate();
        var newDate = newDay.getFullYear()+"-"+parseInt(newDay.getMonth()+1)+"-"+newDay.getDate();
        console.log("@@@@@@ "+newDate);
        createAcountContactEvent.setParams({
            "entityApiName": "Opportunity",'recordTypeId' : opp.RecordTypeId,
            "defaultFieldValues": {
                
                'Name' : opp.Name,   
                'CampaignId' : opp.CampaignId, 
                'Type' : opp.Type,  
                'DDI__c' : opp.DDI__c,
                'Focus_Area__c' : opp.Focus_Area__c,
                'Account__c' : opp.Account__c,
                'AccountId' : opp.AccountId,
                'Market_Source__c'  :   opp.Market_Source__c,
                'Category__c'  : opp.Category__c,
                'QuotingSystem__c' : opp.QuotingSystem__c,
                'Primary_Contact__c' : opp.Primary_Contact__c,
                'StageName' : 'Stage 1 - Planning & Identification',
            
                'CloseDate' : newDate,
                'ForecastCategoryName':'Pipeline',
                'Probability':10
            }
        });
        createAcountContactEvent.fire();  
    },
    
})