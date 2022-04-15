/**
* File : ContentDocumentLinkHelper_Test.cls
* Description : Tests the ContentDocumentLinkTrigger.trigger trigger. 
* Created Date : 28/DEC/2017
* @author : Venkat
*/

@isTest(seeAllData=true)        
public class ContentDocumentLinkHelper_Test {  
    
    
    //method to test the trigger - ContentDocumentLinkTrigger on Files
    private static testmethod void testFile1() {
        
        Lead l = new Lead(FirstName = 'Dummy', LastName='Lead', Company = 'Dummy Company',
                          Email = 'dummylead@rackspace.com.test', LeadSource = 'Chat', Lead_Type__c = 'AWS',
                          Focus_Area__c = 'Amazon', Street = 'Church Street', City = 'San Antonio', 
                          State = 'Texas', Country = 'United States', PostalCode = '78023');
        insert l;
        
        Partner_Role__c pr1 = new Partner_Role__c(Lead__c = l.Id, Role__c = 'Influence',Justification__c='Testing the Justification');
        insert pr1;
        
        Partner_Role__c pr = [SELECT Id FROM Partner_Role__c where id=:pr1.id];
        Test.startTest();
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
        //Insert contentdocument data
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        
        //insert new ContentDocumentLink
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = pr.id;
        newFileShare.ShareType= 'V';
        insert newFileShare;
        Test.stopTest();
        Partner_Role__c pr2 = [SELECT Id, Has_Attachment__c, Status__c FROM Partner_Role__c WHERE Id = :pr.Id];
        // System.assertEquals(pr2.Has_Attachment__c, TRUE);
        //System.assertEquals(pr2.Status__c, 'Pending Approval');
    }
    
    private static testmethod void afterinsert() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserPFC = new User(Alias = 'sgodh', Email='newuser543@testorg.com',
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US', ProfileId = p.Id,
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUserPFC@gmail.com');
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
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
            Update cv;
            
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id=:testContent.ContentDocumentId ];
            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=PFC.id;
            contentlink.ShareType= 'v';
            contentlink.ContentDocumentId=documents[0].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink; 
            update contentlink;
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
            delete documents;
            test.stopTest();
            //  List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
        }
    }
    private static testmethod void Handler(){
        test.startTest();
        
        
        ContentDocumentLinkHandler CDL = new ContentDocumentLinkHandler();
        try{CDL.afterDelete();}catch(Exception e){}
        try{CDL.isActive();}catch(Exception e){}
        try{CDL.beforeInsert();}catch(Exception e){}
        try{CDL.afterInsert();}catch(Exception e){}
        try{CDL.beforeUpdate();}catch(Exception e){}
        try{CDL.afterUpdate();}catch(Exception e){}
        try{CDL.beforedelete();}catch(Exception e){}
        
        
        
        Test.stopTest();	
    }
}