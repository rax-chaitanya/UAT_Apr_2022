public without sharing class SearchBeforeCreateContact extends Framework {
    
    public final String contactString {get; set;}
    public final String leadString {get; set;}
    public Contact contact {get; set;}    // sObject used to bind variables in form 
    
    
    public String queryString {get; set;}
    
    public Map<id, Contact> contactsMap {get; set;}     // contacts table
    public List<Lead> leads {get; set;}             // leads table
    
    public Boolean isSearched {get; set;}
    
    public String clickedOn {get; set;}
    
    public Map<Id, Boolean> selectedMap {get; set;}
    public Map<id, Boolean> contactAccessRecordMap {get; set;}
    // bound variables from contact pushed to these variables, done so dynamic apex querying can be done        
    String firstName, lastName, email, companyName;     
    
    //
    public String recordID {get; set;}
    
    
    public String queryID {get; set;}
    public String pageVal{get; set;} 
    
    public Map<String, TableState> tableState {get; set;}
    
    
    
    public SearchBeforeCreateContact(ApexPages.StandardController controller) {
        super('ContactSearchBeforeCreate');        
        
        contactString =   VF_Query_Manager__c.getInstance('ContactSBC-3').Query_ID__c; //'a0N5B0000009avoUAA';
        leadString =    VF_Query_Manager__c.getInstance('ContactSBC-4').Query_ID__c; //'a0N5B0000009avtUAA';
        
        //initializers, needed so that values will not be null upon submit
        contact = new Contact();                
        contact.Account = new Account();
        
        contactAccessRecordMap = new Map<Id, Boolean>();
        
        leads = new List<Lead>();
        contactsMap = new Map<Id, Contact>();
        
        tableState = new Map<String, TableState>();
        
        clickedOn = contactString;
    }
    
    
    public void cancel() {
        contact = new Contact();
        contact.Account = new Account();
        isSearched = false;
    }
    
    private void setContactAccessRecordMap() {
        //queryBuilder is not referencing an sObject, which means it will keep all query filters (if they exist)
        queryBuilder.setSObject(null);
        
        //need to set these variables since they're referenced in the dynamic query
        Id UserId = UserInfo.getUserId();
        Set<Id> contactsKeySet = contactsMap.keyset();
        String query = queryBuilder.getQueryString( VF_Query_Manager__c.getInstance('ContactSBC-5').Query_ID__c  );
        
        for (UserRecordAccess contactRecordAccess : Database.query(query)) {
            //System.debug(contactRecordAccess.recordid + '===> ' + ((contactRecordAccess.HasReadAccess) ? true : false));
            contactAccessRecordMap.put(contactRecordAccess.recordid, (contactRecordAccess.HasReadAccess) ? true : false);
        }            
        
        
        
        //System.debug(contactAccessRecordMap);
    }
    
    public List<Contact> getContacts() {
        List<Contact> toReturn = new list<Contact>();
        if (String.IsNotBlank(contact.AssistantName)) {
            
            
            for (Id cID : contactsMap.keySet()) {
                if ((contactsMap.get(cID).Name).contains(contact.AssistantName))
                    toReturn.add(contactsMap.get(cid));
            }
            return toReturn;
        } 
        
        return (contactsMap.values() == null) ? new List<Contact>() : contactsMap.values();
        
    }
    
    public void cascadeChoice() {
        System.debug('calling cascadeChoice():');
        for (Contact c : contactsMap.values()) {
            if (!contactAccessRecordMap.get(c.id)) {
                selectedMap.put(c.id, contact.DoNotCall);
                c.DoNotCall = contact.DoNotCall;
            }
        }
    }
    
    
    public Integer getTotalSelected() {
        Integer total = 0;
        for (Id i : selectedMap.keySet()) {
            if (selectedMap.get(i)) {
                total += 1;
            }
        }
        return total;
        
    }
    
    
    public void toggleChoice() {
        System.debug('recordID: ' + recordID);
        
        System.debug('contacts map.values below');
        for (Contact c : contactsMap.values()) {
            System.debug(c.name);
        }
        //Boolean b = (recordID.split('\\+')[0] == 'true') ? true : false;
        //recordID = recordID.split('\\+')[1];
        //selectedMap.put(recordID, b);
        
        
        try {
            if (!contactsMap.get(recordID).DoNotCall) {
                contactsMap.get(recordId).doNotCall = false;
                selectedMap.put(recordID, false);
                
            } else {
                contactsMap.get(recordId).doNotCall = true;
                selectedMap.put(recordID, true);
                
            }
        } catch (Exception e) {
            
            
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage());  
            ApexPages.addMessage( msg );
        }
        
        
        //System.debug('before: ' +contactsMap.get(recordId) );
        
        
        //contactsMap.get(recordId).DoNotCall = b;
        //System.debug('after: ' +contactsMap.get(recordId) );
        
        System.debug('is selected?: ' +recordID + '===>' + selectedMap.get(recordID));
        
        for (Id i : contactAccessRecordMap.keySet()) {
            System.debug(i + '===> ' + contactAccessRecordMap.get(i));
        }
    }
    
    /*
public void filter() {
System.debug(contactsMap.keySet());


String searchParam = contact.AssistantName;     //piggybacking off of unused sObject variable



}
*/
    
    
    public PageReference initNewContact() {
        String ret = String.join(new List<String>
                                 {
                                     'name_firstcon2=' + contact.FirstName,
                                         'name_lastcon2=' + contact.lastName,
                                         'con15=' + (String.IsNotBlank(contact.email) ? contact.email : ''),
                                         'con4=' + (String.IsNotBlank(contact.Account.Name) ? contact.Account.Name : '')
                                         },
                                 '&');
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+ '/003/e?nooverride=1&' + ret );
        
    }
    
    
    
    
    public void createContactShares() {
        System.debug('createContactShares()');
        List<ContactShare> shares = new list<ContactShare>();
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,('No contact shares have been selected.'));
        
        String names = '';
        
        
        for (Id i : selectedMap.keySet()) {
            if (selectedMap.get(i)) {
                shares.add ( new ContactShare(ContactAccessLevel = 'Read', ContactID = i, UserOrGroupId = UserInfo.getUserId() ) );
                ContactAccessRecordMap.put(i, true);
            }
        }
        /*
for (Contact c : contactsMap.values()) {
System.debug('seeing that  ' + c.Firstname + ' has a do not call of : ' + c.DoNotCall);
if (c.DoNotCall) {  //marked as true
shares.add ( new ContactShare(ContactAccessLevel = 'Read', ContactID = c.ID, UserOrGroupId = UserInfo.getUserId() ) );
ContactAccessRecordMap.put(c.id, true);
c.DoNotCall = false;

}
}
*/
        
        if (shares.size() > 0) {
            System.debug(shares);
            try {
                insert shares;
                for (Id i : selectedMap.keySet()) {
                    selectedMap.put(i, false);
                }
                msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,(shares.size() + ' share(s) have been created.'));  
                
            } catch (Exception e) {
                msg = new ApexPages.Message(ApexPages.Severity.ERROR,(e.getMessage()));  
            }
        }
        ApexPages.addMessage( msg );
        
    }    
    
    
    
    public void executeSearch() {
        firstName =  contact.FirstName + '%';
        lastName =  contact.lastName + '%';
        email =  contact.Email + '%';
        companyName =  contact.Account.Name + '%';
        
        selectedMap = new map<Id, Boolean>();
        
        tableState.put(contactString, new TableState('contactsPanel'));
        tableState.put(leadString, new TableState('leadsPanel'));
        
        
        searchForContacts();
        searchForLeads();
        
        //setContactAccessRecordMap();
        isSearched = true;
    }
    
    
    public void genericFunction() {
        System.debug('queryId is ' + queryId);
        System.debug('page is: ' + pageVal);
        
        clickedOn = queryID;
        
        TableState ts = tableState.get(queryId);
        
        if (pageVal == 'first') ts.first();
        if (pageVal == 'prev') ts.prev();
        if (pageVal == 'next') ts.next();
        if (pageVal == 'last') ts.last();
        
        if (queryId == contactString) {
            contact.DoNotCall = false;
            searchForContacts();
        } else if (queryId == leadString) {
            searchForLeads();
        }
        System.debug('will ReRender: ' + tableState.get(clickedOn).reRender);
        
        
        
    }
    
    public map<string,string> getTableResultMap() {
        map<string,String> ret = new map<string,string>();
        
        
        set<string> strs = new set<string>{contactString,leadString};
            for (string s : strs) {
                ret.put(s, tableState.get(s).totalCount == 0 ? '0' : (tableState.get(s).currOffset + 1) + ' - ' + ( Math.min(tableState.get(s).queryLimit + tableState.get(s).currOffset, tableState.get(s).totalCount) ) + ' of ' + (tableState.get(s).totalCount)); 
            }
        
        
        return ret;
        
    }
    
    private void searchForContacts() {
        System.debug(contact);
        queryBuilder.setSObject(contact);
        
        TableState ts = tableState.get(contactString);
        Integer off = ts.curroffset;
        String query = queryBuilder.getQueryString(contactString);
        queryString = query;
        
        contactsMap = new Map<Id, Contact>( (List<Contact>) Database.query(query));
        
        ts.totalCount = Database.countQuery ( queryBuilder.getQueryString ( VF_Query_Manager__c.getInstance('ContactSBC-1').Query_Id__c ) );
        ts.queryLimit = Integer.valueOf(queryBuilder.querylookup.get(contactString).Query_Limit__c);
        
        if (contactsMap.size() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No contacts were found.');  
            ApexPages.addMessage( msg );
        }
        
        
        
        
        //piggybacking off checkbox field to use for requesting access
        for (Id cID : contactsMap.keySet()) {
            if(!selectedMap.containsKey(cId)) {
                selectedMap.put(cId, false);
            } else {
                if (selectedMap.get(cId)) contactsMap.get(cId).DoNotCall = true;
                //c.DoNotCall = false;
            }
        }
        
        
        System.debug('searchContacts map: ' + selectedMap);
        setContactAccessRecordMap();
        
    }
    
    
    private void searchForLeads() {
        Lead l = new Lead();
        l.FirstName = contact.FirstName;
        l.LastName = contact.LastName;
        l.Email = contact.Email;
        l.Company = contact.Account.Name;
        queryBuilder.setSObject(l);
        
        
        System.debug('lead first name: ' + l);
        
        TableState ts = tableState.get(leadString);
        
        
        Integer off = tableState.get(leadString).currOffset;        
        leads = Database.query(queryBuilder.getQueryString(leadString));
        
        ts.totalCount = Database.countQuery(queryBuilder.getQueryString(  VF_Query_Manager__c.getInstance('ContactSBC-2').Query_ID__c ));   //totalCount of leads
        ts.queryLimit = Integer.valueOf(queryBuilder.querylookup.get(leadString).Query_Limit__c);
        
        //ts.print();
        
        
        if (leads.size() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No leads were found.');  
            ApexPages.addMessage( msg );
        }
        
    }
}