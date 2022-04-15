/*
* SFDC -5219 and SFDC 5253  Created By Shravan Godha
* Description Company name and Address details will be update in PartnerFund Claim
* */
@istest(SeeAllData=true)
public class PartnerFundClaimTrigger_Test {
    private static testmethod void afterinsert() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserPFC = new User(Alias = 'sgodh', Email='newuser543@testorg.com',
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US', ProfileId = p.Id,
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUserPFC@gmail.com');
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_Company').getRecordTypeId();
        system.debug('RecordTypeId@@@@' + RecordTypeId);
        
        Account comp = new Account(RecordTypeId=RecordTypeId, Name = 'Test Shravan', BillingCountry = 'United States',BillingCity='Hyd',BillingState='Alabama',BillingStreet='Test',BillingPostalCode='502319');
        insert comp;
        comp.IsPartner=True;
        Update comp;
        PartnerMarketingBudget budjet = new PartnerMarketingBudget(Title='Test',Amount=10,Type='Marketing Funds');
        Insert budjet;
        PartnerFundAllocation FA = new PartnerFundAllocation(Title='Test',Amount=2,BudgetId=budjet.id,ChannelPartnerId=comp.id);
        Insert FA;
        System.runAs(testUserPFC) { 
            PartnerFundRequest PFR = new PartnerFundRequest(Status='Draft',Title='Test',MDF_Activity_Name__c='Test Shravan',Amount=2,RequestedAmount=2,ChannelPartnerId=comp.id,Activity_Start_Date__c=system.today(),
                                                            Activity_End_Date__c=system.today(),Anticipated_Deal_Registrations_Lead__c=2,Anticipated_Opportunities_ConvertedLead__c=2,
                                                            Anticipated_Reach_circulation_attenda__c=2,Marketing_to_or_Marketing_Through__c='Marketing To', Region__c='National ',
                                                            Type_of_MDF_Fund__c='Earned',Audience__c='Partner- Prospect ',AllocationId=FA.id,Description='Test Shravan',Reimbursement__c=100);
            Insert PFR;
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            PFR.Status ='Approved';
            PFR.AllocationId=FA.id;
            Update PFR;
            PartnerFundClaim PFC = new PartnerFundClaim (Title = 'TestShravanGoud',Amount=2,RequestId=PFR.id,Invoice_No__c='2',File_Uploaded__c=true,Description='Test Shravan');
            Insert PFC;
            List<EmailTemplate> templates = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'MDF_Email_to_the_Accounts_Payable_Team'];
            Map<Id,PartnerFundClaim> oldMap = new Map<Id,PartnerFundClaim>();
            oldMap.put(PFC.Id, PFC);
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
            ContentVersion cv = new ContentVersion();
            cv.title = 'Invoice_01';      
            cv.PathOnClient ='Invoice_01.text';           
            cv.VersionData =beforeblob;          
            insert cv;     
            
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id=:testContent.ContentDocumentId ];
            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=PFC.id;
            contentlink.ShareType= 'v';
            contentlink.ContentDocumentId=documents[0].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;    
            PFC.Status ='Approved';
            Update PFC;
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(templates[0].Id);
            String emailSubject = templates[0].Subject;
            message.setSubject(emailSubject);
            message.setHtmlBody('testBody');
             
