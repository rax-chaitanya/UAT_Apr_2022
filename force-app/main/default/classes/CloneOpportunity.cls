/**
* File : CloneOpportunity.cls
* Description : Used to Clone an Opportunity to copy over some fields.
* Ticket : SFDC-2230
* Created Date : August 2018
* @author : RDC (Deepak)
*/

public class CloneOpportunity{    
  
  @AuraEnabled  
    public static Opportunity getDetailsFromOpp(string recordId){
      
      Opportunity opp = [select Id,Name,CampaignId,DDI__c,Ticket_Type__c,Focus_Area__c,Account__c,CloseDate,
            AccountId,StageName,Probability,Accounts_Company__c,
            LeadSource,Lead_Date_Passed__c,
            Bucket_Influence__c,Bucket_Source__c,LDT_Date_Passed__c,
            LDT_Rep__c,Lead_Generator__c,Market_Source__c,
            Primary_Contact__c,RecordTypeId,Type,Need__c,
            Unique__c,Timeframe__c,Solution__c,Enemy__c,Cash__c,Authority__c,
            Authority_Points__c,Cash_Points__c,Customer_Points__c,Enemy_Points__c,Need_Points__c,Timeframe_Points__c,
            Unique_Points__c,Solution_Points__c,Partner_Company__c,Lead_Generator_Role__c,Max_Lead_Gen__c,QuotingSystem__c,Category__c,
            Max_Lead_Role__c,RecordType.Name
        from Opportunity Where Id = :recordId limit 1];
        
        if(opp.recordTypeId == Label.OptyReadOnlyRecordTypeId){
          for(OpportunityFieldHistory OppH:[SELECT Id,NewValue,OldValue,OpportunityId,field,CreatedDate
            FROM OpportunityFieldHistory where field='RecordType'
            AND OpportunityId = :recordId order by CreatedDate desc]){
            if(OppH.NewValue == Label.OptyReadOnlyRecordTypeId)
            opp.recordTypeId =(Id)OppH.OldValue;
            
        }  
        }
       return opp ;
    }
    
 }