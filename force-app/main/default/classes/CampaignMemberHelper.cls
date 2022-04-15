/*********************************************************************************
@Description        : This apex class is created for the Trigger Framework.This class 
                      controls the flow of execution of the trigger
@Class              : CampaignMemberHelper
@Author             : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Created Date       : 08-July-2019
@Lastmodified Date  : 09-July-2019
@Lastmodified By    : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Test Class         : CampaignMemberHelper_Test
@Version            : 1.0
**********************************************************************************/
public class CampaignMemberHelper{
/********************************************************************************************
@Description        : This method is used for to update the FirstRespondedDate on Assosiated 
                      Lead or Contact.
@Author             : Anwesh kumar 
@Parameter          : void
@Return             : null
@Story              : SFDC-3489
********************************************************************************************/
    public static void UpdateContactLeads(){
        Set<ID>RecordIds=new Set<ID>();
        
        for(CampaignMember members : (List<CampaignMember>)trigger.new){
            If(members.LeadId!=null){
                RecordIds.add(members.LeadID);
            }
            If(members.ContactID!=null){
                RecordIds.add(members.ContactID);
            }
        }
        Map<Id, Contact> idContactMap = new Map<Id, Contact>([Select Id,Name,Campaign_Member_Last_Response_Date__c from Contact where ID In:RecordIds]);
        Map<Id, Lead> idLeadMap = new Map<Id, Lead>([Select Id,Name,Campaign_Member_Last_Response_Date__c from Lead where ID In:RecordIds]);
        
        for(CampaignMember member : (List<CampaignMember>)trigger.new) {
       
             if(member.LeadId != null && member.HasResponded
               && idLeadMap.containsKey(member.LeadId) 
               && (idLeadMap.get(member.LeadId).Campaign_Member_Last_Response_Date__c==null
                   ||
                   idLeadMap.get(member.LeadId).Campaign_Member_Last_Response_Date__c < member.FirstRespondedDate)){
                idLeadMap.get(member.LeadId).Campaign_Member_Last_Response_Date__c = member.FirstRespondedDate;
                
            }
            
            if(member.ContactId != null  && member.HasResponded 
               && idContactMap.containsKey(member.ContactId) 
               &&(idContactMap.get(member.ContactId).Campaign_Member_Last_Response_Date__c==null
               ||
               idContactMap.get(member.ContactId).Campaign_Member_Last_Response_Date__c < member.FirstRespondedDate)){
                idContactMap.get(member.ContactId).Campaign_Member_Last_Response_Date__c = member.FirstRespondedDate;
                
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