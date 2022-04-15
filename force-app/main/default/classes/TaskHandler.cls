public class TaskHandler implements TriggerInterface {
    public static boolean firstTgrRun = true;
    public static string stopRecursion = 'Before Update';
    
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('TaskTrigger').Is_Active__c;
    }
    
    public void beforeInsert() 
    {
    
        if(!userinfo.getuserid().contains(Label.FMWFoundationUser) && !userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.beforeInsert(); 
        
        if(userinfo.getuserid().contains(Label.FMWFoundationUser) || userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.UpdateIds();
          
        //if(!System.label.Admin_Profiles.contains(userInfo.getProfileId()) && !System.label.SkipUserIDs.contains(userInfo.getUserId()))
          // task_Helper.VerifyBeforetaskCreation();
      
          //Added for SFDC-3836 and SFDC-3969
           ActivityMethods.updateTechnicalNextStepOpp();
         
    }
    public void beforeUpdate() {
      if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'Before Update')){
         stopRecursion = 'After Update';   
        if(!userinfo.getuserid().contains(Label.FMWFoundationUser) && !userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.beforeUpdate();

        if(userinfo.getuserid().contains(Label.FMWFoundationUser) || userinfo.getuserid().contains(Label.FMW_API_User))
        ActivityMethods.UpdateIds();
       // if(!System.label.Admin_Profiles.contains(userInfo.getProfileId()) && !System.label.SkipUserIDs.contains(userInfo.getUserId()))
         //  task_Helper.VerifyBeforetaskCreation();
         //Added for SFDC-3836 and SFDC-3969
          ActivityMethods.updateTechnicalNextStepOpp();
      }
    }
    
    public void beforeDelete() {
        
    }
    
    public void afterInsert() {
    
    //added by:Vinod Thupakula
    ActivityMethods.countOfTaskandEventsForAccounts(Trigger.new);
     
    /*********** Added by Deepak Sharma for the SFDC-1896----->Starts here************/
    
        Set<id> oppIds = new Set<id>();
        List<Task> UpdateTasks=new List<Task>();
        for (Task tk: (List<Task>)Trigger.new) 
        {
            if(tk.WhatId !=null&&((String)tk.WhatId).startsWith(Schema.SObjectType.Opportunity.getKeyPrefix()))
            {
                oppIds.add(tk.WhatId);
                UpdateTasks.add(tk);
            }
        }
  
    Map<id,Id>  OppMap = new Map<Id,Id>();
     
    if(oppIds.size() > 0){
        Map<Id,Opportunity> optys = new Map<Id,Opportunity>([Select Id,Primary_Contact__c from Opportunity where Id in :oppIds]);
    
    if(optys.size()>0 && UpdateTasks.size()>0)
    {
          Map<Id,Id> upTasks = new Map<Id,Id>();
       for (Task t: UpdateTasks)
       {
       
         If(String.isNotBlank(optys.get(t.WhatId).Primary_Contact__c)&& string.isblank(t.whoid))
         upTasks.put(t.Id, optys.get(t.WhatId).Primary_Contact__c); 
       }
        //update upTasks;
        if(upTasks.size() >0)
        System.enqueueJob(new UpdateContactOnTask(upTasks));
        
    }
    }
      /**********Added by Deepak Sharma for SFDC-1896------> Ends here***********/  
    
    
        if(!UserInfo.getUserId().contains(Label.FMWFoundationUser) && !UserInfo.getUserId().contains(Label.FMW_API_User)) {
            ActivityMethods.logLeadActivity((List<Task>)Trigger.new);
        }        
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