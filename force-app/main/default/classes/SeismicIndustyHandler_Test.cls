@isTest
public class SeismicIndustyHandler_Test {
@testSetup
private static void datasetup(){
    insert new Trigger_Manager__c(Name = 'SeismicIndustyTgr', Is_Active__c = true);
    Account ac = new Account(Name='testAcc', Industry='Agriculture');
    insert ac;
}
@isTest
private static void SeismicIndustyTest(){    
   Seismic_Industry_Mapping__c si = new Seismic_Industry_Mapping__c(Industry__c='Agriculture',Seismic_Name__c='Healthcare');
   Test.startTest();
       insert si;    
       update si;
       delete si;
   Test.stoptest();
} 

}