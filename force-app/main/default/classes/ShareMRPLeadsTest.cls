@istest
public class ShareMRPLeadsTest {
   
    Public Static Testmethod void Leadtest(){
      List<id> ldIds= new List<id>();
        string po = [Select id from Profile where name = 'Rackspace-MRP User' limit 1].id;
        string pr = [Select id from Profile where name = 'Rackspace Seller-US' limit 1].id;
        User testUser = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = po, country='United States',IsActive =true,Group__c = 'US Other',
                              Region__c = 'US', Title = 'title',timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
          insert testUser;
        
       User testUser2 = new User(alias = 'test1234', email='test1234@noemail.com', Title = 'title',
                            emailencodingkey='UTF-8', lastname='Testing123', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = pr, country='United States',IsActive =true,Group__c = 'US Other',
                             Region__c = 'US', timezonesidkey='America/Los_Angeles', username='raxtest123.partner@rackspace.com');
        insert testUser2;
        
        Lead ld= new Lead();
        System.runas(testUser){
            ld.FirstName='test';
            ld.LastName='abc';
            ld.CurrencyIsoCode ='USD';
            ld.Company='Accion';
            ld.Status='Tele-Accepted Lead';
            ld.Type_Of_Deal__c='Google';
            ld.Leadsource='E-Mail';
            ld.Email='xyz@gmail.com';
            ld.Title='lkjh';
            ld.Phone='7865488';
            ld.Focus_Area__c='Amazon';
            ld.Country='Algeria';
            ld.Territory__c='EMEA';
            ld.State='Annaba';
            
            insert ld;
        
            ld.OwnerID = testUser2.id;
            update ld;
        }
        
      ldIds.add(ld.id);
    
      //ShareMRPLeads MRPld=new ShareMRPLeads(){
        ShareMRPLeads.shareLeadsToCreators(ldIds); 
      
}
}