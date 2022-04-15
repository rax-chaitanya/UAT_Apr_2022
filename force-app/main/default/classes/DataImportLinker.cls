public class DataImportLinker {
    
    
    public DataImportLinker() {
        //updateSectionsManager();
        //updateQueriesManager();
        updateComponentsManager();
        updateVFQueryManager();
    }
    
    public static void link() {
        
    }
    
    
    
    public map<string, page_manager__c> SourcePageIDToPageMap() {
        map<string, page_manager__c> toReturn = new map<string, page_manager__c>();
        
        for (Page_Manager__c pm : Database.query('select id, Source_Page_ID__c from page_manager__c where createddate = today')) {
            toReturn.put( (String) pm.get('Source_Page_ID__c'), pm  )   ;
        }
        return toReturn;
    }
    
    
    public map<String, section_Manager__c> getSourceSectionIDToSectionMap() {
        map<string, Section_manager__c> ret  = new map<string, Section_manager__c>();        
        for (Section_manager__c sm : Database.query('Select id, Source_Section_ID__c, Source_Page_Manager_ID__c from section_manager__c where createddate = today')) {
            ret.put((String) sm.get('Source_Section_ID__c') , sm);
        }
        return ret;
    }
    
    public map<String, Query_Manager__c> getSourceQueryIDToQueryMap() {
        String key = 'Source_Query_ID__c';
        map<string, Query_Manager__c> ret  = new map<string, Query_Manager__c>();        
        for (Query_Manager__c sm : Database.query('Select id, Source_Master_Query_ID__c , Source_Master_Section_ID__c, Source_Query_ID__c, Master_query__C, master_section__c from query_manager__c where createddate = today')) {
            ret.put(  (String) sm.get( key ) , sm   );
        }
        return ret;
    }
    
    
    public map<String, Component_Manager__c> getSourceComponentIDToComponentMap() {
        String key = 'Source_Component_Manager_ID__c';
        map<string, Component_Manager__c> ret  = new map<string, Component_Manager__c>();        
        for (Component_Manager__c sm : Database.query('select id, RecordTypeId, Component_Type__c, Variable__c, Source_Component_Manager_ID__c, Source_Parent_Entry_ID__c , Source_Parent_Query__c , Source_Section_Manager_ID__c , Parent_Entry__c , Parent_Query__c , Section__c  from component_manager__c where createddate = today')) {
            ret.put(  (String) sm.get( key ) , sm   );
        }
        return ret;
    }
    
    
    
    
    public map<String, RecordType> getNameToRecordTypeMap() {
        map<String, recordType> ret = new map<String, recordtype>();
        for (RecordType rt : Database.query('select id, name, sobjecttype from recordtype where sobjecttype = \'Component_Manager__c\' ')) {
            ret.put(rt.name, rt);
        }        
        return ret;
    }
        
    
    
    
    
    public void updateAll() {
        
        //begin of updating sections
        map<string, page_manager__c> pagesMap = SourcePageIDToPageMap();
        map<String, section_manager__c> sectionsMap = getSourceSectionIDToSectionMap();
        map<String, Query_Manager__c> queriesMap = getSourceQueryIDToQueryMap();
        map<String, Component_Manager__C> componentsMap = getSourceComponentIDToComponentMap();
        map<string, recordtype> recordtypeMap = getnameToRecordTypeMap();
        
        
                    
        for (Section_Manager__c sec : sectionsMap.values()) {
            String key = 'Source_Page_Manager_ID__c';
            if (pagesMap.containsKey(    (String) sec.get( key )  )  ) {
                sec.page__c = pagesMap.get((String) sec.get( key ) ).id;
            }
        }
        
        update sectionsMap.values();
        
        
       for (Query_Manager__c qm : queriesMap.values()) {
            
            String masterQueryID = (String) qm.get('Source_Master_query_Id__c');
            if (queriesMap.containsKey(masterQueryID)) {
                qm.Master_query__C = queriesMap.get(masterQueryID).id;
            }

            String masterSectionID = (String) qm.get('Source_Master_Section_ID__c');
                
            if (sectionsMap.containsKey(masterSectionID)) {
                qm.master_section__c = sectionsMap.get(masterSectionID).id;
            }
        }
        
        update queriesMap.values();
        
        for (Component_manager__c cm : componentsMap.values()) {
            
            //'Form Entry', 'Query Field', 'Filter Field'};            
            
            if (String.isNotBlank(cm.Component_type__c)) {
                cm.RecordTypeId = recordTypeMap.get('Form Entry').ID;
            } else {
                if (String.isNotBlank(cm.Variable__c)) {
                    cm.RecordTypeId = recordTypeMap.get('Filter Field').ID;
                } else {
                    cm.RecordTypeId = recordTypeMap.get('Query Field').ID;
                }
            }
            
            
            String key = (String) cm.get('Source_Parent_Entry_ID__c');
            
            if (componentsMap.containsKey(key)) {
                cm.Parent_Entry__c = componentsMap.get(key).id;
            }
            
            key = (String) cm.get('Source_Parent_Query__c');
            if (queriesMap.containsKey(key)) {
                cm.Parent_Query__c = queriesMap.get(key).id;
            }
            
            key = (String) cm.get('Source_Section_Manager_Id__c');
            if (sectionsMap.containsKey(key)) {
                cm.Section__c = sectionsMap.get(key).id;
            }
        }
        update componentsMap.values();
                
    }
    
    public void updateSectionsManager() {
        
        //begin of updating sections
        map<string, page_manager__c> pms = new map<string, page_manager__c>();
        
        for (page_manager__c pm : Database.query('select id, Source_Page_ID__c from page_manager__c where source_page_id__c != null and createddate = today') )
        {
            pms.put((String) pm.get('source_page_id__c'), pm);
        }
        
        list<section_manager__c> sms = Database.query('select id, Source_Page_Manager_ID__c, page__c from section_manager__c Where Page__c = null and createddate = today');
        for (section_manager__c sm : sms) 
        {
            if (pms.containsKey((String) sm.get('Source_Page_Manager_ID__c'))) {
                sm.page__c = pms.get((String) sm.get('Source_Page_Manager_ID__c')).id;
            }
        }
        update sms;
        
        //end of updating sections
        
        
    }
    
    public void updateQueriesManager() {
        
        //begin of updating query manager
        map<string, query_manager__c> oldNewQM = new map<string, query_manager__c>();
        map<string, Section_manager__c> smOLDNEW  = new map<string, Section_manager__c>();
        
        List<Query_manager__c> qms = Database.query('Select id, Source_Master_Query_ID__c , Source_Master_Section_ID__c, Source_Query_ID__c, Master_query__C, master_section__c from query_manager__c where Master_Section__c = null and createddate = today');
        
        for (Section_manager__c sm : Database.query('Select id, source_section_id__c from section_manager__c WHERE createddate = today')) {
            String smSourceSectionID = (String) sm.get('source_section_id__c');
            
            smOLDNEW.put(smSourceSectionID, sm);
        }
        
        
        for (Query_Manager__c qm : qms ) 
        {
            String sqid = (String) qm.get('Source_Query_ID__c');
            
            oldNewQM.put(sqid, qm);
        }
        
        for (Query_Manager__c qm : qms) {
            
            String masterQueryID = (String) qm.get('Source_Master_query_Id__c');
            if (oldNewQM.containsKey(masterQueryID)) {
                qm.Master_query__C = oldNewQM.get(masterQueryID).id;
            }

            String masterSectionID = (String) qm.get('Source_Master_Section_ID__c');
                
            if (smOLDNEW.containsKey(masterSectionID)) {
                qm.master_section__c = smOLDNEW.get(masterSectionID).id;
            }
        }
        
        update qms;
        //end of updating query manager        
    }
    
    
    public void updateVFQueryManager() {
        list<vf_query_manager__c> vf_query_manager = [Select Id, Query_Id__c from vf_query_Manager__c];
        set<string> source_ids = new set<String>();
        
        for (VF_Query_Manager__c vfqm : vf_query_manager) {
            if (String.isNotBlank(vfqm.Query_Id__c)) {
                source_ids.add(vfqm.Query_Id__c + '%');
            }
        }
        
        
        if (source_ids.size() > 0) {
            map<string, id> source_query_to_ids_map = new map<string,id>();
            
            for (Query_Manager__c qm : [Select Id, Source_Query_Id__c from Query_Manager__c where Source_Query_Id__c like :source_ids and Is_Nested__c = false]) {
                source_query_to_ids_map.put(qm.Source_Query_id__c, qm.id);
            }
            
            if (source_query_to_ids_map.size() > 0) {
                
                for (VF_Query_Manager__c vfqm : vf_query_manager) {
                    if (source_query_to_ids_map.containsKey(vfqm.Query_Id__c)) {
                        vfqm.Query_Id__c = source_query_to_ids_map.get(vfqm.Query_Id__C);
                    }
                }
                update vf_query_manager;
                
            }
        }
    }
    
    
    public void updateComponentsManager() {
        //begin of updating components
        Map<String, query_manager__c> qmMap = new Map<String, query_manager__c>();
        
        map<string, string> rtNameToID = new map<String, string>();
        set<String> strs = new set<String>{'Form Entry', 'Query Field', 'Filter Field'};
        for (Recordtype rt : [select id, Name from recordtype where name in :strs]) {
            rtNameToId.put(rt.name, rt.id);
            
        }        
        
        
        list<query_manager__c> qms = Database.query('select id, Source_Query_ID__c  from query_manager__c WHERE createddate = today');
        for (Query_Manager__c qm : qms) {
            String sqid = (String) qm.get('Source_Query_ID__c');
            qmMap.put(sqid, qm);
        }
        
        
        
        
        Map<String, section_manager__c> smMap = new Map<String, section_manager__c>();
        list<section_manager__c> sms = Database.query('select id, Source_Section_ID__c  from section_manager__c WHERE createddate = today');
        for (Section_Manager__c sm : sms) {
            String ssid = (String) sm.get('Source_Section_ID__c');
            
            smMap.put(ssid, sm);
        }
        
        
        list<component_manager__c> cms = Database.query('select id, RecordTypeId, Component_Type__c, Variable__c, Source_Component_Manager_ID__c, Source_Parent_Entry_ID__c , Source_Parent_Query__c , Source_Section_Manager_ID__c , Parent_Entry__c , Parent_Query__c , Section__c  from component_manager__c WHERE createddate = today');
        
        Map<String, Component_Manager__c> cmMap = new Map<String, Component_MAnager__c>();
        
        for (Component_Manager__c cm : cms) {
            String scmid = (String) cm.get('Source_Component_Manager_ID__c');
            cmMap.put(scmid, cm);
        }
        
        
        for (Component_manager__c cm : cms) {
            
            //'Form Entry', 'Query Field', 'Filter Field'};            
            
            if (String.isNotBlank(cm.Component_type__c)) {
                cm.RecordTypeId = rtNameToId.get('Form Entry');
            } else {
                if (String.isNotBlank(cm.Variable__c)) {
                    cm.RecordTypeId = rtNameToId.get('Filter Field');
                } else {
                    cm.RecordTypeId = rtNameToId.get('Query Field');
                }
            }
            

            String speid = (String) cm.get('Source_Parent_Entry_ID__c');
            
            if (cmMap.containsKey(speid)) {
                cm.Parent_Entry__c = cmMap.get(speid).id;
            }

        
            
            String spqid = (String) cm.get('Source_Parent_Query__c');
            
            if (qmMap.containsKey(spqid)) {
                cm.Parent_Query__c = qmMap.get(spqid).id;
            }
            
            String ssmid = (String) cm.get('Source_Section_Manager_Id__c');
            
            if (smMap.containsKey(ssmid)) {
                cm.Section__c = smMap.get(ssmid).id;
            }


        }

        
        update cms;
        
        //end of updating components
        
        
    }
    

}