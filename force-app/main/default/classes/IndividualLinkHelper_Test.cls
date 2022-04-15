@isTest
public class IndividualLinkHelper_Test {
   @isTest static void testIndividualLink(){  
         TestDataFactory.getTriggerManagers(); 
       Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                        email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                        Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                        country='India',postalcode='560037');
       insert l;
       et4ae5__Automated_Send__c autosend= new et4ae5__Automated_Send__c(Name='Test',et4ae5__Active__c=true);
       insert autosend;
       Contact c = new Contact(firstname='Test Contact',LastName='Test Last',MailingCountry='India',Email='test.t@test.com',
       MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
       insert c;
       // Variable for date Clicked
       Datetime dateClicked =  System.now()+1;
       // Verify Marketing_Cloud_Last_Activity_Date__c is empty
       l = [Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Lead where ID = :l.Id];
       System.assertEquals(null, l.Marketing_Cloud_Last_Activity_Date__c);
       et4ae5__IndividualEmailResult__c emailResult=new et4ae5__IndividualEmailResult__c(Name='TestMail',et4ae5__TriggeredSendDefinition__c=autosend.Id,et4ae5__Lead__c=l.id);
       insert emailResult;
       et4ae5__IndividualLink__c IndividualLink=new et4ae5__IndividualLink__c(Name='TestIndividualLink', et4ae5__Individual_Email_Result__c=emailResult.id,et4ae5__Unique_Link_ID__c='TestIndividualLink123',et4ae5__Last_Clicked__c =dateClicked);
       Insert IndividualLink;
       Update IndividualLink;
        // Verify Marketing_Cloud_Last_Activity_Date__c update
       l = [Select Id,Marketing_Cloud_Last_Activity_Date__c from Lead where ID = :l.Id];
       System.assertEquals(dateClicked.date(), l.Marketing_Cloud_Last_Activity_Date__c);
       
         // Verify Marketing_Cloud_Last_Activity_Date__c is empty
       c = [Select Id,Name,Marketing_Cloud_Last_Activity_Date__c from Contact where ID = :c.Id];
       System.assertEquals(null, c.Marketing_Cloud_Last_Activity_Date__c);
       et4ae5__IndividualEmailResult__c emailResult1=new et4ae5__IndividualEmailResult__c(Name='TestMail1',et4ae5__TriggeredSendDefinition__c=autosend.Id,et4ae5__Contact__c=c.id);
       insert emailResult1;
       
       et4ae5__IndividualLink__c IndividualLink1=new et4ae5__IndividualLink__c(Name='TestIndividualLink', et4ae5__Individual_Email_Result__c=emailResult1.id,et4ae5__Unique_Link_ID__c='TestIndividualLink1234',et4ae5__Last_Clicked__c =dateClicked );
       insert IndividualLink1;
       Update IndividualLink1;
        // Verify Marketing_Cloud_Last_Activity_Date__c update
       c = [Select Id,Marketing_Cloud_Last_Activity_Date__c from Contact where ID = :c.Id];
       System.assertEquals(dateClicked .date(), c.Marketing_Cloud_Last_Activity_Date__c);

       delete IndividualLink;
       undelete IndividualLink;
  }  
  }