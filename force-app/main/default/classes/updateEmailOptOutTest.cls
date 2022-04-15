@isTest
public class updateEmailOptOutTest {
    @TestSetUp
    static void setDataUp(){
        TestClassUtility.setTestSetupData();
    }
    @isTest
    static void updateEmailOptOutMethod(){
        
        Set<String>setEmailString = new Set<String>();
        Lead l = new Lead(firstname='asdasd',lastname='fssdfgsfd',company='Test compansdfdsfy',Isconverted = false,
                          email='test.test@test.com.asda',LeadSource='Chat',Lead_Type__c='AWS',
                          Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',HasOptedOutOfEmail=false,
                          country='India',postalcode='560037',Campaign_Interest__c='E&A Cart');
        insert l;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India' );
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,email='test.test@test.com.asda',HasOptedOutOfEmail=false);
        insert c;
        c.HasOptedOutOfEmail = true;
        update c;
        setEmailString.add(l.Email);
        Test.startTest();
        UpdateEmailOptOut.updateEmailOptOutField(setEmailString,'Lead');
        
        Test.stopTest();

    }
    
}