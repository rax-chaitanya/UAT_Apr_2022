@isTest(seeAllData=true)
public class AgreementEnhancementsCls_Test {
    public static TestMethod void testAgreementsMethod(){ 
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();         
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Strategic',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India', Add_Attachment__c = true);
        insert a1;
        Account a2 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',
                                 ShippingCountry='India',Agreement_Enhancements_Ids__c = '2',Add_Attachment__c = true );
        insert a2;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        Contact c1 = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c1;
        a1.Primary_Member__c = c.Id;
        update a1;
          a2.Primary_Member__c = c1.Id;
        update a2;
           
        Blob bodyBlob=Blob.valueOf('Random string used for testing');
        ContentVersion cv = new ContentVersion( Title='Test Title',PathOnClient='Test.jpg',VersionData=bodyBlob,origin='H', Related_To__c =a1.Partner_Level__c);
        insert cv;
        ContentVersion cv1=[Select id,title,contentdocumentid from ContentVersion where id=:cv.id Limit 1];
        ContentDocumentLink cdl=new ContentDocumentLink(LinkedEntityId=a1.Id,ContentDocumentId=cv1.Contentdocumentid,ShareType='V');
        insert cdl;
        ContentDistribution cd=  new ContentDistribution(Name= 'contecntdoc',ContentVersionId=cv1.id );  
        insert cd;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
       // USer pUser = [Select Id,ContactID from User Where Email='ryan@sdfibertech.com.invalid' and federationidentifier = 'ryan@sdfibertech.com'];
        USer pUser1 =[select id,name from user where profile.name='Rackspace-Partner Operations' and IsActive =true  limit 1];
        List<ID> ids = new List<ID>();
        List<Id> removeIds = new List<Id>();
        List<List<Sobject>> agreeIds = new List<List<Sobject>>();
        List<List<Sobject>> agreeIds1 = new List<List<Sobject>>();
        Map<Id,ContentDocument> contentDocumentList = new Map<Id,ContentDocument>([Select Id,Title,ParentId From ContentDocument Where ParentId =: Label.Pilot_Agreements_Folder]);
       a1.contract_type__c='Global Strategic Partner Agreement';
        update a1;
         a2.contract_type__c='Global Referral Agreement';
        update a2;
       AgreementEnhancementsCls.getAttachment(a1.Id);
		
    //    System.runAs(pUser1){
       
            String cntct = AgreementEnhancementsCls.PartnerLevelValid(a1.id);
            cntct = AgreementEnhancementsCls.PartnerLevelValid(a1.id);
            a1.Contact_Status__c = 'Active';
            update a1;
            cntct = AgreementEnhancementsCls.PartnerLevelValid(a1.id);
            
            String cntct1 = AgreementEnhancementsCls.PartnerLevelValid(a2.id);
            cntct1 = AgreementEnhancementsCls.PartnerLevelValid(a2.id);
            a2.Contact_Status__c = 'Active';
            update a2;
            cntct1 = AgreementEnhancementsCls.PartnerLevelValid(a2.id);
            
            
            agreeIds = AgreementEnhancementsCls.getAttachment(a1.id);
            system.debug('agreementid'+agreeIds);
            
            if(agreeIds!=null){
               if(agreeIds[0].size()>0 ){
                    for(sObject so : agreeIds[0]){
                        ids.add(so.id);
                    }
                    AgreementEnhancementsCls.updateSelectedAgreements(a1.id, ids);
                    
                }
            agreeIds = AgreementEnhancementsCls.getAttachment(a1.id);
            if(agreeIds[1].size()>0){
                for(sObject so : agreeIds[1]){
                    ids.add(so.id);
                }
                AgreementEnhancementsCls.updateSelectedAgreementsRemove(a1.id,ids);
            }
            if(agreeIds[0].size()>0){
                for(sObject so : agreeIds[0]){
                    ids.add(so.id);
                }
                AgreementEnhancementsCls.updateSelectedAgreements(a1.id, ids);
                
            }
            if(agreeIds[1]!=null)
                if(agreeIds[1].size()>0){
                    for(sObject so : agreeIds[1]){
                        ids.add(so.id);
                    }
                    AgreementEnhancementsCls.updateSelectedAgreementsRemove(a1.id,ids);
                }
            if(agreeIds[1].size()>0){
                for(sObject so : agreeIds[1]){
                    ids.add(so.id);
                }
                AgreementEnhancementsCls.updateSelectedAgreements(a1.id, ids);
                
            }
           
            
        }
            
           agreeIds1 = AgreementEnhancementsCls.getAttachment(a2.id);
            system.debug('agreementid'+agreeIds1);
            
            if(agreeIds1!=null){
               if(agreeIds1[0].size()>0 ){
                    for(sObject so : agreeIds1[0]){
                        ids.add(so.id);
                    }
                    AgreementEnhancementsCls.updateSelectedAgreements(a2.id, ids);
                    
                }
            agreeIds1 = AgreementEnhancementsCls.getAttachment(a2.id);
            if(agreeIds1[1].size()>0){
                for(sObject so : agreeIds1[1]){
                    ids.add(so.id);
                }
                AgreementEnhancementsCls.updateSelectedAgreementsRemove(a2.id,ids);
            }
            if(agreeIds1[0].size()>0){
                for(sObject so : agreeIds1[0]){
                    ids.add(so.id);
                }
                AgreementEnhancementsCls.updateSelectedAgreements(a2.id, ids);
                
            }
            if(agreeIds1[1]!=null)
                if(agreeIds1[1].size()>0){
                    for(sObject so : agreeIds1[1]){
                        ids.add(so.id);
                    }
                    AgreementEnhancementsCls.updateSelectedAgreementsRemove(a2.id,ids);
                }
            if(agreeIds1[1].size()>0){
                for(sObject so : agreeIds1[1]){
                    ids.add(so.id);
                }
                AgreementEnhancementsCls.updateSelectedAgreements(a2.id, ids);
            }
        } 
     //  }
    }
}