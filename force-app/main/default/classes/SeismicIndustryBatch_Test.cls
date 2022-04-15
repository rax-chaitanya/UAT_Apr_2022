@isTest
public class SeismicIndustryBatch_Test{

@testSetup
private static void datasetup(){
    insert new Trigger_Manager__c(Name = 'SeismicIndustyTgr', Is_Active__c = true);
    insert new Account(Name='testAcc', Industry='Agriculture');
    insert new Seismic_Industry_Mapping__c(Industry__c='Agriculture',Seismic_Name__c='Healthcare');
}
@isTest
private static void SeismicIndustyTest(){ 
       Map<String,String> seismicSettings = new Map<String,String>();
        for(Seismic_Industry_Mapping__c seismic: [Select Industry__c,Seismic_Name__c From Seismic_Industry_Mapping__c]){
            if(String.isNotBlank(seismic.Industry__c))seismicSettings.put(seismic.Industry__c,seismic.Seismic_Name__c);
        }
   Test.startTest();
     Id jobID = Database.executebatch(new SeismicIndustryBatch(seismicSettings),200);
   Test.stoptest();
   AsyncApexJob jobInfo = [SELECT Id FROM AsyncApexJob WHERE Id = :jobID limit 1];
   system.assertEquals(true,jobinfo.Id != null);
} 


}