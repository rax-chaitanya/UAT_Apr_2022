public class DDIAccountSignUpOnOptyCloseWon{


    public static void autoCreateDDIAccount(Id opptyId,Set<Id> contactIds){
        
        DDIAccountSignUpPayload(opptyId,contactIds);
        
        
    }
    
    @future(callout=true)
    public static void autoCreateDDIAccountFuture(Id opptyId,Set<Id> contactIds){
        
        DDIAccountSignUpPayload(opptyId,contactIds);
    }
    ///////////////
    public static void DDIAccountSignUpPayload(Id opptyId,Set<Id> contactIds){
       system.debug('DDI Creation future with oppty Id>>>'+opptyId);
       system.debug('DDI Creation future with contactIds>>>'+contactIds);
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId() limit 1];
       
       Opportunity opptyRec  = [Select Id, Name,MuleSoft_Acknowledge__c, AccountId,AcquisitionId__c, Account.Name,Account.CurrencyIsoCode,
                                Account.Tax_ID_VAT_Number__c,Account__c,Account__r.Name,Account__r.CurrencyIsoCode,Account__r.Tax_ID_VAT_Number__c,
                                Type,Account__r.Contracting_Entity__r.Name, Account__r.ShippingCountry,RecordTypeId,RecordType.developerName from Opportunity where Id =:opptyId ];
       List<Contact> contList= [Select Id,Name,FirstName,LastName,Salutation,suffix,Email, Phone,MailingCountryCode,MailingCountry,Is_Primary_Member__c,MailingStreet,MailingState,MailingCity,MailingPostalCode from Contact where Id IN:contactIds];
       List<AccountContactRelation> acclist=[select id,contactid,accountid,Account.Name,roles from AccountContactRelation where accountid =: opptyRec.Account__c];
       system.debug('contList>>>>> size is  '+contList);
       /*boolean isOnlyOneContact = false;
       if(contList.size()==1){
           isOnlyOneContact = true;
       }*/
       
       Map<Id,String> ACRContIdByRoleMap = new Map<Id,String>();
       for(AccountContactRelation acrRec: acclist){
       system.debug('acrRec roles>>>> '+acrRec.roles);
           //if(acrRec.accountid == opptyRec.AccountId)
           ACRContIdByRoleMap.put(acrRec.contactid, acrRec.roles);
       }
       system.debug('ACRContIdByRoleMap>>>> '+ACRContIdByRoleMap);         
       
       String description         = '';
       String serviceLevel        = '';
       String notificationOption  = '';
       String paymentType         = '';
       String serviceType         = '';
       String type                = '';
       String paymentMethod       = '';
       String paymentTerms        = '';
       String businessType        = '';
       boolean termsAndConditions = false;
       boolean acceptTermsAndConditions = false;
       //String muleSoftEndPointURL = '';
       String sandboxEndPointURL = '';
       String productionEndPointURL = '';
       String clientid = '';
       String clientsecret = '';
       
        String strContMailingCountryCode = '';
        String strContEmail = '';
        String strContPhone = '';
        String strContMailingState = '';
        String strContMailingPostalCode = '';
        String strContMailingCity = '';
        String strContMailingStreet = '';
        String strContSalutation = '';
        String strContcontsuffix = '';
        String strContLastName = '';
        String strContFirstName = '';
       
        String strAccount = string.isNotBlank(opptyRec.Account__c) ? opptyRec.Account__c : '';
       String strAquisitionID = string.isNotBlank(opptyRec.AcquisitionId__c) ? opptyRec.AcquisitionId__c : '';
       //already using if else for Blank value for Tax_ID_VAT_Number__c 
       String strAcctTaxIDVATNumber = string.isNotBlank(opptyRec.Account__r.Tax_ID_VAT_Number__c) ? opptyRec.Account__r.Tax_ID_VAT_Number__c : '';
       String strAccCurrencyIsoCode = string.isNotBlank(opptyRec.Account__r.CurrencyIsoCode) ? opptyRec.Account__r.CurrencyIsoCode : '';
       
       
       
       if(DDIAccountSignUpOnOptyCloseWon__c.getAll().containsKey('DDICreationForCloseWon')){
           description            = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Description__c;
           serviceLevel           = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').ServiceLevel__c;
           notificationOption     = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').NotificationOption__c;
           paymentType            = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').PaymentType__c;
           serviceType            = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').ServiceType__c;
           type                   = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Type__c;
           paymentMethod          = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Payment_Method__c;
           paymentTerms           = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').PaymentTerms__c;
           businessType           = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').BusinessType__c;
           termsAndConditions     = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').TermsAndConditions__c;
           acceptTermsAndConditions = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').AcceptTermsAndConditions__c;
           //muleSoftEndPointURL  = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Mulesoft_Endpoint_URL__c;
           productionEndPointURL = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Production_Endpoint_URL__c;
           sandboxEndPointURL = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Sandbox_Endpoint_URL__c;
           clientid    = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Client_Id__c;
           clientsecret    = DDIAccountSignUpOnOptyCloseWon__c.getInstance('DDICreationForCloseWon').Client_Secret__c;
       }    
        
        String strServiceType = string.isNotBlank(serviceType) ? serviceType : '';
        
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('sfdcOpportunityId', opptyId);
        String sfOppTypeExteId = opptyRec.Type;
        if(sfOppTypeExteId=='Google'){
            sfOppTypeExteId='MANAGED_GCP';
        }
     
        if(sfOppTypeExteId=='Azure' || sfOppTypeExteId=='Azure Resale'){
            sfOppTypeExteId='AZURE';
        }
        //SFDC-7018 - Auto DDI creation for Government record type for Opp type = Professional services and Dedicated/Private cloud - Aswini - 15/03/2022
        if(opptyRec.RecordType.developerName == 'Government' && (opptyRec.Type =='AWS' || opptyRec.Type =='Azure' || opptyRec.Type =='Google' || opptyRec.Type =='Dedicated/Private Cloud' || opptyRec.Type =='Professional Services')){
            sfOppTypeExteId = 'RGS';
        }
            system.debug('newStr--------'+sfOppTypeExteId);
            gen.writeStringField('externalId', sfOppTypeExteId); 
            //gen.writeStringField('externalId', opptyRec.Type);            
            gen.writeFieldName('metadata');
                gen.writeStartObject();
                gen.writeFieldName('property');
                gen.writeStartArray();
                    gen.writeStartObject();
                        //gen.writeStringField('value', opptyRec.Account__c);
                        gen.writeStringField('value', strAccount);
                        
                        gen.writeStringField('key', 'rackUID');
                    gen.writeEndObject();
                    gen.writeStartObject();
                        gen.writeStringField('value', 'deviceFingerPrint');
                        gen.writeStringField('key', 'deviceFingerPrint');
                    gen.writeEndObject();
                    gen.writeStartObject();
                        gen.writeStringField('value', 'true');
                        gen.writeStringField('key', 'skipCloudWelcomeEmail');
                    gen.writeEndObject();
                    System.debug('Contracting entity'+ opptyRec.Account__r.Contracting_Entity__r.Name);
                    if(opptyRec.Account__r.Contracting_Entity__r.Name!=null && opptyRec.Account__r.Contracting_Entity__r.Name.contains('Onica')){
                        gen.writeStartObject();
                            gen.writeStringField('value', 'ONICA');
                            gen.writeStringField('key', 'Business_Unit');
                        gen.writeEndObject();
                        gen.writeStartObject();
                       // if(opptyRec.AcquisitionId__c!=null){
                            //gen.writeStringField('value', opptyRec.AcquisitionId__c);
                            gen.writeStringField('value', strAquisitionID);
                              gen.writeStringField('key', 'Onica_Legacy_Account_Number');
                          //  }
                          
                        gen.writeEndObject();
                    }
                gen.writeEndArray();
                gen.writeEndObject();
                
            gen.writeStringField('serviceType', serviceType);
            gen.writeStringField('accountName',opptyRec.Account__r.Name);
            gen.writeStringField('description', description );
            gen.writeStringField('type',type);
            if(opptyRec.Account__r.Contracting_Entity__r.Name!=null && (opptyRec.Account__r.Contracting_Entity__r.Name.equals('Rackspace US, Inc') || opptyRec.Account__r.Contracting_Entity__r.Name.equals('CANADA Group LLC'))){
                gen.writeStringField('termsAndConditions','US');
            }else{
                gen.writeStringField('termsAndConditions','INTL');
            }
            gen.writeBooleanField('acceptTermsAndConditions',acceptTermsAndConditions );
            
            
            //gen.writeStringField('promoCode','788');
            /*if(opptyRec.Account__r.Tax_ID_VAT_Number__c != null){
                gen.writeStringField('vatCode',opptyRec.Account__r.Tax_ID_VAT_Number__c);
            }else{
                gen.writeStringField('vatCode','');
            }*/
            gen.writeStringField('vatCode',strAcctTaxIDVATNumber);
            gen.writeStringField('defaultRegion','');
            if(opptyRec.Account__r.ShippingCountry.equals('Japan') || opptyRec.Account__r.ShippingCountry.equals('CANADA ') || opptyRec.Account__r.ShippingCountry.equals('United States')){
                gen.writeStringField('geography','US');
            }else{
                gen.writeStringField('geography','UK');
            }
            gen.writeStringField('serviceLevel',serviceLevel);
            
            gen.writeFieldName('paymentMethod');
                gen.writeStartObject();
                gen.writeFieldName('paymentInfo');
                    gen.writeStartObject();
                    gen.writeStringField('notificationOption',notificationOption);
                    gen.writeStringField('paymentTerms',paymentTerms );
                    gen.writeStringField('paymentType',paymentType);
                    gen.writeEndObject();
                gen.writeEndObject();
            
            gen.writeStringField('businessType',businessType);
            //gen.writeStringField('currencyCode',opptyRec.Account__r.CurrencyIsoCode);
            gen.writeStringField('currencyCode',strAccCurrencyIsoCode);
                    
            gen.writeFieldName('contacts');
            gen.writeStartObject();
                gen.writeFieldName('contact');
                    
                    gen.writeStartArray();
            for(Contact contRec:contList){
                
            strContMailingCountryCode = string.isNotBlank(contRec.MailingCountryCode) ? contRec.MailingCountryCode : '';
            strContEmail = string.isNotBlank(contRec.Email) ? contRec.Email : '';
            strContPhone = string.isNotBlank(contRec.Phone) ? contRec.Phone : '';
            strContMailingState = string.isNotBlank(contRec.MailingState) ? contRec.MailingState : '';
            strContMailingPostalCode = string.isNotBlank(contRec.MailingPostalCode) ? contRec.MailingPostalCode : '';
            strContMailingCity = string.isNotBlank(contRec.MailingCity) ? contRec.MailingCity : '';
            strContMailingStreet = string.isNotBlank(contRec.MailingStreet) ? contRec.MailingStreet : '';
            strContSalutation = string.isNotBlank(contRec.Salutation) ? contRec.Salutation : '';
            strContcontsuffix = string.isNotBlank(contRec.suffix) ? contRec.suffix : '';
            strContLastName = string.isNotBlank(contRec.LastName) ? contRec.LastName : '';
            strContFirstName = string.isNotBlank(contRec.FirstName) ? contRec.FirstName : '';
            
                if(ACRContIdByRoleMap.get(contRec.Id).contains('Primary')){
                    
                    gen.writeStartObject();
                    //gen.writeStringField('firstName', contRec.FirstName);
                    gen.writeStringField('firstName', strContFirstName);
                    //gen.writeStringField('lastName', contRec.LastName);
                    gen.writeStringField('lastName', strContLastName);
                    gen.writeFieldName('addresses');
                        gen.writeStartObject();
                        gen.writeFieldName('address');
                        gen.writeStartArray();
                            gen.writeStartObject();
                            //gen.writeStringField('zipcode',contRec.MailingPostalCode);
                            gen.writeStringField('zipcode',strContMailingPostalCode);
                            //gen.writeStringField('country',contRec.MailingCountryCode );
                            gen.writeStringField('country',strContMailingCountryCode);
                            //gen.writeStringField('city',contRec.MailingCity);
                            gen.writeStringField('city',strContMailingCity);
                            //gen.writeStringField('street',contRec.MailingStreet);
                            gen.writeStringField('street',strContMailingStreet);
                            //gen.writeStringField('state',contRec.MailingState);
                            gen.writeStringField('state',strContMailingState);
                            gen.writeBooleanField('primary',true);
                            //gen.writeStringField('primary','true');
                            gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();
                        
                    gen.writeFieldName('emailAddresses');
                        gen.writeStartObject();
                        gen.writeFieldName('emailAddress');
                        gen.writeStartArray();
                            gen.writeStartObject();
                            gen.writeStringField('address',strContEmail);
                            gen.writeBooleanField('primary',true);
                            //gen.writeStringField('primary','true');
                            gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();
                    
                    gen.writeFieldName('roles');
                        gen.writeStartObject();
                        if(ACRContIdByRoleMap.containsKey(contRec.Id) && ACRContIdByRoleMap.get(contRec.Id).contains('Billing') ){
                            gen.writeFieldName('role');
                            gen.writeStartArray();
                            gen.writeString('PRIMARY');
                            gen.writeString('BILLING');
                            gen.writeEndArray();
                        }else{
                            gen.writeFieldName('role');
                            gen.writeStartArray();
                            gen.writeString('PRIMARY');
                            gen.writeEndArray();
                        }
                            gen.writeEndObject();
                    if(contRec.suffix != null)
                    gen.writeStringField('suffix', contRec.suffix);
                    if(contRec.Salutation != null)
                    gen.writeStringField('title', contRec.Salutation);
                    //if(ACRContIdByRoleMap.get(contRec.Id).contains('Primary')){
                        gen.writeFieldName('user');
                            gen.writeStartObject();
                            //gen.writeStringField('password', 'ToBeDecided');
                            gen.writeStringField('username', strContEmail);
                            gen.writeEndObject();
                    //}
                    gen.writeFieldName('phoneNumbers');
                        gen.writeStartObject();
                        gen.writeFieldName('phoneNumber');
                        gen.writeStartArray();
                            gen.writeStartObject();
                            //gen.writeStringField('country',contRec.MailingCountryCode);
                            gen.writeStringField('country',strContMailingCountryCode);
                            //gen.writeStringField('number',contRec.Phone);
                            gen.writeStringField('number',strContPhone);
                            gen.writeStringField('category','HOME');
                            gen.writeBooleanField('primary',true);
                            //gen.writeStringField('primary','true');
                            gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();                    
                        gen.writeEndObject();
                    //gen.writeEndArray();
                }else if(ACRContIdByRoleMap.get(contRec.Id).contains('Billing')){
                    //gen.writeFieldName('contact');                    
                    //gen.writeStartArray();
                    gen.writeStartObject();
                    //gen.writeStringField('firstName', contRec.FirstName);
                    gen.writeStringField('firstName', strContFirstName);
                    //gen.writeStringField('lastName', contRec.LastName);
                    gen.writeStringField('lastName', strContLastName);
                    gen.writeFieldName('addresses');
                        gen.writeStartObject();
                        gen.writeFieldName('address');
                        gen.writeStartArray();
                            gen.writeStartObject();
                            //gen.writeStringField('primary','false');
                            //gen.writeStringField('zipcode',contRec.MailingPostalCode);
                            gen.writeStringField('zipcode',strContMailingPostalCode);
                            //gen.writeStringField('country',contRec.MailingCountryCode );
                            gen.writeStringField('country',strContMailingCountryCode);
                            //gen.writeStringField('city',contRec.MailingCity);
                            gen.writeStringField('city',strContMailingCity);
                            //gen.writeStringField('street',contRec.MailingStreet);
                            gen.writeStringField('street',strContMailingStreet);
                            //gen.writeStringField('state',contRec.MailingState);
                            gen.writeStringField('state',strContMailingState);
                            gen.writeBooleanField('primary',true);
                            gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();
                        
                        gen.writeFieldName('emailAddresses');
                        gen.writeStartObject();
                        gen.writeFieldName('emailAddress');
                        gen.writeStartArray();
                            gen.writeStartObject();
                            gen.writeStringField('address',strContEmail);
                            gen.writeBooleanField('primary',true);
                            //gen.writeStringField('primary','false');
                            gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();
                    
                    gen.writeFieldName('roles');
                        gen.writeStartObject();
                        if(ACRContIdByRoleMap.containsKey(contRec.Id)){
                           gen.writeFieldName('role');
                            gen.writeStartArray();
                            gen.writeString('BILLING');
                            gen.writeEndArray();
                            }
                            
                        //gen.writeEndArray();
                        gen.writeEndObject();
                    if(contRec.suffix != null)
                    gen.writeStringField('suffix', contRec.suffix);
                    if(contRec.Salutation != null)
                    gen.writeStringField('title', contRec.Salutation);
                    
                    gen.writeFieldName('phoneNumbers');
                        gen.writeStartObject();
                        gen.writeFieldName('phoneNumber');
                        gen.writeStartArray();
                            gen.writeStartObject();
                            //gen.writeStringField('country',contRec.MailingCountryCode );
                            gen.writeStringField('country',strContMailingCountryCode);
                            //gen.writeStringField('number',contRec.Phone);
                            gen.writeStringField('number',strContPhone);
                            gen.writeStringField('category','HOME');
                            gen.writeBooleanField('primary',true);
                            //gen.writeStringField('primary','true');
                            gen.writeEndObject();
                        gen.writeEndArray();
                        gen.writeEndObject();                    
                    gen.writeEndObject();                   
                    
                }
            }
            gen.writeEndArray();
            gen.writeEndObject();
            gen.writeEndObject(); 
            String jsonS = gen.getAsString();                  
            System.debug('jsonMaterials'+jsonS);
            
             Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try{
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('client_id',clientid);
            req.setHeader('client_secret',clientsecret);
            req.setBody(jsonS);
            req.setMethod('POST');
            if(org.IsSandbox){
                req.setEndpoint(sandboxEndPointURL);
            }
            if(!org.IsSandbox){
                 req.setEndpoint(productionEndPointURL);     
            }
           /* if(org.IsSandbox){
                req.setEndpoint('callout:dev_CAC_rackspace_Credentials');
            }
            if(!org.IsSandbox){
                 req.setEndpoint('callout:dev_CAC_rackspace_Credentials');     
            }*/
            req.setTimeout(120000);
            
            
            if(!Test.isRunningTest()){
                res = h.send(req);
            }
             if (res.getStatusCode() == 200) {
           opptyRec.MuleSoft_Acknowledge__c=true;
           opptyRec.Integration_Status_Code__c = '200';
           opptyRec.Is_FutureJob_Running__c = false;
           update opptyRec;
           system.debug('Status Code............200');
           //Samba, SFDC-6218, Added opptyRec.Integration_Status_Code__c = '503'; condition and update opty
           }else if(res.getStatusCode() == 503){
             //res = h.send(req);
             opptyRec.Integration_Status_Code__c = '503';
             opptyRec.Is_FutureJob_Running__c = false;
             update opptyRec;
             system.debug('Status Code............503');
            //CalebG, SFDC-6666, Added opptyRec.Integration_Status_Code__c = '500','400','401'; condition and update opty
            }else if(res.getStatusCode() == 500){
            opptyRec.Integration_Status_Code__c = '500';
            opptyRec.Is_FutureJob_Running__c = false;
            update opptyRec;
            system.debug('Status Code............500');
            }else if(res.getStatusCode() == 400){
            opptyRec.Integration_Status_Code__c = '400';
            opptyRec.Is_FutureJob_Running__c = false;
            update opptyRec;
            system.debug('Status Code............400');
            }else if(res.getStatusCode() == 401){
            opptyRec.Integration_Status_Code__c = '401';
            opptyRec.Is_FutureJob_Running__c = false;
            update opptyRec;
            system.debug('Status Code............401');
            }//SFDC-6666 end
            
            else{
                
                system.debug('res.getStatusCode............'+res.getStatusCode());
            Map<String, Object> responseBody= (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
           string responseBodyMessage = (String)responseBody.get('message');
            ErrorLogHelper.ClogErrorRecord(responseBodyMessage,'CloudOpportunityIntegration');
            }
            
        }catch(Exception ex){
        
           /* if(!Test.isRunningTest()){
                res = h.send(req);
            }*/
             ErrorLogHelper.ClogErrorRecord(ex.getMessage(),'CloudOpportunityIntegration');
        }
        
         system.debug('>>>>>'+res);
            system.debug('>>>>>'+res.getBody());
    }

}