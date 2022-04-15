public class ActivityMethods {
    public static final Id TaskRecordTypeId =schema.sobjecttype.Task.getrecordtypeinfosbyname().get('TechSales Activity').getRecordTypeId();

    public static void beforeUpdate() {
        beforeInsert();
    }
    
    public static void beforeInsert() {
        try {
            map<string, sobject> sObjectMap = new map<string, sObject>();
            map<string,map<string,Activity_Trigger_Settings__c >> when_to_field_to_query_map = new map<string,map<string,Activity_Trigger_Settings__c >>();   // (ex: All => WhatId => Select * from ..., Task => RecordTypeId => null)
            map<string, map<string, list<string>>> what_to_sObject_to_ids_map = new map<string, map<string, list<string>>>(); //WhatId => (Accounts__c => (xx, yy, zz), Account => (aa, bb) ), WhoId =>  )
            
            
            map<string,set<string>> field_to_values_map = new map<string, set<string>>();                       // (ex: WhatId => (xx, yy, zz), WhoId => (aa, bb, cc),...)
            
            for (Activity_Trigger_Settings__c ats : [Select Id, Name, SObject__c, Field__c, Query__c,Fields_To_Retrieve__c, Key_Field__c from Activity_Trigger_Settings__c order by name]) {
                if (when_to_field_to_query_map.containsKey(ats.SObject__c)) {
                    when_to_field_to_query_map.get(ats.SObject__c).put(ats.Field__c, ats);
                } else {
                    when_to_field_to_query_map.put(ats.SObject__c, new map<string,Activity_Trigger_Settings__c>{ats.Field__c => ats});                
                }
            }
            
            if (when_to_field_to_query_map.size() == 0) {
                CustomException ce = new CustomException('Activity Trigger Settings fields are not populated.');
                ExceptionHandler.postToAll(ce, false);
                throw ce;
            }
            
            system.debug('when_to_field_to_query_map: ' + when_to_field_to_query_map);
            system.debug('when_to_field_to_query_map.values(): ' + when_to_field_to_query_map.values());
            
            for (SObject sObj : (List<sObject>) Trigger.new) {
                for (String sObjType : when_to_field_to_query_map.keySet()) {       //All, Task, Event
                    if (sObjType == 'All' || sObjType == (sObj).getSObjectType().getDescribe().getName() ) {        
                        
                        for (String field : when_to_field_to_query_map.get(sObjType).keySet()) {
                            
                            String value = (String) sObj.get(field);
                            if (String.isNotBlank (value) && value instanceof ID) {
                                
                                String sObject_type_Name = ( (ID) value ).getSObjectType().getDescribe().getName() ;
                                
                                if (what_to_sObject_to_ids_map.containsKey( field ) ) {
                                    if (what_to_sObject_to_ids_map.get(field).containsKey( sObject_type_Name   ) ) {
                                        what_to_sObject_to_ids_map.get( field ).get( sObject_type_Name ).add( value );
                                    } else {
                                        what_to_sObject_to_ids_map.get( field ).put( sObject_type_Name, new list<string>{value} );
                                    }
                                } else {
                                    what_to_sObject_to_ids_map.put( field, new map<string, list<string>>{sObject_type_Name => new list<string>{ value } } );
                                }
                            }
                        }
                    }
                }
            }
            
            System.debug('field_to_values_map NEWLY EDITED ONE: ' + field_to_values_map);
            System.debug('what_to_sObject_to_ids_map : ' + what_to_sObject_to_ids_map);
            
            map<string, Activity_Trigger_Settings__c> mp = new map<string,Activity_Trigger_Settings__c>();
            for (map<string,Activity_Trigger_Settings__c> m :when_to_field_to_query_map.values() ) {
                mp.putAll(m);
            }
            
            System.debug(mp);
            for (String field : what_to_sObject_to_ids_map.keySet() ) {
                for (String sObject_type : what_to_sObject_to_ids_map.get(field).keySet()) {
                    
                    System.debug('is ' + mp.get ( field ).Fields_to_Retrieve__c + ' a valid field for : ' + sObject_type + ' OR is this string ('  + mp.get(field).Query__c + ' not blank and does it not have {0}  ?');
                    if ( (Schema.getGlobalDescribe().get(sObject_type) != null &&
                          Schema.getGlobalDescribe().get(sObject_type).newSObject().getSObjectType().getDescribe().fields.getMap().containsKey(mp.get ( field ).Fields_to_Retrieve__c ) ) 
                        || 
                        (String.isNotBlank( mp.get(field).Query__c)  && !mp.get(field).Query__c.contains('{0}'))
                       ) 
                    {
                        system.debug('yes');
                        
                        string[] values = what_to_sObject_to_ids_map.get(field).get(sObject_type);
                        
                        if (String.isNotBlank ( mp.get( field ).Query__c) ) {
                            String queryString = String.format(  mp.get( field ).Query__c, new list<string>{sObject_Type});
                            
                            for (SObject sObj : Database.query( queryString) ) {
                                System.debug('going to put ' + mp.get(field).key_field__c + ' as a key for : ' + sObj);
                                sObjectMap.put( (String) sObj.get( mp.get( field).Key_Field__c ), sObj );
                                
                            }
                            System.debug('values for query string below are : ' + values);
                            
                            System.debug(queryString);
                        } 
                        
                    }
                    
                }
            }
            System.debug('sobject map: ' + sObjectMap);
            
            for (SObject sObj : (List<sObject>) Trigger.new) {
                string[] lookup_ids = new list<string>();
                
                for (String sObjType : when_to_field_to_query_map.keySet()) {       //All, Task, Event
                    if (sObjType == 'All' || sObjType == (sObj).getSObjectType().getDescribe().getName() ) {        
                        
                        for (String field : when_to_field_to_query_map.get(sObjType).keySet()) {
                            
                            String value = String.isBlank( (String) sObj.get(field) ) ? 'N/A' : (String) sObj.get(field);
                            System.debug(sObj.get('id') + ' value on field: ' + field + ' is: ' + value);
                            
                            if (value instanceof Id) {
                                if (sObjectMap.containsKey(value)) {
                                    string sObj_value = (String) sObjectMap.get( value  ).get((String) mp.get(field).Fields_to_retrieve__c );
                                    sObj_value = (String.isBlank(sObj_value)) ?  'N/A' : sObj_value;
                                    System.debug('lookup_ids.add( ' +  sObjectMap.get( value + ').get(' +  mp.get(field).Fields_to_retrieve__c ) + ')');
                                    lookup_ids.add(sObj_value);  
                                } else {
                                    lookup_ids.add('N/A');
                                }  
                            } else {
                                lookup_ids.add( value);
                            }
                        }
                    }
                }
                sObj.put('Lookup_Ids__c', String.join(lookup_ids,','));
                
                System.debug('lookup_ids: for  '  + sObj.get('id') +  lookup_ids);
            }             
            
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
            throw new CustomException(e.getMessage());
        }
        
    }
    
    
    
    public static void UpdateIds()
    {
        
        /*
map <string,fieldmapping__c> activityRecordTypeMapping = new map <string,fieldmapping__c>();

for (FieldMapping__c fm : [SELECT sourceField__c, targetField__c from FieldMapping__c where name like 'Task-RT-%']) {
//put activity record type from old instance in key and the fm in value
activityRecordTypeMapping.put(fm.SourceField__c, fm);
}
*/
        
        map<string, id> userMap = new map<string, id>();
    /*    for (USer u : [Select Id, federationidentifier from user Where Federationidentifier != '']) {
            userMap.put(u.federationidentifier, u.id);
        }*/
        
        map<integer, String> order_to_field_map = new map<integer, string>();
        Integer count = 0; 
        for (Activity_Trigger_Settings__c ats : [Select Id, Name, SObject__c, Field__c, Query__c, Fields_To_Retrieve__c, Key_Field__c from Activity_Trigger_Settings__c order by name]) {
            order_to_field_map.put(count, ats.field__c);
            count++;
        }        
        
        for(SObject t : (List<SObject>)Trigger.new)
        {
            
            System.debug('STARTING task of old_record_id__c value of : ' + t.get('old_record_id__c'));
            
            Schema.SObjectType sobjType =  t.getSObjectType();
            String sobjName = sobjType.getDescribe().getName();
            system.debug('@@'+(String)(t.get('Lookup_Ids__c')));
            if((Trigger.isInsert && String.isNotBlank((String)(t.get('Lookup_Ids__c')))) || (Trigger.isUpdate
                                                                                             && String.isNotBlank((String)(t.get('Lookup_Ids__c'))) &&((Map<id,SObject>)Trigger.NewMap).get(t.id).get('Lookup_Ids__c') != ((Map<id,SObject>)Trigger.OldMap).get(t.id).get('Lookup_Ids__c')))
            {
                
                string[] lookups = ( (String) t.get('lookup_ids__c') ).split(',');
                for (Integer i = 0; i < lookups.size(); ++i) {
                    String s = lookups[i] == 'N/A' ? '' : lookups[i];
                    //if (s != 'N/A') {
                    System.debug('iTH value: ' + i + ', field: ' + order_to_field_map.get(i) + ',lookups[i]: ' + lookups[i]);
                    if (userMap.containsKey(s)) {
                        t.put(order_to_field_map.get(i), userMap.get(s));
                    } else {
                        if (i == 2) {
                            t.put(order_to_field_map.get(i), UserInfo.getUserId());
                        } else {
                            t.put(order_to_field_map.get(i), s);
                        }
                    } 
                    //}
                }
            }
            
            System.debug('FINISHING with task of old_record_id__c value of : ' + t.get('old_record_id__c'));
        }
        
    }
    
    
    
    //added for SFDC-21, JY(RDC) on Jul/25/2017, begin
    public static void logLeadActivity(List<Task> triggerNew) {
        try {
            List<Id> affectedLeads = new List<Id>();
            Map<Id, Lead> leadDetails = new Map<Id, Lead>();
            Map<Id, Lead> activeLeads = new Map<Id, Lead>();
            List<Task> relevantTasks = new List<Task>();
            for(Task t : triggerNew) {
                if(t.WhoId != null && ((String)t.WhoId).startsWith('00Q')) {
                    affectedLeads.add(t.WhoId);
                    relevantTasks.add(t);
                }
            }
            
            if(!affectedLeads.isEmpty()) {
                leadDetails = new Map<Id, Lead> ([SELECT Id, OwnerId, ActivityLogged__c
                                                  FROM Lead
                                                  WHERE Id IN :affectedLeads AND
                                                  ActivityLogged__c = false AND
                                                  Max_Date_Passed__c != null]);
            }
            
            for(Task t : relevantTasks) {
                if(leadDetails.containsKey(t.WhoId) && t.CreatedById == leadDetails.get(t.WhoId).OwnerId) {             
                    activeLeads.put(t.WhoId, new Lead(Id = t.WhoId, ActivityLogged__c = true));
                }
            }
            
            if(!activeLeads.isEmpty()) {
                update activeLeads.values();
            }
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
    }
    //added for SFDC-21, JY(RDC) on Jul/25/2017, end  
    
    //Added By: Vinod Thupakula
    //SFDC-2286
    
    //Added By: Vinod Thupakula
    //SFDC-2286 Modified by Thirupathi Aeneni
    
    public static void countOfTaskandEventsForAccounts(List<Sobject> items){
        Set<Id> accountIds = new Set<Id>();
        Set<Id> companyIds = new Set<Id>();
        if(items!= null && items.size()>0){ 
            for(Sobject sobj:items){
                // Added by Thirupathi Aeneni for SFDC - 2673
                if(sobj.get('WhatId') !=null && Id.valueOf(String.valueOf(sobj.get('WhatId'))).getSObjectType().getDescribe().getName() =='Account' ){
                    companyIds.add(Id.valueOf(String.valueOf(sobj.get('WhatId'))));
                }
                
            }

            // Added by Thirupathi Aeneni for SFDC - 2673
            if(companyIds.size()>0){
                List<Account> updateCompanies = new List<Account>();
                updateCompanies = [SELECT Id,Company_Named_Account__c FROM Account WHERE Id IN:companyIds AND Company_Named_Account__c='ABM'];
                if(updateCompanies.size()>0)
                    update  updateCompanies;
            }
        }
    }
    
    //Added by Anitha Sajja
    //Added for SFDC-3836 and SFDC-3969
    public static void updateTechnicalNextStepOpp()
    {
          
    List<opportunity> oppupdate=new list<opportunity>();
    Set<id> oppIds = new Set<id>();
        List<Task> updateTasks=new List<Task>();
        

        for (Task tk: (List<Task>)Trigger.new) 
        {
            if(tk.WhatId !=null&&((String)tk.WhatId).startsWith(Schema.SObjectType.Opportunity.getKeyPrefix()))
            {
                oppIds.add(tk.WhatId);
                updateTasks.add(tk);
            }
        }
  
    
     
    if(oppIds.size() > 0){
        List<Opportunity> optys = [Select Id,RecordType.Name,Technical_Next_Steps__c from Opportunity where Id in :oppIds and RecordType.Name!='Read Only'];
    
  
    
   
    for (Task t: updateTasks)
       {
        
        
     if(t.RecordtypeId==TaskRecordTypeId && (userinfo.getProfileId()==(Label.Rackspace_SE_US_Profile)) && (((String)t.WhatId).startsWith(Schema.SObjectType.Opportunity.getKeyPrefix()))){ 
     
      for(opportunity opp:optys){
          if(opp.RecordType.Name!='Read Only'&& t.WhatId==opp.id && t.Technical_Next_Steps__c!=null)
          {
            opp.Technical_Next_Steps__c=t.Technical_Next_Steps__c;
    
            oppupdate.add(opp);
          }
       }
         
 
    }
      
    }
    update oppupdate;
    }
    }
    
    
}