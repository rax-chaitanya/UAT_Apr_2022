/**
* File :  UpdateEmailOptOut.cls
* Description : This class will provide value to the OPC link which will be sent to Account Managers. UpdateOPCSurveyCmp and ProcessOPCSurvey
Component is using this class.Please Refer to the Epic SFDC-3124 for complete understanding of the requirement.
* Created Date : 5/May/2019 
* Author : RDC
*/
public class UpdateOPCController {
    @AuraEnabled 
    public static List<OPC_Account_Survey__c> displaySurveys(String accRecordId){
        list<OPC_Account_Survey__c> finalsurveylist=New List<OPC_Account_Survey__c>();
        List<OPC_Account_Survey__c> surveyRecord = [select Id,name,Account_Name_value__c ,Survey_Date__c,Account_Number__c,Account_Name__r.name ,Customer_s_Current_Pulse__c,Expected_START_Churn_Date__c,Expected_STOP_Churn_Date__c,Monthly_Call_Recap__c,Survey_Complete_Date__c  from OPC_Account_Survey__c where Account_Name__r.Account_Manager__c =:accRecordId And Survey_Complete_Date__c = null AND CreatedDate = THIS_MONTH];
        if(surveyRecord.size()>0){      
            return surveyRecord;
        }
        else {
            return null;
        }       
    }
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField){
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }    
    @AuraEnabled
    public static void saveSurveyRecord(Id surveyId,DateTime surveyCompletedDate,String CustomersCurrentPulse, DateTime startchurndate, DateTime stopchurndate, string MonthlyRecap,Decimal MRRLoss){
        OPC_Account_Survey__c o = [Select id, Customer_s_Current_Pulse__c,Monthly_Call_Recap__c,Survey_Complete_Date__c,Expected_START_Churn_Date__c ,Expected_STOP_Churn_Date__c, MRR_Loss__c  from OPC_Account_Survey__c where id =:surveyId];
        o.Customer_s_Current_Pulse__c = CustomersCurrentPulse;
        o.Survey_Complete_Date__c = surveyCompletedDate;
        o.Expected_STOP_Churn_Date__c = stopchurndate;
        o.Expected_START_Churn_Date__c= startchurndate;
        o.Monthly_Call_Recap__c=MonthlyRecap;
        o.MRR_Loss__c =MRRLoss;
        update o;   
    }
    @AuraEnabled
    Public static boolean checkfriday(){
        /*Boolean friday=false;
        Date d = System.today();
        Date firstFriday;
        Date thirdFriday;
        firstFriday = d.toStartOfMonth().toStartOfWeek().addDays(5);    
        if(firstFriday < d.toStartOfmonth()) 
            firstFriday = firstFriday.addDays(7);
        thirdFriday = firstFriday.addDays(14);
        if(date.today() >=thirdFriday){           
            friday= true;
            return true;
        }
        return False;*/
        
        Boolean friday=false;
        DateTime thirdFriday = OPCSurveyUtil.thirdFriday(System.now());
        System.debug('thirdFridayChk:' + thirdFriday);
        if(thirdFriday.format('EEEE') == 'Friday' && System.now() >= thirdFriday){
            friday= true;
            return true;
        }
        return false;
                
    }    
}