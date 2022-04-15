public class ContactSearchcontroller {
    public String firstName{get;set;}
    public String lastName{get;set;}
    public String email{get;set;}
    public String companyName{get;set;}
    public String currentPageURL{get;set;} // To get the current page URL
    public map<id, contact> contactsMap{get;set;}// To display the list of contact records based on the search criteria
    public List<Lead> leadList{get;set;}// To display the list of Lead records based on the search criteria
    
    public Id contactID {get; set;}
    
    public Id contactID2 {get; set;}
    public map<Id, Boolean> contactToAccessMap {get; set;}

    
    
    public ContactSearchController() {
        contactsMap = new map<id, contact>();
        contactToAccessMap         = new map<id, boolean>();
        leadList = new List<Lead>();
        currentPageURL = System.currentPageReference().getURL();
    }
    
    public ContactSearchcontroller(ApexPages.StandardController controller) {
        
        contactsMap = new map<id, contact>();
        contactToAccessMap         = new map<id, boolean>();
        
        leadList = new List<Lead>();
        currentPageURL = System.currentPageReference().getURL();

    }
    
    public Integer getContactsMapSize() {
        return contactsMap.size();
    }
    
    
    
    public PageReference createContactShare() {

        ContactShare share = new ContactShare();
        share.ContactId = contactID;
        share.UserOrGroupId = UserInfo.getUserId();
        share.ContactAccessLevel = 'Read';   
        try {
            insert share;
            contactToAccessMap.put(contactId, true);
        } catch (exception e) {
            ApexPages.Message wsErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Could not grant access to contact');                       
        }

        return null;
        
    }    
    
     public PageReference cancel()
    {        
        PageReference newpage = new PageReference(currentPageURL);        
        newpage.getParameters().clear();
        newpage.setRedirect(true);
        return newpage;
    }
    
    
    public void setContactRecordAccessMap() {
        
        for (UserRecordAccess contactRecordAccess : [select recordid, hasreadaccess from userrecordaccess where userid = :userInfo.getUserId()
                                                  and recordid in : contactsMap.keySet()]) 
        {
            contactToAccessMap.put(contactRecordAccess.recordid, contactRecordAccess.hasreadaccess);
        }
        
    }

    public PageReference showPage() {
        String ret = String.join(new List<String>
                                 {
                                     'name_firstcon2=' + firstName,
                                         'name_lastcon2=' + lastName,
                                         'con15=' + email,
                                         'con4=' + companyName
                                         },
                                 '&');
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+ '/003/e?nooverride=1&' + ret );
    }
    
    
    
    
    
    /*Search method: It dsiplay the contact and lead  results based on search criteria entered*/
    public void searchRecords()
    {
        /*Initialising the list variables*/
        contactsMap = new map<id, contact>();
        leadList = new List<Lead>();
        /*Validation for last name field*/
        if(String.isBlank(lastName) || String.isBlank(firstName))
        {
            System.debug('Error!!!');
            ApexPages.Message wsErrorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter last and first name');                       
            ApexPages.addMessage(wsErrorMessage);
        }
        else
        {
        
        /* dynamic SOQL query for Salesforce Contact, Lead objects */
        String conSearch = 'select id, userrecordaccess.hasreadaccess, lastname, firstname, accountid, account.name,email,phone,mailingstate,mailingcity,mailingcountry, mailingaddress, mailingStreet from contact where lastname like \'%'+lastName+'%\'';
        String leadSearch = 'select id, lastname, firstname, email, phone, Company,  state, country, city, Data_com_Contact_Key__c, Street from Lead where lastname like \'%'+lastName+'%\'';
        
        
        if(!String.isEmpty(firstName))
        {
            conSearch += ' and firstname like \'%'+firstname+'%\'';
            leadSearch += ' and firstname like \'%'+firstname+'%\'';
        }
        
        if(!String.isEmpty(email))
        {
            conSearch += ' and email like \'%'+email+'%\'';
            leadSearch += ' and email like \'%'+email+'%\'';
        }
        
        if(!String.isEmpty(companyName))
        {
            System.debug('company name is : ' + companyName);
            conSearch += ' and account.name like \'%'+companyName+'%\'';
            leadSearch += ' and company like \'%'+companyName+'%\'';
        }
        contactsMap =  new Map<Id, Contact>((List<Contact>) database.query(conSearch));//Converting Contact string query to list in salesforce
        leadList = database.query(leadSearch);//Converting Lead string query to list in salesforce
        
        }
        
        setContactRecordAccessMap();
    }    
}