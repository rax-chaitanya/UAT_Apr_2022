public class AddressDoctorComponentController{
    
    @AuraEnabled
    public static List<String> fetchCountryList(){
        List<string> lstCountry = new List<String>();
        Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ple);
        for( Schema.PicklistEntry f : ple){
            lstCountry.add(f.getLabel());
            System.debug(f.getLabel() +'::'+ f.getValue());
        }
        return lstCountry;
    }
    
    @AuraEnabled
    public static List<InitialResponse> serveInitAddress(String objId, String objectName){
        System.debug('objectName --'+objectName);
        List<InitialResponse> response = new List<InitialResponse>();
        Map<String, Address_Doctor_Fields_Config__mdt> mapOfFieldsToAddressType = new Map<String, Address_Doctor_Fields_Config__mdt>();
        List<String> fields = new List<String>();
        if(!String.isBlank(objId) && !String.isBlank(ObjectName)){
            for(Address_Doctor_Fields_Config__mdt mapping : Database.query('Select Address_Type__c, Address_Verified__c, Address_Bypassed__c,City_Api_Name__c,ContactAddressRecursiveHandler_c__c , Country_Api_Name__c, PostalCode_Api_Name__c, State_Api_Name__c, Street_Api_Name__c from Address_Doctor_Fields_Config__mdt where Object_Name__c =: objectName')){
                mapOfFieldsToAddressType.put(mapping.Address_Type__c, mapping);
                if(String.isNotBlank(mapping.City_Api_Name__c)) fields.add(mapping.City_Api_Name__c);
                fields.add(mapping.Country_Api_Name__c);
                fields.add(mapping.PostalCode_Api_Name__c);
                fields.add(mapping.Street_Api_Name__c);
                fields.add(mapping.State_Api_Name__c);
                fields.add(mapping.Address_Verified__c);
                fields.add(mapping.Address_Bypassed__c);
                
            }
            
            /*for(Account acc:[Select BillingPostalCode, BillingState, BillingStreet, BillingCity, BillingCountry from Account where id=:objId]){
response = new AddressRes(null, null, null, acc.BillingStreet, acc.BillingCity, acc.BillingState, acc.BillingPostalCode, acc.BillingCountry, null);
}*/
            
            for(sobject eachRec: (List<sObject>)Database.query('Select '+ String.join(fields , ', ')+' from '+objectName +' where id =: objId')){
                //response = new AddressRes(null, null, null, acc.BillingStreet, acc.BillingCity, acc.BillingState, acc.BillingPostalCode, acc.BillingCountry, null);
                Integer i=0;
                for(String key : mapOfFieldsToAddressType.keySet()){
                    system.debug('Is Address Verified'+eachRec);
                    system.debug('###############'+(String)eachRec.get(mapOfFieldsToAddressType.get(key).State_Api_Name__c));
                    InitialResponse obj = new InitialResponse();
                    obj.index = i++;
                    obj.addresType = key;
                    obj.eachAddress = new AddressRes( null,
                                                     null,
                                                     null,
                                                     (String)eachRec.get(mapOfFieldsToAddressType.get(key).Street_Api_Name__c),
                                                     (String)eachRec.get(mapOfFieldsToAddressType.get(key).City_Api_Name__c),
                                                     (String)eachRec.get(mapOfFieldsToAddressType.get(key).State_Api_Name__c),
                                                     (String)eachRec.get(mapOfFieldsToAddressType.get(key).PostalCode_Api_Name__c),
                                                     (String)eachRec.get(mapOfFieldsToAddressType.get(key).Country_Api_Name__c),
                                                     null,
                                                     (Boolean)eachRec.get(mapOfFieldsToAddressType.get(key).Address_Verified__c)
                                                    );
                    response.add(obj);
                }
            }
            
        }
        
        return response;
    }
    
    @AuraEnabled
    public static MainResponse serveBatchMode(String streetString, String cityString, String stateString, String countryString, String zipString, String mode){
        List<CountryCodeMap__c> CountryList = New List<CountryCodeMap__c>();
        countrylist=[select id,name,country_code__c from CountryCodeMap__c
                     where name like: countryString+'%' and Active__c = true
                    ];
        
        List<validator5AddrdocComWebservice5.Response> listOfResponses = new List<validator5AddrdocComWebservice5.Response>();
        validator5AddrdocComWebservice5.Response res = new validator5AddrdocComWebservice5.Response();
        // split string to arrays
        String[] arrStreetString = String.isBlank(streetString)?null:streetString.split(' ');
        String[] arrCityString = String.isBlank(cityString)?null:cityString.split(' ');
        String[] arrStateString = String.isBlank(stateString)?null:stateString.split(' ');
        String[] arrCountryString = String.isBlank(countryString)?null:countryString.split(' ');
        String[] arrZipString = String.isBlank(zipString)?null:zipString.split(' ');
        
        //prepare arrOfStringCountry
        validator5AddrdocComWebservice5.ArrayOfString arrOfStringCountry = new validator5AddrdocComWebservice5.ArrayOfString();
        arrOfStringCountry.string_x = arrCountryString;
        //prepare arrOfStringProvince
        validator5AddrdocComWebservice5.ArrayOfString arrOfStringProvince = new validator5AddrdocComWebservice5.ArrayOfString();
        arrOfStringProvince.string_x = arrStateString;
        //prepare arrOfStringLocality
        validator5AddrdocComWebservice5.ArrayOfString arrOfStringLocality = new validator5AddrdocComWebservice5.ArrayOfString();
        arrOfStringLocality.string_x = arrCityString;
        // prepare arrOfStringPostalCode
        validator5AddrdocComWebservice5.ArrayOfString arrOfStringPostalCode = new validator5AddrdocComWebservice5.ArrayOfString();
        arrOfStringPostalCode.string_x = arrZipString;
        //prepare arrOfStringStreet
        validator5AddrdocComWebservice5.ArrayOfString arrOfStringStreet = new validator5AddrdocComWebservice5.ArrayOfString();
        arrOfStringStreet.string_x = arrStreetString;
        
        //prepare each address
        validator5AddrdocComWebservice5.Address eachAdd = new validator5AddrdocComWebservice5.Address();
        if(countrylist.size() == 0){
            eachAdd.Country = arrOfStringCountry;
        }
        eachAdd.Province = arrOfStringProvince;
        eachAdd.Locality = arrOfStringLocality;
        eachAdd.Street = arrOfStringStreet;
        eachAdd.PostalCode= arrOfStringPostalCode;
        
        
        //wrap inside
        validator5AddrdocComWebservice5.ArrayOfAddress arrAddress = new validator5AddrdocComWebservice5.ArrayOfAddress();
        arrAddress.Address = new validator5AddrdocComWebservice5.Address[1];
        arrAddress.Address[0] = eachAdd;
        
        //prepare service parameter
        validator5AddrdocComWebservice5.ServiceParameters servParam = new validator5AddrdocComWebservice5.ServiceParameters();
        servParam.UseTransactionPool = AddressDoctor__c.getValues('addrdoc').UseTransactionPool__c;
        
        //prepare outputOptions
        validator5AddrdocComWebservice5.AddressOptions outputOptions = new validator5AddrdocComWebservice5.AddressOptions();
        outputOptions.AddressDetailed = 'ON';
        
        
        //Set Standardizations for locality to restrict it to 40 characters
        validator5AddrdocComWebservice5.Standardize standardizeLocality = new validator5AddrdocComWebservice5.Standardize();
        standardizeLocality.Element = 'Locality';
        standardizeLocality.Casing = 'UPPER';
        standardizeLocality.MaxLength = 40;
        standardizeLocality.MaxItemCount = 1;
        
        //Set Standardizations for province
        validator5AddrdocComWebservice5.Standardize standardizeProvince = new validator5AddrdocComWebservice5.Standardize();
        standardizeProvince.Element = 'Province';
        standardizeProvince.Casing = 'UPPER';
        standardizeProvince.MaxLength = 40;
        standardizeProvince.MaxItemCount = 1;
        
        //prepare address params
        validator5AddrdocComWebservice5.ValidationParameters validationParameters = new validator5AddrdocComWebservice5.ValidationParameters();
        validationParameters.MaxResultCount = (Integer)AddressDoctor__c.getValues('addrdoc').MaxResultCount__c;
        validationParameters.StreetWithNumber = AddressDoctor__c.getValues('addrdoc').StreetWithNumber__c;
        validationParameters.FormatWithCountry = AddressDoctor__c.getValues('addrdoc').FormatWithCountry__c;
        validationParameters.ElementAbbreviation = AddressDoctor__c.getValues('addrdoc').ElementAbbreviation__c;
        validationParameters.StandardizeInvalidAddresses = AddressDoctor__c.getValues('addrdoc').StandardizeInvalidAddresses__c;
        validationParameters.MatchingExtendedArchive = AddressDoctor__c.getValues('addrdoc').MatchingExtendedArchive__c;
        validationParameters.FlexibleRangeExpansion = AddressDoctor__c.getValues('addrdoc').FlexibleRangeExpansion__c;
        validationParameters.GlobalMaxLength = (Integer)AddressDoctor__c.getValues('addrdoc').GlobalMaxLength__c;
        validationParameters.FormatMaxLines = (Integer)AddressDoctor__c.getValues('addrdoc').FormatMaxLines__c;
        validationParameters.GlobalCasing = AddressDoctor__c.getValues('addrdoc').GlobalCasing__c;
        //validationParameters.FormatAddressComplete = 'SINGLE_LINE';
        validationParameters.RangesToExpand = 'ALL';
        //add standarizations for locality
        validationParameters.Standardizations = new validator5AddrdocComWebservice5.Standardize[2];
        validationParameters.Standardizations[0] = standardizeLocality;
        validationParameters.Standardizations[1] = standardizeProvince;
        validationParameters.OutputOptions = outputOptions;
        
        //prepare params
        validator5AddrdocComWebservice5.Parameters param = new validator5AddrdocComWebservice5.Parameters();
        param.ProcessMode = mode;
        param.ServiceParameters = servParam;
        param.ValidationParameters = validationParameters;
        
        //hit service method
        String userName = AddressDoctor__c.getValues('addrdoc').user_name__c;
        String password = AddressDoctor__c.getValues('addrdoc').password__c;
        validator5AddrdocComWebservice5.AddressValidationSoap addValObj = new validator5AddrdocComWebservice5.AddressValidationSoap();
        
        if(countrylist.size() != 0){
            for(CountryCodeMap__c ccm : countrylist){
                
                param.ValidationParameters.ForceCountryISO3 = ccm.Country_Code__c;
                res = addValObj.Process(userName, password, param, arrAddress, new validator5AddrdocComWebservice5.ArrayOfEnrichment());
                listOfResponses.add(res);
            }
        }else{
            res = addValObj.Process(userName, password, param, arrAddress, new validator5AddrdocComWebservice5.ArrayOfEnrichment());
        }
        
        //Initialize my list of response
        List<AddressRes> lstAddressRes = new List<AddressRes>();
        MainResponse mainRes = new MainResponse();
        System.debug('res @@'+ res.StatusMessage);
        //set the basic response code and error if exists
        mainRes.isError = false;
        mainRes.message = 'No results found, Please refine your search parameters';
        if(res != null && res.StatusCode != 100){
            mainRes.isError = true;
            mainRes.message = res.StatusMessage;
        }
        //main response
        if(listOfResponses.size()>0){
            for(validator5AddrdocComWebservice5.Response resp : listOfResponses){
                if(resp != null && resp.Results != null && resp.Results.Result != null && resp.Results.Result[0].ResultDataSet != null && resp.Results.Result[0].ResultDataSet.ResultData != null){
                    mainRes.verCode = resp.Results.Result[0].ProcessStatus;
                    if(!Label.Address_Accepted_Codes.contains(resp.Results.Result[0].ProcessStatus)){
                        /*mainRes.isError = true;
mainRes.message = 'The search results are not valid addresses, Please provide a valid address to search';
return mainRes;*/
                        lstAddressRes.add(new AddressRes( 'bypassed',
                                                         ' ',
                                                         ' ',
                                                         streetString,
                                                         cityString,
                                                         stateString,
                                                         zipString,
                                                         countryString,
                                                         ' ',
                                                         null
                                                        ));
                        
                    }else{
                        for(validator5AddrdocComWebservice5.ResultData eachRes: res.Results.Result[0].ResultDataSet.ResultData){
                            //System.debug('restillData '+eachRes.Address.AddressComplete);
                            System.debug('@@@@@@@@///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
                            System.debug('resTillAddress '+eachRes.Address.AddressComplete);
                            lstAddressRes.add(new AddressRes( eachRes.ResultNumber,
                                                             (eachRes.Address.HouseNumber!=null)?String.join(eachRes.Address.HouseNumber.string_x, ' '):' ',
                                                             (eachRes.Address.Building!=null)?String.join(eachRes.Address.Building.string_x, ' '):' ',
                                                             (eachRes.Address.Street!=null)?String.join(eachRes.Address.Street.string_x, ' '):' ',
                                                             (eachRes.Address.Locality!=null)?String.join(eachRes.Address.Locality.string_x, ' '):' ',
                                                             (eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Province != null)?eachRes.Address.AddressDetailed.Province.ProvinceDetailed[0].EXTENDED:' ',
                                                             (eachRes.Address.PostalCode!=null)?String.join(eachRes.Address.PostalCode.string_x, ' '):' ',
                                                             //(eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Country != null)?eachRes.Address.AddressDetailed.Country.CountryDetailed[0].ISO2:' ',
                                                             (eachRes.Address.Country!=null)?String.join(eachRes.Address.Country.string_x, ' '):' ',
                                                             (eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Province != null)?eachRes.Address.AddressDetailed.Province.ProvinceDetailed[0].ABBREVIATION:' ',
                                                             null
                                                            ));
                        }
                    }
                }
            }
        }else{
            if(res != null && res.Results != null && res.Results.Result != null && res.Results.Result[0].ResultDataSet != null && res.Results.Result[0].ResultDataSet.ResultData != null){
                mainRes.verCode = res.Results.Result[0].ProcessStatus;
                if(!Label.Address_Accepted_Codes.contains(res.Results.Result[0].ProcessStatus)){
                    /*mainRes.isError = true;
mainRes.message = 'The search results are not valid addresses, Please provide a valid address to search';
return mainRes;*/
                    lstAddressRes.add(new AddressRes( 'bypassed',
                                                     ' ',
                                                     ' ',
                                                     streetString,
                                                     cityString,
                                                     stateString,
                                                     zipString,
                                                     countryString,
                                                     ' ',
                                                     null
                                                    ));
                    
                }else{
                    for(validator5AddrdocComWebservice5.ResultData eachRes: res.Results.Result[0].ResultDataSet.ResultData){
                        //System.debug('restillData '+eachRes.Address.AddressComplete);
                        System.debug('@@@@@@@@///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
                        System.debug('resTillAddress '+eachRes.Address.AddressComplete);
                        lstAddressRes.add(new AddressRes( eachRes.ResultNumber,
                                                         (eachRes.Address.HouseNumber!=null)?String.join(eachRes.Address.HouseNumber.string_x, ' '):' ',
                                                         (eachRes.Address.Building!=null)?String.join(eachRes.Address.Building.string_x, ' '):' ',
                                                         (eachRes.Address.Street!=null)?String.join(eachRes.Address.Street.string_x, ' '):' ',
                                                         (eachRes.Address.Locality!=null)?String.join(eachRes.Address.Locality.string_x, ' ').SubStringBefore(','):' ',
                                                         (eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Province != null)?eachRes.Address.AddressDetailed.Province.ProvinceDetailed[0].EXTENDED.SubStringBefore(','):' ',
                                                         (eachRes.Address.PostalCode!=null)?String.join(eachRes.Address.PostalCode.string_x, ' '):' ',
                                                         //(eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Country != null)?eachRes.Address.AddressDetailed.Country.CountryDetailed[0].ISO2:' ',
                                                         (eachRes.Address.Country!=null)?String.join(eachRes.Address.Country.string_x, ' '):' ',
                                                         (eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Province != null)?eachRes.Address.AddressDetailed.Province.ProvinceDetailed[0].ABBREVIATION:' ',
                                                         null
                                                        ));
                    }
                }
            }
        }
        
        system.debug('lstAddressRes####### '+lstAddressRes);
        mainRes.lstAddress = lstAddressRes;
        system.debug('Main Address returned'+mainRes);
        return mainRes;
    }
    
    @AuraEnabled
    public static SaveResponse saveRecord(string addressObj, Id recordId, String[] addresses, String objectName, String type){
        
        // query current user information
        system.debug('addresses-->'+addresses);
        system.debug('addressObj-->'+addressObj);
        system.debug('recordId-->'+recordId);
        AddressRes addressRes = (AddressRes)JSON.deserialize(addressObj, AddressRes.class);
        system.debug('addressRes-->'+addressRes.resultNumber);
        
        SaveResponse saveResponse = new SaveResponse();
        sObject acc;
        String isoCodeApi;
        String stateField;
        Boolean isBypassed;
        if(addressRes.resultNumber=='bypassed'){
            isBypassed = true;
        }else{
            isBypassed = false;
        }
        List<Address_Doctor_Fields_Config__mdt> configFields;
        try{
            if(recordId != null && String.isNotBlank(objectName) && String.isNotBlank(type)){
                acc = Schema.getGlobalDescribe().get(objectName).newSObject();
                acc.put('id', recordId);
                
                // query the metadata
                configFields = Database.query('Select Address_Verified__c, Address_Bypassed__c,StateCode_Api_Name__c,Object_Name__c, Address_Type__c, City_Api_Name__c, Country_Api_Name__c,ContactAddressRecursiveHandler_c__c, PostalCode_Api_Name__c, State_Api_Name__c, Street_Api_Name__c from Address_Doctor_Fields_Config__mdt where Object_Name__c =: objectName and Address_Type__c =: type');
                for(Address_Doctor_Fields_Config__mdt mapping : configFields){
                    //mapOfFieldsToAddressType.put(mapping.Address_Type__c, mapping);
                    acc.put(mapping.City_Api_Name__c, addressRes.city);
                    acc.put(mapping.Country_Api_Name__c, addressRes.country);
                    acc.put(mapping.PostalCode_Api_Name__c, addressRes.zip);
                    acc.put(mapping.Street_Api_Name__c, (addressRes.houseNo + addressRes.building + addressRes.street));
                    //acc.put(mapping.StateCode_Api_Name__c, addressRes.provinceISO);
                    isoCodeApi = mapping.StateCode_Api_Name__c;
                    stateField = mapping.State_Api_Name__c;
                    System.debug('addressRes.province.split() '+addressRes.province.split(',')[0]);
                    acc.put(mapping.State_Api_Name__c,addressRes.province.split(',')[0]); 
                    //acc.put(mapping.State_Api_Name__c, (mapping.Object_Name__c =='Account' || mapping.Object_Name__c == 'Contact') ? getStateValue(addressRes.province.split(',')[0]):addressRes.province.split(',')[0]);
                    acc.put(mapping.Address_Verified__c, addressRes.ifVerified);
                    acc.put(mapping.ContactAddressRecursiveHandler_c__c,addressRes.ContactAddressRecursiveHandler );
                    acc.put(mapping.Address_Bypassed__c, isBypassed);
                    
                }
                
                system.debug('acc-->'+acc);
                Database.SaveResult rsAttempt1 = Database.update(acc);
                if(rsAttempt1.isSuccess()){
                    saveResponse.message = 'Address Save Successfully';
                    saveResponse.isError = false;
                    saveResponse.updatedAddress = populateAddressRes(configFields, acc);
                }
            }
        }catch(System.DmlException dmlE){
            system.debug(dmlE);
            saveResponse.isError = true;
            saveResponse.message = dmlE.getDmlMessage(0);
            if(dmlE.getDmlStatusCode(0) != 'STRING_TOO_LONG'){
                acc.put(isoCodeApi, addressRes.provinceISO);
                acc.put(stateField, '');
                System.debug('acc '+acc);
                Database.SaveResult rsAttemp2 = Database.update(acc);
                if(rsAttemp2.isSuccess()){
                    saveResponse.message = 'Address Save Successfully';
                    saveResponse.isError = false;
                    saveResponse.updatedAddress = populateAddressRes(configFields, acc);
                }
            }
        }catch(Exception e){
            System.debug(e);
            saveResponse.message = e.getDmlMessage(0);
            saveResponse.isError = true;
        }finally{
            System.debug('return anyway'+saveResponse);
            return saveResponse;
        }
        return saveResponse;
    }
    
    static AddressRes populateAddressRes(List<Address_Doctor_Fields_Config__mdt> configFields, sObject acc){
        AddressRes addressRes;
        for(Address_Doctor_Fields_Config__mdt mapping : configFields){
            addressRes = new AddressRes(
                null,
                null,
                null,
                (String)acc.get(mapping.Street_Api_Name__c),
                (String)acc.get(mapping.City_Api_Name__c),
                (String)acc.get(mapping.State_Api_Name__c),
                (String)acc.get(mapping.PostalCode_Api_Name__c),
                (String)acc.get(mapping.Country_Api_Name__c),
                null,
                (Boolean)acc.get(mapping.Address_Verified__c)
            );
        }
        return addressRes;
    }
    
    public class AddressRes{
        @AuraEnabled public String resultNumber;
        @AuraEnabled public String houseNo;
        @AuraEnabled public String building;
        @AuraEnabled public String street;
        @AuraEnabled public String city;
        @AuraEnabled public String province;
        @AuraEnabled public String zip;
        @AuraEnabled public String country;
        @AuraEnabled public String provinceISO;
        @AuraEnabled public Boolean ifVerified;
        @AuraEnabled public Boolean ContactAddressRecursiveHandler =True;
        AddressRes(String resultNumber, String houseNo, String building, String street, String city, String province, String zip, String country, String provinceISO, Boolean ifVerified){
            this.resultNumber = resultNumber;
            this.houseNo = houseNo;
            this.building = building;
            this.street = street;
            this.city = city;
            this.province = province;
            this.zip = zip;
            this.country = country;
            this.provinceISO = provinceISO;
            this.ifVerified = ifVerified;
        }
    }
    
    public class MainResponse{
        @AuraEnabled public String verCode;
        @AuraEnabled public List<AddressRes> lstAddress;
        @AuraEnabled public String message;
        @AuraEnabled public boolean isError;
    }
    
    public class InitialResponse{
        @AuraEnabled public Integer index;
        @AuraEnabled public String addresType;
        @AuraEnabled public AddressRes eachAddress;
    }
    
    public class SaveResponse{
        @AuraEnabled public String message;
        @AuraEnabled public boolean isError;
        @AuraEnabled public AddressRes updatedAddress;
    }
    //This method return the exact state picklist value which has used in salesforce address compound field to avoid the case sensitive issue.
    /*public static String getStateValue(String StateLabel){
        
        String State_Value='';
        Schema.DescribeFieldResult fieldResult = User.statecode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){  
            if(f.getLabel().containsIgnoreCase(StateLabel)){       
                State_Value=f.getLabel();
            }
            
        }
        return State_Value;
    }*/
}