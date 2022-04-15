public virtual class Framework {
    
    public Page_Manager__c pageManager {get; set;}
    public QueryBuilder queryBuilder {get; set;}
    public List<Section_Manager__c> sectionManager {get; set;}

    public String getTrue() {
        return 'true';
    }
    
    public String getFalse() {
        return 'false';
    }
    
    public Framework(String pageName) {
        System.debug('Frameworkable(' + pageName +')');
        queryBuilder = new QueryBuilder(pageName);
        pageManager = PageBuilder.getPage(pageName);
        sectionManager = PageBuilder.getSectionsByPageName(pageName);
        
        System.debug('PageManager: ' + pageManager);
        System.debug('SectionManager: ' + sectionManager);
        
    }
    
    
    public ApexPages.Component getDynamicPage() {
        ApexPages.Component component = new Component.Apex.OutputPanel();        
        
        for (Section_Manager__c section : sectionManager) {
            component.childComponents.add(PageBuilder.createSection(section));
        }      
        return component;
    }
    
    
    public Framework() {
        
    }
    
    
    
}