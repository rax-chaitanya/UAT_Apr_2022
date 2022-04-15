/**
 * File : ContactSearchAndCreateCtrl.cls
 * Description : Search and create Contact
 * Created Date : 11/July/2018
 * @author : Anil
 */
public without sharing class ContactSearchAndCreateCtrl{

// LTCSF-140 : fetch Contact RecordTypes available for current user
    @AuraEnabled        
    public static Map<Id, String> fetchContactRecordTypes(){
        List<Schema.RecordTypeInfo> recordtypes = Contact.SObjectType.getDescribe().getRecordTypeInfos();    
        Map<Id, String> contactRecordTypeMap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.isAvailable())
            contactRecordTypeMap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return contactRecordTypeMap;
    }
    @AuraEnabled
    public static ContactSearchAndCreateCtrl.ContactAndLeadWrapper fetchSearchResultData(String fName,String lName,String email,String cmpName){
        ContactSearchAndCreateCtrl.ContactAndLeadWrapper conAndLeadwrpObject;
        List<ContactWrapper> conWrpList = new List<ContactWrapper>();
        List<LeadWrapper> ldWrpList = new List<LeadWrapper>();
        String conQueryString = 'Select Id,DoNotCall,AssistantName,userrecordaccess.hasreadaccess, lastname, firstname, accountid, account.name,email,phone,mailingstate,mailingcity,mailingcountry, mailingaddress, mailingStreet, Name, Account.Owner.Name From Contact WHERE ';
        String confilters = '';
        String leadQueryString = 'Select id, lastname, firstname, email, phone, Company, state, country, city, Data_com_Contact_Key__c, Street From Lead WHERE ';
        String LeadFilters = '';
        Id RBURecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
        Id RBURecTypeIdlead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        
        if(String.isNotEmpty(fName)){
            String ftName = fNAme.trim()+'%';
            confilters = confilters + ' FirstName like :ftName';
            LeadFilters = LeadFilters + ' FirstName like :ftName';
            
        }        
        if(String.isNotEmpty(lName)){
            String ltName = lNAme.trim()+'%';
            confilters = confilters + ' AND LastName like :ltName';
            LeadFilters = LeadFilters + ' AND LastName like :ltName';
        }        
        if(String.isNotEmpty(email)){
            String uEmail = email.trim()+'%';
            confilters = confilters + ' AND email like :uEmail';
            LeadFilters = LeadFilters + ' AND email like :uEmail';
        }        
        if(String.isNotEmpty(cmpName)){
            String cpName = cmpName.trim()+'%';
            confilters = confilters + ' AND Account.Name like :cpName';
            LeadFilters = LeadFilters + ' AND Company like :cpName';
        }    
        if(MyProflieName =='RBU Profile'){
        confilters=confilters +' And RecordtypeId=:RBURecTypeId';
         LeadFilters =LeadFilters +' And RecordtypeId=:RBURecTypeIdlead';
        }
        if(MyProflieName!='RBU Profile'){
        confilters=confilters +' And RecordtypeId!=:RBURecTypeId';
        LeadFilters=LeadFilters +' And RecordtypeId!=:RBURecTypeIdlead';
        }
        
        conQueryString = conQueryString + confilters + ' Limit 200';
        Map<Id, Contact> contactMap = new Map<Id, Contact>((List<Contact>) Database.query(conQueryString));
        for(contact con:contactMap.values()){  //Forming the contact wrapper data.
            conWrpList.add(new ContactWrapper(con));
        }
        
        leadQueryString = leadQueryString + LeadFilters + ' Limit 200';
        Map<Id, Lead> leadMap = new Map<Id, Lead>((List<Lead>) Database.query(leadQueryString)); 
        for(Lead ld:leadMap.values()){  //Forming the lead wrapper data.
            ldWrpList.add(new LeadWrapper(ld));
        }        
                
        System.debug('contactMap Size-->'+contactMap.size());
        System.debug('ldWrpList Size-->'+ldWrpList.size());
        
        conAndLeadwrpObject = new ContactSearchAndCreateCtrl.ContactAndLeadWrapper(conWrpList,ldWrpList);
        
        return conAndLeadwrpObject;
    }
    
    //Contact and Lead object data Wrapper to return this object to Lightning Component
    public class ContactAndLeadWrapper{
        @AuraEnabled
        public List<ContactWrapper> contactWrapList{get;set;}
        
        @AuraEnabled
        public List<LeadWrapper> leadWrapList{get;set;}
        
        public ContactAndLeadWrapper(List<ContactWrapper> conWrpLst,List<LeadWrapper> ldWrpLst){
            contactWrapList = conWrpLst;
            leadWrapList = ldWrpLst;
        }
    }
    
    //Contact Wrapper class
    public class ContactWrapper{
        @AuraEnabled
        public Contact conObj{get;set;}
        
        public ContactWrapper(Contact con){
            conObj = con;
        }
    }
   
    //Lead Wrapper Class
    public class LeadWrapper{
        @AuraEnabled
        public Lead leadObj{get;set;}
        
        public LeadWrapper(Lead ld){
            leadObj = ld;
        }
    }
}