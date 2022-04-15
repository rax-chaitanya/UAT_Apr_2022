/*********************************************************************************
@Description        : This apex class is created for the Trigger Framework.
					  This class controls the flow of execution of the trigger.
@Class              : IndividualEmailResultHelper
@Author             : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Created Date       : 11-July-2019
@Lastmodified Date  : 15-July-2019
@Lastmodified By    : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Test Class         : IndividualEmailResultHelper_Test
@Version            : 1.0
**********************************************************************************/
public class IndividualEmailResultHelper {
/***********************************************************************************
@Description        : This method is used for to update the DateOpend on Assosiated 
					  Lead or Contact.
@Author				: Anwesh kumar 
@Parameter          : none
@Return             : null
@Story				: SFDC-3489
**************************************************************************************/ 
    public static void UpdateContactLeads(){
        Set<ID>RecordIds=new Set<ID>();// Lead or Conatct RecordsIds
        
        for(et4ae5__IndividualEmailResult__c IndividualEmail : (List<et4ae5__IndividualEmailResult__c>)trigger.new){
            If(IndividualEmail.et4ae5__Lead__c!=null){
                RecordIds.add(IndividualEmail.et4ae5__Lead__c);
            }
            If(IndividualEmail.et4ae5__Contact__c!=null){
                RecordIds.add(IndividualEmail.et4ae5__Contact__c);
            }
        }
        Map<Id, Contact> idContactMap = new Map<Id, Contact>([Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Contact where ID In:RecordIds]);
        Map<Id, Lead> idLeadMap = new Map<Id, Lead>([Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Lead where ID In:RecordIds]);
        
        for(et4ae5__IndividualEmailResult__c emailResult : (List<et4ae5__IndividualEmailResult__c>)trigger.new) {
            
            if(emailResult.et4ae5__DateOpened__c!=null){
                Date DateOpend = Date.newinstance(emailResult.et4ae5__DateOpened__c.year(),emailResult.et4ae5__DateOpened__c.month(),emailResult.et4ae5__DateOpened__c.day());
                
                if(emailResult.et4ae5__Lead__c!= null 
                   && idLeadMap.containsKey(emailResult.et4ae5__Lead__c)
                  && 
                   (idLeadMap.get(emailResult.et4ae5__Lead__c).Marketing_Cloud_Last_Activity_Date__c==null
                    ||idLeadMap.get(emailResult.et4ae5__Lead__c).Marketing_Cloud_Last_Activity_Date__c < DateOpend
                     )
                  )
                {
                    
                    idLeadMap.get(emailResult.et4ae5__Lead__c).Marketing_Cloud_Last_Activity_Date__c = DateOpend;
                    
                }
                if(emailResult.et4ae5__Contact__c != null 
                   && idContactMap.containsKey(emailResult.et4ae5__Contact__c)
                   && 
                   (idContactMap.get(emailResult.et4ae5__Contact__c).Marketing_Cloud_Last_Activity_Date__c==null
                    || idContactMap.get(emailResult.et4ae5__Contact__c).Marketing_Cloud_Last_Activity_Date__c < DateOpend 
                    )
                  )
                {
                    idContactMap.get(emailResult.et4ae5__Contact__c).Marketing_Cloud_Last_Activity_Date__c=DateOpend;
                    
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