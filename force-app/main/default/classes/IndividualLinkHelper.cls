/*********************************************************************************
@Description        : This apex class is created for the Trigger Framework
@Class              : IndividualLinkHelper
@Author             : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Created Date       : 15-July-2019
@Lastmodified Date  : 15-July-2019
@Lastmodified By    : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Test Class         : IndividualLinkHelper_Test
@Version            : 1.0 
**********************************************************************************/
public class IndividualLinkHelper {
/********************************************************************************************
@Description        : This method is used for to update the DateOpend on Assosiated 
					  Lead or Contact.
@Author				: Anwesh kumar 
@Parameter          : none
@Return             : null
@Story				: SFDC-3489
********************************************************************************************/    
    public static void UpdateContactLeads(){
        Set<ID>RecordIds=new Set<ID>();
        
        for(et4ae5__IndividualLink__c ILink : (List<et4ae5__IndividualLink__c>)trigger.new){
            If(ILink.Lead__c!=null){
                RecordIds.add(ILink.Lead__c);
            }
            If(ILink.Contact__c!=null){
                RecordIds.add(ILink.Contact__c);
            }
        }
        Map<Id, Contact> idContactMap = new Map<Id, Contact>([Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Contact where ID In:RecordIds]);
        Map<Id, Lead> idLeadMap = new Map<Id, Lead>([Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Lead where ID In:RecordIds]);
        
        for(et4ae5__IndividualLink__c ILinks : (List<et4ae5__IndividualLink__c>)trigger.new) {
            if(ILinks.et4ae5__Last_Clicked__c !=null){            
                Date LastClicked = Date.newinstance(ILinks.et4ae5__Last_Clicked__c.year(),ILinks.et4ae5__Last_Clicked__c.month(),ILinks.et4ae5__Last_Clicked__c.day());
                
                if(ILinks.Lead__c!= null  
                   && idLeadMap.containsKey(ILinks.Lead__c)
                   &&
                   (idLeadMap.get(ILinks.Lead__c).Marketing_Cloud_Last_Activity_Date__c==null
                    || 
                    idLeadMap.get(ILinks.Lead__c).Marketing_Cloud_Last_Activity_Date__c < LastClicked
                   )
                  )
                {
                    idLeadMap.get(ILinks.Lead__c).Marketing_Cloud_Last_Activity_Date__c = LastClicked;
                }
                
                if(ILinks.Contact__c != null 
                   && 
                   idContactMap.containsKey(ILinks.Contact__c)
                   && 
                   (idContactMap.get(ILinks.Contact__c).Marketing_Cloud_Last_Activity_Date__c==null
                    || idContactMap.get(ILinks.Contact__c).Marketing_Cloud_Last_Activity_Date__c < LastClicked
                   )
                  )
                {
                    idContactMap.get(ILinks.Contact__c).Marketing_Cloud_Last_Activity_Date__c=LastClicked;
                }
                
            }
            
        }
        if(!idLeadMap.isEmpty()){
            LeadHandler.IS_TRIGGER_ENABLED=false;
            Update idLeadMap.values();
            LeadHandler.IS_TRIGGER_ENABLED=True;
        }
        
        if(!idContactMap.isEmpty()){
            ContactHandler.IS_TRIGGER_ENABLED=false;
            update idContactMap.values();
            ContactHandler.IS_TRIGGER_ENABLED=True;
        }
        
    }
    
}