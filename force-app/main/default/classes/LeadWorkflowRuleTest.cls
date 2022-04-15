@isTest(seeAllData = true)
public class LeadWorkflowRuleTest {
    
    /**
     * Helper method for testUSMarketingQualifiedLeadWorkflow
     */
    public static Lead createAndReturnMQL(String state, Integer revenue) {
        Lead lead = new Lead(
            FirstName='Test',
            LastName='Lead',
            Phone='9995551235',
            Company='AAAAAAAA',
            Status='Marketing Qualified',
            Country='United States',
            State=state,
            OwnerId=Label.Marketing_Engaged_Queue_Id,
            CleanStatus='Skipped',
            LeadSource='Site Submission',
            AnnualRevenue=revenue
        );
        insert lead;
        lead = [SELECT Original_Queue__c
                FROM Lead
                WHERE Id = :lead.Id
                LIMIT 1];
        return lead;
    }
    
    @isTest static void testUSMarketingQualifiedLeadWorkflow() {
        Integer MM_REVENUE = 200000000;
        Integer ENT_REVENUE = 600000000;
        
        Test.startTest();

        // MQL without state
        // Should go to US_SDR
        Lead lead = createAndReturnMQL(null, MM_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('Pennsylvania', MM_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('Arkansas', MM_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('North Dakota', MM_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('California', MM_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('Pennsylvania', ENT_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('Arkansas', ENT_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('North Dakota', ENT_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('California', ENT_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('Maryland', MM_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        // Should go to US_SDR
        lead = createAndReturnMQL('Maryland', ENT_REVENUE);
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
        
        Test.stopTest();
        
        // Create Marketing Engaged Lead
        lead = new Lead(
            FirstName='Test',
            LastName='Lead',
            Phone='9995551235',
            Company='Testers',
            Status='Marketing Engaged',
            Country='United States',
            State='Texas',
            OwnerId=Label.Marketing_Engaged_Queue_Id,
            CleanStatus='Skipped',
            LeadSource='Site Submission',
            Focus_Area__c='Customer Uncertain',
            
            AnnualRevenue=MM_REVENUE
        );
        insert lead;
        lead = [SELECT Original_Queue__c
                FROM Lead
                WHERE Id = :lead.Id
                LIMIT 1];
        System.assertEquals(null, lead.Original_Queue__c);
        // Update Lead to MQL
        // Should go to US_SDR
        lead.Status='Marketing Qualified';
        update lead;
        lead = [SELECT Original_Queue__c
                FROM Lead
                WHERE Id = :lead.Id
                LIMIT 1];
        System.assertEquals(Label.US_SDR, lead.Original_Queue__c);
    }
}