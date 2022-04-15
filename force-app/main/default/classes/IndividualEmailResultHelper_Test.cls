@IsTest
public class IndividualEmailResultHelper_Test {
@isTest static void testEmailResult(){
       TestDataFactory.getTriggerManagers();
     
      Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                      email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                      Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                      country='India',postalcode='560037',Campaign_Member_Last_Response_Date__c=System.today());
    insert l;

   // Variable for date opened
   Datetime dateOpened =  System.now()+1;

   // Verify Marketing_Cloud_Last_Activity_Date__c is empty
   l = [Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Lead where ID = :l.Id];
   System.assertEquals(null, l.Marketing_Cloud_Last_Activity_Date__c);
    
    et4ae5__Automated_Send__c autosend= new et4ae5__Automated_Send__c(Name='Test',et4ae5__Active__c=true);
    insert autosend;
    
    et4ae5__IndividualEmailResult__c emailResult=new et4ae5__IndividualEmailResult__c(
        Name='TestMail',
        et4ae5__DateOpened__c=dateOpened,
        et4ae5__TriggeredSendDefinition__c=autosend.Id,
        et4ae5__Lead__c=l.id);
    insert emailResult;
    update emailResult;

   // Verify Marketing_Cloud_Last_Activity_Date__c update
   l = [Select Id,Marketing_Cloud_Last_Activity_Date__c from Lead where ID = :l.Id];
   System.assertEquals(dateOpened.date(), l.Marketing_Cloud_Last_Activity_Date__c);

    Contact c = new Contact(firstname='Test Contact',LastName='Test Last',MailingCountry='India',Email='test.t@test.com',
                            MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka',Campaign_Member_Last_Response_Date__c=System.today());
    insert c;

   // Verify Marketing_Cloud_Last_Activity_Date__c is empty
   c = [Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Contact where ID = :c.Id];
   System.assertEquals(null, c.Marketing_Cloud_Last_Activity_Date__c);

     et4ae5__IndividualEmailResult__c emailResult1=new et4ae5__IndividualEmailResult__c(Name='TestMail1',et4ae5__DateOpened__c=dateOpened,et4ae5__TriggeredSendDefinition__c=autosend.Id,et4ae5__Contact__c=c.id);
    insert emailResult1;
    update emailResult1;

   // Verify Marketing_Cloud_Last_Activity_Date__c update
   c = [Select Id,Marketing_Cloud_Last_Activity_Date__c from Contact where ID = :c.Id];
   System.assertEquals(dateOpened.date(), c.Marketing_Cloud_Last_Activity_Date__c);

    Delete emailResult1;
    undelete emailResult1;
    
 
}
}