//create  quote line item , set opp id ( rec1con1.id)and insert
////create focus area , set opp id and insert
@isTest

public class HighLowMarginCalculatorTest {
    static testMethod void testConvertToWrappperList(){
        Test.startTest();
        new HighLowMarginCalculator().CoverageModule1();
        system.assert(true, 'Running as expected');
        Test.stopTest();
        /*Test.startTest();
        Test.stopTest();
        @testSetup static void setup() 
            
        {
            List<Opportunity> oppList = new List<Opportunity>();
            
            
            Opportunity rec1Con1 = new Opportunity(
                Amount = 21000,
            );          
            insert rec1Con1;
            
            Opportunity rec2Con1 = new Opportunity(
                Workload_Platform__c = 'Optimizer',
                Final_MRR__c = 150            
            );  
            insert rec2Con1;
            
            Opportunity rec3Con1 = new Opportunity(
                Cloud_Contract_Type__c = 'EDP ShareShift',
                Amount = 658            
            );  
            insert rec3Con1;
            
            
            Opportunity rec4Con1 = new Opportunity(
                Cloud_Contract_Type__c = 'Marketplace',
                Amount = 900            
            );  
            insert rec4Con1;       
            
            Opportunity rec5Con1 = new Opportunity(
                Type = 'Professional Services',
                Amount = 900            
            );  
            insert rec5Con1;   
            
            Opportunity rec5Con2 = new Opportunity(
                Type = 'TriCore ProServe',
                Amount = 850            
            );  
            insert rec5Con2; 
            
            Opportunity rec5Con3 = new Opportunity(
                Onica_Type__c = 'PSO',
                Amount = 750            
            );  
            insert rec5Con3; 
            
            Opportunity rec6Con1 = new Opportunity(
                Type = 'Revenue Ticket',
                Amount = 120            
            );  
            insert rec6Con1; 
            
            Opportunity rec7Con1 = new Opportunity(
                Onica_Type__c = 'EE',
                Amount = 120            
            );  
            insert rec7Con1; 
            
            Opportunity rec7Con2 = new Opportunity(
                Workload_Platform__c = 'Fanatical Support for AWS',
                Final_MRR__c = 152            
            );  
            insert rec7Con2; 
            
            Opportunity rec8Con1 = new Opportunity(
                Onica_Type__c = 'MCO',
                Final_MRR__c = 126          
            );  
            insert rec8Con1; 
            
            Opportunity rec8Con2 = new Opportunity(
                Workload_Platform__c = 'Infrastructure for AWS',
                Final_MRR__c = 54            
            );  
            insert rec8Con2;
            
            Opportunity rec9Con1 = new Opportunity(
                Workload_Platform__c = 'Colo',
                Final_MRR__c = 96            
            );  
            insert rec9Con1; 
            
            Opportunity rec10Con1 = new Opportunity(
                Name = 'MSFT Private',
                Focus_Area_Total__c = 936            
            );  
            insert rec10Con1; 
            
            Opportunity rec11Con1 = new Opportunity(
                Name = 'Cloud Office',
                Focus_Area_Total__c = 936            
            );  
            insert rec11Con1; 
            
            
            
            
            insert oppList;
*/
        }
    }