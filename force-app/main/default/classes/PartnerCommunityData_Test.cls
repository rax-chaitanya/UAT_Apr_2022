@isTest
private class PartnerCommunityData_Test {
    @testSetup
    private static void datasetup(){
        insert new Trigger_Manager__c(name='PartnerCommunityDataTgr',Is_Active__c=true); 
        datainsert();
    }
    @isTest
    private static void insertTest(){         
        datainsert();     
    }
    @isTest
    private static void updateTest(){         
        Partner_Community_Data__c data = getData();
        update data;
    }
    @isTest
    private static void deleteTest(){         
        Partner_Community_Data__c data = getData();
        delete data;
        undelete data;
    }
    
    private static void datainsert(){
        try{ 
            insert new Partner_Community_Data__c(Active__c=true,Head_Line__c='testdata1',Contract_Type__c='Agent Channel Agreement'); 
        }catch(Exception ex){} 
    }
    private static Partner_Community_Data__c getData(){
        return [SELECT ID FROM Partner_Community_Data__c WHERE Contract_Type__c INCLUDES('Agent Channel Agreement') LIMIT 1];
    }
}