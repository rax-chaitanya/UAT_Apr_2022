@isTest
public class UpdateChildRelationshipsBatch_Test {
    
    @testSetup
    static void testSetup() {
        sobject[] toInsert = new List<SObject>();
        
        Integer CREATE_AMOUNT = 10;
        
        TestClassUtility.setTestSetupData();
        //insert TestClassUtility.createLeads(CREATE_AMOUNT);
        
        Lead[] leads = [Select Id, Old_Record_Id__c from Lead];
        for (Lead l : leads) {
            l.put(Label.Linkage_Field, l.id);           // assign the id to the old record id for the batch query to pull info
            
            Task leadTask = new Task();
            leadTask.Subject = 'Dummy Subj';
            leadTask.WhoId = l.Id;
            toInsert.add(leadTask);
        }
        
        update leads;
        insert toInsert;
    }
    
    @isTest
    static void testBatch() {
        
        Test.startTest();
        
        map<Id, Task> taskMapBefore = new map<Id, Task>([Select Id, CreatedDate, LastModifiedDate from Task]);
        
        
        
        Lead[] leads = [Select Id, Old_Record_Id__c from Lead];
        
        for (Lead l : leads) {
            System.assertEquals(false, String.isBlank( l.Old_Record_Id__c));
        }
        
        for (Task t : taskMapBefore.values()) {
            //System.assertEquals(true, String.isBlank(t.Old_Record_Id__c));
        }
        UpdateChildRelationshipsBatch batchable = new UpdateChildRelationshipsBatch();
        Database.executeBatch(batchable);
        Test.stopTest();
        
    }
     @isTest
    static void testBatch1() {
   // Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
    Account acc = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=accRID);
   // rvpe__RVAccount__c rva = [SELECT Id FROM rvpe__RVAccount__c LIMIT 1];
    // rvpe__RVMember__c rvm = [SELECT Id FROM rvpe__RVMember__c LIMIT 1];
    Test.startTest();
    ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
     
    Partner_Role__c role =  new Partner_Role__c(Partner_Company__c=acc.Id,  Role__c = 'Source', 
                                    Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification');
                                      
    insert role;
    Partner_Role__c role1 = new Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.Id, Role__c = 'Source', 
                                        Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification');  
                             
    try{insert role1 ;
       }catch(Exception ex){}
        UpdateChildRelationshipsBatch batchable = new UpdateChildRelationshipsBatch();
        Database.executeBatch(batchable);
    Test.stopTest();
     
}

    @isTest
    static void testBatchException() {
        
        Child_Query_Settings__c setting = [Select Id, Name, Include__c from Child_Query_Settings__C where Name = 'Lead'];
        setting.Name = 'Dummy SObject name';
        update setting;
        UpdateChildRelationshipsBatch batchable = new UpdateChildRelationshipsBatch();
        Database.BatchableContext BC;
        
        batchable.start(BC);
        //batchable.execute(BC, scope);
        batchable.finish(BC);
       
    } 
    
  
}