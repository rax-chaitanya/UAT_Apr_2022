/**
*  @author: Diego Castro 
*  @story: SFSB-616
*  @class: QLDeleteOppIDBatch_Test
*  @date: 04/28/2017
*  @description: Test class for QLDeleteOppIDBatch, which deletes SFDCDevices under an opportunity via a batch process.
*  @return: tests passed or they didn't
*/    
@isTest
public class QLDeleteOppIDBatch_Test {
    private static Integer QUOTE_AMOUNT_SMALL = 2;    
    private static Integer QUOTE_LINES_AMOUNT_SMALL = 100; 
    
    private static Integer OPP_COUNT = Label.QLDeleteOppId.split(',').size();
    
    @testSetup
    static void testSetup() {
        
        insert new FeatureFlag__c(Name='BucketLogic_DM',Enabled__c=true);
        map<string,string> mapping = new map<string,string>
        {
            'Not Applicable'=>'Not Applicable',
                'Amazon'=>'Amazon',
                'OpenStack Public'=>'OpenStack Public',
                'Microsoft Private'=>'MSFT Private',
                'Dedicated'=>'Dedicated',
                'Microsoft Public'=>'MSFT Public',
                'Cloud Office'=>'Cloud Office',
                'Data Stores'=>'Data Stores',
                'Security'=>'Security',
                'OpenStack Private'=>'OpenStack Private'            };
                    
                    
                    SObject[] sObjs = new list<SObject>();
        for (String key : mapping.keySet()) {
            sObjs.add(new FocusAreaMapping__c(Name = key, OppFocusArea__c = mapping.get(key)));
        }
        String[] names = new list<string>{'QuoteLineTgr', 'QuoteTgr', 'OpportunityFocusAreaTgr', 'OpportunityTgr'};
            for (String name : names) {
                sObjs.add( new Trigger_Manager__c(Name = name, Is_Active__c = false) );
            }        
        insert sObjs;
    }
    
    
    @isTest    
    static void test_delete_1() {
        list<string> oppIds = Label.QLDeleteOppId.split(',');
        
        
        quote__c[] quotes = new list<quote__c>();
        for (String oppId :  oppIds) 
        {
            for (Integer i = 0; i < 1; ++i) 
            {
                Quote__c q = new Quote__c();
                q.opportunity__c = oppid;
                q.Name = 'DUMMY QUOTE NAME:' + (i+1);
                
                
                quotes.add(q);
            }
        }
        
        insert quotes;
        
        System.assertEquals(1, quotes.size());
        
        
        
        Opp_FocusArea__c[] focusareas = new list<Opp_FocusArea__c>();
        sobject[] sobjects = new list<sobject>();
        
        
        for (Quote__c q : quotes) {
            
            Opp_FocusArea__c fa = new Opp_FocusArea__c(
                Name = 'Amazon' + q.Opportunity__c,
                Opportunity__c = q.Opportunity__c
            );
            
            focusareas.add(fa);
        }
        
        insert focusareas;
        
        System.assertEquals(1, focusAreas.size());
        
        for (Opp_FocusArea__c q : focusareas) {
            
            
            for (Integer i = 0; i < 1; ++i) {
                Quote_Line__c qline = new Quote_Line__C();
                qline.Name = 'QUOTE LINE NUM ' + (i+1);
                qline.Opportunity_Quote__c = q.Opportunity__c;
                qline.FocusArea__c = q.id;
                sobjects.add(qline);
            }
            
        }
        
        
        insert sObjects;
        
        System.assertEquals(1, sObjects.size());
        
        Test.startTest();
        
        QLDeleteOppIdBatch batchable = new QLDeleteOppIdBatch();
        Database.executeBatch(batchable);
        
        Test.stopTest();
        
        
        String query = 'Select COUNT() from Quote_Line__c where Opportunity_Quote__c IN :oppIds';
        Integer count = Database.countQuery(query);
        
        System.assertEquals(0, count);
        
        
        
        
        
        
        
        
    }
    
    
    
    
    @isTest    
    static void test_schedule() {
        list<string> oppIds = Label.QLDeleteOppId.split(',');
        
        
        quote__c[] quotes = new list<quote__c>();
        for (String oppId :  oppIds) 
        {
            for (Integer i = 0; i < 1; ++i) 
            {
                Quote__c q = new Quote__c();
                q.opportunity__c = oppid;
                q.Name = 'DUMMY QUOTE NAME:' + (i+1);
                quotes.add(q);
            }
        }
        
        insert quotes;
        
        System.assertEquals(1, quotes.size());
        
        
        
        Opp_FocusArea__c[] focusareas = new list<Opp_FocusArea__c>();
        sobject[] sobjects = new list<sobject>();
        
        
        for (Quote__c q : quotes) {
            
            Opp_FocusArea__c fa = new Opp_FocusArea__c(
                Name = 'Amazon' + q.Opportunity__c,
                Opportunity__c = q.Opportunity__c
            );
            
            focusareas.add(fa);
        }
        
        insert focusareas;
        
        System.assertEquals(1, focusAreas.size());
        
        for (Opp_FocusArea__c q : focusareas) {
            
            
            for (Integer i = 0; i < 1; ++i) {
                Quote_Line__c qline = new Quote_Line__C();
                qline.Name = 'QUOTE LINE NUM ' + (i+1);
                qline.Opportunity_Quote__c = q.Opportunity__c;
                qline.FocusArea__c = q.id;
                sobjects.add(qline);
            }
        }
        
        insert sObjects;
        
        System.assertEquals(1, sObjects.size());
        
        Test.startTest();
        
        QLDeleteOppIDBatchScheduler m = new QLDeleteOppIDBatchScheduler();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Merge Job', sch, m);        
        
        Test.stopTest();
    }    
    
    
    @isTest
    static void test_Exceptions() {
        Trigger_manager__c[] managers = [Select Id, Is_Active__c from Trigger_Manager__c];
        
        for (Trigger_Manager__C tm : managers) {
            tm.Is_active__c = true;
        }
        
        update managers;
        
        
        list<string> oppIds = Label.QLDeleteOppId.split(',');
        
        
        quote__c[] quotes = new list<quote__c>();
        for (String oppId :  oppIds) 
        {
            for (Integer i = 0; i < 1; ++i) 
            {
                Quote__c q = new Quote__c();
                q.opportunity__c = oppid;
                q.Name = 'DUMMY QUOTE NAME:' + (i+1);
                
                
                quotes.add(q);
            }
        }
        if(quotes != null && quotes.size() >0)
        insert quotes;
        
        
        
        
        Opp_FocusArea__c[] focusareas = new list<Opp_FocusArea__c>();
        sobject[] sobjects = new list<sobject>();
        
        
        for (Quote__c q : quotes) {
            
            Opp_FocusArea__c fa = new Opp_FocusArea__c(
                Name = 'Amazon',
                Opportunity__c = q.Opportunity__c
            );
            
            focusareas.add(fa);
        }
        
        insert focusareas;
        
        
        for (Opp_FocusArea__c q : focusareas) {
            
            
            for (Integer i = 0; i < 1; ++i) {
                Quote_Line__c qline = new Quote_Line__C();
                qline.Name = 'QUOTE LINE NUM ' + (i+1);
                qline.Opportunity_Quote__c = q.Opportunity__c;
                qline.FocusArea__c = q.id;
                sobjects.add(qline);
            }
            
        }
        
        
        insert sObjects;
        
        
        Test.startTest();
        
        QLDeleteOppIdBatch batchable = new QLDeleteOppIdBatch();
        Database.executeBatch(batchable);
        
        Test.stopTest();
        
        

                
        
    }
    
    
    
    
    @isTest        
    static void test_deleteNone() {


    list<string> oppIds = Label.QLDeleteOppId.split(',');

        String query = 'Select COUNT() from Quote_Line__c where Opportunity_Quote__c IN :oppIds';
        Integer count = Database.countQuery(query);


        System.assertEquals(0, count);
        Test.startTest();
        
        QLDeleteOppIdBatch batchable = new QLDeleteOppIdBatch();
        Database.executeBatch(batchable);
        
        Test.stopTest();
        
        count = Database.countQuery(query);
        
        System.assertEquals(0, count);
        
        
    }
    
}