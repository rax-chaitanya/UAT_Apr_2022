public without sharing class RaxInfoController {
    
      public static Integer ONBOARDING_OPEN = 0;
    
    @AuraEnabled
    public static String raxinfo(){
       User puser = [Select name,AccountId,id,contactid,Account.Enforced_Pilot_Agreement_Ids__c,Account.Pilot_Agreement_Ids__c,Account.Enforce_Pilot_Agreement__c  from User where id =: UserInfo.getUserId() limit 1];
        Account company = [Select Id,Name,Partner_Level__c,Primary_Member__c,onboard_step__c,Agreed_By_Timestamp__c,OwnerId,Owner.Email,Owner.Phone,Contract_Signed_Date__c from Account where id = : puser.AccountId limit 1];
        User pam = [Select name, phone, Email, id from User where id =: company.OwnerId limit 1];
        String retVal ='';
        
        // Added by Thirupathi Aeneni to automatically disable the Pilot Agreements tab in Portal when all agreements are expired - start
      
        if(puser.Account.Enforced_Pilot_Agreement_Ids__c != null && puser.Account.Pilot_Agreement_Ids__c != null && puser.Account.Enforce_Pilot_Agreement__c ){
           
            Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
            
            for(ContentDistribution con : [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                           where ContentDocumentId In : contentDocumentMap.KeySet()]){
                                            
              if(puser.Account.Enforced_Pilot_Agreement_Ids__c.contains(con.id) || puser.Account.Pilot_Agreement_Ids__c.contains(con.id)){
                if(con.ExpiryDate < System.now())
                    contentDocumentMap.remove(con.ContentDocumentId);
              }
              else{
                  
                    contentDocumentMap.remove(con.ContentDocumentId);                               
              }
            }
            
            List<ContentDistribution> listCon = new List<ContentDistribution>([SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                           where ContentDocumentId In : contentDocumentMap.KeySet()]);
           
            if(listCon.size() == 0){
               
                puser.Account.Enforced_Pilot_Agreement_Ids__c = '';
                puser.Account.Pilot_Agreement_Ids__c = '';
                puser.Account.Enforce_Pilot_Agreement__c= false;
                update puser.Account;
            }
        }
        if(puser.Account.Enforced_Pilot_Agreement_Ids__c == null && puser.Account.Pilot_Agreement_Ids__c == null &&  puser.Account.Enforce_Pilot_Agreement__c){
                puser.Account.Enforce_Pilot_Agreement__c=false; 
             update puser.Account;
           } 
    
        // Added bY Thirupathi Aeneni For SFDC-2306 - Ends
        
        
        
        if(pam == null || String.isBlank(company.Owner.Email))
            retVal = Label.RacksapceHelpDeskEmail;        
        else{
            if(String.isNotBlank(pam.name)){
                retVal += pam.name;
                retVal += '  | ';
            }
            if(pam.phone!=null){
                retVal += pam.phone;
                retVal += '  | ';
            }
            if(String.isNotBlank(pam.Email))
                retVal +=String.valueOf(pam.Email);
        }
            if(puser.contactId == company.Primary_Member__c){
                if(company.onboard_step__c != 'completed' && 
                   (company.Partner_Level__c == Label.Reseller ||company.Partner_Level__c == Label.Referral || company.Partner_Level__c == Label.Referral_Reseller || company.Partner_Level__c == Label.ResellerEMEA ||company.Partner_Level__c == Label.ReferralEMEA || company.Partner_Level__c == Label.Reseller_ReferralEMEA ||  company.Partner_Level__c == Label.Strategic ||company.Partner_Level__c == Label.Master_Agent || company.Partner_Level__c == Label.StrategicEMEA || company.Partner_Level__c == Label.Reseller_Referral || company.Partner_Level__c == Label.Master_Agent_EMEA))
                {
                    return System.Label.NotSigned;  
                    
                }  
            }
              
        return retVal;
        
    }
    
    @AuraEnabled
    public static Integer getOnboarding(){
         
        return ONBOARDING_OPEN+1;
    }
}