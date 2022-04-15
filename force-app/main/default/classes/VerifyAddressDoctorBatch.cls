/////////////////////////////////////////////////////////
//(Address Doctor) - SFDC-3401
//Bulk address validation on: Company, Contact, Account and ACR.
//
//
//
//////////////////////////////////////////////////////////
global class VerifyAddressDoctorBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    
    global final List<String> objectList = new List<String>{'Contact', 'Account','Accounts__c','Account_Contact_Role__c'};
        //  global final List<String> objectList = new List<String>{'Account'};   
        global final Integer index;
    global final String query;
    
    
    global VerifyAddressDoctorBatch(){
        index = 0;
        query = getQuery();
    }
    global VerifyAddressDoctorBatch(Integer i){
        index = i;
        query = getQuery();
    }
    
    private String getQuery(){
        if(objectList.size()>index){
            
            if(objectList[index] == 'Contact'){
                return  'SELECT Id, Name,BatchVerified__c,Batch_Status__c,MailingCountry,MailingStreet,MailingState,MailingPostalCode,MailingCity,'+
                    'Mailing_Address_Verified__c FROM Contact where MailingCity != null and MailingCountry !=null '+
                    'and MailingStreet != null and MailingState != null and MailingPostalCode != null and '+
                    'Mailing_Address_Verified__c != true and BatchVerified__c = false ';
                
            }
            if(objectList[index] == 'Account'){
                //system.debug('Account Entry****');
                return 'SELECT Id, Name,Batch_Status__c,Batch_Billing_Verified__c,BillingCountry,BillingStreet,BillingState,BillingPostalCode,BillingCity,'+
                    'Billing_Address_Verified__c,Batch_Shipping_Verified__c,ShippingCountry,ShippingStreet,ShippingState,ShippingPostalCode,ShippingCity,'+
                    'Shipping_Address_Verified__c FROM Account where ((BillingCity != null and BillingCountry !=null '+
                    'and BillingStreet != null and BillingState != null and BillingPostalCode != null and '+
                    'Billing_Address_Verified__c != true and Batch_Billing_Verified__c = false) or (ShippingCity != null and ShippingCountry !=null '+
                    'and ShippingStreet != null and ShippingState != null and ShippingPostalCode != null and '+
                    'Shipping_Address_Verified__c != true and Batch_Shipping_Verified__c  = false))';
                
                
                
            }
            if(objectList[index] == 'Accounts__c'){
                return 'SELECT Id, Name,Batch_Verified__c,Batch_Status__c,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Country__c,'+
                    'Billing_Zip_Postal_Code__c ,Billing_Address_Verified__c FROM Accounts__c where Billing_City__c != null and '+
                    'Billing_State_Province__c !=null and Billing_Street__c != null and Billing_Country__c != null and Billing_Zip_Postal_Code__c != null and '+
                    'Billing_Address_Verified__c != true and Batch_Verified__c = false ';
            }
            if(objectList[index] == 'Account_Contact_Role__c'){
                return 'SELECT ID,Name,Batch_Verified__c,Batch_Status__c,Mailing_Country__c,Mailing_State__c,Mailing_City__c,Mailing_Street__c,'+
                    'Mailing_Postal_Code__c ,Mailing_Address_Verified__c FROM Account_Contact_Role__c where Mailing_City__c != null and '+
                    'Mailing_Country__c !=null and Mailing_Street__c != null and Mailing_State__c != null and Mailing_Postal_Code__c != null and '+
                    'Mailing_Address_Verified__c != true and Batch_Verified__c = false' ;
            }
        }
        return null;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        //System.debug('objectList '+objectList[index]+' : '+scope.size());
        for (sObject s:scope){
            //system.debug('####### Request ids' + s.get('ID'));
        }
        
        List<Contact> contoupdate = new List<Contact>();
        List<Accounts__c> prodacctoupdate = new List<Accounts__c>();
        List<Account> acctoupdate = new List<Account>();
        List<Account_Contact_Role__c> acrtoupdate = new List<Account_Contact_Role__c>();
        List<String> streetList = new List<String>();
        List<String> countryList = new List<String>();
        List<String> cityList = new List<String>();
        List<String> provinceList = new List<String>();
        List<String> zipList = new List<String>();
        List<ErrorLog__c> errorslist=new  List<ErrorLog__c>();
        
        ///////////////////////////////////////////////////////
        if(objectList[index] == 'Contact'){
            AddressDoctorBatch.MainResponse mainres =new AddressDoctorBatch.MainResponse();
            
            List<Contact> conlist = (List<Contact>)scope;
            //String listType = 'List<Contact>';
            for(Contact con : conlist){
                streetList.add(Con.MailingStreet);
                cityList.add(Con.MailingCity);
                provinceList.add(Con.MailingState);
                countryList.add(Con.MailingCountry);
                zipList.add(Con.MailingPostalCode);
                
            }
            validator5AddrdocComWebservice5.Response res = AddressDoctorBatch.serveBatchMode(streetList, cityList,provinceList,  countryList, zipList);
            
            //  if(!mainres.isError && mainres.lstAddress.size()>0){
            // if(res!=null){
            // if(mainres.lstAddress.size() == 1){
            
            //system.debug('###Contact Response###'+res);   
            for(Contact con : conlist){
                con.BatchVerified__c = true;
                Integer i=0; 
                if(res != null && res.results !=null && res.results.result != null){
                    for(;i<res.results.result.size();i++){
                        con.Batch_Status__c = res.results.result[i].ProcessStatus;
                        
                        // system.debug('###Contact Processstatus###'+res.results.result[i].Processstatus);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%'+res.results.result[i].resultdataset);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%% '+Con.MailingStreet+' %%% '+Con.MailingCity+' %%%% '+Con.MailingCountry+' %%%%% '+Con.MailingPostalCode);
                        
                        if((res.results.result[i].ProcessStatus=='V4'|| res.results.result[i].ProcessStatus=='V3' ||res.results.result[i].ProcessStatus=='V2'||res.results.result[i].ProcessStatus=='C4'|| res.results.result[i].ProcessStatus=='C3' ||res.results.result[i].ProcessStatus=='C2')&&
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.MailingStreet) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.MailingCity) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.MailingCountry) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.MailingPostalCode)){
                               //system.debug('$$$$$$$$$$$$$$ Contact ids'+con.id);
                               
                               con.Mailing_Address_Verified__c = true;
                               
                           }
                    }
                }
                
                contoupdate.add(con);
            }
        }
        //////////////////////////////////////////////////
        // 
        if(objectList[index] == 'Accounts__c'){
            AddressDoctorBatch.MainResponse mainres =new AddressDoctorBatch.MainResponse();
            
            List<Accounts__c> paclist = (List<Accounts__c>)scope;
            //system.debug('$$$$$$$$$$$$$$'+paclist.size());
            //String listType = 'List<Accounts__c>';
            for(Accounts__c con : paclist){
                streetList.add(Con.Billing_Street__c);
                cityList.add(Con.Billing_City__c);
                provinceList.add(Con.Billing_State_Province__c);
                countryList.add(Con.Billing_Country__c);
                zipList.add(Con.Billing_Zip_Postal_Code__c);
                
            }            
            validator5AddrdocComWebservice5.Response res = AddressDoctorBatch.serveBatchMode(streetList, cityList,provinceList,  countryList, zipList);
            
            //  if(!mainres.isError && mainres.lstAddress.size()>0){
            // if(res!=null){
            // if(mainres.lstAddress.size() == 1){
            
            //system.debug('###Accounts__c Response###'+res);      
            for(Accounts__c con : paclist){
                con.Batch_Verified__c = true;
                Integer i=0;
                if(res != null && res.Results != null && res.Results.Result != null && res.Results.Result[0].ResultDataSet != null && res.Results.Result[0].ResultDataSet.ResultData != null){
                    for(;i<res.results.result.size();i++){                    
                        con.Batch_Status__c = res.results.result[i].ProcessStatus;
                        //system.debug('###Accounts__c Processstatus### '+res.results.result[i].Processstatus);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%'+res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%% '+Con.Billing_Street__c+' %%% '+Con.Billing_City__c+' %%%% '+Con.Billing_Country__c+' %%%%% '+Con.Billing_Zip_Postal_Code__c);
                        
                        if((res.results.result[i].ProcessStatus=='V4' ||res.results.result[i].ProcessStatus=='V3' ||res.results.result[i].ProcessStatus=='V2' || res.results.result[i].ProcessStatus=='C4' ||res.results.result[i].ProcessStatus=='C3' ||res.results.result[i].ProcessStatus=='C2')&&
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Billing_Street__c) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Billing_City__c) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Billing_Country__c) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Billing_Zip_Postal_Code__c)){
                               // system.debug('$$$$$$$$$$$$$$ Accounts__c ids'+con.id);
                               con.Billing_Address_Verified__c = true;
                           }
                    }
                }
                
                prodacctoupdate.add(con);
            }
        }
        
        ///////////////////////////////////////////////////////////////////
        if(objectList[index] == 'Account_Contact_Role__c'){
            AddressDoctorBatch.MainResponse mainres =new AddressDoctorBatch.MainResponse();
            
            List<Account_Contact_Role__c> acrlist = (List<Account_Contact_Role__c>)scope;
            //String listType = 'List<Account_Contact_Role__c>';
            for(Account_Contact_Role__c con : acrlist){
                streetList.add(Con.Mailing_Street__c);
                cityList.add(Con.Mailing_City__c);
                provinceList.add(Con.Mailing_State__c);
                countryList.add(Con.Mailing_Country__c);
                zipList.add(Con.Mailing_Postal_Code__c);
                
            }
            
            validator5AddrdocComWebservice5.Response res = AddressDoctorBatch.serveBatchMode(streetList, cityList,provinceList,  countryList, zipList);
            
            //  if(!mainres.isError && mainres.lstAddress.size()>0){
            // if(res!=null){
            // if(mainres.lstAddress.size() == 1){
            
            //system.debug('###Account_Contact_Role__c  Response###'+res);       
            for(Account_Contact_Role__c con : acrlist){
                con.Batch_Verified__c = true;
                Integer i=0;
                if(res != null && res.results !=null && res.results.result != null){
                    for(;i<res.results.result.size();i++){
                        con.Batch_Status__c = res.results.result[i].ProcessStatus; 
                        //system.debug('###Account_Contact_Role__c  Processstatus###'+res.results.result[i].Processstatus);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%'+res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%% '+Con.Mailing_Street__c+' %%% '+Con.Mailing_City__c+' %%%% '+Con.Mailing_Country__c+' %%%%% '+Con.Mailing_Postal_Code__c);
                        
                        if((res.results.result[i].ProcessStatus=='V4' ||res.results.result[i].ProcessStatus=='V3' ||res.results.result[i].ProcessStatus=='V2' || res.results.result[i].ProcessStatus=='C4' ||res.results.result[i].ProcessStatus=='C3' ||res.results.result[i].ProcessStatus=='C2')&&
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Mailing_Street__c) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Mailing_City__c) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Mailing_Country__c) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.Mailing_Postal_Code__c)){
                               //system.debug('$$$$$$$$$$$$$$ Account_Contact_Role__c ids'+con.id);
                               con.Mailing_Address_Verified__c = true;
                               
                           }
                    }
                }
                acrtoupdate.add(con);
                
            }
            
        }
        //////////////////Company Billing Address///////////////////
        if(objectList[index] == 'Account'){
            AddressDoctorBatch.MainResponse mainres =new AddressDoctorBatch.MainResponse();
            List<Account> acclist = (List<Account>)scope;
            
            for(Account con : acclist){
               // if(con.BillingCity != null && con.BillingCountry !=null && con.BillingStreet != null && con.BillingState != null && con.BillingPostalCode != null){
                 if(!String.isBlank(con.BillingCity) && !String.isBlank(con.BillingCountry) && !String.isBlank(con.BillingStreet) && !String.isBlank(con.BillingState) && !String.isBlank(con.BillingPostalCode)){
                    streetList.add(Con.BillingStreet);
                    cityList.add(Con.BillingCity);
                    provinceList.add(Con.BillingState);
                    countryList.add(Con.BillingCountry);
                    zipList.add(Con.BillingPostalCode);
                }
            }
            
            validator5AddrdocComWebservice5.Response res = AddressDoctorBatch.serveBatchMode(streetList, cityList,provinceList,  countryList, zipList);
            
            
            //system.debug('###Accounts Response###'+res);      
            for(Account con : acclist){
                con.Batch_Billing_Verified__c = true;
                Integer i=0;
                if(res != null && res.results !=null && res.results.result != null ){
                    if(!String.isBlank(con.BillingCity) && !String.isBlank(con.BillingCountry) && !String.isBlank(con.BillingStreet) && !String.isBlank(con.BillingState) && !String.isBlank(con.BillingPostalCode)){
                    for(;i<res.results.result.size();i++){
                        con.Batch_Status__c = res.results.result[i].ProcessStatus; 
                        //system.debug('###Accounts Response###'+res.results.result[i].Processstatus);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%'+res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%% '+Con.BillingStreet+' %%% '+Con.BillingCity+' %%%% '+Con.BillingCountry+' %%%%% '+Con.BillingPostalCode);
                        
                        if((res.results.result[i].ProcessStatus=='V4' ||res.results.result[i].ProcessStatus=='V3' ||res.results.result[i].ProcessStatus=='V2' || res.results.result[i].ProcessStatus=='C4' ||res.results.result[i].ProcessStatus=='C3' ||res.results.result[i].ProcessStatus=='C2')&&
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.BillingStreet) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.BillingCity) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.BillingCountry) && 
                           res.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.BillingPostalCode)){
                               // system.debug('$$$$$$$$$$$$$$ Account ids'+con.id);
                               con.Billing_Address_Verified__c = true;
                               
                           }
                    }
                    }
                }
                acctoupdate.add(con);
            }                       
            ///////////////////////////Company Shipping Address////////////////////////////////
            for(Account con : acclist){
                //if(con.ShippingCity != null && con.ShippingCountry !=null && con.ShippingStreet != null && con.ShippingState != null && con.ShippingPostalCode != null){
                if(!String.isBlank(con.ShippingCity) && !String.isBlank(con.ShippingCountry) && !String.isBlank(con.ShippingStreet) && !String.isBlank(con.ShippingState) && !String.isBlank(con.ShippingPostalCode)){
                    streetList.add(Con.ShippingStreet);
                    cityList.add(Con.ShippingCity);
                    provinceList.add(Con.ShippingState);
                    countryList.add(Con.ShippingCountry);
                    zipList.add(Con.ShippingPostalCode);
                }
            }
            
            validator5AddrdocComWebservice5.Response res2 = AddressDoctorBatch.serveBatchMode(streetList, cityList,provinceList,  countryList, zipList);
            
            //  if(!mainres.isError && mainres.lstAddress.size()>0){
            // if(res!=null){
            // if(mainres.lstAddress.size() == 1){
            
            for(Account con : acclist){
                con.Batch_Shipping_Verified__c = true;
                Integer i=0;
                if(res2 != null && res2.results !=null && res2.results.result != null){
                    if(!String.isBlank(con.ShippingCity) && !String.isBlank(con.ShippingCountry) && !String.isBlank(con.ShippingStreet) && !String.isBlank(con.ShippingState) && !String.isBlank(con.ShippingPostalCode)){
                    for(;i<res2.results.result.size();i++){
                        con.Batch_Status__c = res2.results.result[i].ProcessStatus;
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%'+res2.results.result[i].Processstatus);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%'+res2.results.result[i].resultdataset.resultdata[0].Address.AddressComplete);
                        //system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%% '+Con.ShippingStreet+' %%% '+Con.ShippingCity+' %%%% '+Con.ShippingCountry+' %%%%% '+Con.ShippingPostalCode);
                        
                        if((res2.results.result[i].ProcessStatus=='V4' ||res2.results.result[i].ProcessStatus=='V3' ||res2.results.result[i].ProcessStatus=='V2' || res2.results.result[i].ProcessStatus=='C4' ||res2.results.result[i].ProcessStatus=='C3' ||res2.results.result[i].ProcessStatus=='C2')&&
                           
                           res2.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.ShippingStreet) && 
                           res2.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.ShippingCity) && 
                           res2.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.ShippingCountry) && 
                           res2.results.result[i].resultdataset.resultdata[0].Address.AddressComplete.containsignorecase(Con.ShippingPostalCode)){
                               //system.debug('$$$$$$$$$$$$$$'+con.id);
                               con.Shipping_Address_Verified__c = true;
                               
                           }
                    }
                    }
                }
                acctoupdate.add(con);                
            }                        
        }
        
        if (contoupdate.size() > 0){
            
            //update contoupdate;
            Database.SaveResult [] updateResult = Database.update(contoupdate, false);
            
            for(Integer i=0;i<updateResult.size();i++){
                if (!updateResult.get(i).isSuccess()){
                    
                    Database.Error error = updateResult.get(i).getErrors().get(0);
                    system.debug('Failed ID: '+contoupdate.get(i).Id + 'Error msg: '+ error.getMessage());
                    ErrorLog__c errordetails=new Errorlog__c();
                    errordetails.RecordID__c = (String)contoupdate.get(i).Id;
                    errordetails.Message__c = error.getMessage();
                    errorslist.add(errordetails);
                }
                
            }
            
            
            
        }
        if (prodacctoupdate.size() > 0){
            //update prodacctoupdate;
            
            
            Database.SaveResult [] updateResult = Database.update(prodacctoupdate, false);
            for(Integer i=0;i<updateResult.size();i++){
                if (!updateResult.get(i).isSuccess()){
                    
                    Database.Error error = updateResult.get(i).getErrors().get(0);
                    system.debug('Failed ID: '+prodacctoupdate.get(i).Id + 'Error msg: '+ error.getMessage());
                    ErrorLog__c errordetails=new Errorlog__c();
                    errordetails.RecordID__c = (String)prodacctoupdate.get(i).Id;
                    errordetails.Message__c = error.getMessage();
                    errorslist.add(errordetails);
                }
                
            }
            
            
        }
        // Added by: Chiranjeevi Gogulakonda /**** Start *****/
        Map<Id,Account> acccountUpdateMap = new Map<Id,Account>();
        List<Account> accValues = new List<Account>();
        
        for(Account act : acctoupdate){
            acccountUpdateMap.put(act.Id,act);
        }
        if(!acccountUpdateMap.values().isEmpty()){
            accValues.addAll(acccountUpdateMap.values());
        }
        if(accValues.size() > 0){
            
            //update acccountUpdateMap.values();
            Database.SaveResult [] updateResult = Database.update(accValues, false);
            for(Integer i=0;i<updateResult.size();i++){
                if (!updateResult.get(i).isSuccess()){
                    
                    Database.Error error = updateResult.get(i).getErrors().get(0);
                    system.debug('Failed ID: '+accValues.get(i).Id + 'Error msg: '+ error.getMessage());
                    ErrorLog__c errordetails=new Errorlog__c();
                    errordetails.RecordID__c = (String)accValues.get(i).Id;
                    errordetails.Message__c = error.getMessage();
                    errorslist.add(errordetails);
                }
                
            }
        }
        /**** End *****/
        
        if (acrtoupdate.size() > 0){
            //update acrtoupdate;
            Database.SaveResult [] updateResult = Database.update(acrtoupdate, false);
            for(Integer i=0;i<updateResult.size();i++){
                if (!updateResult.get(i).isSuccess()){
                    
                    Database.Error error = updateResult.get(i).getErrors().get(0);
                    system.debug('Failed ID: '+acrtoupdate.get(i).Id + 'Error msg: '+ error.getMessage());
                    ErrorLog__c errordetails=new Errorlog__c();
                    errordetails.RecordID__c = (String)acrtoupdate.get(i).Id;
                    errordetails.Message__c = error.getMessage();
                    errorslist.add(errordetails);
                }
                
            }
        }
        if(errorslist.size()> 0)
        {
            Database.insert(errorslist,false);
        }
        
        
    }
    global void finish(Database.BatchableContext BC){
        /*VerifyAddressDoctorBatch batchInstance = new VerifyAddressDoctorBatch(index+1);
        if(batchInstance.Query != null){
        Database.executeBatch(batchInstance);
        } */
        
    }
}