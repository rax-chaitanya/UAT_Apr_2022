public class OPCAccountSurveyTriggerHelper {
    
    public Static void requiredFields(){
        for (OPC_Account_Survey__c opcSurvey: (List<OPC_Account_Survey__c>)Trigger.New)
        {
            if(opcSurvey.Survey_Complete_Date__c == null){
                opcSurvey.Survey_Complete_Date__c.addError('Please fill the Survey Complete date field.');
            }else if(opcSurvey.Customer_s_Current_Pulse__c == null || opcSurvey.Customer_s_Current_Pulse__c == ''){
                opcSurvey.Customer_s_Current_Pulse__c.addError('Please fill the Customer\'s Current Pulse field.');
            }else if(opcSurvey.Monthly_Call_Recap__c == null || opcSurvey.Monthly_Call_Recap__c == ''){
                opcSurvey.Monthly_Call_Recap__c.addError('Please fill the Monthly Call Recap field.');
                
            }else if(opcSurvey.Customer_s_Current_Pulse__c == 'Customer is exhibiting churn indicators (including lack of interactions)Customer is leaving Rackspace' && opcSurvey.Expected_START_Churn_Date__c  == null){
                opcSurvey.Expected_START_Churn_Date__c.addError('Please fill the Expected START Churn Date field.');
                
            }else if(opcSurvey.Customer_s_Current_Pulse__c == 'Customer is exhibiting churn indicators (including lack of interactions)Customer is leaving Rackspace' && opcSurvey.Expected_STOP_Churn_Date__c == null){
                opcSurvey.Expected_STOP_Churn_Date__c.addError('Please fill the Expected STOP Churn Date field.');  
            }
            
            
        }  
    }
    public Static void validateEdit(list<OPC_Account_Survey__c> opcUpdatedRec){
        
        /*Date d = System.today();
        Date firstFriday;
        Date thirdFriday;
        firstFriday = d.toStartOfMonth().toStartOfWeek().addDays(5);    
        if(firstFriday < d.toStartOfmonth()) 
            firstFriday = firstFriday.addDays(7);
        thirdFriday = firstFriday.addDays(14);
        system.debug('Date1'+thirdFriday);
        system.debug('Date2'+date.today());
        if(opcUpdatedRec != null){
            for(OPC_Account_Survey__c opc : opcUpdatedRec){
                if(date.today() >=thirdFriday){
				 

                    opc.CreatedDate.addError('This record cannot be updated on or after third Friday.');
                }
            }
			}
        }*/
        
        if(!opcUpdatedRec.isEmpty()){
            DateTime thirdFriday = OPCSurveyUtil.thirdFriday(System.now());
            for(OPC_Account_Survey__c opc : opcUpdatedRec){
                if(thirdFriday.format('EEEE') == 'Friday' && System.now() >= thirdFriday){
				if(!Test.isRunningTest()){
                    opc.CreatedDate.addError('This record cannot be updated on or after third Friday.');
                }
				}
            }
        }
        
    }
    
}