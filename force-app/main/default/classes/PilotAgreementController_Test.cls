@isTest(seeAllData=true)
public class PilotAgreementController_Test {
    public static TestMethod void testAgreementsMethod(){ 
        User partnerUser = [Select Id,AccountId,ProfileId,Account.Primary_Member__c,Account.Pilot_Agreement_Term_Date__c,Account.Pilot_Agreement_Ids__c,isActive,ContactId From User Where isActive=true AND ProfileId=:Label.Rackspace_Partners_Profile AND AccountId!=null AND Account.Primary_Member__c!=null Limit 1];
        Contact con = [Select Id From Contact Where ID =: partnerUser.Account.Primary_Member__c  Limit 1];
        USer pUser = [Select Id,ContactID from User Where ContactID=:con.Id];
        List<ID> ids = new List<ID>();
        List<Id> removeIds = new List<Id>();
         Map<Id,ContentDocument> contentDocumentList = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
        for(ContentDistribution cd :[SELECT Id,ContentDocumentId From ContentDistribution Where ContentDocumentID In : contentDocumentList.keySet()])
			ids.add(cd.id);
        removeIds = ids;
        System.runAs(pUser){
            PilotAgreementController.getAgreements(partnerUser.AccountId);
            PilotAgreementController.updateSelectedAgreements(partnerUser.AccountId, ids);
            PilotAgreementController.EnforcedAgreements(partnerUser.AccountId);
            PilotAgreementController.RemoveSelectedAgreements(partnerUser.AccountId, removeIds);
            PilotAgreementController.getPreviewUrls();
            PilotAgreementController.updatePilotAgreementDate(ids[0]);
            //PilotAgreementController.updatePilotAgreementDate(ids[1]);
            PilotAgreementController.getPreviewedUrls();
            PilotAgreementController.updatePilotAgreementDate('');
            partnerUser.Account.Pilot_Agreement_Ids__c=null;
            partnerUSer.Account.Pilot_Agreement_1__c='';
            update partnerUser.Account;
           PilotAgreementController.updatePilotAgreementDate(ids[0]);
            partnerUSer.Account.Pilot_Agreement_1__c='abcdef1';
            partnerUSer.Account.Pilot_Agreement_2__c='';
            update partnerUser.Account;
           PilotAgreementController.updatePilotAgreementDate(ids[0]);
            partnerUSer.Account.Pilot_Agreement_1__c='abcdef1';
            partnerUSer.Account.Pilot_Agreement_2__c='abcdefg2';
            partnerUSer.Account.Pilot_Agreement_3__c='';
            update partnerUser.Account;
             PilotAgreementController.updatePilotAgreementDate(ids[0]);
             partnerUSer.Account.Pilot_Agreement_1__c='abcdef';
            partnerUSer.Account.Pilot_Agreement_2__c='abcdefg';
            partnerUSer.Account.Pilot_Agreement_3__c='abcdefg3';
            partnerUSer.Account.Pilot_Agreement_4__c='';
            update partnerUser.Account;
             PilotAgreementController.updatePilotAgreementDate(ids[0]);
            partnerUSer.Account.Pilot_Agreement_1__c='abcdef';
            partnerUSer.Account.Pilot_Agreement_2__c='abcdefg';
            partnerUSer.Account.Pilot_Agreement_3__c='abcdefg3';
            partnerUSer.Account.Pilot_Agreement_4__c='abcdefg4';
             partnerUSer.Account.Pilot_Agreement_5__c='';
            update partnerUser.Account;
           PilotAgreementController.updatePilotAgreementDate(ids[0]);
            RaxInfoController.raxinfo();  
            
        }
       
    }
    public static TestMethod void testAgreementsMethod2(){ 
        User partnerUser = [Select Id,AccountId,ProfileId,Account.Enforce_Pilot_Agreement__c,Account.Primary_Member__c,Account.Pilot_Agreement_Term_Date__c,Account.Pilot_Agreement_Ids__c,Account.Enforced_Pilot_Agreement_Ids__c,isActive,ContactId From User Where isActive=true AND ProfileId=:Label.Rackspace_Partners_Profile AND AccountId!=null AND Account.Primary_Member__c!=null Limit 1];
        Contact con = [Select Id From Contact Where ID =: partnerUser.Account.Primary_Member__c  Limit 1];
        USer pUser = [Select Id,ContactID from User Where ContactID=:con.Id];
        List<ID> ids = new List<ID>();
         Map<Id,ContentDocument> contentDocumentList = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
        
        System.runAs(pUser){
            //PilotAgreementController.getAgreements(partnerUser.AccountId);
            //PilotAgreementController.updateSelectedAgreements(partnerUser.AccountId, ids);
            //PilotAgreementController.getPreviewUrls();
            //PilotAgreementController.updatePilotAgreementDate(ids[0]);
           // PilotAgreementController.updatePilotAgreementDate(ids[1]);
            //PilotAgreementController.getPreviewedUrls();
            for(ContentDistribution cd : [SELECT Id,ContentDocumentId From ContentDistribution Where ContentDocumentID In : contentDocumentList.keySet()])
                contentDocumentList.remove(cd.ContentDocumentId);
            //List<ContentDistribution> cd =[];
            system.debug('size'+contentDocumentList.size());
            //System.assert(cd.size() == 0);
             RaxInfoController.raxinfo();  
            partnerUser.Account.Enforced_Pilot_Agreement_Ids__c ='';
            partnerUser.Account.Pilot_Agreement_Ids__c ='';
            partnerUser.Account.Enforce_Pilot_Agreement__c =true;
            Update partnerUser.Account;
            RaxInfoController.raxinfo();  
            
        }
       
    }

}