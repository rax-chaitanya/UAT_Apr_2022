/**********************************************************************************

Author: Sreeramulu Redladinne
Description: This class will be used to create test data for Apex tests.

**********************************************************************************/
@isTest
public class ST_TestUtil {
    
    /**
      *@params - Name for Company, number of records
      *@returns - list of companies
    */  
    public static List<Account> getCompany(String cName, Integer count) {
        List<Account> retVal = new List<Account>();
        for(Integer i = 0; i < count; i++) {
            retVal.add(new Account(Name = cName + i,RecordTypeId = Label.Standard_Company_RecordTypeId));
        }
        return retVal;
    }
    
    /**
      *@params - Name for Contracting Entity, number of records
      *@returns - list of entities
    */  
    public static List<Contracting_Entity__c> getContractingEntity(String ceName, Integer count) {
        List<Contracting_Entity__c> retVal = new List<Contracting_Entity__c>();
        for(Integer i = 0; i < count; i++) {
            retVal.add(new Contracting_Entity__c(Name = ceName + i, Territory__c = 'US/CANADA', Country__c = 'Canada'));
        }
        return retVal;
    }
    
    /**
      *@params - Name for Account, number of records, Company and Contracting Entity
      *@returns - list of 
    */  
    
    
    public static List<Account> getAccount(String aName, Integer count, Account company, Contracting_Entity__c ce) {
        List<Account> retVal = new List<Account>();
        for(Integer i = 0; i < count; i++) {
            retVal.add(new Account(Name = aName + i, BillingCountry = 'US', Company_Name__c = company.Id, Contracting_Entity__c = ce.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID));
        }
        return retVal;
    } 
    
    /**
      *@params - Name of Country and Territory
      *@returns - Country
    */  
   /* public static Country__c getCountry(String country, String territory) {
        Country__c retVal = new Country__c(Name = country, Territory__c = territory);
        return retVal;
    }*/
    
    /**
      *@params - Id of profile and role
      *@returns - User
    */  
    public static User getUser(Id pId, Id rId) {
        User retVal = new User(ProfileId = pId, LastName = 'Test', Username = 'testuser@test.rackspace.com', Email = 'tsetuser@test.rackspace.com',
                                alias = 'testuser123', LanguageLocaleKey = 'en_US', CurrencyIsoCode = 'USD', LocaleSidKey = 'en_US');
        if(rId != null) {
            retVal.UserRoleId = rId;
        }
        return retVal;
    }
    
    /**
      *@params - Account, Email and number of records
      *@returns - list of contacts
    */  
    public static List<Contact> getContact(Account acc, String email, Integer count) {
        List<Contact> retVal = new List<Contact>();
        for(Integer i = 0; i < count; i++) {
            retVal.add(new Contact(LastName = 'test' + i, Email = email + i + '@test.rackspace.com', 
                        AccountId = acc.Id));
        }
        return retVal;
    }
    
    /**
      *@params - Rv_Account_Name, rvpe__ExtAccountId__c and number of records
      *@returns - list of RvAccounts
    */  
    public static List<rvpe__RVAccount__c> getRvAccount(String rvAccountName, Integer externalId, Integer count) {
        List<rvpe__RVAccount__c> retVal = new List<rvpe__RVAccount__c>();
        for(Integer i = 0; i < count; i++) {
            retVal.add(new rvpe__RVAccount__c(Name = rvAccountName + i, rvpe__ExtAccountId__c = externalId + i));
        }
        return retVal;
    }
    
    /**
      *@params - Rv_Member_Name, rvpe__ExtMemberId__c, username and number of records
      *@returns - list of RvMembers
    */  
    public static List<rvpe__RVMember__c> getRvMember(String rvMemberName, Integer externalId, string username, Integer count) {
        List<rvpe__RVMember__c> retVal = new List<rvpe__RVMember__c>();
        for(Integer i = 0; i < count; i++) {
            retVal.add(new rvpe__RVMember__c(Name = rvMemberName + i, rvpe__ExtMemberId__c = externalId + i, rvpe__UserName__c = username+i));
        }
        return retVal;
    }
//////////////////////////////////////////////////////////////////////    
    /**   
     * created by Anjaneyulu dynamically creating the records passing the fields and values in the map.
     ** */
/////////////////////////
public static Account createCompany(String company, string phone)
    {
        Account cmp = new Account(Name = company, phone = phone,RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert cmp;
        return cmp;
    }
    public static Account createAccount(String accountName, Id cmpId)
    {
        Account acc = new Account(Name = accountName, Company_Name__c = cmpId,RecordTypeId = Label.Account_Prospect_RecordType_ID);        
        insert acc;
        return acc;
    }    
    public static Opportunity createOpportunity(String Name, Id cmpId,String stageName, Id accId, Date closedate, string focustarea)
    {
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = cmpid;
        opp.StageName = 'Prospect';
        opp.CloseDate = system.today();
        opp.Account__c = accid;
        opp.Focus_Area__c = 'Amazon';
        insert opp;
        return opp;
    }
    public static Sales_Support_Portfolio__c createSalesSupport(Id oppId)
    {
        Sales_Support_Portfolio__c ssp = new Sales_Support_Portfolio__c(Opportunity__c = oppId);
        insert ssp;
        return ssp;
    }
   
}