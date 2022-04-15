@istest
public class QlikViewInsertFromEmailTEST {
@TestSetUp
    static void setDataUp(){
    TestClassUtility.setTestSetupData();
    }
    static testMethod void myTestMethod() 
    {
    // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.TextAttachment inAtt = new Messaging.InboundEmail.TextAttachment();
      
     //   Id recTypeId = [select id, name, sObjecttype from RecordType where sObjecttype='Account' and  Name='Standard'].id; 
        
       //  Id recTypeId2 = [select id, name, sObjecttype from RecordType where sObjecttype='Account' and Name='Prospect'].id;
                
      //  Account testCompany = new Account(name='This Company',ShippingCountry='India', RecordTypeId=Label.Account_Prospect_RecordType_ID);
         Account testCompany = new Account(name='This Company',ShippingCountry='India');
        insert testCompany; 
                
      //  Account testAccount = new Account(name='this account', ddi__c='930886',BillingCountry = 'India',ShippingCountry='India', RecordTypeId=Label.Account_Prospect_RecordType_ID, Company_Name__c=testCompany.Id);
         Account testAccount = new Account(name='this account', ddi__c='930886',BillingCountry = 'India',ShippingCountry='India');
        insert testAccount;
        
        Contact testContact = new Contact(Firstname='First', LastName='Last1', phone='1234124',email='lili@lili.com',AccountId=testCompany.Id);
        insert testContact;
        
       // Account_contact_role__c testRS = new Account_contact_role__c(Contact__c=testContact.Id,Account__c=testAccount.Id,Role__c='Primary Contact');
       AccountContactRelation testRS = new AccountContactRelation(ContactId=testContact.Id,AccountId=testAccount.Id,Roles='Primary Contact');
        insert testRS;
        
        // Create the email body
        email.subject='test';
        env.fromAddress='user@acme.com';
        // set the body of the attachment
        List<String> ListBody = new List<String>();
        
        String Strbody='<html>\r\n';
        StrBody =StrBody +'<body>\r\n';
        StrBody =StrBody +'Upgrades<br>\r\n';
        StrBody =StrBody +'More than 30 units and at least 25% of base.<br>\r\n';
        StrBody =StrBody +'<table cellspacing=0 style="border-collapse:collapse;">\r\n';
        StrBody =StrBody +'<tr Style="height:0pt;">\r\n';
        StrBody =StrBody +'<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:41px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">DDI</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:158px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Acct Name</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Status</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Core Acct #</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Last Invoice</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">MRR</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Country</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:151px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Primary Contact Name</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:162px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Primary Contact Email</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:147px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Primary Contact Phone</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Team</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">AM</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Flag</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Delta</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">Total as of 10/12/2014</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#F5F5F5;Font-family:Tahoma;Font-size:8pt;color:#333333;Font-weight: bold;text-align:left;">% Change</td>\r\n';
        StrBody =StrBody + '</tr>\r\n';
        StrBody =StrBody + '<tr Style="height:0pt;">\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:41px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:right;">450099</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:158px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">Dutriz Hermanos, S.A. de C.V.</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">Active</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">-</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">9/27/2014</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:right;">4599.34</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">El Salvador</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:151px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">Alvaro Sagrera</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:162px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">it@grupodutriz.com</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:147px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">+503 2241-2150</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">Team D8</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">Krystal Johnson</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:left;">1</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:right;">118</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:right;">306</td>\r\n';
        StrBody =StrBody + '<td Style="Border-Left:1px solid #DCDCDC;Border-Right:1px solid #DCDCDC;Border-Bottom:1px solid #DCDCDC;Border-Top:1px solid #DCDCDC;vertical-align:bottom;width:98px;Background:#FFFFFF;Font-family:Tahoma;Font-size:8pt;color:#333333;text-align:right;">63%</td>\r\n';
        StrBody =StrBody + '</tr>\r\n';
        StrBody =StrBody + '</table>\r\n';
        StrBody =StrBody + '</body>\r\n';
        StrBody =StrBody + '</html>\r\n';
        inAtt.body = StrBody;
        
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';

        email.textAttachments = new Messaging.inboundEmail.textAttachment[] {inAtt }; 

        // call the class and test it with the data in the testMethod
        QlikViewInsertFromEmail emailServiceObj= new QlikViewInsertFromEmail();
        emailServiceObj.handleInboundEmail(email, env );            
    }
}