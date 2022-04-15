@isTest
public class ProjectExtensionController_Test {
    
    @isTest
    static void createEmeaProject(){
        String pId=[select id,name from Profile where name='Rackspace ProServ - INTL' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        
        
        insert conuser;
        Id recId= [Select id from RecordType where sobjectType='Project__c' and Name='EMEA ProServices' limit 1].id;
        Apexpages.currentPage().getParameters().put('RecordType',recId);
        
        Project__c p = new Project__c(Project_Name__c='Test Account',Close_Date__c = system.today()+2,Proposal_Stage__c = 'Pre Qualify',Milestone_Due_Date__c = System.today());
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectExtensionController pec = new ProjectExtensionController(sc);
        pec.save();
        p.Proposal_Stage__c = 'Qualify';
        pec.save();
        p.Proposal_Stage__c = 'Scope';
        pec.save();
        p.Proposal_Stage__c = 'Proposal & Quote';
        pec.save();
        p.Proposal_Stage__c = 'Proposal & Quote - Modifications';
        pec.save();
        p.Proposal_Stage__c = 'Final Legal';
        pec.save();
        p.Proposal_Stage__c = 'Won - Signed Agreement';
        pec.save();
        
        p.PS_Time_Discounted__c = true;
        try{
            pec.save();
        }catch(Exception e){
            System.assert(e.getMessage().contains(Label.ProjectDiscountApproverRequired));
        }
        p.Discount_Approver__c = conuser.id;
        
        p.Commissions__c = 'Yes';
        
        try{
            pec.save();
        }catch(Exception e){
            System.assert(e.getMessage().contains(Label.ProjectCommissionPercentageRequired));
        }
        
        p.Proposal_Stage__c = 'Lost';
        p.INTL_Project_Lost_Reason__c = null;
        
        try{
            pec.save();
        }catch(Exception e){
            System.assert(e.getMessage().contains(Label.ProjectIntlLostReasonRequired));
        }
        
        p.INTL_Project_Lost_Reason__c ='No Response';
        
      pec.save();
        
       System.assert(pec.Cancel() != null);
        System.assert(pec.Cancel1() != null);
    }
    
    
     @isTest
    static void createEmeaProject1(){
        String pId=[select id,name from Profile where name='Rackspace ProServ - INTL' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        
        
        insert conuser;
        Id recId= [Select id from RecordType where sobjectType='Project__c' and Name='EMEA ProServices' limit 1].id;
        Apexpages.currentPage().getParameters().put('RecordType',recId);
        
        Project__c p = new Project__c(Project_Name__c='Test Account',Close_Date__c = system.today()+2,Proposal_Stage__c = 'Pre Qualify',Milestone_Due_Date__c = System.today());
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectExtensionController pec = new ProjectExtensionController(sc);
      
        p.Proposal_Stage__c = 'Lost';
       
        try{
            pec.save();
        }catch(Exception e){
            System.assert(e.getMessage().contains(Label.ProjectIntlLostReasonRequired));
        }
        
        p.INTL_Project_Lost_Reason__c ='No Response';
        p.Lost_Reason__c ='Price';
        
      pec.save();
        
       System.assert(pec.Cancel() != null);
        System.assert(pec.Cancel1() != null);
    }
}