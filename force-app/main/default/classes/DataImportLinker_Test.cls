@isTest//(seeAllData = true)
public class DataImportLinker_Test {
    @testSetup
    static void dataSetup(){
        Id rTypeId = Schema.SObjectType.Component_Manager__c.getRecordTypeInfosByName().get('Form Entry').getRecordTypeId();
        
        Page_Manager__c pmnew = new Page_Manager__c(Name = 'CompanySearchBeforeCreate', Standard_Stylesheets__c = TRUE,
        	Page_ID__c = 'page', Title__c = 'Company Search Before Create');
		insert pmnew;
        
		Section_Manager__c smnew = new Section_Manager__c(Page__c = pmnew.Id, Name__c = 'Queries', Order__c = 1);
		insert smnew;
		Section_Manager__c smnew2 = new Section_Manager__c(Page__c = pmnew.Id, Name__c = 'Page Header and Messages', Order__c = 2);
		insert smnew2;
        
        Query_Manager__c qmnew = new Query_Manager__c(Source_Master_query_Id__c='',Master_Section__c = smnew.Id, Object_Name__c = 'Account', Order__c = '1', Query_Limit__c = 10, Query_Offset__c = ':off');
		insert qmnew;        
		Query_Manager__c qmnew2 = new Query_Manager__c(Source_Master_query_Id__c=qmnew.Id,Master_Section__c = smnew.Id, Object_Name__c = 'Account', Order__c = '2', Query_Limit__c = 2000);
		insert qmnew2;
        
        Trigger_Manager__c tm = new Trigger_Manager__c(Is_Active__c = false,Name = 'ComponentManagerTrigger');
        insert tm;
    	Component_Manager__c cmnew=new Component_Manager__c(RecordTypeID =rTypeId, Section__c = smnew2.Id, Component_Type__c = 'Page Block', Field_Order__c = 1, Active__c = TRUE, 
        Description__c = 'Enter search parameters.', subTitle__c = 'Companies', Selected__c = TRUE,
        Layout__c = 'inline', Rendered__c = TRUE, Title__c = 'Search Before Create');
        insert cmnew;
    	Component_Manager__c cmnew2=new Component_Manager__c(Source_Parent_Entry_ID__c=cmnew.Id,RecordTypeID =rTypeId, Section__c = smnew2.Id, Component_Type__c = 'Page Block', Field_Order__c = 1, Active__c = TRUE, 
        Description__c = 'Enter search parameters.', subTitle__c = 'Companies', Selected__c = TRUE,
        Layout__c = 'inline', Rendered__c = TRUE, Title__c = 'Search Before Create');
        insert cmnew2;
     
    }

    @isTest
    static void testImportData(){
        DataImportLinker d = new DataImportLinker();
        DataImportLinker.link();
        d.SourcePageIDToPageMap();
        d.getSourceSectionIDToSectionMap();
        d.getSourceQueryIDToQueryMap();
        d.getSourceComponentIDToComponentMap();
        d.getNameToRecordTypeMap();
        d.updateAll();
        d.updateSectionsManager();
        d.updateQueriesManager();
       // d.updateVFQueryManager();
        d.updateComponentsManager();
        
    }
}