public without sharing class AgreementEnhancementsCls {
    
    @AuraEnabled
    Public static  String PartnerLevelValid(Id AccountId){
        system.debug(accountId);
        Account pAccount = [Select Id,Agreement_Enhancements_Ids__c,Add_Attachment__c,Partner_Level__c,Contact_Status__c,Contract_Type__c  From Account Where Id =: AccountId];
      // start-6163
           List<String> Global_Strategic_Partner_Agreement_labels = System.Label.Global_Strategic_Partner_Agreement_labels.Split(',');
    List<String> Partner_Level_Strategic_Step = System.Label.Partner_Level_Strategic_Step.Split(',');
    List<String> Global_Referral_Agreement_labels = System.Label.Global_Referral_Agreement_labels.Split(',');
    List<String> Partner_Level_Referral_Reseller_Step = System.Label.Partner_Level_Referral_Reseller_Step.Split(',');
    List<String> Channel_Distribution_Agreement = System.Label.Channel_Distribution_Agreement.Split(',');
    List<String> Partner_Level_Distribution = System.Label.Partner_Level_Distribution.Split(',');
        
       

        system.debug('chaitu1'+((!pAccount.contract_type__c.contains(System.Label.Global_Strategic_Partner_Agreement_labels))    || (!pAccount.Partner_Level__c.contains(System.Label.Partner_Level_Strategic_Step))) );
    system.debug('chaitu2'+((!pAccount.contract_type__c.contains(System.Label.Global_Referral_Agreement_labels)) || (!pAccount.Partner_Level__c.contains(System.Label.Partner_Level_Referral_Reseller_Step))));
       system.debug('chaitu3'+((!pAccount.contract_type__c.contains(System.Label.Channel_Distribution_Agreement)) || (!pAccount.Partner_Level__c.contains(System.Label.Partner_Level_Distribution))));
        system.debug('chaitu4'+((pAccount.contract_type__c != System.Label.Strategic_Partner_Agreement) || (!Partner_Level_Strategic_Step.contains('Strategic') )));

       // List<String> masternstartegic=new List<string>{'Master Agent','Strategic'};
              if(((!Global_Strategic_Partner_Agreement_labels.contains(pAccount.contract_type__c))    || (!Partner_Level_Strategic_Step.contains(pAccount.Partner_Level__c))) 
&& ((!Global_Referral_Agreement_labels.contains(pAccount.contract_type__c)) || (!Partner_Level_Referral_Reseller_Step.contains(pAccount.Partner_Level__c)))
&&((!Channel_Distribution_Agreement.contains(pAccount.contract_type__c)) || (!Partner_Level_Distribution.contains(pAccount.Partner_Level__c))) 
                && (pAccount.contract_type__c != System.Label.Strategic_Partner_Agreement) ) 
            //end -6163
              {
      
            return 'uncontract';
        }else if(pAccount.Contact_Status__c != 'Active'){
            return 'inactive';
        }else{
            return 'show';
        }
        
        
    }
    
    @AuraEnabled
    Public static  List<List<sObject>> getAttachment(Id AccountId){
        List<List<sObject>> finalreturn = new List<List<sObject>>();
        Account pAccount = [Select Id,Agreement_Enhancements_Ids__c,Add_Attachment__c,Partner_Level__c From Account Where Id =: AccountId];
        Map<Id,ContentDistribution> distributionMap = New Map<Id,ContentDistribution>();
        Map<Id,ContentVersion> cVersion = new Map<Id,ContentVersion>([SELECT Id, ContentDocumentId,Related_to__c FROM ContentVersion 
                                                                      WHERE Related_To__c =: paccount.Partner_Level__c ]);
        If(cVersion.keySet().size()>0){
            for(ContentDistribution cd :[SELECT Id,Name,DistributionPublicUrl,ContentDocumentId,ExpiryDate, createdDate, ContentDownloadUrl FROM ContentDistribution
                                         where ContentVersionId In : cVersion.KeySet()])
                if(!distributionMap.containsKey(cd.ContentDocumentId))
                distributionMap.put(cd.ContentDocumentId,cd);
            
        }
        If (distributionMap.keyset().size()>0){
            List<sObject> toRemove = new List<sObject>();	
            List<sObject> toAdd = new List<sObject>();
            for(id i : distributionMap.keyset()){
                
                if(pAccount.Agreement_Enhancements_Ids__c != null && pAccount.Agreement_Enhancements_Ids__c.contains(distributionMap.get(i).id)){
                    toRemove.add(distributionMap.get(i));
                }else{
                    system.debug('%%%%%%%%%'+toAdd);
                    toAdd.add(distributionMap.get(i));
                }
            }
            finalreturn.add(toAdd);
            finalreturn.add(toRemove);
        }
        if(finalreturn.size()>0){   
            return finalreturn;
        }
        else
            return null;
        
    }
    @AuraEnabled
    Public static  void updateSelectedAgreements(Id AccountId,List<Id> listOfAgreementids){
        
        Account pAccount = [Select Id,Agreement_Enhancements_Ids__c,Add_Attachment__c  From Account Where Id =: AccountId];
        List<Account> pAccountList = new List<Account>();        
        for(Id cId : listOfAgreementids){
            if(pAccount.Agreement_Enhancements_Ids__c == null )
                pAccount.Agreement_Enhancements_Ids__c = cId;
            else if(!pAccount.Agreement_Enhancements_Ids__c.contains(cid))
                pAccount.Agreement_Enhancements_Ids__c =pAccount.Agreement_Enhancements_Ids__c+','+cId;
            
            
        }
        pAccount.Add_Attachment__c  = true;
        
        try{
            Update pAccount;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    Public static  void updateSelectedAgreementsRemove(Id AccountId,List<Id> listOfAgreementids){
        
        Account pAccount = [Select Id,Agreement_Enhancements_Ids__c,Add_Attachment__c  From Account Where Id =: AccountId];
        List<Account> pAccountList = new List<Account>();        
        for(Id cId : listOfAgreementids){
            if(pAccount.Agreement_Enhancements_Ids__c!=null)
                if(!pAccount.Agreement_Enhancements_Ids__c.contains(cId))
            {
                pAccount.Agreement_Enhancements_Ids__c.addError('This Aggrement cannot be removed');
                
            }
            else if(pAccount.Agreement_Enhancements_Ids__c.containsNone(','))
                pAccount.Agreement_Enhancements_Ids__c = pAccount.Agreement_Enhancements_Ids__c.remove(cId);
            else if(pAccount.Agreement_Enhancements_Ids__c.contains(cId+','))
                pAccount.Agreement_Enhancements_Ids__c = pAccount.Agreement_Enhancements_Ids__c.remove(cId+',');
            else
                pAccount.Agreement_Enhancements_Ids__c = pAccount.Agreement_Enhancements_Ids__c.remove(','+cId); 
            
        }
        if(pAccount.Agreement_Enhancements_Ids__c == null || pAccount.Agreement_Enhancements_Ids__c== '')
            pAccount.Add_Attachment__c  = false;
        
        try{
            Update pAccount;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}