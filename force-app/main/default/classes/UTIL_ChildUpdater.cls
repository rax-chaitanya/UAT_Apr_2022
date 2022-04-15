/********************************************************************************************************
* @developer   : Diego Castro
* @date        : 05/31/17
* @description : 	For a given sObject, this class will find the relevant child
*					relationships (which live in a Child_Query_Settings__c custom setting) and perform a
*                	dummy update on the records that have the linkage field blank.
*********************************************************************************************************/
public class UTIL_ChildUpdater {

    /*
    @future
    public static void processDML(Set<Id> ids, String objectAPIName) {
        try {
            if (ids.size() > 0 && UserInfo.getUserId().contains(Label.FMWFoundationUser)) {
                String baseQuery = getQuery(objectApiName);
                
                if (String.isNotBlank(baseQuery)) {
                    String query = baseQuery + ' WHERE ID in :ids';
                    
                    System.debug('Query: ' + query + ', Ids: ' + ids);
                                        
                    SObject[] toUpdate = grabChildRecords(Database.query( query ), objectAPIName);
                    
                    if (toUpdate.size() > 0) {
                        toUpdate.sort();
                        Database.update(toUpdate, false);
                    }   
                }   
            }
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                ExceptionHandler.postToAll(e, false);
            }
        }
    }
*/
        
/*
    public static SObject[] grabChildRecords(Sobject[] sObjects, String objectAPIName) {
        SObject[] ret = new List<SObject>();
        
        //Tasks; Events; Contacts;...
        Child_Query_Settings__c setting = Child_Query_Settings__c.getInstance( objectAPIName );
        
        if (setting != null) {
            String [] fields = new List<String>();
            
            fields = setting.Include__c.split(';') ;            
            
            if (fields.size() > 0 ) {
                for (SObject sObj : sObjects) {
                    
                    for (String rel : fields ) {
                        if (sObj.getSObjects( rel ) != null) {
                            ret.addAll ( sObj.getSObjects ( rel ) );
                        }
                    } 
                }            
            }
        }
        return ret;
    }
  */	  
    
    public static SObject[] grabChildRecords(Sobject[] sObjects, Child_Query_Settings__c setting) {
        SObject[] ret = new List<SObject>();
        
        if (setting != null) {
            String [] fields = new List<String>();
            
            fields = setting.Include__c.split(';') ;            
            
            if (fields.size() > 0 ) {
                for (SObject sObj : sObjects) {
                    
                    for (String rel : fields ) {
                        if (sObj.getSObjects( rel ) != null) {
                            ret.addAll ( sObj.getSObjects ( rel ) );
                        }
                    } 
                }            
            }
        }
        return ret;
    }    
    
    
    public static String getQuery(Child_Query_Settings__c setting) {
        if (setting != null) {            
            String[] childQueries = new list<String>();
            
            for (String childRelationship : setting.Include__c.split(';')) {
                childQueries.add(('( SELECT ID from ' + childRelationship + ' WHERE ' + Label.Linkage_Field + '= null )'));
            }
            return 'SELECT ID, ' + String.join(childQueries, ',') + ' FROM ' + setting.Name ;
        }
        return null;
    }

}