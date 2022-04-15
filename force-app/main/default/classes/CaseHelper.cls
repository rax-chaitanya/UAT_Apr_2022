/*********************************************************************************
Author: D Anjaneyulu
Date: 09/19/2017
Description: This apex class is created for the Trigger Framework. This class conatins helper methods
for case functionality.
**********************************************************************************/
public class CaseHelper {
    /*
    public static void updateContactforPartnerCases(){
        
        List<Case> newCases = (List<Case>)Trigger.new;
        set<Id> rvmemberIds = new Set<Id>();
        for(Case c : newCases){
            if(c.rvpe__RVMember__c != null && c.RecordTypeId == Label.CasePartnerRecordTypeId)
                rvmemberIds.add(c.rvpe__RVMember__c) ; 
        }
        if(rvmemberIds.size() > 0){
            Set<Id> RVaccids = new Set<Id>();
            Map<String,Id> RVaccidEmailVsrvMId = new Map<String,Id>();
            Map<Id,Id> rvmIdVsConId = new Map<Id,Id>();
            for(rvpe__RVMember__c rvm : [Select id,name,rvpe__Email__c,rvpe__RVAccount__c from rvpe__RVMember__c where id in :rvmemberIds]){
                
                if(rvm.rvpe__RVAccount__c != null && String.isNotBlank(rvm.rvpe__Email__c)){
                    RVaccids.add(rvm.rvpe__RVAccount__c);
                    RVaccidEmailVsrvMId.put(rvm.rvpe__RVAccount__c + rvm.rvpe__Email__c,rvm.Id);
                }
            }
           
            if(RVaccids.size() > 0){
                
                for(Contact c : [Select id,RV_Account__c,Email from Contact where RV_Account__c in : RVaccids]){
                    
                    if(RVaccidEmailVsrvMId.containsKey(c.RV_Account__c+c.Email)){
                        rvmIdVsConId.put(RVaccidEmailVsrvMId.get(c.RV_Account__c+c.Email), c.Id);  
                    }
                }
                
                for(Case c : newCases){
                    if(c.rvpe__RVMember__c != null && c.RecordTypeId == Label.CasePartnerRecordTypeId){
                        if(rvmIdVsConId.containsKey(c.rvpe__RVMember__c))
                            c.ContactId = rvmIdVsConId.get(c.rvpe__RVMember__c);
                    }
                }
            }
        }  
        
    }
    */
    
    public static void updateLocationForPartnerCases(){
        
        Set<Id> companyIds = new Set<Id>();
        for(Case c : (List<Case>) Trigger.New){
            if(c.RecordTypeId == Label.CasePartnerRecordTypeId){
                if(String.isNotBlank(c.AccountId) && String.isBlank(c.Location__c))
                    companyIds.add(c.AccountId);
            }
                  }

        if(companyIds.size() > 0){
            List<Case> cases = new List<Case>();
             Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;   
            Map<Id,Account> companies = new Map<Id,Account>([Select Id,Territory__c,BillingCountry from Account where id in : companyIds]);
            for(Case c : (List<Case>) Trigger.New){
                Account comp = companies.get(c.AccountId);
                if(String.isNotBlank(comp.BillingCountry))
                {
                    Case ca = new Case(Id = c.Id);
                 ca.setOptions(dmo);
                    if(Label.EMEA_Countries.contains(comp.BillingCountry))
                    ca.Location__c = 'EMEA';
                else if(Label.APAC_Countries.contains(comp.BillingCountry))
                    ca.Location__c = 'APAC';
                else if(Label.LATAM_Countries.Contains(comp.BillingCountry))
                    ca.Location__c = 'US';
                else ca.Location__c = 'DACH';
            cases.add(ca);
            }
            }
            
           if(cases.size() > 0)
               update cases;
        }
    }
}