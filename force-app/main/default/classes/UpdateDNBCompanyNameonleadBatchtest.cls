@isTest
public class UpdateDNBCompanyNameonleadBatchtest {
     static testMethod void testMethod1() 
     {
         List<Lead> leadlst= new List<Lead>();
         Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
         Account a1 = new Account(RecordTypeId= accRID1,Name='Test Account12346',BillingCountry='India',ShippingCountry='India');
         Database.insert (a1,false);
         lead l= new lead(LastName='Test', D_B_Company_Name__c='',Company='Test Company',IsConverted=False,email='Test@gmail.com', LeadSource='Alliance');
         Insert l;
         lead l1= new lead(LastName='Test1',D_B_Company_Name__c='',Company='Test Company1',IsConverted=false,email='Test1@gmail.com',LeadSource='Alliance');
         List<Database.SaveResult> srList =new List<Database.SaveResult>();
         srList.add(Database.insert(l1, false));
         
        /*List<Lead> leadlst= new List<Lead>();
        for(Integer i=0 ;i <200;i++)
        {
            Lead l = new lead();
            l.LastName ='Test'+i;
            l.D_B_Company_Name__c='';
            l.Company='Test Company'+i;
            l.IsConverted=False;
            leadlst.add(l);
        }
        
        insert leadlst;*/
        
        Test.startTest();
            //Lead leadTest = [SELECT id,Name,D_B_Company_Name__c,IsConverted FROM Lead WHERE Id = :l1.Id];
           
            UpdateDNBCompanyNameonleadBatch obj = new UpdateDNBCompanyNameonleadBatch();
            DataBase.executeBatch(obj); 
          //System.assertEquals( leadTest.D_B_Company_Name__c!='Test Company1', 'Lead is not updated');
            
        Test.stopTest();
}
    
        
    }