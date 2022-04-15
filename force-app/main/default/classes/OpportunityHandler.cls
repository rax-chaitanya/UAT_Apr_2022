/**********************************************************************************

#Author: Pradeep Guttha
#Description: This apex class is created for the Trigger Framework. This class 
#controls the flow of execution of the trigger.
# Change Log: 07-Jul-2017, JY(RDC), modified the method calls to OpportunityTriggerHelper.populateCompanyFromAccount() 
# to make them compatible with method's new signature for SFDC-443.



* @author Chaitanya
* @date March 2022
* @Change description SFDC-7331 Make Gross Margin Min field mandatory for EMEA Sales rep
* @Test Class - OpportunityTriggerTest , OpportunityTrigger_Test

* @author Rishabh
* @date March 2022
* @Change description SFDC-7446 - Update Owner region field when an Opportunity owner is updated
* @Test Class - OpportunityTriggerTest , OpportunityTrigger_Test


**********************************************************************************/


public class OpportunityHandler implements TriggerInterface
{
    
    public static boolean firstTgrRun = true;
    public static boolean IS_TRIGGER_ENABLED = true; //Added by Sreeram for SFDC-3317O
    public static boolean Is_Source =true;
    public static string stopRecursion = 'Before Update';
    public static boolean isValidationFire = true;
    Public Static boolean webhookfirtRun = false;
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('OpportunityTgr') && IS_TRIGGER_ENABLED) {
            //  StopRecursion.resetOnce('Opportunity');
            return Trigger_Manager__c.getInstance('OpportunityTgr').Is_Active__c;
        }
        return false;
        
    }
    
    public void beforeInsert() 
    {
        try 
        {   
            OpportunityTriggerHelper.mappedForecastBucketField((List<Opportunity>)Trigger.new);
            OpportunityTriggerHelper.populateCompanyFromAccount((List<Opportunity>)Trigger.new, (Map<Id, Opportunity>)Trigger.oldMap);
            OppBucketFieldsHandler.updateBucketFields(null, (List<Opportunity>)Trigger.new, True, false, false);
            //added by sundar sfdc-5100
            OppBucketFieldsHandler.updateBucketSourceField(null, (List<Opportunity>)Trigger.new, True, false);
            
            OpportunityTriggerHelper.beforeInsert();
            
            //OpportunityStamp.stampPrimaryContact();
            
            //OpportunityTriggerHelper.mapAccountFieldsOnOpportunities((List<Opportunity>)Trigger.new);
            // Added by Anjaneyulu for SFDC-2821 -- Starts
            
            OpportunityTriggerHelper.updateOpportunitywithAccountDetails();
            // Added by Anjaneyulu for SFDC-2821 -- Ends
            
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
    }
    
    public void beforeUpdate() {
        
        if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'Before Update')){   
            stopRecursion = 'After Update';
            // system.debug('CompanyHandler.isLeadConverting...'+CompanyHandler.isLeadConverting);
            try {
                // Added by Ashok for SFDC-2922 --- Starts
                List<Opportunity> opps  = new List<Opportunity>();
                Map<id,Opportunity> oppMaps = (Map<Id,Opportunity>)Trigger.oldMap;
                for(Opportunity opp: (List<Opportunity>)Trigger.new){
                    if(oppMaps.get(opp.Id) != null && oppMaps.get(opp.Id).Type != opp.Type ){opps.add(opp);}
                }
                OpportunityTriggerHelper.mappedForecastBucketField(opps);
                // Added by Ashok for SFDC-2922 --- Ends
                //SFDC-7331 commented this code which is not used anywhere but consuming SOQL  
                //OpportunityTriggerHelper.beforeUpdate();
                OpportunityTriggerHelper.updateOwnerRegion(trigger.newMap,trigger.oldMap);//SFDC-7446
                OpportunityTriggerHelper.reOpenclosedlost();
                OpportunityTriggerHelper.populateCompanyFromAccount((List<Opportunity>)Trigger.new, (Map<Id, Opportunity>)Trigger.oldMap);
                OppBucketFieldsHandler.bucketTriggerCheck((List<Opportunity>)Trigger.new,(Map<ID,Opportunity>)Trigger.oldMap);
                //sfdc-5595
                if(Test.isRunningtest()){
                    isValidationFire = true;
                }
                //SFDC-7331 Commented out below since it is not required in both before and after update
                // OpportunityTriggerHelper.grossMarginValidation((List<Opportunity>)Trigger.new,isValidationFire);
                
                //Start : SFDC-1625 
                Set<Id> oppIds = new Set<Id>();
                
                for(Integer i=0;i<Trigger.Size;i++){
                    if(((Opportunity)Trigger.new[i]).StageName == 'Closed Won' && ((Opportunity)Trigger.Old[i]).StageName != 'Closed Won')
                        oppIds.add(((Opportunity)Trigger.new[i]).Id);
                }
                if(oppIds.size() > 0)
                    OpportunityTriggerHelper.populateSolutionEngineerOnOpportunity(oppIds,(Map<Id, Opportunity>)Trigger.newMap);
                //End : SFDC-1625
                // Added by Anjaneyulu for SFDC-2821 -- Starts
                if(OpportunityTriggerHelper.UPDATE_ACCOUNT_DETAILS)
                    OpportunityTriggerHelper.updateOpportunitywithAccountDetails();
                // Added by Anjaneyulu for SFDC-2821 -- Ends
            } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
            try{
                List<Opportunity> oppList = (list<opportunity>)trigger.new;
                if( firstTgrRun == true){
                    firstTgrRun = false;
                    Map<String,Map<String, Decimal>> totalMap =  HighLowMarginTriggerHandler.setBookingTotalFieldOnOpportunityForOppChange(oppList);  
                    for(Opportunity opp : oppList){
                        if(totalMap.get(opp.Id) != null){
                            opp.Booking_Total__c = totalMap.get(opp.Id).get('bookingTotal');
                            opp.Commission_Booking_Total__c = totalMap.get(opp.Id).get('cbBookingTotal');
                        }
                    }
                }
            } catch(Exception ex){
                system.debug('Exception in HighLowMarginTriggerHandler.opportunityTrigger'+ex.getMessage());
            }
        }
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        try {
            // The below cndition added by Anjaneyulu to stop recursion 
            if(ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE){
                isValidationFire = false;
                OpportunityTriggerHelper.UpdateIsInstallBase();
                OpportunityTriggerHelper.updateMRRonAccount();
                OpportunityTriggerHelper.afterInsert();        
                CreateFocusAreaRecords.OppFocusArea();
                //Added by Vinod Thupakula
                //SFDC-1335
                OpportunityTriggerHelper.updateAccountEAN((List<Opportunity>)Trigger.new, null);
                //OpportunityTriggerHelper.updateAccountContractingentity((List<Opportunity>)Trigger.new, (Map<ID,Opportunity>)Trigger.oldMap);
                OpportunityTriggercontractentityupdate.updateAccountContractingentity((List<Opportunity>)Trigger.new, (Map<ID,Opportunity>)Trigger.oldMap);
                //SFDC-2241
                
            }
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
        
        // Added by Anjaneyulu for Partner communities -- Starts
        List<Opportunity> partnerOpportunities = new List<Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity op : (List<Opportunity>)Trigger.new){
            if(String.isNotBlank(op.Partner_Company__c)){
                partnerOpportunities.add(op);
                
            }
            
        }
        
        
        if(!partnerOpportunities.isEmpty()){
            CommunitySharingHelper.shareRecordsOnCreation(partnerOpportunities,'Opportunity');
        }
        // Added by Anjaneyulu for Partner communities -- Ends
        
        //SFDC-2975
        If(!OpportunityChildRecordUtility.OCR_UTIL)
            OpportunityChildRecordUtility.updateOpportunityChildRecords(Trigger.newMap.keySet());
        
    }
    
    public void afterUpdate() {
        if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'After Update')){   
            stopRecursion = 'Stop Recursion';  
            List<Opportunity> oppNewList = (List<Opportunity>)Trigger.new;
            //List<Opportunity> oppbfoldlist = (List<Opportunity>)Trigger.old; 
            Map<Id,Opportunity> oppOldMap = (Map<Id,Opportunity>)Trigger.oldMap;
            
            //start 6302
            
            //moved this code to the top fro SFDC-6464 to make sure that the trigger returning correct values on old and new data
            if(!webhookfirtRun) {
                // system.debug('fisrtcall'+OpportunityTriggerHelper.firstcall);
                Set<id> Oppid = new Set<id>();
                for(Opportunity op : oppNewList){
                    system.debug('cvp New Value'+op.CVP_Verified__c);
                    system.debug('cvp old value'+oppOldMap.get(op.Id).CVP_Verified__c);
                    system.debug('StageName'+op.StageName);
                    system.debug('type'+op.Type);
                    
                    if(op.CVP_Verified__c && oppOldMap.get(op.Id).CVP_Verified__c ==  false && op.StageName == 'Closed Won' && op.Type == 'RSVC' 
                       && op.DDI__c != null ) {
                           webhookfirtRun = true;
                           Oppid.add(op.id);
                       }
                } 
                if(Oppid.size() > 0 ){
                    OpportunityTriggerHelper.PostDataWebhookRSVCOpportunities(Oppid); 
                    System.debug('Oppid'+Oppid);
                }
            }
            // end 6302
            //end SFDC-6464
            // system.debug('CompanyHandler.isLeadConverting...'+CompanyHandler.isLeadConverting);
            OpportunityTriggerHelper.afterUpdate(); 
            // The below cndition added by Anjaneyulu to stop recursion 
            if(ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE){ 
                //Call this method to move quote lines to Dummy Opportunity
                OpportunityTriggerHelper.UpdateIsInstallBase();
                DeleteOppQuoteLines.DeleteQuoteLines();
                OpportunityTriggerHelper.updateMRRonAccount();
                List<OpportunitySplit> updateOppSplitList = new List<OpportunitySplit>();
                Map<Id,Opportunity> oppMap = (Map<Id,Opportunity>)Trigger.NewMap;
                
                for(OpportunitySplit os : [select Id, Old_Opportunity_Id__c from OpportunitySplit where OpportunityId in : oppMap.keyset()])
                {
                    if(String.isBlank(os.Old_Opportunity_Id__c))
                    {
                        updateOppSplitList.add(os);
                    }
                }
                if(updateOppSplitList.size() > 0 )
                {
                    update updateOppSplitList;
                }
                
                //Added by Vinod Thupakula
                //SFDC-1335
                OpportunityTriggerHelper.updateAccountEAN((List<Opportunity>)Trigger.new, (Map<ID,Opportunity>)Trigger.oldMap);
                //OpportunityTriggerHelper.updateAccountContractingentity((List<Opportunity>)Trigger.new, (Map<ID,Opportunity>)Trigger.oldMap);
                //sfdc 1640
                OpportunityTriggercontractentityupdate.updateAccountContractingentity((List<Opportunity>)Trigger.new, (Map<ID,Opportunity>)Trigger.oldMap);
                //SFDC 2241
                ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE =false;
                
            } 
            
            // Added by Anjaneyulu for Partner communities -- Starts
            List<Opportunity> partnerOpportunities = new List<Opportunity>();
            Map<Id,Opportunity> oldmap = (Map<Id,Opportunity>)Trigger.OldMap;
            Set<Id> grossMarginOppOwners = new Set<Id>();////SFDC-7331
            
            for(Opportunity op : (List<Opportunity>)Trigger.new){
                if((String.isNotBlank(op.Partner_Company__c) && op.OwnerId != oldmap.get(op.Id).OwnerId) || (String.isNotBlank(op.Partner_Company__c) && op.Partner_Company__c != oldmap.get(op.Id).Partner_Company__c) && Is_Source ){
                    partnerOpportunities.add(op);
                }
                if (string.isNotBlank(op.OwnerId)) {
                    grossMarginOppOwners.add(op.OwnerId);//SFDC-7331
                }    
            }
            OpportunityTriggerHelper.grossMarginValidation((List<Opportunity>)Trigger.new,isValidationFire,grossMarginOppOwners);     //SFDC-7331 
            
            
            if(!partnerOpportunities.isEmpty()){
                CommunitySharingHelper.shareRecordsOnCreation(partnerOpportunities,'Opportunity');
            }
            // Added by Anjaneyulu for Partner communities -- Ends
            // Added by Anjaneyulu for SFDC-1886 -- Starts
            if(OpportunityTriggerHelperController.CREATE_OPPORTUNITY_TEAM_MEMBER){
                OpportunityTriggerHelperController.CREATE_OPPORTUNITY_TEAM_MEMBER = false;
                RequestOpportunityAccessController.createOpportunityTeamMember();
            }
            // Added by Anjaneyulu for SFDC-1886 -- Ends
            
            //SFDC-2789
            CreateFocusAreaRecords.OppFocusArea();
            //sfdc-5595
            //OpportunityTriggerHelper.grossMarginValidation((List<Opportunity>)Trigger.new,isValidationFire);
            //SFDC-7331 commented above line to call grossMarginValidation with owner as parameter
            
            //SFDC-2975
            If(!OpportunityChildRecordUtility.OCR_UTIL)
                OpportunityChildRecordUtility.updateOpportunityChildRecords(Trigger.newMap.keySet());
            
        }
    }
    
    public void afterDelete() {
        try {
            OpportunityTriggerHelper.updateMRRonAccount();
            List<Opportunity> OppList = (List<Opportunity>)Trigger.old;
            DeleteUndeleteTriggerHandler.DeleteUndelete(OppList, 'Opportunity');
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
    }
    
    public void afterUndelete() {}
    
}