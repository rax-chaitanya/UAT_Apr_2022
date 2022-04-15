@isTest
public class SobjectRecordDeletionBatch_Test {
    
 /*   @isTest
    static void rejectedLeadDeletionBatchTest(){
        
        insert new Records_Deletion__c(Name='Lead',Filtered_Field__c='Rejection_Approved_Date__c',Filtered_Operator__c='< =LAST_N_DAYS:',filtered_value__c='30');
     List<Lead> leads = new List<Lead>();
        for(Integer i=0;i<200;i++){
            leads.add(new Lead(firstname='Testfirst'+i,lastname='lastname'+i,company='Test company'+i,
                          email=i+'test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037',Rejection_Approved_date__c=System.Date.Today().addDays(-32)));
        }
        
        for(Integer i=1;i<100;i++){
            leads.add(new Lead(firstname='Testfirst'+i,lastname='lastname'+i,company='Test company'+i,
                          email=i+'test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037',Rejection_Approved_date__c=System.Date.Today()));
        }
        insert leads;
       
         Test.startTest();
        Database.executeBatch(new SobjectRecordDeletionBatch('Lead'), 300);
        Test.stopTest();
       
        List<Lead> deletedLeads = [select id from Lead where Rejection_Approved_date__c=:System.Date.Today().addDays(-32)];
        List<Lead> undeletedLeads = [select id from Lead where Rejection_Approved_date__c=:System.Date.Today()];
        System.assert(deletedLeads.isEmpty(),true);
        System.assert(undeletedLeads.isEmpty(),false);
    }*/
    
    @isTest
    static void rejectedLeadDeletionScheduleTest(){
        
        insert new Records_Deletion__c(Name='Lead',Filtered_Field__c='Rejection_Approved_Date__c',Filtered_Operator__c='< =LAST_N_DAYS:',filtered_value__c='30');
     List<Lead> leads = new List<Lead>();
        for(Integer i=0;i<5;i++){
            leads.add(new Lead(firstname='Testfirst'+i,lastname='lastname'+i,company='Test company'+i,
                          email=i+'test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037',Rejection_Approved_date__c=System.Date.Today().addDays(-32)));
        }
        
       insert leads; 
        DateTime d = System.now();
        Integer min = Integer.valueOf(d.minute() + 5);
        //String cronexp= '0 ' + 0 +' '+ 0 +' '+ 1 +' '+ 1 +' '+' ? '+d.year();
        String cronexp = '0 0 22 * * ? *';
        System.debug('Exp '+cronexp);
        Test.startTest();
        Id jobID =System.schedule('DelRejectedLeads1', cronexp, new SobjectRecordDeletionBatch('Lead'));
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    }
}