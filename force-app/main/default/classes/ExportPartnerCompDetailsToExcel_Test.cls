@isTest 
public class ExportPartnerCompDetailsToExcel_Test {
        @TestSetUp
    static void setDataUp(){
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;}
    
    static testMethod void validateExportCompensationDetails() {
        
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        List<OrgConstants__c> orgConst = new List<OrgConstants__c>();
        orgConst.add(new OrgConstants__c(Name='Prod Org ID',Prod_Value__c='00D61000000J4OKEA0',Non_Prod_Value__c='00D61000000J4OKEA0'));
        orgConst.add(new OrgConstants__c(Name='Company Approval Process ID',Prod_Value__c='04a4C0000008PNQ',Non_Prod_Value__c='04a4C0000008PNQ'));
        orgConst.add(new OrgConstants__c(Name = '#salesforce-errors', Prod_Value__c = 'https://hooks.slack.com/services/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', Non_Prod_Value__C = 'https://hooks.slack.com/services/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'));              
        orgConst.add(new OrgConstants__c(Name='System Administrator ID',Prod_Value__c='00561000001ziVf',Non_Prod_Value__c='00561000001ziVf'));
      //  orgConst.add(new OrgConstants__c(Name='System Administrator ID',Prod_Value__c='00561000001ziVf',Non_Prod_Value__c='00561000001ziVf'));
      insert orgConst;
      //  Trigger_Manager__c tgmr=new Trigger_Manager__c();
      //  tgmr.Is_Active__c=true;
       // tgmr.Name='ContactTgr';
       // insert tgmr;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        
        Account a = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = RecordTypeIdAccount,Partner_Account_Status__c = 'Approved');
        insert a; 
        
        Account a1 = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(),Partner_Account_Status__c = 'Approved');
        insert a1;        
        
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        Account acc = new Account(Name='Custom Account',Company_Name__c=a1.id,Is_install_Base__c = true,recordTypeId=RecordTypeIdAcc);
        insert acc;
        
        Partner_Compensation__c pc = new Partner_Compensation__c(Partner_Company__c=a.id);
        insert pc;
        Partner_Compensation__c pc1 = new Partner_Compensation__c(Partner_Company__c=a.id);
        Partner_Compensation_Detail__c pcd = new Partner_Compensation_Detail__c();
        pcd.Account__c = acc.id;
        pcd.Amount__c = 200;
        pcd.Partner_Compensation__c = pc.Id;
        insert pcd;
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',RecordTypeId = crecordType);
        insert con;  
        Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
        
       // insert user;
       
      //  System.runAs(user){
            
            PageReference pageRef = Page.ExportCompensationDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(pc);
            ApexPages.currentPage().getParameters().put('id',pc.id);
            
            ExportPartnerCompensationDetailsToExcel exp = new ExportPartnerCompensationDetailsToExcel();
            //System.assert(exp.partnerCompDetails.size() >0);
            exp.exportAll();
            String xlsHdr = exp.xlsHeader;
            exp.Flag=true;
            String str = 'abcdef';
            PageReference pageRef1 = Page.ExportCompensationDetails;
             ApexPages.currentPage().getParameters().put('id',pc.Id);
            Test.setCurrentPage(pageRef1);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(pc);
            
            ExportPartnerCompensationDetailsToExcel exp1 = new ExportPartnerCompensationDetailsToExcel(sc1);
            exp1.recID=pc.id;
            system.debug('iddd'+exp1.recID);
            system.debug('iddd'+pc.Id);
          //   Test.startTest();
            PageReference pageRef2 = Page.ExportCompensationDetails;
            ApexPages.currentPage().getParameters().put('id',null);
            Test.setCurrentPage(pageRef2);
             
            ApexPages.StandardController sc2 = new ApexPages.StandardController(pc);
            
            ExportPartnerCompensationDetailsToExcel exp2 = new ExportPartnerCompensationDetailsToExcel(sc2);
            exp2.recID='';
            exp2.recID=ApexPages.currentPage().getParameters().get('id');
          //  Test.stopTest();
            //exp1.ExportPartnerCompensationDetailsToExcel();
            //String str=exp1.getbaseUrl();
      ExportPartnerCompensationDetailsToExcel.getbaseUrl();
       // }
    }
    
    
}