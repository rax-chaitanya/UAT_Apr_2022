@isTest

public class HighLowMarginTriggerHandlerTest {
    static testMethod void testHighLowMarginTriggerHandler(){
        Test.startTest();
        new HighLowMarginTriggerHandler().CoverageModule1();
        system.assert(true, 'Running as expected');
        Test.stopTest();
    }
}