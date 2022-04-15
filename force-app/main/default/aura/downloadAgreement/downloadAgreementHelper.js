({
    getPartnerType : function(component,helper) { 
        var REFERRAL='Referral';
        var RESELLER='Reseller';
        var EMEA='EMEA';
        var levels = [];
        var cType = 'Strategic Partner Agreement';
        var cStatus = 'Active';
        var STRATEGIC = 'Strategic';
        
        var action = component.get("c.getPartnerType");
        action.setCallback(this,function(response){ 
            var returnvalue = response.getReturnValue();
            var pLevel = returnvalue.Partner_Level__c;
            var conType = returnvalue.Contract_Type__c;
            var conStatus = returnvalue.Contact_Status__c;
            var attachAllowed = returnvalue.Add_Attachment__c;
            if(conType == cType && conStatus ==cStatus && attachAllowed){
                if(pLevel != null && pLevel != 'undefined'){
                	levels.push(pLevel);  
                }    
            }
            else if(pLevel != null && pLevel != 'undefined'){
                    if(pLevel.includes(REFERRAL) && pLevel.includes(RESELLER) && !pLevel.includes(EMEA)){
                        levels.push(REFERRAL);
                        levels.push(RESELLER);                    
                    }
                    else if(pLevel.includes(REFERRAL) && pLevel.includes(RESELLER) && pLevel.includes(EMEA)){
                        levels.push(REFERRAL+EMEA);
                        levels.push(RESELLER+EMEA);
                        levels.push(RESELLER+REFERRAL+EMEA);
                    }
                    else if(pLevel.includes(STRATEGIC) != true){
                        levels.push(pLevel);   
                    }                    
            }  
            this.getAgreements(component,helper,levels);
            
        });
        $A.enqueueAction(action);
    },
    getAgreements : function(component,helper,Val){ 
        var action = component.get("c.getAgreements");
        action.setParams({ docTypes : Val });
        action.setCallback(this,function(response){
            var returnvalue = response.getReturnValue();
            if(returnvalue != null){
                console.log(returnvalue);
                component.set("v.contentDocs",returnvalue);
            } 
        });
        $A.enqueueAction(action);
    }
})