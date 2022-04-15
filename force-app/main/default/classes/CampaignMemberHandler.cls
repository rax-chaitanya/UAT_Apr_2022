/**********************************************************************************

Author: Shantan Nagulapalli
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class CampaignMemberHandler implements TriggerInterface 
{
    public static boolean firstTgrRun = true;
    public static Boolean IS_TRIGGER_ENABLED = true;
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('CampaignMemberTrigger').Is_Active__c && IS_TRIGGER_ENABLED ;
    }
 
    public void beforeInsert() 
    {
        UpdateContactIdfromACR.updateContactId();
    }
 
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
 
    public void afterInsert()  {
        /*** Added by Anwesh for SFDC-3489 --Starts ***/
        CampaignMemberHelper.UpdateContactLeads();
        /*** Added by Anwesh for SFDC-3489 --Ends ***/
    }
 
    public void afterUpdate() {
        
       /*** Added by Anwesh for SFDC-3489 --Starts ***/
        CampaignMemberHelper.UpdateContactLeads();
        /*** Added by Anwesh for SFDC-3489 --Ends ***/
    }
 
    public void afterDelete() {
        List<CampaignMember> campMemList = (List<CampaignMember>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(campMemList, 'CampaignMember');
    }
    
    public void afterUndelete() {}
    
}