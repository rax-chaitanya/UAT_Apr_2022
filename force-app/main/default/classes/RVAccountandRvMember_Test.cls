@isTest
public class RVAccountandRvMember_Test {
    
    static testmethod void rvAccountTest(){
        
        Trigger_Manager__c cs = new Trigger_Manager__c();
        cs.Name='RVAccountTgr';
        cs.Is_Active__c = true;
        insert cs; 
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
        List<rvpe__RVAccount__c> rvAccount = ST_TestUtil.getRvAccount('rvAccountTest', 28910, 1000);       
        insert rvAccount;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
        update rvAccount;
        
        delete rvAccount;
        
        undelete rvAccount;
        
        system.debug('list of accounts inserted ******** rvAccount :' +rvAccount.size());
        
    }
    static testmethod void rvMemberTest(){        
        
        Trigger_Manager__c cs = new Trigger_Manager__c();
        cs.Name='RVMemberTgr';
        cs.Is_Active__c = true;
        insert cs;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
        List<rvpe__RVMember__c> rvMember = ST_TestUtil.getRvMember('rvMemberTest', 28910, 'Mark',  1000);       
        insert rvMember;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
        update rvMember;
        
        delete rvMember;
        
        undelete rvMember;
       
        /*
        List<PartnerNetworkRecordConnection> pnr = new List<PartnerNetworkRecordConnection>([select id from PartnerNetworkRecordConnection where localRecordId in : rvMember]);
        System.assert(pnr.size()==1000,true); 
        */
                
    }
}