            List<PartnerFundClaim> triggerList = new List<PartnerFundClaim>();
            triggerList.add(PFC);
            test.startTest();
            PartnerFundClaimTriggerHelper.sendInvoicesAfterApproved(triggerList, oldMap);
            SubmitForApproval.getPartnerfundclaimdata(PFC.id);
            test.stopTest();
        }
    }
        private static testmethod void Negativetest() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserPFC = new User(Alias = 'sgodh', Email='newuser543@testorg.com',
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US', ProfileId = p.Id,
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUserPFC@gmail.com');
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_Company').getRecordTypeId();
        system.debug('RecordTypeId@@@@' + RecordTypeId);
        
        Account comp = new Account(RecordTypeId=RecordTypeId, Name = 'Test Shravan', BillingCountry = 'United States',BillingCity='Hyd',BillingState='Alabama',BillingStreet='Test',BillingPostalCode='502319');
        insert comp;
        comp.IsPartner=True;
        Update comp;
        PartnerMarketingBudget budjet = new PartnerMarketingBudget(Title='Test',Amount=10,Type='Marketing Funds');
        Insert budjet;
        PartnerFundAllocation FA = new PartnerFundAllocation(Title='Test',Amount=2,BudgetId=budjet.id,ChannelPartnerId=comp.id);
        Insert FA;
        System.runAs(testUserPFC) { 
            PartnerFundRequest PFR = new PartnerFundRequest(Status='Draft',Title='Test',MDF_Activity_Name__c='Test Shravan',Amount=2,RequestedAmount=2,ChannelPartnerId=comp.id,Activity_Start_Date__c=system.today(),
                                                            Activity_End_Date__c=system.today(),Anticipated_Deal_Registrations_Lead__c=2,Anticipated_Opportunities_ConvertedLead__c=2,
                                                            Anticipated_Reach_circulation_attenda__c=2,Marketing_to_or_Marketing_Through__c='Marketing To', Region__c='National ',
                                                            Type_of_MDF_Fund__c='Earned',Audience__c='Partner- Prospect ',AllocationId=FA.id,Description='Test Shravan',Reimbursement__c=100);
            Insert PFR;
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            PFR.Status ='Approved';
            PFR.AllocationId=FA.id;
            Update PFR;
            PartnerFundClaim PFC = new PartnerFundClaim (Title = 'TestShravanGoud',Amount=2,RequestId=PFR.id,Invoice_No__c='2',File_Uploaded__c=true,Description='Test Shravan');
            Insert PFC;
            List<EmailTemplate> templates = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'MDF_Email_to_the_Accounts_Payable_Team'];
            Map<Id,PartnerFundClaim> oldMap = new Map<Id,PartnerFundClaim>();
            oldMap.put(PFC.Id, PFC);
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
            ContentVersion cv = new ContentVersion();
            cv.title = 'Invoice_01';      
            cv.PathOnClient ='Invoice_01.text';           
            cv.VersionData =beforeblob;          
            insert cv;     
            
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id=:testContent.ContentDocumentId ];
            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=PFC.id;
            contentlink.ShareType= 'v';
            contentlink.ContentDocumentId=documents[0].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;    
            PFC.Status ='Approved';
            Update PFC;
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(templates[0].Id);
            String emailSubject = templates[0].Subject;
            message.setSubject(emailSubject);
            message.setHtmlBody('testBody');
             
            List<PartnerFundClaim> triggerList = new List<PartnerFundClaim>();
            triggerList.add(PFC);
            test.startTest();
            PartnerFundClaimTriggerHelper.sendInvoicesAfterApproved(triggerList, oldMap);
            SubmitForApproval.getPartnerfundclaimdata(PFC.id);
            
            delete PFC ;
            delete PFR;
            test.stopTest();
        }
    }
    private static testmethod void Negativetest1() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserPFC = new User(Alias = 'sgodh', Email='newuser543@testorg.com',
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US', ProfileId = p.Id,
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUserPFC@gmail.com');
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_Company').getRecordTypeId();
        system.debug('RecordTypeId@@@@' + RecordTypeId);
        
        Account comp = new Account(RecordTypeId=RecordTypeId, Name = 'Test Shravan', BillingCountry = 'United States',BillingCity='Hyd',BillingState='Alabama',BillingStreet='Test',BillingPostalCode='502319');
        insert comp;
        comp.IsPartner=True;
        Update comp;
        PartnerMarketingBudget budjet = new PartnerMarketingBudget(Title='Test',Amount=10,Type='Marketing Funds');
        Insert budjet;
        PartnerFundAllocation FA = new PartnerFundAllocation(Title='Test',Amount=2,BudgetId=budjet.id,ChannelPartnerId=comp.id);
        Insert FA;
        System.runAs(testUserPFC) { 
            PartnerFundRequest PFR = new PartnerFundRequest(Status='Draft',Title='Test',MDF_Activity_Name__c='Test Shravan',Amount=2,RequestedAmount=2,ChannelPartnerId=comp.id,Activity_Start_Date__c=system.today(),
                                                            Activity_End_Date__c=system.today(),Anticipated_Deal_Registrations_Lead__c=2,Anticipated_Opportunities_ConvertedLead__c=2,
                                                            Anticipated_Reach_circulation_attenda__c=2,Marketing_to_or_Marketing_Through__c='Marketing To', Region__c='National ',
                                                            Type_of_MDF_Fund__c='Earned',Audience__c='Partner- Prospect ',AllocationId=FA.id,Description='Test Shravan',Reimbursement__c=100);
            Insert PFR;
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            PFR.Status ='Approved';
            PFR.AllocationId=FA.id;
            Update PFR;
            PartnerFundClaim PFC = new PartnerFundClaim (Title = 'TestShravanGoud',Amount=2,RequestId=PFR.id,Invoice_No__c='2',File_Uploaded__c=true,Description='Test Shravan');
            Insert PFC;
            List<EmailTemplate> templates = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'MDF_Email_to_the_Accounts_Payable_Team'];
            Map<Id,PartnerFundClaim> oldMap = new Map<Id,PartnerFundClaim>();
            oldMap.put(PFC.Id, PFC);
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
            ContentVersion cv = new ContentVersion();
            cv.title = 'Invoice_01';      
            cv.PathOnClient ='Invoice_01.text';           
            cv.VersionData =beforeblob;          
            insert cv;     
            
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id=:testContent.ContentDocumentId ];
            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=PFC.id;
            contentlink.ShareType= 'v';
            contentlink.ContentDocumentId=documents[0].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;    
            PFC.Status ='Submitted';
            Try{
            Update PFC;
            }
          catch (Exception e) { 
              ExceptionHandler.postToAll(e);  
              throw new CustomException(ExceptionHandler.getBody(e)); 
          }
            test.startTest();
            SubmitForApproval.getPartnerfundclaimdata(PFC.id);             
            test.stopTest();
        }
    }
    private static testmethod void Handler(){
        test.startTest();
        PartnerFundClaimHandler PFCH = new PartnerFundClaimHandler();
        try{PFCH.afterDelete();}catch(Exception e){}
        try{PFCH.isActive();}catch(Exception e){}
        try{PFCH.beforeInsert();}catch(Exception e){}
        try{PFCH.afterInsert();}catch(Exception e){}
        try{PFCH.beforeUpdate();}catch(Exception e){}
        
        ContentDocumentLinkHandler CDLH = new ContentDocumentLinkHandler();
        try{CDLH.afterDelete();}catch(Exception e){}
        try{CDLH.isActive();}catch(Exception e){}
        try{CDLH.beforeInsert();}catch(Exception e){}
        try{CDLH.afterInsert();}catch(Exception e){}
        try{CDLH.beforeUpdate();}catch(Exception e){}
        
        PartnerFundRequestHandler PFRH = new PartnerFundRequestHandler();
        try{PFRH.afterDelete();}catch(Exception e){}
        try{PFRH.isActive();}catch(Exception e){}
        try{PFRH.beforeInsert();}catch(Exception e){}
        try{PFRH.afterInsert();}catch(Exception e){}
        try{PFRH.beforeUpdate();}catch(Exception e){}
        Test.stopTest();	
    }
}