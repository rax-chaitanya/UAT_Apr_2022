/**********************************************************************************

Author: Jayant
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class AccountHandler implements TriggerInterface
{
    public static boolean firstTgrRun = true;
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('AccountTrigger')) {
            return Trigger_Manager__c.getInstance('AccountTrigger').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        AccountTriggerHelper.UpdateContractingEntity();
        
        //Start : SFDC-983 Anil
        /*if(userinfo.getuserid().contains(Label.FMW_API_User) || userinfo.getuserid().contains(Label.FMWFoundationUser))
{            
List<Accounts__c> alist= (List<Accounts__c>)Trigger.new;
Map<Id, Accounts__c> aMap = (Map<Id, Accounts__c>)Trigger.oldMap; 
UpdateTerritory.populateTerritory(alist, aMap, 'Accounts__c');
}*/ 
        //End : SFDC-983 Anil
        
        // Added by Anjaneyulu for SFSB-610 -- Starts
        AccountTriggerHelper.copyContactAddressToAcrs();
        // Added by Anjaneyulu for SFSB-610 -- Ends
        
        //Start : SFDC-983 Anil
        UpdateTerritory.populateTerritory((List<Accounts__c>)Trigger.new, null, 'Accounts__c');   
        //End : SFDC-983 Anil
    }
    
    public void beforeUpdate() {
        // Added by Thirupathi Aeneni and Omkar Narkar for SFDC-2286
        AccountTriggerHelper.recalculateActivityCount();
        //Ended SFDC-2286
        AccountTriggerHelper.UpdateContractingEntity();
        
        if(userinfo.getuserid().contains(Label.FMW_API_User) || userinfo.getuserid().contains(Label.FMWFoundationUser) || userinfo.getuserid().contains(Label.SkipuserDnB))
        {            
            UpdateTerritory.populateTerritory((List<Accounts__c>)Trigger.new, (Map<Id, Accounts__c>)Trigger.oldMap, 'Accounts__c');
        }      
    }
    
    public void beforeDelete() {
        //empty
    }
    
    public void afterInsert()  {
        AccountTriggerHelper.insertAccountRole();
       //SFDC-2787
       //Commented By: Vinod Thupakula
       // AccountTriggerHelper.autoCloseOpportunity((List<Accounts__c>)trigger.new); 
          AccountTriggerHelper.createOrUpdateAccountTeamMembers();

    }
    
    public void afterUpdate() {
        //SFDC-2787
       //Commented By: Vinod Thupakula
       // AccountTriggerHelper.autoCloseOpportunity((List<Accounts__c>)trigger.new);
        AccountTriggerHelper.unlockRecord();
        AccountTriggerHelper.createOrUpdateAccountTeamMembers();

        
    }
    
    public void afterDelete() {
        DeleteUndeleteTriggerHandler.DeleteUndelete((List<Accounts__c>)Trigger.old, 'Accounts__c');
    }
    
    public void afterUndelete() {
        //empty
    }    
}