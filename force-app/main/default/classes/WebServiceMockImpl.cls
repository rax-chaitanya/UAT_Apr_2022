global class WebServiceMockImpl implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            
            //////////******************************///
            validator5AddrdocComWebservice5.Enrichment enRich=new validator5AddrdocComWebservice5.Enrichment();
            enRich.Type_x = '';
            enRich.PayloadXml = '';
            
            validator5AddrdocComWebservice5.ArrayOfProvinceDetailed arrayOfDet =new validator5AddrdocComWebservice5.ArrayOfProvinceDetailed();
            arrayOfDet.ProvinceDetailed = new List<validator5AddrdocComWebservice5.ProvinceDetailed>();
            
            validator5AddrdocComWebservice5.ContactDetailed contDet =new validator5AddrdocComWebservice5.ContactDetailed();
            contDet.Item = 1;
            contDet.COMPLETE = '';
            contDet.FIRST_NAME = '';
            contDet.MIDDLE_NAME = '';
            contDet.LAST_NAME = '';
            contDet.NAME = '';
            contDet.TITLE = '';
            contDet.FUNCTION = '';
            contDet.SALUTATION = '';
            contDet.GENDER = '';
            
            validator5AddrdocComWebservice5.StreetDetailed streetDet =new validator5AddrdocComWebservice5.StreetDetailed();
            streetDet.Item = 1;
            streetDet.COMPLETE_WITH_NUMBER = '';
            streetDet.NAME = '';
            streetDet.PRE_DESCRIPTOR = '';
            streetDet.POST_DESCRIPTOR = '';
            streetDet.PRE_DIRECTIONAL = '';
            streetDet.POST_DIRECTIONAL = '';
            streetDet.ADD_INFO = '';
            
            validator5AddrdocComWebservice5.LocalityDetailed locDet =new validator5AddrdocComWebservice5.LocalityDetailed();
            locDet.Item = 1;
            locDet.COMPLETE = '';
            locDet.NAME = '';
            locDet.PREFERRED_NAME = '';
            locDet.SORTING_CODE = '';
            locDet.ADD_INFO = '';
            
            validator5AddrdocComWebservice5.ArrayOfBuildingDetailed arrayOfBuidDet =new validator5AddrdocComWebservice5.ArrayOfBuildingDetailed();
            arrayOfBuidDet.BuildingDetailed  = new List<validator5AddrdocComWebservice5.BuildingDetailed>();
            
            validator5AddrdocComWebservice5.ArrayOfDeliveryServiceDetailed arrayOfDelSerDet =new validator5AddrdocComWebservice5.ArrayOfDeliveryServiceDetailed();
            arrayOfDelSerDet.DeliveryServiceDetailed  = new List<validator5AddrdocComWebservice5.DeliveryServiceDetailed>();
            
            validator5AddrdocComWebservice5.ArrayOfSubBuildingDetailed arrayOfSubBuildDet =new validator5AddrdocComWebservice5.ArrayOfSubBuildingDetailed();
            arrayOfSubBuildDet.SubBuildingDetailed  = new List<validator5AddrdocComWebservice5.SubBuildingDetailed>();
            
            validator5AddrdocComWebservice5.AddressDetailed addDel =new validator5AddrdocComWebservice5.AddressDetailed();
            addDel.Organization  = new validator5AddrdocComWebservice5.ArrayOfOrganizationDetailed();
            addDel.Contact  = new validator5AddrdocComWebservice5.ArrayOfContactDetailed();
            addDel.Building  = new validator5AddrdocComWebservice5.ArrayOfBuildingDetailed();
            addDel.SubBuilding  = new validator5AddrdocComWebservice5.ArrayOfSubBuildingDetailed();
            addDel.Street  = new validator5AddrdocComWebservice5.ArrayOfStreetDetailed();
            addDel.HouseNumber  = new validator5AddrdocComWebservice5.ArrayOfHouseNumberDetailed();
            addDel.DeliveryService  = new validator5AddrdocComWebservice5.ArrayOfDeliveryServiceDetailed();
            addDel.Locality  = new validator5AddrdocComWebservice5.ArrayOfLocalityDetailed();
            addDel.PostalCode  = new validator5AddrdocComWebservice5.ArrayOfPostalCodeDetailed();
            addDel.Province  = new validator5AddrdocComWebservice5.ArrayOfProvinceDetailed();
            addDel.Country  = new validator5AddrdocComWebservice5.ArrayOfCountryDetailed();
            addDel.Residue  = new validator5AddrdocComWebservice5.ArrayOfResidueDetailed();
            
            validator5AddrdocComWebservice5.CountryDetailed conDet =new validator5AddrdocComWebservice5.CountryDetailed();
            conDet.Item = 1;
            conDet.NAME_EN = '';
            conDet.ABBREVIATION = '';
            conDet.ISO2 = '';
            conDet.ISO3 = '';
            conDet.ISO_NUMBER = '';
            
            validator5AddrdocComWebservice5.AdditionalInformation addInfo =new validator5AddrdocComWebservice5.AdditionalInformation();
            addInfo.Name = '1';
            addInfo.Value = '';
            
            validator5AddrdocComWebservice5.ProvinceDetailed proDel =new validator5AddrdocComWebservice5.ProvinceDetailed();
            proDel.Item = 1;
            proDel.COUNTRY_STANDARD = '';
            proDel.ABBREVIATION = '';
            proDel.EXTENDED = '';
            proDel.ISO = '';
            
            validator5AddrdocComWebservice5.HouseNumberDetailed houseDel =new validator5AddrdocComWebservice5.HouseNumberDetailed();
            houseDel.Item = 1;
            houseDel.COMPLETE = '';
            houseDel.NUMBER_x = '';
            houseDel.DESCRIPTOR = '';
            houseDel.ADD_INFO = '';
            
            validator5AddrdocComWebservice5.DeliveryServiceDetailed deliveryDel =new validator5AddrdocComWebservice5.DeliveryServiceDetailed();
            deliveryDel.Item = 1;
            deliveryDel.COMPLETE = '';
            deliveryDel.DESCRIPTOR = '';
            deliveryDel.NUMBER_x = '';
            deliveryDel.ADD_INFO = '';
            
            
            //************************************///
            //************************************///
            
            validator5AddrdocComWebservice5.ArrayOfResultData rds=new validator5AddrdocComWebservice5.ArrayOfResultData();
            
            validator5AddrdocComWebservice5.ResultData rd=new validator5AddrdocComWebservice5.ResultData();
            rd.ResultNumber='2';
            rd.MailabilityScore='2';
            rd.ResultPercentage='91.00';
            rd.ElementInputStatus='60605060000000000060';
            rd.ElementResultStatus='F0F8E8F08000000000E0';
            rd.ElementRelevance='10111010100000000010';
            rd.ExtElementStatus='00500000000000000000';
            rd.AddressResolutionCode='00020000200000000000';
            rd.AddressType='U';
            rd.LanguageISO3='SPA';
            validator5AddrdocComWebservice5.Address address=new validator5AddrdocComWebservice5.Address();
            validator5AddrdocComWebservice5.ArrayOfString aos=new validator5AddrdocComWebservice5.ArrayOfString();
            aos.string_x=new String[]{'CALLE PATRICIO SANZ'};
                address.Street=aos;
            aos=new validator5AddrdocComWebservice5.ArrayOfString();
            aos.string_x=new String[]{'116'};
                address.HouseNumber=aos;
            aos=new validator5AddrdocComWebservice5.ArrayOfString();
            aos.string_x=new String[]{'CIUDAD DE MÉXICO','COL. DEL VALLE CENTRO'};
                address.Locality=aos;
            rd.Address=address;
            
            
            validator5AddrdocComWebservice5.ResultData rd1=new validator5AddrdocComWebservice5.ResultData();
            rd1.ResultNumber='2';
            rd1.MailabilityScore='2';
            rd1.ResultPercentage='91.00';
            rd1.ElementInputStatus='60605060000000000060';
            rd1.ElementResultStatus='F0F8E8F08000000000E0';
            rd1.ElementRelevance='10111010100000000010';
            rd1.ExtElementStatus='00500000000000000000';
            rd1.AddressResolutionCode='00020000200000000000';
            rd1.AddressType='U';
            rd1.LanguageISO3='SPA';
            address=new validator5AddrdocComWebservice5.Address();
            aos=new validator5AddrdocComWebservice5.ArrayOfString();
            aos.string_x=new String[]{'CALLE PATRICIO SANZ'};
                address.Street=aos;
            aos=new validator5AddrdocComWebservice5.ArrayOfString();
            aos.string_x=new String[]{'116'};
                address.HouseNumber=aos;
            aos=new validator5AddrdocComWebservice5.ArrayOfString();
            aos.string_x=new String[]{'CIUDAD DE MÉXICO','COL. DEL VALLE CENTRO'};
                address.Locality=aos;
            rd1.Address=address;
            rds.ResultData=new validator5AddrdocComWebservice5.ResultData[]{rd,rd1};
                
                
                validator5AddrdocComWebservice5.Result r=new validator5AddrdocComWebservice5.Result();
            r.ResultDataSet=rds;
            r.ProcessStatus='I3';
            r.CountryISO3='MEX';
            
            validator5AddrdocComWebservice5.ArrayOfResult ar= new validator5AddrdocComWebservice5.ArrayOfResult();
            ar.Result=new validator5AddrdocComWebservice5.Result[]{r};
                
                
                validator5AddrdocComWebservice5.ProcessResponse_element res = new validator5AddrdocComWebservice5.ProcessResponse_element();
            res.ProcessResult=new validator5AddrdocComWebservice5.Response();
            res.ProcessResult.StatusMessage='OK';
            res.ProcessResult.StatusCode=100;
            res.ProcessResult.JobToken='9774a023-bef2-4ba0-9da3-448976a56729';
            res.ProcessResult.Results=ar;
            
            response.put('response_x',res);
        }
}