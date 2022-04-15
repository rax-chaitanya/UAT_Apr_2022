public class UpdateBillingAddress{
    @AuraEnabled
    public static list<Account> saveCompany(id recordid){
        list<Account> compRecupdate = new list<Account>();
        system.debug('recordid chap' + recordid);
        List<Account> cmpList = new List<Account>();
        /*
         @developer: Atheer Bdaiwi
         @date: 04 November 2021
         @story: SFDC-6852
         @description:
         If Billing details are null, update them from the details within Shipping details
         */
        cmpList = [SELECT Id, name, Territory__c, lastModifiedBy.id, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, 
        ShippingCountry, ShippingStateCode, ShippingCountryCode, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, BillingStreet, 
        BillingCity, BillingCountry, BillingState, BillingPostalCode, DNBoptimizer__DnBCompanyRecord__c
                   FROM Account
                   WHERE id = :recordid 
                   AND DNBoptimizer__DnBCompanyRecord__c != ''
                   AND (BillingState = '' OR BillingStreet = '' OR BillingCity = '' OR BillingPostalCode = '')
                   AND Shippingstate      != ''
                   AND ShippingStreet     != ''
                   AND ShippingCity       != ''
                   AND ShippingPostalCode != ''
                 	];

            if (!cmpList.isEmpty()){

            Account compRec = cmpList[0];

            compRec.BillingStreet = (compRec.BillingStreet == null) ? compRec.ShippingStreet: compRec.BillingStreet;
            compRec.BillingCity = (compRec.BillingCity == null) ? compRec.ShippingCity : compRec.BillingCity;
            compRec.BillingCountry = (compRec.Billingcountry == null) ? compRec.ShippingCountry : compRec.BillingCountry;
            compRec.BillingState = (compRec.Billingstate == null) ? compRec.Shippingstate : compRec.Billingstate;
            compRec.BillingPostalCode = (compRec.BillingPostalCode == null) ? compRec.ShippingPostalCode : compRec.BillingPostalCode;
               

            compRec.Check_Address__c = False;           

            compRecupdate.add(compRec);

            /*
             @developer: Atheer Bdaiwi
             @date: 04 November 2021
             @story: SFDC-6852
             @description: The below update was commentented out because we do not need to update the Product Account

             Account ac=new Account();
             if(recordid!=null){
             ac=[SELECT id,Company_Name__c,BillingCountry,BillingStreet,BillingPostalCode,BillingState,ShippingCountry,ShippingState,
             ShippingPostalcode,createddate
             FROM Account where Company_Name__c=:recordid ORDER BY createddate desc limit 1];
             }
             ac.BillingStreet=compRecupdate[0].BillingStreet;
             ac.BillingCity=compRecupdate[0].BillingCity;
             ac.BillingCountry=compRecupdate[0].BillingCountry;
             ac.BillingPostalCode=compRecupdate[0].BillingPostalCode;
             ac.BillingState=compRecupdate[0].BillingState;
             ac.ShippingStreet=compRecupdate[0].ShippingStreet;
             ac.ShippingCity=compRecupdate[0].ShippingCity;
             ac.ShippingCountry=compRecupdate[0].shippingcountry;
             ac.ShippingPostalcode=compRecupdate[0].ShippingPostalCode;
             ac.ShippingState=compRecupdate[0].ShippingState;
             //update ac;
             */
            List<String> cmpaccJSONList = new List<String>();
            String CompanyJSONString = JSON.serialize(compRec);
            //String AccJSONString = JSON.serialize(ac);
            cmpaccJSONList.add(CompanyJSONString);
            //cmpaccJSONList.add(AccJSONString);
            updateRecord(cmpaccJSONList);

            return compRecupdate;
            //}
            }
         
        return null;
    }

    @future
    public static void updateRecord(List<String> cmpaccJSONList){
        integer jsonsize = cmpaccJSONList.size();
        List<Account> cmpaccList = new List<Account>();
        for (Integer i = 0; i < jsonsize; ++i){
            Account company = new Account();
            cmpaccList.add((Account) JSON.deserialize(cmpaccJSONList[i], Account.class ));
            System.debug('Company::' + (Account) JSON.deserialize(cmpaccJSONList[i], Account.class ));
        }
        //update cmpaccList;
        map<id, account> accmap = new map<id, account>();
        /*for(Account acc: cmpaccList){
         if(acc.Territory__c==''){
         accmap.putall(cmpaccList);
         }
         }*/
        accmap.putall(cmpaccList);
        if (accmap.size() > 0){
            update accmap.values();
        }
    }
}