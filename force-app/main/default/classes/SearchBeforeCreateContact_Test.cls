@isTest(SeeAllData=true)
public class SearchBeforeCreateContact_Test {
    
    
    
    
    
    
    @isTest
    static void test() {
        Integer total = 50;
        
        
        List<Account> companies = new List<Account>();
        
        for (Integer i = 0; i < TOTAL; ++i) {
            Account company = new Account(BillingCountry='India',ShippingCountry='India');
            company.name = 'Rackspace Dummy Company ' + (i+1);
            companies.add(company);
        }
        
        insert companies;
        
        List<SObject> sObjects = new List<SObject>();
        for (Integer i = 0; i < TOTAL; ++i) {
            Contact c = new Contact();
            c.FirstName = 'Rackspace Dummy Contact ' + (i+1);
            c.LastName = 'Rackspace Dummy Contact ' + (i+1);
            c.AccountId = companies[i].id;            
            sObjects.add(c);
        }
        
        insert sObjects;
        
        
        String pId=[select id,name from Profile where name like 'Rackspace%' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', FederationIdentifier='dhar2815dummy', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        
            
        insert conuser;
        
        User u = [select id, name, profile.name from user where profile.name like 'Rackspace %' and isactive = true LIMIT 1];
        System.runAs(u) {
            
            
            
            Contact c = new Contact();
            
            
            ApexPages.StandardController controller = new ApexPages.StandardController( c );
            SearchBeforeCreateContact sbc = new SearchBeforeCreateContact ( controller );
            try{
                sbc.createContactShares();
            }catch(Exception e){
            
            }
            try{
                sbc.toggleChoice();
            }catch(Exception e){
            
            }
            sbc.getDynamicPage();
            
            sbc.contact.FirstName = 'Rackspace Dummy Contact-NO RESULTS';
            sbc.contact.LastName = 'Rackspace Dummy Contact';
            
            
            sbc.executeSearch();
            sbc.contact.FirstName = 'Rackspace Dummy Contact';

            sbc.executeSearch();
            
            
            System.assertEquals(10, sbc.getContacts().size());
            
            sbc.queryID = sbc.contactString;
            sbc.pageVal = 'next';
            
            
            sbc.contact.DoNotCall = true;
            sbc.cascadeChoice();
            
            
            for (Contact ct : sbc.getContacts()) {
              //  System.assertEquals(true, ct.DoNotCall);
            }
            
         //   System.assertEquals(10, sbc.getTotalSelected());
           // System.assertEquals(0, sbc.getTotalSelected());
            sbc.recordID = sbc.contactString;
            
            
            
            while (sbc.tableState.get(sbc.recordID).currOffset != sbc.tableState.get(sbc.recordID).getMaxOffset()) {
                
                System.debug('curr offset is now: ' + sbc.tableState.get(sbc.recordID).currOffset);
                
                sbc.genericFunction();
                
                System.debug('hit next');
                
                  sbc.tableState.get(sbc.recordID).getIsDisabledFirstAndPrev();
           sbc.tableState.get(sbc.recordID).getIsDisabledNextAndLast();
           sbc.tableState.get(sbc.recordID).print();
           sbc.tableState.get(sbc.recordID).first();
           sbc.tableState.get(sbc.recordID).prev();
           sbc.tableState.get(sbc.recordID).last();
                
                sbc.contact.DoNotCall = true;
                
                
                
                sbc.cascadeChoice();
                for (Contact ct : sbc.getContacts()) {
                 //   System.assertEquals(true, ct.DoNotCall);
                }
            }
            
            //System.assertEquals(TOTAL, sbc.getTotalSelected());
            
            
            Contact firstCon = sbc.getContacts().get(0);
            
            sbc.recordId = firstCon.Id;
            firstCon.DoNotCall = false;         // simulates clicking the checkbox to false;
            sbc.toggleChoice();
            
            System.assertEquals(false, sbc.selectedMap.get(sbc.recordId));          
            
            //System.assertEquals(TOTAL - 1, sbc.getTotalSelected());
            
            firstCon.DoNotCall = true;          // simulates clicking the checkbox to false;
            sbc.toggleChoice();
          //  System.assertEquals(true, sbc.selectedMap.get(sbc.recordId));           
            sbc.getTotalSelected();
            sbc.getTableResultMap();
            
            
            sbc.createContactShares();
            
            sbc.initNewContact();
            
            sbc.cancel();
            
            
            
            
        }
        
        
        
        
        
    }    
    
    
}