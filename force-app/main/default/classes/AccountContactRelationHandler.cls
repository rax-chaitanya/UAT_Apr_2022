/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.
Test Class : AccountContactRelationHandler_Test
* Last modified : MAR 2022,Dev- Chaitanya,Jira - SFDC-7308
**********************************************************************************/
public without sharing class AccountContactRelationHandler implements TriggerInterface
{
    
    public static boolean firstTgrRun = true;
    
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('AcrTgr').Is_Active__c;
    }
    
    public void beforeInsert(){
     // FieldMappingHandler.AcrAddressMapping(); 
    if(userinfo.getuserid().contains(Label.FMW_API_User))
     {
            UpdateRoleHandler.updateRole(); 
       }
        string ProdAccountRecordtype=label.AccountRecordtypes;
       List<AccountContactRelation> prodAcrList = new list<AccountContactRelation>();
       list<id> acIdlist = new list<id>();
       Map<Id, AccountContactRelation> prodAcrMap = new Map<Id, AccountContactRelation>();
     //   if(userinfo.getuserid().contains(Label.FMW_API_User) || userinfo.getuserid().contains(Label.FMWFoundationUser))
     //   {            
            List<AccountContactRelation> acrlist = (List<AccountContactRelation>)Trigger.new;
            Map<Id, AccountContactRelation> acrMap = (Map<Id, AccountContactRelation>)Trigger.oldMap; 
                //GTMO-324 ,Samba Start
                for(AccountContactRelation acr :acrlist){
                acIdlist.add(acr.accountid);
                prodAcrMap.put(acr.accountid,acr);
            }
            for(account ac : [SELECT id, name,recordtypeid from account WHERE id =:acIdlist]){
                if(ProdAccountRecordtype.contains(ac.recordtypeid)){
                prodAcrList.add(prodAcrMap.get(ac.id));
                }
                //system.debug('ac.recordtypeid.......'+ac.recordtypeid);
            }
            //system.debug('prodAcrList.......'+prodAcrList);
           // AccountContactRelationHelper.checkPrimaryACROnUpdate(prodAcrList,True);
           AccountContactRelationHelper.checkPrimaryACROnUpdate(prodAcrList);//SFDC-7308
            //GTMO-324 ,Samba End
         //   UpdateTerritory.populateTerritory(acrlist, acrMap, 'AccountContactRelation');
     //   }   
       // if(ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES){
            
            for(sObject acr1:Trigger.new){
                acr1.put('Account_Contact_Ids__c',acr1.get('AccountId')+'_'+acr1.get('ContactId'));
              // acr1.put('AccountId', acr1.get('AccountId'));
            }
         //   ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = false; 
        //}
    }
    
    public void beforeUpdate() { 
         string ProdAccountRecordtype=label.AccountRecordtypes;
       List<AccountContactRelation> prodAcrList = new list<AccountContactRelation>();
       list<id> acIdlist = new list<id>();
       Map<Id, AccountContactRelation> prodAcrMap = new Map<Id, AccountContactRelation>();
       List<AccountContactRelation> acrlist2 = (List<AccountContactRelation>)Trigger.new;
        if(userinfo.getuserid().contains(Label.FMW_API_User) || userinfo.getuserid().contains(Label.FMWFoundationUser))
        {            
            List<AccountContactRelation> acrlist = (List<AccountContactRelation>)Trigger.new;
            Map<Id, AccountContactRelation> acrMap = (Map<Id, AccountContactRelation>)Trigger.oldMap; 
            //UpdateTerritory.populateTerritory(acrlist, acrMap, 'AccountContactRelation');
        }   
         //GTMO-324 ,Samba Start
                for(AccountContactRelation acr :acrlist2){
                acIdlist.add(acr.accountid);
                prodAcrMap.put(acr.accountid,acr);
            }
            for(account ac : [SELECT id, name,recordtypeid from account WHERE id =:acIdlist]){
                if(ProdAccountRecordtype.contains(ac.recordtypeid)){
                prodAcrList.add(prodAcrMap.get(ac.id));
                }
            }
            //system.debug('prodAcrList.......'+prodAcrList);
           // AccountContactRelationHelper.checkPrimaryACROnUpdate(prodAcrList,false);
     AccountContactRelationHelper.checkPrimaryACROnUpdate(prodAcrList);//SFDC-7308
            //GTMO-324 ,Samba End
        //if(ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES){
            
            for(sObject acr1:Trigger.new){
                acr1.put('Account_Contact_Ids__c',acr1.get('AccountId')+'_'+acr1.get('ContactId'));
               // acr1.put('accountid', acr1.get('accountid'));
            }
          //  ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = false; 
        //}
    }
    
    public void beforeDelete() {}
    
    public void afterInsert() {
    //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start 
        List<Id> newConIds = new List<Id>(); 
        for(AccountContactRelation acr : (List<AccountContactRelation>)Trigger.New){
            if(acr.ContactId != null){
                newConIds.add(acr.ContactId);
            }
        }
        
            if(!newConIds.isEmpty()){
                NPS_Contact_and_Role_Creation.checkNPSContactEligiblityAsync(newConIds);
            }
       //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End    
       }
    
   
    
    public void afterUpdate() {
        Set<Id> ContactIds = new Set<Id>();
        List<Contact> cons = New List<Contact>();
        List<AccountContactRelation> acrlist = (List<AccountContactRelation>)Trigger.new;
        Map<Id, AccountContactRelation> acrMap = (Map<Id, AccountContactRelation>)Trigger.oldMap;
        
        //[4/26/2018]Added by Thirupathi Aeneni to resolve eSig Issue - Update AccountId on Contact in NA34 if it is blank
        AccountContactRelationHelper.updateContactwithCompany((List<AccountContactRelation>)Trigger.new);
          
      
        
        //CDH-SFDC-2410: start
        for(AccountContactRelation acr: acrList)
        {
        
        System.debug('Inside after update');
            if(acr.ContactId !=acrMap.get(acr.id).ContactId && acr.ContactId!='' && acrMap.get(acr.id).ContactId!='')
            {
                ContactIds.add(acr.ContactId);
                ContactIds.add(acrMap.get(acr.id).ContactId);
            }
        }
            if(!ContactIds.isEmpty())
            {
                cons = [Select id, Acr_Count__c, RPN__c from Contact where Id in:ContactIds];
                Update cons;
            } //CDH-SFDC-2410: end
              //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start
        List<Id> newConIds = new List<Id>(); 
        for(AccountContactRelation acr : (List<AccountContactRelation>)Trigger.New){
            if(acr.ContactId != null){
                newConIds.add(acr.ContactId);
            }
        }
        
            if(!newConIds.isEmpty()){
                NPS_Contact_and_Role_Creation.checkNPSContactEligiblityAsync(newConIds);
            }
       //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End  
            
    }
    
    public void afterDelete()
    {
        Set<Id> ContactIds = new Set<Id>();
        List<Contact> cons = New List<Contact>();
        List<AccountContactRelation> acrList = (List<AccountContactRelation>)Trigger.old;
        
        
        //CDH-SFDC-2410: start
        for(AccountContactRelation acr: acrList)
        {
            ContactIds.add(acr.ContactId);
        }
            
        if(!ContactIds.isEmpty()){
            cons = [Select id, Acr_Count__c, RPN__c from Contact where Id in:ContactIds];
            Update cons;
        } //CDH-SFDC-2410: end
        
        
        DeleteUndeleteTriggerHandler.DeleteUndelete(acrList, 'AccountContactRelation');
        //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start 
        List<Id> oldConIds = new List<Id>();  
        for(AccountContactRelation acr : (List<AccountContactRelation>)Trigger.old){
            if(acr.ContactId != null){
                oldConIds.add(acr.ContactId);
            }
        }
        
            if(!oldConIds.isEmpty()){
                NPS_Contact_and_Role_Creation.checkNPSContactEligiblityAsync(oldConIds);
            }
       //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End
    }
    public void afterUndelete() {}
    
}