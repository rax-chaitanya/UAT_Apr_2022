/*
* Author: Kartikeya Tewari
* Ticket: SFDC-1204
* Description: Controller for Onboarding wizard parent/main component
* Updated : SFDC-6574 : Contract Status is set to Active when a New Partner accepts the Agreement 
*/
public without sharing class PartnerOnboardingController {    
    @AuraEnabled
    public static Account getPartnerAccount(){
        User puser = [Select name,AccountId,id,contactid from User where id =: UserInfo.getUserId() limit 1];
        Account company = [Select Id,Partner_Level__c,onboard_step__c,Completion_Progress__c,click_to_agree__c,Contract_Signed_Date__c
                           from Account where id = : puser.AccountId limit 1];
        return company;
    }
    
    @AuraEnabled
    public static String saveProcessAndClose(String progress){
        User puser = [Select name,AccountId,id,contactid from User where id =: UserInfo.getUserId() limit 1];
        Account company = [Select Id,Partner_Level__c,onboard_step__c,Completion_Progress__c,click_to_agree__c,Contract_Signed_Date__c
                           from Account where id = : puser.AccountId limit 1];
        company.onboard_step__c = progress;
        if(progress=='agreements' && company.Contract_Signed_Date__c!=null){
            company.Completion_Progress__c = 40;    
        }else if(progress=='payments'){
            company.Completion_Progress__c = 40;    
        }else if(progress=='onboarding'){
            company.Completion_Progress__c = 70;    
        }else if(progress=='completed'){
            company.Completion_Progress__c = 100; 
        }
        
        try{
            update company;
            return 'success';
        }catch(Exception e){
            return 'failed';
        }
    }
    
    @AuraEnabled
    public static void setAgreementDate(){
        
        User puser = [Select name,AccountId,id,contactid from User where id =: UserInfo.getUserId() limit 1];
        Account company = [Select Id,Partner_Level__c,Program_Of_Interest__c,Territory__c
                           from Account where id = : puser.AccountId limit 1];
        
        company.Contract_Signed_Date__c = System.Date.today();
        company.Agreed_By_Timestamp__c = System.now();
        company.Reseller_Contract_Start_Date__c = System.Date.today();
        
        //SFDC-3865 Started   
        String ContractType;
        if(company.Program_Of_Interest__c == 'Referral Only'){
            
            ContractType = territoryBasedContractType('Referral',company.Territory__c);
        }
        else if(company.Program_Of_Interest__c == 'Reseller - Rackspace Services Only (Excludes Email Services)'){
            ContractType = territoryBasedContractType('Reseller',company.Territory__c);
        }
        else if(company.Program_Of_Interest__c == 'Referral/Reseller - Rackspace Services Only (Excludes the resell of Email Services'){
            ContractType = territoryBasedContractType('Referral/Reseller',company.Territory__c);
        }
        
        if(ContractType != null && ContractType != 'No Contract')
        {
            company.Contract_Type__c = ContractType;
        }
        //SFDC-6574 - Starts - Rishabh 
        if(company.Contract_Type__c.contains('Reseller')||company.Contract_Type__c.contains('Referral'))
        {
            company.Contact_Status__c='Active';
        }
        //SFDC-6574 - Ends - Rishabh
        company.Completion_Progress__c = 40;
        
        update company; 
        
    }
    
    public static String territoryBasedContractType(String PGInterest,String Territory){
        
        Map<String,String> contractTypeMap = new Map<String,String>();   
        if(System.Label.Territories_under_EMEA_Agreement.contains(Territory) ){  
            //SFDC-4556
            contractTypeMap.put(PGInterest+Territory,'International '+PGInterest+' Agreement (EMEA)');          
            return contractTypeMap.get(PGInterest+Territory);   
        }
        else if(System.Label.Territories_under_US_Agreement.contains(Territory) ){
            contractTypeMap.put(PGInterest+Territory,'US '+PGInterest+' Agreement');
            return contractTypeMap.get(PGInterest+Territory);
            
        }
        else if(System.Label.Territories_under_LATAM_Agreement.contains(Territory) ){
            contractTypeMap.put(PGInterest+Territory,'LATAM '+PGInterest+' Agreement');
            return contractTypeMap.get(PGInterest+Territory);
        }
        else if(System.Label.Territories_under_AUS_Agreement.contains(Territory) ){
            contractTypeMap.put(PGInterest+Territory,'AUS '+PGInterest+' Agreement');
            return contractTypeMap.get(PGInterest+Territory);
        }
        
        return 'No Contract';
    }
    //SFDC-3865 Ended
}