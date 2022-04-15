public without sharing class AgreementDownloadController { 
    @AuraEnabled
    public static Account getPartnerType(){
        User u = [Select AccountId from User where id =: UserInfo.getUserId() limit 1];   
        return [Select Id,Partner_Level__c,Contract_Type__c,Contact_Status__c,Add_Attachment__c from Account where id = : u.AccountId limit 1];
    }
    
    @AuraEnabled
    public static List<String> getAgreements(List<string> docTypes){ 
        User u = [Select AccountId from User where id =: UserInfo.getUserId() limit 1];
        Account acc = [Select Id,Partner_Level__c,Contract_Type__c,Contact_Status__c,Add_Attachment__c,Agreement_Enhancements_Ids__c
                       from Account where id = : u.AccountId limit 1];
        List<String> agreements = new List<String>();
        Set<Id> docId = new Set<Id>();
        //start --6163
        List<String> Global_Strategic_referral_Partner_Agreements = System.Label.Global_Strategic_referral_Partner_Agreements.Split(',');
        List<String> Partner_Level_all_values = System.Label.Partner_Level_all_values.Split(',');
        //end --6163
        if(docTypes != null && docTypes.size()>0){
            for(ContentVersion cVersion:[SELECT Id, ContentDocumentId FROM ContentVersion WHERE Related_To__c IN:docTypes]){
                docId.add(cVersion.ContentDocumentId); 
            } 
            for(ContentDistribution content:[SELECT DistributionPublicUrl,id FROM ContentDistribution where contentDocumentId IN:docId order by createdDate desc]){
               if(acc.Contract_Type__c==System.Label.Strategic_Partner_Agreement && acc.Contact_Status__c=='Active' && acc.Agreement_Enhancements_Ids__c!=null){    
  			 //SFDC-6163 start
  			 //6163 is reverted back to show Agreements as before this story
                //if(Global_Strategic_referral_Partner_Agreements.contains(acc.contract_type__c) && acc.Contact_Status__c=='Active' && acc.Agreement_Enhancements_Ids__c!=null ){    
                   //SFDC-6163 end
                    if(acc.Agreement_Enhancements_Ids__c.contains(content.id)){
                         agreements.add(content.DistributionPublicUrl); 
                    }
                }else if(acc.Partner_Level__c!='Master Agent' && acc.Partner_Level__c!='Strategic'){
                   agreements.add(content.DistributionPublicUrl); 
                }
    			 //SFDC-6163 start
    			 //6163 is reverted back to show Agreements as before this story

          /*   else if(!Partner_Level_all_values.contains(acc.Partner_Level__c)){
                  agreements.add(content.DistributionPublicUrl); 
                }  */                 
				//SFDC-6163 end
            }  
            }  
         
        system.debug('agree'+agreements);
        return agreements;
    }
}