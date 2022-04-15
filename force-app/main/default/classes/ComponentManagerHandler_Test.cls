@isTest
public with sharing class ComponentManagerHandler_Test { 
  private static testmethod void ComponentTest() {
    
    Trigger_Manager__c triggerSettings = new Trigger_Manager__c(Name = 'ComponentManagerTrigger', Is_Active__c = true);
        
    Insert triggerSettings; 
    
    Component_Manager__c cm=New Component_Manager__c(Field_Name__c='ParentID',Operator__c='=',Variable__c=':companyID',Active__c=true,Field_Order__c=1);
    Insert cm;
    
    cm.Field_Order__c=2;
    Update cm;
    
    try
    {
      Delete cm;
    }
    catch(Exception e)
    {
       Boolean expectedExceptionThrown =  e.getMessage().contains('Component records cannot be deleted. Please mark the IsActive__c field as false.') ? true : false;
       System.AssertEquals(expectedExceptionThrown, true);
     } 
    
  }
}