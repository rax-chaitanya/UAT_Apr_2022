public class QueryBuilder {


    public Map<Id,Query_Manager__c> queryLookup {get; set;}
    private SObject sObj {get; set;}

    
    public void setSObject(SObject obj) {
        sObj = obj;
    }
    

    public QueryBuilder() {
        queryLookup = new Map<Id, Query_Manager__c>();
        sObj = null;
    }
    
    public String getFilterString(Component_Manager__c f) {
        string[] filters = new list<string>{' '};
        
        map<integer, string> fieldsMap = new map<integer, string>();
        fieldsMap.put(1, 'Condition__c');
        fieldsMap.put(2, 'Open_Parenthesis__c');
        fieldsMap.put(3, 'Field_Name__c');
        fieldsMap.put(4, 'Operator__c');
        fieldsMap.put(5, 'Variable__C');
        fieldsMap.put(6, 'Closed_Parenthesis__c');
        
        for (Integer i = 1; i <= fieldsMap.size(); ++i) {
            String fieldVal = (String) f.get( fieldsMap.get(i) )   ;
            filters.add ( String.isNotBlank (fieldVal ) ? fieldVal : '' );
        } 
        
        //return ' ' + condition + ' ' + openP + ' ' +  f.field_Name__c + ' ' + f.Operator__c + ' ' + f.Variable__c + ' ' + closedP;
        return String.join(filters, ' ');
    }
    
    public QueryBuilder(String pageName) {

        queryLookup = new Map<id, Query_manager__c>( (list<query_manager__c>) Database.query('Select ID, Order__c, Object_Name__c, Is_Nested__c, Query_Limit__c, Query_Offset__c,(Select Id from Child_queries__r),(Select Id, RecordType.Name, Field_Name__c, Field_Order__c, Is_Hidden__c, Condition__c, Operator__c, Variable__c, Left_Wildcard__c, Right_Wildcard__c, Open_Parenthesis__c, Closed_parenthesis__c from Fields__r  Where Active__c = true Order By RecordType.Name DESC)from Query_Manager__c Where Master_Section__r.Page__r.Name = :pageName'));
        sObj = null;
        
    }
    
    public Boolean isNotBlank(SObject sObj, String fieldName) {
        return (String.isNotBlank((String) sObj.get(fieldName)));
    }
    
    
    
    public String  getQueryString(Id qID) {
        String queryString = '';
        String selectClause = 'SELECT ';
        
        queryString += SelectClause;
        
        //System.debug('queryID: ' + qID);
        
        Query_Manager__C qm = queryLookup.get(qId);
        String fromClause = ' FROM ' + qm.Object_Name__c + ' ';
        String whereClause;        
        
        if (qm.Fields__r.size() > 0) {
			queryString += qm.Fields__r[0].Field_Name__c;
            
            if (qm.Fields__r.size() > 1) {
                Map<Integer, Component_Manager__c> filters = new Map<integer, Component_Manager__c>();
                
                for (Integer i = 1; i < qm.Fields__r.size(); ++i) {
                    if (qm.Fields__r[i].RecordType.Name == 'Query Field') {
                        queryString += ',' + qm.Fields__r[i].Field_name__c;
                    } else {	//filter field
                        if (!qm.Fields__r[i].Is_Hidden__c) {
                            filters.put((Integer) qm.Fields__r[i].Field_Order__c, qm.Fields__r[i]);
                        }
                    }
                }
                
                if (filters.size() > 0) {
                    whereClause = ' WHERE ';
                    
                    List<Integer> sortedOrder = new List<Integer>(filters.keySet());
                    sortedOrder.sort();
                    
                    for (Integer i : sortedOrder) {
                        Component_Manager__c filter = filters.get(i);
                        if (sObj != null) {
                            if (!filter.Field_Name__c.containsAny('.')) {
                                if (String.isNotBlank((String.valueOf(sObj.get(filter.Field_Name__c))))) {
                                    whereClause += getFilterString(filters.get(i));
                                }
                            } else {
                                List<String> lookUpFields = filter.Field_Name__c.split('\\.');
                                SObject dummyObj = sObj.getSObject(lookUpFields[0]);
                                
                                if (lookupFields.size() > 2) {
                                    for (Integer fieldName = 1; i < lookupFields.size() - 1; ++i) {
                                        dummyObj = sObj.getSObject(lookupFields[fieldName]);
                                    }
                                }
                               
                                String finalVal = String.valueOf(dummyObj.get(lookupFields[lookupFields.size() - 1])); 
                                
                                if (String.isNotBlank(finalVal)) {
                                    whereClause += getFilterString(filters.get(i));
                                }
                            }
                        } else {
                            whereClause += getFilterString(filters.get(i));
                        }

                    }
                }
            }            
        }
        
        for (Query_Manager__c childQuery : qm.Child_Queries__r) {
            queryString += ',(' + getQueryString(childQuery.id) + ')';
        }
        
        queryString += fromClause;
        if (string.isNotBlank(whereClause)) queryString += whereClause;
        if (String.isNotBlank(String.valueOf(qm.Query_Limit__c))) queryString += (' LIMIT ' + String.valueOf(qm.Query_Limit__c));
        if (String.IsNotBlank(String.valueOf(qm.Query_Offset__c))) queryString += ' OFFSET ' + qm.Query_Offset__c;
        
        System.debug('getQueryString(' + qiD + ') ====>' + queryString);
        return queryString;
        
    }
    
    
    


}