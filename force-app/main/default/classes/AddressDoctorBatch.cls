public class AddressDoctorBatch {
//
public static validator5AddrdocComWebservice5.Response serveBatchMode(List<String> streetStringList, List<String> cityStringList, List<String> stateStringList, List<String> countryStringList, List<String> zipStringList){
  
//public static MainResponse serveBatchMode(List<String> streetStringList, List<String> cityStringList, List<String> stateStringList, List<String> countryStringList, List<String> zipStringList){
    /////////////////////////////////////////////
        // split string to arrays
        Integer i = 0;
        validator5AddrdocComWebservice5.ArrayOfAddress arrAddress = new validator5AddrdocComWebservice5.ArrayOfAddress();
arrAddress.Address = new validator5AddrdocComWebservice5.Address[streetStringList.size()];
    for(;i<streetStringList.size();i++){
        String[] arrStreetString = String.isBlank(streetStringList[i])?null:streetStringList[i].split(' ');
        String[] arrCityString = String.isBlank(cityStringList[i])?null:cityStringList[i].split(' ');
        String[] arrStateString = String.isBlank(stateStringList[i])?null:stateStringList[i].split(' ');
        String[] arrCountryString = String.isBlank(countryStringList[i])?null:countryStringList[i].split(' ');
        String[] arrZipString = String.isBlank(zipStringList[i])?null:zipStringList[i].split(' ');
        
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
        eachAdd.Country = arrOfStringCountry;
        eachAdd.Province = arrOfStringProvince;
        eachAdd.Locality = arrOfStringLocality;
        eachAdd.Street = arrOfStringStreet;
        eachAdd.PostalCode= arrOfStringPostalCode;
        //system.debug(eachAdd);
        //wrap inside
        
        arrAddress.Address[i] = eachAdd;
        //system.debug('$$$$$$$$$$$$$$$$$$$$$'+arrAddress.Address[1]);
    }
    
        ////////////////////////////////////////////////////////////
        
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
        param.ProcessMode = 'BATCH';
        param.ServiceParameters = servParam;
        param.ValidationParameters = validationParameters;
        
        //hit service method
        String userName = AddressDoctor__c.getValues('addrdoc').user_name__c;
        String password = AddressDoctor__c.getValues('addrdoc').password__c;
        validator5AddrdocComWebservice5.AddressValidationSoap addValObj = new validator5AddrdocComWebservice5.AddressValidationSoap();
        validator5AddrdocComWebservice5.Response res = addValObj.Process(userName, password, param, arrAddress, new validator5AddrdocComWebservice5.ArrayOfEnrichment());
        return res;
        //Initialize my list of response
       /* List<AddressRes> lstAddressRes = new List<AddressRes>();
        MainResponse mainRes = new MainResponse();
        System.debug('res @@'+ res);
        //set the basic response code and error if exists
        mainRes.isError = false;
        mainRes.message = 'No results found, Please refine your search parameters';
        if(res != null && res.StatusCode != 100){
            mainRes.isError = true;
            mainRes.message = res.StatusMessage;
        }   
        //main response
        if(res != null && res.Results != null && res.Results.Result != null && res.Results.Result[0].ResultDataSet != null && res.Results.Result[0].ResultDataSet.ResultData != null){
            mainRes.verCode = res.Results.Result[0].ProcessStatus;
            if(!Label.Address_Accepted_Codes.contains(res.Results.Result[0].ProcessStatus)){
            mainRes.isError = true; 
            mainRes.message = 'The search results are not valid addresses, Please provide a valid address to search';
            return mainRes;
            }   
            for(validator5AddrdocComWebservice5.ResultData eachRes: res.Results.Result[0].ResultDataSet.ResultData){
                //System.debug('restillData '+eachRes.Address.AddressComplete);
                System.debug('@@@@@@@@///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
                System.debug('resTillAddress '+eachRes.Address.AddressComplete);
                lstAddressRes.add(new AddressRes(   eachRes.ResultNumber,
                                                    (eachRes.Address.HouseNumber!=null)?String.join(eachRes.Address.HouseNumber.string_x, ' '):' ',
                                                    (eachRes.Address.Building!=null)?String.join(eachRes.Address.Building.string_x, ' '):' ',
                                                    (eachRes.Address.Street!=null)?String.join(eachRes.Address.Street.string_x, ' '):' ',
                                                    (eachRes.Address.Locality!=null)?String.join(eachRes.Address.Locality.string_x, ' '):' ',
                                                    //(eachRes.Address.Province!=null)?String.join(eachRes.Address.Province.string_x, ' '):' ',
                                                    (eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Province != null)?eachRes.Address.AddressDetailed.Province.ProvinceDetailed[0].EXTENDED:' ',
                                                    (eachRes.Address.PostalCode!=null)?String.join(eachRes.Address.PostalCode.string_x, ' '):' ',
                                                    (eachRes.Address.Country!=null)?String.join(eachRes.Address.Country.string_x, ' '):' ',
                                                    (eachRes.Address.AddressDetailed!=null && eachRes.Address.AddressDetailed.Province != null)?eachRes.Address.AddressDetailed.Province.ProvinceDetailed[0].ABBREVIATION:' ',
                                                    null
                                                    ));
            }
        }
            
            system.debug('lstAddressRes####### '+lstAddressRes);
            mainRes.lstAddress = lstAddressRes;
            return mainRes;*/
    }
    public class MainResponse{
         public String verCode;
         public List<AddressRes> lstAddress;
         public String message;
         public boolean isError;
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
}