/**********************************************************************************

Author: Venkat
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

* Last Modified by - Chaitanya Nov 2021
* SFDC-6972 Opportunity Notes data to be made visible in Partner Portal
* shareNotes - Added this Method which is being called in before insert for setting sharing type to All Users
* Test Class - ContentDocumentLinkHelper_Test

**********************************************************************************/

public class ContentDocumentLinkHandler implements TriggerInterface
{
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('ContentDocumentLinkTgr')) {
            return Trigger_Manager__c.getInstance('ContentDocumentLinkTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        ContentDocumentLinkHelper.updateFileNameMDF(Trigger.New);
        ContentDocumentLinkHelper.shareNotes(Trigger.New);
        
    }
    
    public void beforeUpdate() {
        
    }
    
    public void beforeDelete() {
    }
    
    public void afterInsert()  {
        ContentDocumentLinkHelper.ContentDocumentLinkMethod(Trigger.New);
        //ContentDocumentLinkHelper.FileUploaded(Trigger.New);
        
    }
    
    public void afterUpdate() {
        
        
    }
    
    public void afterDelete() {
    }
    
    public void afterUndelete() {
        
    }
    
}