/**
 * File : PilotAgreementController.cls
 * Description : Apex Controller to handle the Pilot Agreement Functionality (SFDC-2185,SFDC-2306,SFDC-2477)
 * Created Date : 10/Jul/2018
 * Last Modified Date : 24/SEP/2018
 * @author : RDC (Thirupathi Aeneni)
 */
public without sharing class PilotAgreementController {
     @AuraEnabled
    Public static List<sObject> EnforcedAgreements(String AccountId){
        Account pAccount = [Select Id,Enforced_Pilot_Agreement_Ids__c,Enforced_Agreements_count__c,Pilot_Agreement_Ids__c,Enforce_Pilot_Agreement__c From Account Where Id =: AccountId];
        Map<Id,ContentDistribution> distributionMap = New Map<Id,ContentDistribution>();
        Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
        If(contentDocumentMap.keySet().size()>0){
            for(ContentDistribution con : [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                           where ContentDocumentId In : contentDocumentMap.KeySet()])
                if(con.ExpiryDate < System.now())
                contentDocumentMap.remove(con.ContentDocumentId);
            
            
             
            for(ContentDistribution cd :[SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                         where ContentDocumentId In : contentDocumentMap.KeySet()])
                if(pAccount.Enforced_Pilot_Agreement_Ids__c != null){
                	If(pAccount.Enforced_Pilot_Agreement_Ids__c.contains(cd.Id) && (pAccount.Pilot_Agreement_Ids__c == null || ! pAccount.Pilot_Agreement_Ids__c.contains(cd.id)))
                		if(!distributionMap.containsKey(cd.ContentDocumentId))
                		distributionMap.put(cd.ContentDocumentId,cd);
             
                   }
        }
       
        If (distributionMap.size()>0){
            
            return distributionMap.values();
        }
        else
            return null;
        
    }
    @AuraEnabled
    Public static void RemoveSelectedAgreements(String AccountId,List<Id> listOfAgreementids){
        Account pAccount = [Select Id,Enforced_Pilot_Agreement_Ids__c,Enforced_Agreements_count__c,Enforce_Pilot_Agreement__c From Account Where Id =: AccountId];
        for(String agreementId : listOfAgreementids){
            If(pAccount.Enforced_Pilot_Agreement_Ids__c.contains(agreementId)){
              pAccount.Enforced_Agreements_count__c--;
                if(pAccount.Enforced_Pilot_Agreement_Ids__c.containsNone(','))
                    pAccount.Enforced_Pilot_Agreement_Ids__c = pAccount.Enforced_Pilot_Agreement_Ids__c.remove(agreementId);
                    
                else if(pAccount.Enforced_Pilot_Agreement_Ids__c.contains(agreementId+','))
                    pAccount.Enforced_Pilot_Agreement_Ids__c = pAccount.Enforced_Pilot_Agreement_Ids__c.remove(agreementId+',');
                else
                    pAccount.Enforced_Pilot_Agreement_Ids__c = pAccount.Enforced_Pilot_Agreement_Ids__c.remove(','+agreementId); 
                   
                    
            }
                
            
        }
       
        Update pAccount;
    }

    @AuraEnabled
    Public static List<ContentDistribution> getPreviewUrls(){
        User partnerUser = [Select Id,AccountId,Account.Primary_Member__c,Account.Enforced_Pilot_Agreement_Ids__c,Account.Pilot_Agreement_Ids__c,ContactId From User Where Id =: UserInfo.getUserId() Limit 1];
        Map<Id,ContentDistribution> distributionMap= new Map<Id,ContentDistribution>();
        If(System.Label.Partner_Profiles.contains(UserInfo.getProfileId())){
            If(partnerUser.ContactId == partnerUser.Account.Primary_Member__c){
                If(partnerUser.Account.Enforced_Pilot_Agreement_Ids__c != null){
                    Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
                   
                    If(contentDocumentMap.size()>0) {
                        for(ContentDistribution con : [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                                     where ContentDocumentId In : contentDocumentMap.KeySet()])
            				if(con.ExpiryDate < System.now())
                				contentDocumentMap.remove(con.ContentDocumentId);
                        
                        for(ContentDistribution cd: [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                                     where ContentDocumentId In : contentDocumentMap.KeySet()])
                               If(partnerUser.Account.Enforced_Pilot_Agreement_Ids__c.contains(cd.Id) && (partnerUser.Account.Pilot_Agreement_Ids__c == null || ! partnerUser.Account.Pilot_Agreement_Ids__c.contains(cd.id)))
                                    if(!distributionMap.containsKey(cd.ContentDocumentId))
                                         distributionMap.put(cd.ContentDocumentId,cd);
                               }       
                                
                             
                        
                }
            }
        }
        
       
        
        If(distributionMap.size()>0) 
            return distributionMap.values();
        
        
        return null;
        
        
    } 
    @AuraEnabled
    Public static void updatePilotAgreementDate(String ContentDistId){
       
        try{
             String conName = [Select Id,Name From ContentDistribution Where Id=:ContentDistId Limit 1 ].Name;
            User partnerUser = [Select Id,AccountId,Account.Primary_Member__c,Account.Pilot_Agreement_1__c,Account.Pilot_Agreement_1_Signed_Date__c,
                                Account.Pilot_Agreement_2__c,Account.Pilot_Agreement_2_Signed_Date__c,Account.Pilot_Agreement_3__c,Account.Pilot_Agreement_3_Signed_Date__c,
                                Account.Pilot_Agreement_4__c,Account.Pilot_Agreement_4_Signed_Date__c,Account.Pilot_Agreement_5__c,Account.Pilot_Agreement_5_Signed_Date__c,
                                Account.Pilot_Agreement_6__c,Account.Pilot_Agreement_6_Signed_Date__c,Account.Pilot_Agreement_Ids__c,ContactId From User Where Id =: UserInfo.getUserId() Limit 1];
            If(partnerUser.Account.Pilot_Agreement_Ids__c == null){
                partnerUser.Account.Pilot_Agreement_Ids__c = ContentDistId;
            }
            else{
                partnerUser.Account.Pilot_Agreement_Ids__c = partnerUser.Account.Pilot_Agreement_Ids__c+','+ContentDistId;
            }
            If(String.isBlank(partnerUser.Account.Pilot_Agreement_1__c)){
                partnerUser.Account.Pilot_Agreement_1__c = conName;
                partnerUser.Account.Pilot_Agreement_1_Signed_Date__c = System.now();
            }
            else If(String.isNotBlank(partnerUser.Account.Pilot_Agreement_1__c) && String.isBlank(partnerUser.Account.Pilot_Agreement_2__c)){
                partnerUser.Account.Pilot_Agreement_2__c = conName;
                partnerUser.Account.Pilot_Agreement_2_Signed_Date__c = System.now();
            }
            else If(String.isNotBlank(partnerUser.Account.Pilot_Agreement_1__c) && String.isNotBlank(partnerUser.Account.Pilot_Agreement_2__c) 
                    && String.isBlank(partnerUser.Account.Pilot_Agreement_3__c)){
                partnerUser.Account.Pilot_Agreement_3__c = conName;
                partnerUser.Account.Pilot_Agreement_3_Signed_Date__c = System.now();
            }
            else If(String.isNotBlank(partnerUser.Account.Pilot_Agreement_1__c) && String.isNotBlank(partnerUser.Account.Pilot_Agreement_2__c) && 
                    String.isNotBlank(partnerUser.Account.Pilot_Agreement_3__c) && String.isBlank(partnerUser.Account.Pilot_Agreement_4__c)){
                partnerUser.Account.Pilot_Agreement_4__c = conName;
                partnerUser.Account.Pilot_Agreement_4_Signed_Date__c = System.now();
            }
            else If(String.isNotBlank(partnerUser.Account.Pilot_Agreement_1__c) && String.isNotBlank(partnerUser.Account.Pilot_Agreement_2__c) && 
                    String.isNotBlank(partnerUser.Account.Pilot_Agreement_3__c) && String.isNotBlank(partnerUser.Account.Pilot_Agreement_4__c) &&
                    String.isBlank(partnerUser.Account.Pilot_Agreement_5__c)){
                partnerUser.Account.Pilot_Agreement_5__c = conName;
                partnerUser.Account.Pilot_Agreement_5_Signed_Date__c = System.now();
            }
            else {
                partnerUser.Account.Pilot_Agreement_6__c = conName;
                partnerUser.Account.Pilot_Agreement_6_Signed_Date__c = System.now();
            }
            Update partnerUser.Account;
        }catch(Exception e){
            
        }
    }
    @AuraEnabled
    Public static List<ContentDistribution> getPreviewedUrls(){
        Map<Id,ContentDistribution> distributionMap= new Map<Id,ContentDistribution>();
        User partnerUser = [Select Id,AccountId,Account.Primary_Member__c,Account.Enforce_Pilot_Agreement__c,Account.Enforced_Pilot_Agreement_Ids__c,Account.Pilot_Agreement_Ids__c,ContactId From User Where Id =: UserInfo.getUserId() Limit 1];
        If(System.Label.Partner_Profiles.contains(UserInfo.getProfileId())){
            If(partnerUser.ContactId == partnerUser.Account.Primary_Member__c){
                Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
                
                If(contentDocumentMap.size()>0){
                     for(ContentDistribution con : [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                                     where ContentDocumentId In : contentDocumentMap.KeySet()])
            			if(con.ExpiryDate < System.now())
                			contentDocumentMap.remove(con.ContentDocumentId);
                    
                    for(ContentDistribution cd: [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                                 where ContentDocumentId In : contentDocumentMap.KeySet()])
                      If(partnerUser.Account.Pilot_Agreement_Ids__c != null &&  partnerUser.Account.Pilot_Agreement_Ids__c.contains(cd.id))
                           if(!distributionMap.containsKey(cd.ContentDocumentId))
                               distributionMap.put(cd.ContentDocumentId,cd);
                }
           
            }
            
        }
        
        If(distributionMap.size()>0) 
            return distributionMap.values();
        
        	return null;
             
    } 
    @AuraEnabled
    Public static  Object getAgreements(Id AccountId){
        Map<String,Object> result = new Map<String,Object>();
        result.put('agreementscount',getAgreementsCount(AccountId));
        result.put('agreementsList',getPilotAgreements(AccountId));
        return result;
    }
     @AuraEnabled
    Public static  Decimal getAgreementsCount(Id AccountId){
        Account pAccount = [Select Id,Enforced_Pilot_Agreement_Ids__c,Enforced_Agreements_count__c,Enforce_Pilot_Agreement__c From Account Where Id =: AccountId Limit 1];
        if(pAccount.Enforced_Agreements_count__c == null)
            pAccount.Enforced_Agreements_count__c =0;
        return pAccount.Enforced_Agreements_count__c;
    }
    @AuraEnabled
    Public static  List<sObject> getPilotAgreements(Id AccountId){
        Account pAccount = [Select Id,Enforced_Pilot_Agreement_Ids__c,Enforced_Agreements_count__c,Enforce_Pilot_Agreement__c From Account Where Id =: AccountId];
        Map<Id,ContentDistribution> distributionMap = New Map<Id,ContentDistribution>();
        Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
        If(contentDocumentMap.keySet().size()>0 && (pAccount.Enforced_Agreements_count__c<6 || pAccount.Enforced_Agreements_count__c == null)){
        for(ContentDistribution con : [SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                                     where ContentDocumentId In : contentDocumentMap.KeySet()])
            if(con.ExpiryDate < System.now())
                contentDocumentMap.remove(con.ContentDocumentId);
        
        
            for(ContentDistribution cd :[SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                                     where ContentDocumentId In : contentDocumentMap.KeySet()])
            	If(pAccount.Enforced_Pilot_Agreement_Ids__c == null || ! pAccount.Enforced_Pilot_Agreement_Ids__c.contains(cd.Id))
           			if(!distributionMap.containsKey(cd.ContentDocumentId))
                       distributionMap.put(cd.ContentDocumentId,cd);
                 
        }
       
        If (distributionMap.size()>0){
           
            return distributionMap.values();
         }
        else
            return null;
    }
    @AuraEnabled
    Public static  void updateSelectedAgreements(Id AccountId,List<Id> listOfAgreementids){
        
        Account pAccount = [Select Id,Enforced_Pilot_Agreement_Ids__c,Enforced_Agreements_count__c,Enforce_Pilot_Agreement__c From Account Where Id =: AccountId];
        if(pAccount.Enforced_Agreements_count__c == null)
        	pAccount.Enforced_Agreements_count__c=0;
        List<Account> pAccountList = new List<Account>();
        for(Id cId : listOfAgreementids){
            pAccount.Enforced_Agreements_count__c++;
            if(pAccount.Enforced_Pilot_Agreement_Ids__c == null )
                pAccount.Enforced_Pilot_Agreement_Ids__c = cId;
            else
                pAccount.Enforced_Pilot_Agreement_Ids__c =pAccount.Enforced_Pilot_Agreement_Ids__c+','+cId;
            
            
        }
         pAccount.Enforce_Pilot_Agreement__c = true;
            
        try{
            Update pAccount;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}