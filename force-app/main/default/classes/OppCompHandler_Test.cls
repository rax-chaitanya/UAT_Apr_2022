@isTest
public with sharing class OppCompHandler_Test { 
  private static testmethod void OppCompHandlerTest() {    
   
        Trigger_Manager__c sustom = new Trigger_Manager__c();
        sustom.Name ='OppCompTgr';
        sustom.Is_Active__c = true;
        insert sustom;
        OppCompHandler  obj = new OppCompHandler();
        obj.isActive();
        obj.afterDelete();
        obj.beforeInsert();
        obj.beforeUpdate();
        obj.beforeDelete();
        obj.afterInsert();
        obj.afterUpdate();
        obj.afterUndelete();    
  }
}