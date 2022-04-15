@isTest()
public class VerifyAddressDoctorBatch_Test {
    
    @TestSetUp
    static void setDataUp(){
        TestClassUtility.setTestSetupData();
    }
    
    public static testMethod void VerifyAddresstest1(){  
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        String custAcct='Accounts__c';
        String acct='Account'; 
        String cont='Contact';
        integer index = 0;
        
        AddressDoctor__c adddoc = new AddressDoctor__c();
        adddoc.name = 'addrdoc';
        adddoc.MaxResultCount__c = 25;
        adddoc.ElementAbbreviation__c = false;
        adddoc.FlexibleRangeExpansion__c = true ;
        adddoc.FormatWithCountry__c = true;
        adddoc.FormatMaxLines__c = 19;
        adddoc.StreetWithNumber__c = false;
        adddoc.password__c = 'kP4/59N:CU';
        adddoc.GlobalCasing__c = 'NOCHANGE';
        adddoc.MatchingExtendedArchive__c = true;
        adddoc.GlobalMaxLength__c = 0 ;
        adddoc.StandardizeInvalidAddresses__c = false ;
        adddoc.UseTransactionPool__c = 'TEST';
        adddoc.user_name__c = '141161';
        
        Insert adddoc;
        /*Trigger_Manager__c contgr = new Trigger_Manager__c();
        contgr.Name = 'ContactTgr';
        contgr.Is_Active__c = true;
        Insert contgr;*/
        //adddoc.ElementAbbreviation__c
            
            
        //Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India' );
        //insert a;
        Account a = new Account(Name='Test Account1234',BillingCountry='United States',
                                BillingStreet = '209 REDWOOD SHORES PKWY', BillingState = 'california' , BillingPostalCode = '94065-1175',
                                BillingCity = 'REDWOOD CITY' , ShippingStreet = '209 REDWOOD SHORES PKWY', ShippingState = 'california', ShippingPostalCode  = '94065-1175',
                                ShippingCity ='REDWOOD CITY' , ShippingCountry='United States' );
        insert a;
        //Accounts__c ac = new Accounts__c(Name='Test C Account',Company_Name__c=a.Id,Shipping_Country__c='India',Type__c='Prospect');
        //insert ac;
        Accounts__c ac = new Accounts__c(Name='Test C Account', Company_Name__c=a.Id, Billing_Street__c = '209 REDWOOD SHORES PKWY',
                                         Billing_City__c = 'REDWOOD CITY' , Billing_State_Province__c = 'california',
                                         Billing_Country__c ='United States' , Billing_Zip_Postal_Code__c = '94065-1175',  
                                         Shipping_Country__c='United States',Type__c='Prospect');
        insert ac;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false,
                                MailingCountry='United States',MailingCity='REDWOOD CITY', MailingStreet='209 REDWOOD SHORES PKWY',
                                MailingState='california', MailingPostalCode='94065-1175');
        Insert c;
        
       /* Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false);
        insert c;*/
        Account_Contact_Role__c acr = new Account_Contact_Role__c (Mailing_Country__c='United States',Account__c = ac.id, Contact__c = c.id,
                                                                   Mailing_State__c='california',Mailing_City__c='REDWOOD CITY',
                                                                   Mailing_Street__c='209 REDWOOD SHORES PKWY',Mailing_Postal_Code__c='94065-1175');
        Insert acr;

        Test.startTest();
        
        VerifyAddressDoctorBatch Addacc= new VerifyAddressDoctorBatch();
        database.executeBatch(Addacc);
        
        VerifyAddressDoctorBatch batchclass1 = new VerifyAddressDoctorBatch(1);       
         database.executeBatch(batchclass1);
         
        VerifyAddressDoctorBatch batchclass2 = new VerifyAddressDoctorBatch(2);       
        database.executeBatch(batchclass2);
        
        VerifyAddressDoctorBatch batchclass3 = new VerifyAddressDoctorBatch(3);       
        database.executeBatch(batchclass3);
        Test.stopTest();
        
    }
}