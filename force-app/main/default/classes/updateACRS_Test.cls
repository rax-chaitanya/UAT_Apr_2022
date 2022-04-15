@isTest(seeAllData=true)
public class updateACRS_Test {
    @isTest
    static void TestgetACRs(){
       
        Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Phone='1234567890');
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
        insert c;
        Accounts__c a = new Accounts__c(Name='Custom Account',Company_Name__c=a1.id,Is_install_Base__c = true);
        insert a;
        List<Account_Contact_Role__c> acList=new LIst<Account_Contact_Role__c>();
		for(Integer i=0;i<=99;i++)
    		acList.add(new Account_Contact_Role__c(Account__c=a.Id,Contact__c=c.Id,Role__c='Executive Sponsor'+i,Email__c='test'+i+'@mail.com'));
		insert acList;
        List<Account_Contact_Role__c> tList=updateACRS.getACRs(c.Id);
        System.assert(tList.size()>0);
    }
	@isTest
    static void TestUpadateACRs(){
        Account a1=new Account();
        a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Phone='1234567890');
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
        insert c;
        Accounts__c a = new Accounts__c(Name='Custom Account',Company_Name__c=a1.id,Is_install_Base__c = true);
        insert a;
        List<Account_Contact_Role__c> acList=new LIst<Account_Contact_Role__c>();
		for(Integer i=0;i<=99;i++)
    		acList.add(new Account_Contact_Role__c(Account__c=a.Id,Contact__c=c.Id,Role__c='Executive Sponsor'+i,Email__c='test'+i+'@mail.com'));
		insert acList;
        List<String> stringIds=new List<String>();
        for(Integer i=0;i<acList.size();i++){
            stringIds.add(acList[i].id);
        }
        updateACRS.updateSelectedACRs(c.Id,stringIds);
        try{
            updateACRS.updateSelectedACRs(null,stringIds);
        }catch(Exception e){
            
        }
       
    }

}