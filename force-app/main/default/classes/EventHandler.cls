public class EventHandler implements TriggerInterface {
    public static boolean firstTgrRun = true;
    
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('EventTrigger').Is_Active__c;
    }
    
    public void beforeInsert() 
    {
        if(!userinfo.getuserid().contains(Label.FMWFoundationUser) && !userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.beforeInsert();
        
        if(userinfo.getuserid().contains(Label.FMWFoundationUser) || userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.UpdateIds();
         //if(!System.label.Admin_Profiles.contains(userInfo.getProfileId()) && !System.label.SkipUserIDs.contains(userInfo.getUserId()))
           //    Event_Helper.VerifyBeforeEventcreation();
    }
    
    public void beforeUpdate() {
        
        if(!userinfo.getuserid().contains(Label.FMWFoundationUser) && !userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.beforeUpdate();
        
        if(userinfo.getuserid().contains(Label.FMWFoundationUser) || userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.UpdateIds();
         // if(!System.label.Admin_Profiles.contains(userInfo.getProfileId()) && !System.label.SkipUserIDs.contains(userInfo.getUserId()))
             //  Event_Helper.VerifyBeforeEventcreation();
    }
    
    public void beforeDelete() {
        
    }
    
    public void afterInsert() {
        //added by:Vinod Thupakula
        ActivityMethods.countOfTaskandEventsForAccounts(Trigger.new);
    }
    
    public void afterUpdate() {
        
    }
    
    public void afterDelete() 
    {
        //added by:Vinod Thupakula
        ActivityMethods.countOfTaskandEventsForAccounts(Trigger.old);
    }
    
    public void afterUndelete() 
    {}    
    
}