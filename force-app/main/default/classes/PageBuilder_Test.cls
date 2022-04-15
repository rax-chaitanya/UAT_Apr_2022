/**
* File : PageBuilder_Test.cls
* Description : Tests the PageBuilder.cls class. 
* Created Date : 02/FEB/2017
* @author : RDC (JY)
*/

@isTest
public class PageBuilder_Test {  
    @testSetup static void setupTestData() { 
         Trigger_Manager__c tm = new Trigger_Manager__c();
        tm.Is_Active__c = false;
        tm.Name = 'ComponentManagerTrigger';
        insert tm;
        List<Page_Manager__c> page = new List<Page_Manager__c>();
        page.add(new Page_Manager__c(Name = 'CompanySearchBeforeCreate', Standard_Stylesheets__c = TRUE,
        Page_ID__c = 'page', Title__c = 'Company Search Before Create'));
        insert page;
        
        List<Section_Manager__c> sections = new List<Section_Manager__c>();
        sections.add(new Section_Manager__c(Page__c = page.get(0).Id, Name__c = 'Queries', Order__c = 1));
        sections.add(new Section_Manager__c(Page__c = page.get(0).Id, Name__c = 'Page Header and Messages', Order__c = 2));
        sections.add(new Section_Manager__c(Page__c = page.get(0).Id, Name__c = 'Search part', Order__c = 3));
        sections.add(new Section_Manager__c(Page__c = page.get(0).Id, Name__c = 'Companies', Order__c = 4));
        sections.add(new Section_Manager__c(Page__c = page.get(0).Id, Name__c = 'D and B Companies', Order__c = 5));
        insert sections;
        
        List<Query_Manager__c> queries = new List<Query_Manager__c>();
        queries.add(new Query_Manager__c(Master_Section__c = sections.get(0).Id, Object_Name__c = 'Account', Order__c = '1', Query_Limit__c = 10, Query_Offset__c = ':off'));
        queries.add(new Query_Manager__c(Master_Section__c = sections.get(0).Id, Object_Name__c = 'Account', Order__c = '2', Query_Limit__c = 2000));
        insert queries;
        Id rTypeId = Schema.SObjectType.Component_Manager__c.getRecordTypeInfosByName().get('Form Entry').getRecordTypeId();
        
        Component_Manager__c parent =  new Component_Manager__c(RecordTypeID =rTypeId, Section__c = sections.get(1).Id, Component_Type__c = 'Page Block', Field_Order__c = 1, Active__c = TRUE, 
        Description__c = 'Enter search parameters.', subTitle__c = 'Companies', Selected__c = TRUE,
        Layout__c = 'inline', Rendered__c = TRUE, Title__c = 'Search Before Create' );
        insert parent;
        
       List<String> strs = new List<String>{'Command Button','Command Link','Section Header','Input Hidden','Select List','Input Field',
                                             'Include Script','Input Checkbox','Input Text','Form','Input File','Input Text Area',
                                             'Image','Select Checkboxes','Output Field','Output Panel','Output Text','Page Messages',
                                             'Page Block Buttons','Page Block Section','Stylesheet','Page Block Table','Column','Page Block Section Item',
                                             'Output Label','Select Radio','Select Option','Select Options','Action Region','Action Support',
                                             'Action Status'};
        List<Component_Manager__c> components = new List<Component_Manager__c>();
        
        for(Integer i=0;i<strs.size();i++){
            components.add(new Component_Manager__c(RecordTypeID =rTypeId, Section__c = sections.get(1).Id, Component_Type__c =  strs.get(i), Field_Order__c = i+1, Active__c = TRUE, Description__c = 'Enter search parameters.', subTitle__c = 'Companies', 
                            Selected__c = TRUE,Layout__c = 'inline', Rendered__c = TRUE, Title__c = 'Search Before Create',Parent_Entry__c =parent.Id));                           
        }
        insert components;  
        }
         
    private static testMethod void testMethod1() { 
        ApexPages.Component component = new Component.Apex.OutputPanel();   
        PageBuilder.getPage('CompanySearchBeforeCreate'); 
        Section_Manager__c  sm = new Section_Manager__c(); 
        for(Section_Manager__c sm1 : PageBuilder.getSectionsByPageName('CompanySearchBeforeCreate')){
                     if(sm1.Components__r.size()>0 ){
                       sm = sm1;
                    }
                } 
         Test.StartTest();
         component  =  PageBuilder.createSection(sm); 
         Test.StopTest();
         System.assertEquals(component != null,true);
    }
    private static testMethod void testMethod2() { 
        ApexPages.Component component = new Component.Apex.OutputPanel();   
        new Framework();
        Framework  fm = new Framework('CompanySearchBeforeCreate'); 
        fm.getTrue();
        fm.getFalse();
        Test.StartTest();
        component  = fm.getDynamicPage();
        Test.StopTest();
        System.assertEquals(component != null,true);
        }
         
}