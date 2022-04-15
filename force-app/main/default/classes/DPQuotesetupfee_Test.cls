@isTest
public class DPQuotesetupfee_Test {

  
    
    @isTest static void testInsert() {
    try{
     
        TestDataFactory.getProdOrgIDSetting();       
        TestDataFactory.getOrgConstants();
        TestDataFactory.getTriggerManagers();
        TestDataFactory.getFeatureFlagSetting();
        
        Id standard = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        DP_DataCenter__c dc = getDataCenter();
        Account company = new Account(Name = 'Smoke Company',phone='987654325',RecordTypeId=standard);
        insert company;
        
        company = [Select Id, (Select Id from Account__r LIMIT 1) from Account Where Id = :company.Id];
        
        Account acc = company.Account__r[0];
        if (company.Account__r.size() == 0) {
            Id prospect = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
            
            acc = new Account(Name = company.Name, 
                                             RecordTypeId =  prospect);
            insert acc;
            
        }
        
        Opportunity opp = new Opportunity(Name = 'Smoke Opp', 
                                          Type = 'AWS',
                                          StageName = 'Closed Won',
                                          AccountId = company.Id,
                                          
                                          CloseDate = Date.newInstance(Date.today().year(), Date.today().month(), 27) //Date.today().addDays(10)
                                         );
        
        insert opp;
        
        Pricebook2 pbk1 = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update pbk1;        
        Product2 pd2 = new Product2(Name='Oracle Database Advanced Security',DP_Max_Discount__c=0,DP_CAPEX__c=1.0,isActive=true);
        insert pd2;
        /*pricebookentry pbe = new pricebookentry(UnitPrice=0,CurrencyIsoCode='USD',product2id=pd2.Id,pricebook2id=pbk1.Id,isactive=true);
        insert pbe;*/
        
        PricebookEntry pbe = [Select Id, name, product2id, pricebook2id from pricebookentry where product2id != '' and product2.isactive = true and isactive = true limit 1];        
        Test.startTest();
        Quote q = new Quote(OpportunityId = opp.Id, Name = 'Dummy Quote', PriceBook2Id = pbe.Pricebook2Id,QuoteSynced__C=true ,DP_Currency_Code__c='EUR');
        insert q;
        
        
       QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id, DP_Data_Center__c = dc.Id,
                                             PriceBookEntryId = pbe.Id, Product2Id = pbe.Product2Id,
                                             Quantity = 1, UnitPrice = 1,DP_Setup_fee__C=20.00);
     
        
  
        insert qli;
       
        update qli;
              
        delete qli;
       
       // q.DP_Currency_Code__c='EUR';
       // update q;
        
        Test.stopTest();
       }catch(Exception e)
        {
            
        }       
        
    }
     private static DP_DataCenter__c getDataCenter(){
        DP_DataCenter__c dc = new DP_DataCenter__c(Name='Northern Virginia - NOVA11',DP_DataCenterID__c=10000,DP_kWCost__c=0.47,DP_kW_Markup__c=50.00);
        insert dc;
        return dc;
    }
}