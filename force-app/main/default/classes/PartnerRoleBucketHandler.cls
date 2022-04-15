/**********************************************************************************

Author: Rajesh Sukamanchi
Description: This apex class is Populate/Update values of Bucket_source & Bucket_Influence fields on Opportunity

**********************************************************************************/

Public class PartnerRoleBucketHandler 
{
  //Added by Sundarayya E to Update Bucket source field with new logic SFDC-4612 and modifed logic fro SFDC-5100 and SFDC-5308
    //Modified by SundarayyaE -with new rwquirement SFDC-5876
     public static void updateOppSource(List<Partner_Role__c> newPartnerRolesList,list<Id> oppIds){
        //List<ID> OppIDs = new List<ID>();     
        Map<Id, Opportunity> OppsMap;
         
        Map<Id, Opportunity> UpdateOppMap = new Map<Id, opportunity>();
         List<Partner_Role__c> UpdateOppbucketValList = New List<Partner_Role__c>();
         if(oppIds.size() > 0){
             OppsMap = New Map<Id,Opportunity>([Select Id,Name,Bucket_Source__c,CreatedDate from Opportunity where Id IN:oppIds ]);
         }
         
         for(Partner_Role__c ptnr : newPartnerRolesList)
        {
            if(String.isNotBlank(ptnr.Opportunity__c) && OppsMap !=Null && OppsMap.containsKey(ptnr.Opportunity__c) && 
              ptnr.CreatedDate >= OppsMap.get(ptnr.Opportunity__c).CreatedDate){
            //system.debug('days diff'+ptnr.CreatedDate.Date().daysBetween(OppsMap.get(ptnr.Opportunity__c).CreatedDate.Date()));
			//system.debug('OppMap'+OppsMap);
            integer daysDiff;
            integer hoursDiff;
            if(String.isNotBlank(ptnr.Opportunity__c) && OppsMap !=Null && OppsMap.containsKey(ptnr.Opportunity__c)){
                
               //daysDiff = ptnr.CreatedDate.Date().daysBetween(OppsMap.get(ptnr.Opportunity__c).CreatedDate.Date());
               decimal Hours = decimal.valueof((ptnr.CreatedDate.getTime() - OppsMap.get(ptnr.Opportunity__c).CreatedDate.getTime())/(60*60));
               hoursDiff=Integer.valueOf((Hours/1000));
                //system.debug('a::->'+Hours);
                system.debug('b::->'+hoursDiff);
            }
            system.debug('hoursDiff'+ hoursDiff);
            if(hoursDiff < 0)hoursDiff = hoursDiff * -1;             
         
            system.debug('hoursDiff'+hoursDiff );
            if(ptnr.Role__c == 'Source' && String.isNotBlank(ptnr.Opportunity__c) && OppsMap !=Null && OppsMap.containsKey(ptnr.Opportunity__c)
               && OppsMap.get(ptnr.Opportunity__c).Bucket_Source__c != 'Partner' && hoursDiff < 24  ){
                   //system.debug('Updating parent opp'+ isPtnrCall);
                  Opportunity myParentOpp = OppsMap.get(ptnr.Opportunity__c);
                   myParentOpp.Bucket_Source__c = 'Partner';
			//UpdateOppMap.put(ptnr.Opportunity__c, OppsMap.get(ptnr.Opportunity__c)); 
			//added for SFDC-6267 to update opp if the source partner role is added after 24 hrs and opp bucket source is sales 
               }else if(ptnr.Role__c == 'Source' && String.isNotBlank(ptnr.Opportunity__c) && OppsMap !=Null && OppsMap.containsKey(ptnr.Opportunity__c)
               && OppsMap.get(ptnr.Opportunity__c).Bucket_Source__c == 'Sales' && hoursDiff > 24){
                   Opportunity myParentOpp = OppsMap.get(ptnr.Opportunity__c);
                   myParentOpp.Bucket_Source__c = 'Partner';
               }
                
              }else if(String.isNotBlank(ptnr.Opportunity__c) && OppsMap !=Null && OppsMap.containsKey(ptnr.Opportunity__c) && 
              ptnr.CreatedDate < OppsMap.get(ptnr.Opportunity__c).CreatedDate && OppsMap.get(ptnr.Opportunity__c).Bucket_Source__c != 'Partner'){
                  Opportunity myParentOpp = OppsMap.get(ptnr.Opportunity__c);
                   myParentOpp.Bucket_Source__c = 'Partner';
              }
        }
        
        if(OppsMap.size() > 0 )	
        {
            Update OppsMap.values();
            //system.debug('bucketlogic fired');
           // OppBucketFieldsHandler.updateBucketSourceField(UpdateOppMap, null, false, true, isPtnrCall);
        }
    }
    
    
  /*  public Static void updateBucketFieldsonOpp(List<Partner_Role__c> newPartnerRolesList, Boolean isPtnrCall) 
    {   
        List<ID> OppIDs = new List<ID>();     
        Map<Id, Opportunity> OppsMap = new Map<ID, Opportunity>();
        
        for(Partner_Role__c ptnr : newPartnerRolesList)
        {
            if(ptnr.Status__c=='Approved')
                OppIds.add(ptnr.Opportunity__c);
        }
        
        if(OppIDs.size()>0)
        {
            for(Opportunity Opp: [Select id, name, Max_Lead_Role__c, Market_Source__c, CampaignID, Bucket_Source__c, Bucket_Influence__c from Opportunity where ID IN :OppIds])
            {
                OppsMap.put(Opp.id, Opp);
            }
        }
        
        if(!OppsMap.isEmpty())
        {
            OppBucketFieldsHandler.updateBucketFields(OppsMap, null, false, true, isPtnrCall);
        }
    }*/
}