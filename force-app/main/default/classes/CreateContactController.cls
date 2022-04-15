public without sharing class CreateContactController {
    @AuraEnabled
    Public static Object getPickListData(){
        Map<String, Object> result = new Map<String, Object>();
        result.put('SalutationValues', ApexDependentPicklistUtility.getPicklistValues('Contact', 'Salutation'));
        result.put('LanguageValues', ApexDependentPicklistUtility.getPicklistValues('Contact', 'Language__c'));
        result.put('MailingCountryOptions', ApexDependentPicklistUtility.getPicklistValues('Contact', 'MailingCountryCode'));
        result.put('MailingStateValues', (Map<String, List<String>>)ApexDependentPicklistUtility.getDependentOptions('Contact', 'MailingCountryCode', 'MailingStateCode'));
        return result;  
        
    }
    @AuraEnabled
    Public Static string Createcontact(string Fname,String Lname,string Tit,string Suff,string Salu,string Email,
                                       string Phone,string Fax,string Mob,String lang,string mailcon,string mailstate,
                                       string terr,String city,String pcode,String address)
    {
        Contact c = new contact();
        try{
            
            if(System.label.Partner_Profiles.contains(userInfo.getProfileId())){
                
                list<contact> conlist = new list <contact>([Select id,email from contact where recordtypeId=:System.Label.Contact_Partner_RecordTypeID]);
                for(contact con : conlist){
                    
                    if(con.Email==email){
                        con.Email.addError('This Email is already exist');
                    }
                    else{
                        c.FirstName = Fname;
                        c.LastName = Lname;
                        c.Salutation = Salu;
                        c.Title = Tit;
                        c.Email = email;
                        c.Phone = phone;
                        c.MobilePhone = mob;
                        c.Fax = Fax;
                        c.Language__c = lang;
                        c.Territory__c = terr;
                        c.MailingCity = city;
                        c.MailingPostalCode = pcode;
                        c.MailingStreet = address;
                        c.MailingCountry = mailcon;
                        c.MailingState = mailstate; 
                        
                    }    
                    
                }
                
                user parterloginuser = [select contactid,accountid from user where id=: UserInfo.getUserId() 
                                        and contact.Is_Primary_Member__c = True];
                if(parterloginuser != null && c!= null){
                    c.AccountId = parterloginuser.accountid;
                    insert c;
                }
                
                
            }
        }
        catch (Exception e){
            system.debug('Coming to Exception');  
        }
        return c.Id; 
          
    }

    @AuraEnabled
    public static Boolean redirectionPolling(Id contactId){
        return ![select id,contactid from user where contactId =:contactId].isEmpty();
    }
    
}