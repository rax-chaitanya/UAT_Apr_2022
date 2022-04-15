/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public without sharing class AccountContactRoleHandler implements TriggerInterface
{
    
    public static boolean firstTgrRun = true;
    
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('AcrTgr').Is_Active__c;
    }
    
    public void beforeInsert()
    {
        FieldMappingHandler.AcrAddressMapping(); 
        if(userinfo.getuserid().contains(Label.FMW_API_User))
        {
            UpdateRoleHandler.updateRole(); 
        }
        
        if(userinfo.getuserid().contains(Label.FMW_API_User) || userinfo.getuserid().contains(Label.FMWFoundationUser) || Test.isRunningTest())
        {            
            List<Account_Contact_Role__c> acrlist = (List<Account_Contact_Role__c>)Trigger.new;
            Map<Id, Account_Contact_Role__c> acrMap = (Map<Id, Account_Contact_Role__c>)Trigger.oldMap; 
            UpdateTerritory.populateTerritory(acrlist, acrMap, 'Account_Contact_Role__c');
        }   
        // if(ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES){
        
        for(sObject acr1:Trigger.new){
            acr1.put('Account_Contact_Ids__c',acr1.get('Account__c')+'_'+acr1.get('Contact__c'));
            acr1.put('Account_ID__c', acr1.get('Account__c'));
        }
        //   ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = false; 
        //}
          /****************SFDC-3974 starts added by Anitha******************/
        AccountContactRoleHelper.copyAccountAddress();
        /****************SFDC-3974 Ended added by Anitha******************/ 
    }
    
    public void beforeUpdate() { 
        AccountContactRoleHelper.updateIsAddressVerified();
        if(userinfo.getuserid().contains(Label.FMW_API_User) || userinfo.getuserid().contains(Label.FMWFoundationUser) || Test.isRunningTest())
        {            
            List<Account_Contact_Role__c> acrlist = (List<Account_Contact_Role__c>)Trigger.new;
            Map<Id, Account_Contact_Role__c> acrMap = (Map<Id, Account_Contact_Role__c>)Trigger.oldMap; 
            UpdateTerritory.populateTerritory(acrlist, acrMap, 'Account_Contact_Role__c');
        }   
        //if(ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES){
        
        for(sObject acr1:Trigger.new){
            acr1.put('Account_Contact_Ids__c',acr1.get('Account__c')+'_'+acr1.get('Contact__c'));
            acr1.put('Account_ID__c', acr1.get('Account__c'));
        }
        //  ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = false; 
        //}
          /****************SFDC-3974 starts added by Anitha******************/
        AccountContactRoleHelper.copyAccountAddress();
        /****************SFDC-3974 Ended added by Anitha******************/ 
    }
    
    public void beforeDelete() {}
    
    public void afterInsert() {
        try{  
            // [4/26/2018]Added by Anjaneyulu to Update contacts with Company Ids- When it syncs from eSig
            AccountContactRoleHelper.updateContactwithCompany((List<Account_Contact_Role__c>)Trigger.new);
            // Added by Anjaneyulu for STCM-127, STCM-130 and SFSB-470 -- Starts 
            
            List<AccountContactRole> acrsToCreate = new List<AccountContactRole>();
            Set<Id> companyIds = new Set<Id>();
            for(Account_Contact_Role__c acr : (List<Account_Contact_Role__c>)Trigger.new ){
                if(acr.ConCompId__c != acr.AccCompId__c){
                    companyIds.add(acr.AccCompId__c); 
                    
                }
            }
            
            if(!companyIds.isEmpty()){
                Map<Id,Account> companies = new Map<Id,Account>([Select id,(Select id,AccountId,Role,ContactId from AccountContactRoles) from Account where id in :companyIds]);
                Set<String> excontactIds = new Set<String>();
                for(Account_Contact_Role__c acr : (List<Account_Contact_Role__c>)Trigger.new ){
                    
                    if(companies.get(acr.AccCompId__c) != null && companies.get(acr.AccCompId__c).AccountContactRoles.isEmpty() && !excontactIds.contains(acr.AccCompId__c+'_'+acr.Contact__c+'_'+Label.ACR_Role_Business)){
                        acrsToCreate.add(new AccountContactRole(AccountId=acr.AccCompId__c,ContactId=acr.Contact__c,Role=Label.ACR_Role_Business,IsPrimary=true)); 
                        excontactIds.add(acr.AccCompId__c+'_'+acr.Contact__c+'_'+Label.ACR_Role_Business);
                    }else if(companies.get(acr.AccCompId__c) != null && !companies.get(acr.AccCompId__c).AccountContactRoles.isEmpty()){
                        for(AccountContactRole ccr : companies.get(acr.AccCompId__c).AccountContactRoles){
                            excontactIds.add(ccr.AccountId+'_'+ccr.ContactId+'_'+ccr.Role);   
                        }
                        
                        if(!excontactIds.contains(acr.AccCompId__c+'_'+acr.Contact__c+'_'+Label.ACR_Role_Business)){
                            if(acr.Account_Install_Base_Flag__c || acr.Role__c !=Label.ACR_Role_Primary_Contact)
                                acrsToCreate.add(new AccountContactRole(AccountId=acr.AccCompId__c,ContactId=acr.Contact__c,Role=Label.ACR_Role_Business));
                            else
                                acrsToCreate.add(new AccountContactRole(AccountId=acr.AccCompId__c,ContactId=acr.Contact__c,Role=Label.ACR_Role_Business,IsPrimary=true));
                            // Added by Anjaneyulu to avaid duplicate contact role creation
                            excontactIds.add(acr.AccCompId__c+'_'+acr.Contact__c+'_'+Label.ACR_Role_Business);
                        } }  
                    
                }
                
                if(!acrsToCreate.isEmpty())
                    insert acrsToCreate;
            }
        }catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(e.getMessage());
        }
        // Added by Anjaneyulu for STCM-127, STCM-130 and SFSB-470 -- Ends
 
    }
    
    public void afterUpdate() {
        Set<Id> ContactIds = new Set<Id>();
        List<Contact> cons = New List<Contact>();
        List<Account_Contact_Role__c> acrlist = (List<Account_Contact_Role__c>)Trigger.new;
        Map<Id, Account_Contact_Role__c> acrMap = (Map<Id, Account_Contact_Role__c>)Trigger.oldMap;
        
        //[4/26/2018]Added by Thirupathi Aeneni to resolve eSig Issue - Update AccountId on Contact in NA34 if it is blank
      AccountContactRoleHelper.updateContactwithCompany((List<Account_Contact_Role__c>)Trigger.new);
        
        
        //CDH-SFDC-2410: start
        for(Account_Contact_Role__c acr: acrList)
        {
            if(acr.Contact__c!=acrMap.get(acr.id).Contact__c && acr.Contact__c!='' && acrMap.get(acr.id).Contact__c!='')
            {
                ContactIds.add(acr.Contact__c);
                ContactIds.add(acrMap.get(acr.id).Contact__c);
            }
        }
        if(!ContactIds.isEmpty())
        {
            cons = [Select id, Acr_Count__c, RPN__c from Contact where Id in:ContactIds];
            Update cons;
        } //CDH-SFDC-2410: end     
    }
    
    public void afterDelete()
    {
        Set<Id> ContactIds = new Set<Id>();
        List<Contact> cons = New List<Contact>();
        List<Account_Contact_Role__c> acrList = (List<Account_Contact_Role__c>)Trigger.old;
        
        
        //CDH-SFDC-2410: start
        for(Account_Contact_Role__c acr: acrList)
        {
            ContactIds.add(acr.Contact__c);
        }
        
        if(!ContactIds.isEmpty()){
            cons = [Select id, Acr_Count__c, RPN__c from Contact where Id in:ContactIds];
            Update cons;
        } //CDH-SFDC-2410: end
        
        
        DeleteUndeleteTriggerHandler.DeleteUndelete(acrList, 'Account_Contact_Role__c');
    }
    
    public void afterUndelete() {}
    
}