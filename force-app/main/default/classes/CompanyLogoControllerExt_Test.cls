@isTest 
public class CompanyLogoControllerExt_Test {
    
        static Account acc;
        static {
         insert new OrgConstants__c(Name='Prod Org ID',Prod_Value__c='00D61000000J4OKEA0',Non_Prod_Value__c='00D61000000J4OKEA0');
        insert new OrgConstants__c(Name='Company Approval Process ID',Prod_Value__c='04a4C0000008PNQ',Non_Prod_Value__c='04a4C0000008PNQ');
        insert new OrgConstants__c(Name='System Administrator ID',Prod_Value__c='00561000001ziVf',Non_Prod_Value__c='00561000001ziVf');
        insert new FieldMapping__C(Name='ActivityTrigger-OldRecordID-1',CompName__c='ActivityTrigger-OldRecordID',SourceField__c='Account',TargetField__c='WhatId');

           Trigger_Manager__c triggerSettings = new Trigger_Manager__c(Name = 'CompanyTrigger', Is_Active__c = false);
                  
           insert triggerSettings;
           acc = new Account(Name = 'Test Account', BillingCountry = 'Canada', ShippingCountry = 'Canada');
           insert acc;
           Attachment att=new Attachment();
           att.Name='CompanyLogo';
           att.body=Blob.valueOf('Test old Attachment Body');
           att.parentId=acc.id; // attachment Parent Account record ID
           att.ContentType = 'image/jpg';
           Insert att;
       }
     
       static ApexPages.StandardController sc = new ApexPages.standardController(acc);
       static CompanyLogoControllerExt myPageCon = new CompanyLogoControllerExt(sc);
       static {
          myPageCon.attachment.Name='Test Name';
          Blob bodyBlob=Blob.valueOf('Test Attachment Body');
          myPageCon.attachment.body=bodyBlob;
          myPageCon.attachment.parentId=acc.id; // attachment Parent Account record ID
          myPageCon.attachment.ContentType = 'image/jpg';
        }
        static PageReference pageRef = Page.UploadCompanyLogo;
    
    //Positive behavior   
    static testMethod void testPositive() {

        myPageCon.upload();
        Test.setCurrentPageReference(pageRef);
    }
    //Negative behavior   
    static testMethod void testNegative() {

        myPageCon.attachment.Name=null;
        myPageCon.upload();
        Test.setCurrentPageReference(pageRef);
    }
    //Exception behavior
    static testMethod void testException() {

        myPageCon.attachment.body=null;
        myPageCon.upload();
        Test.setCurrentPageReference(pageRef);
    }
   
    //Test for PDF attachment
    static testMethod void testBodyType() {

        myPageCon.attachment.ContentType = 'pdf';
        myPageCon.upload();
        Test.setCurrentPageReference(pageRef);
    }
   
}