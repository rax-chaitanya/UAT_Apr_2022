@isTest(seeAllData = true)
public class AutoConvertLead_Test {

    @isTest
    static void autoConvertLeadTest(){
     
       Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();  
         Lead l =  new Lead(firstname='Testfirst21',lastname='lastname21',company='Test company2',
                          email='test.test21@test.com',Phone='32423423423',LeadSource='Site Submission',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                         Focus_Area__c='Amazon',Status='New',State='Kiev Oblast',
                          country='Ukraine',RecordTypeId = rtIdLead,Campaign_Interest__c ='E&A Cart',EMEA_Inquiry_Focus_Solution__c='Colocation', EMEA_Inquiry_Type_Product__c='AliCloud');
        insert l;
         
        List<Id> ids = new List<Id>();
        ids.add(l.Id);
        AutoConvertLead.autoConvertLeadtoCompany(ids);
        Lead l1 = [Select Id,isconverted from Lead where id =: l.Id];
        
        System.assert(l1.IsConverted);
    }
}