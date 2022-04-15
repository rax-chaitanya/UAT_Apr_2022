/*********************************************************************************
@Description        : This apex class is created for the Trigger Framework.This class 
					  controls the flow of execution of the trigger
@Class              : IndividualEmailResultHandler
@Author             : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Created Date       : 11-July-2019
@Lastmodified Date  : 15-July-2019
@Lastmodified By    : Anwesh Kumar(anweshkumar.surbiryala@rackspace.com)
@Test Class         : IndividualEmailResultHelper_Test
@Version            : 1.0
**********************************************************************************/
public class IndividualLinkHandler implements TriggerInterface {
    public static boolean firstTgrRun = true;
    public static Boolean IS_TRIGGER_ENABLED = true;
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('IndividualLinkTrigger').Is_Active__c && IS_TRIGGER_ENABLED;
    }
    
    public void beforeInsert() 
    {
        
    }
    
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        /*** Added by Anwesh for SFDC-3489 --Starts ***/
        IndividualLinkHelper.UpdateContactLeads();
        /*** Added by Anwesh for SFDC-3489 --Ends ***/
    }
    
    public void afterUpdate() {
        
        
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {
        
    }
    
    
    
}