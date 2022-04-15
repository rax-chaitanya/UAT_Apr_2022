/* File Name : ExceptionHandler_Test
 * Created date : jan 2022
 * Jira : SFDC-6711
* Description : Test Class for ExceptionHandler
* Author - Chaitanya
*/

@istest
public class ExceptionHandler_Test {
    
    @testSetup static void setupTestData() {
        insertTriggerSettings();
        insertOrgConstants();
    }
    public static void insertTriggerSettings() {
        TestDataFactory.triggerManagerFlagValue = true;
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings = TestDataFactory.getTriggerManagers();
        
    } 
    
    public static void insertOrgConstants() {
        List<OrgConstants__c> constants = new List<OrgConstants__c>();
                constants.add(new OrgConstants__c(Name = '#salesforce-errors', Non_Prod_Value__c = 'https://www.google.com', Prod_Value__c = 'https://www.google.com'));
        constants.add(new OrgConstants__c(Name = 'Salesforce Errors Group', Non_Prod_Value__c = '0F961000000JJa2', Prod_Value__c = '0F961000000JJa2'));
        insert constants;
    }
    
    @isTest static void testExceptionHandler() {         
        Test.startTest();
        try {               
            Id p = [select id from profile where name='System Administrator'].id;
            User userFMW = new User(alias = 'FMW123', email='testFMW123@noemail.com',
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerFMW@noemail.com1');
            insert userFMW;
            userFMW.email='testFMW123@noemail.com.invalid';
            userFMW.FederationIdentifier='';
            update userFMW;
            
        }
        catch(Exception e){
            string urltest=ExceptionHandler.getURL();
            System.assertEquals(urltest,'https://www.google.com');
            ExceptionHandler.postToChatter(e);
            ExceptionHandler.postToChatter(ExceptionHandler.getBody(e));
            ExceptionHandler.postToAll(e,false);
        }
        Test.stopTest();
    }
    
}