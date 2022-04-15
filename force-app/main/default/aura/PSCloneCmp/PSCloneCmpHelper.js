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
       
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Opportunity",
            "defaultFieldValues": {
                'Name' : 'Linked Opp-'+opp.Name,   
                'Type' : 'Professional Services',
                'CampaignId' : opp.CampaignId,
                'Lead_Generator__c' : opp.Lead_Generator__c,
                'DDI__c' : opp.DDI__c,
                'Ticket_Type__c' : opp.Ticket_Type__c,
                'Focus_Area__c' : opp.Focus_Area__c,
                'Account__c' : opp.Account__c,
                'AccountId' : opp.AccountId,
                'StageName' : opp.StageName,
                'Probability' : opp.Probability,
             //   'Accounts_Company__c' : opp.Accounts_Company__c,
                'Market_Source__c'  :   opp.Market_Source__c,
                'LeadSource' : opp.LeadSource,
                'Lead_Date_Passed__c' : opp.Lead_Date_Passed__c,
                'LDT_Rep__c' : opp.LDT_Rep__c,
                'LDT_Date_Passed__c' : opp.LDT_Date_Passed__c,
               // 'Lead_Generator_Role__c' : opp.Lead_Generator_Role__c,
                'Need__c' : opp.Need__c,
                'Unique__c' : opp.Unique__c,
                'Timeframe__c' : opp.Timeframe__c,
                'Solution__c' : opp.Solution__c,
                'Enemy__c' : opp.Enemy__c,
                'Cash__c' : opp.Cash__c,
                'CloseDate' : opp.CloseDate, 
                'RecordTypeId' : opp.RecordTypeId,
                'Customer__c' : opp.Customer__c,
                'Authority__c' : opp.Authority__c,
                'Authority_Points__c' : opp.Authority_Points__c,
                'Cash_Points__c' : opp.Cash_Points__c,
                'Customer_Points__c' : opp.Customer_Points__c,
                'Enemy_Points__c' : opp.Enemy_Points__c,
                'Need_Points__c' : opp.Need_Points__c,
                'Timeframe_Points__c' : opp.Timeframe_Points__c,
                'Unique_Points__c' : opp.Unique_Points__c,
                'Solution_Points__c' : opp.Solution_Points__c,
                'Partner_Company__c' : opp.Partner_Company__c,
                'Primary_Contact__c' : opp.Primary_Contact__c,
              //  'Bucket_Source__c'   : opp.Bucket_Source__c,
              //  'Bucket_Influence__c' :opp.Bucket_Influence__c  
              //  'Max_Lead_Gen__c'    : opp.Max_Lead_Gen__c,
               // 'Max_Lead_Role__c'   : opp.Max_Lead_Role__c
            }
        });
        createAcountContactEvent.fire();
    },
    
})