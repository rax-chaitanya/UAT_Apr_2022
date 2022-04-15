@isTest
public class TestDataSetUp {
    @testSetup
    public static void insertTestRecords(){
         Profile pr = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User us = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Quetesting', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pr.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='Quetesting1@testorg.com');
                            insert us;
    }
    
}