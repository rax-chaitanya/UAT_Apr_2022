@isTest(SeeAlldata=true)
public class UpdateCompanyOICParticipantTest {
   @isTest 
    static void updateOiCParticipantTest(){
         List<id> acclist = new List<id>();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Account company = new Account(Name = 'TestCompany',Partner_Level__c='Strategic', Contract_Signed_Date__c= System.today().addDays(2), Partner_Account_Status__c ='Approved', BillingCountry = 'Canada',OIC_Participant__c= false, Contract_Type__c='EMEA Reseller Agreement',ShippingCountry = 'Canada',RecordTypeId=recordTypeId);
       /* Account acc =new Account(Name=' testCompany',Partner_Account_Status__c='Approved',RecordTypeId=recordTypeId,OIC_Participant__c= false,Contract_Type__c='EMEA Reseller Agreement',
                                 Contract_Signed_Date__c= System.today().addDays(2),BillingCountry='United States',Territory__c='US/CANADA');*/
        
        Insert company;
        Opportunity opty = new Opportunity(Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Closed Won',AccountId=a.Id,Partner_Company__c=company.Id,CloseDate=System.today(),Focus_Area__c='Amazon',Category__c='Downgrade',CurrencyIsoCode='USD');
        insert opty;
        
        Partner_Role__c pRolewithOpp=new Partner_Role__c(Opportunity__c=opty.Id,Partner_Company__c=company.Id,Role__c='Source',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithOpp;
        test.startTest();
        company.Name=' testCompany1234';
        update company;
        
        acclist.add(company.id);
        UpdateCompanyOICParticipant.updateOiCParticipant(acclist);
        test.stopTest();
        
    }
    
}