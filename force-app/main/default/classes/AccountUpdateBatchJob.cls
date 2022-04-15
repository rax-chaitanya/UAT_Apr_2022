global class AccountUpdateBatchJob Implements Database.Batchable <sObject> {
global Database.queryLocator start(Database.BatchableContext bc) {
string datacomuser=System.Label.Datacleanuser;
  DateTime currentdate=System.Now();
    String SOQL = 'SELECT Id,BillingStreet,Lastmodifieddate,BillingCity,ShippingStreet,ShippingCity,Billingpostalcode,shippingpostalcode,BillingCountry,ShippingCountry,BillingState,shippingstate,Check_Address__c,LD_USE_DnB_Optimize__c,AnnualRevenue,LastModifiedby.Name FROM Account where LD_USE_DnB_Optimize__c=true and (Check_Address__c=true or (LastModifiedby.Name=:datacomuser and lastmodifieddate>=:currentdate)) and DNBoptimizer__DNB_D_U_N_S_Number__c!=null';
    system.debug('SOQL--------'+SOQL);
    return Database.getQueryLocator(SOQL);
}
global void execute(Database.BatchableContext bc, List<Account> scope) {
system.debug('scope--------'+scope);
    list<Account> listToUpdate = new list<Account>();
    List<ErrorLog__c> errorslist=new  List<ErrorLog__c>();
    List<Account> accupdate=new list<Account>();
    string datacomuser=System.Label.Datacleanuser;
  DateTime currentdate=System.Now();
    system.debug('currentdade--------'+currentdate);
    set<id> pacid=new set<id>();
    
    
    map<id,Account> pacid2=new map<id,Account>();
    try{
        for(Account listObj : scope){
      if(listObj.LD_USE_DnB_Optimize__c==True && listObj.Check_Address__c==true){
      system.debug('listObj--------'+listObj);
           //listObj.BillingPostalCode = listObj.shippingpostalcode;
            listobj.BillingStreet=(listobj.BillingStreet==null)?listobj.ShippingStreet:listobj.BillingStreet;
            listobj.BillingCity=(listobj.BillingCity==null)?listobj.ShippingCity:listobj.BillingCity;
            listobj.BillingCountry=(listObj.BillingCountry!=null || listObj.BillingCountry!='')?listObj.shippingCountry:listObj.BillingCountry;
            listobj.BillingState=(listObj.BillingState!=null || listObj.BillingState!='')?listObj.shippingstate:listObj.BillingState;
            listObj.BillingPostalCode=(listObj.BillingPostalCode!=null || listObj.BillingPostalCode!='')?listObj.shippingpostalcode:listObj.BillingPostalCode;
            listobj.Check_Address__c=false;
            pacid.add(listObj.id);
            
            listToUpdate.add(listObj);
            system.debug('listToUpdate--------'+listToUpdate);
          }
          if(listObj.AnnualRevenue!=null && listObj.LD_USE_DnB_Optimize__c==True && listObj.LastModifiedby.Name==datacomuser){
           //pacid.add(listObj.id);
           system.debug('listObj2--------'+listObj);
           pacid2.put(listobj.id,listobj);
          }
           }
   

        if(!pacid2.isempty()){
         List<AccountHistory> achlist=[SELECT AccountId,CreatedById,CreatedDate,Field,Id,NewValue,OldValue FROM AccountHistory where Field = 'annualrevenue' and AccountId in:pacid2.keyset() and createdby.name=:datacomuser and createddate>=:currentdate order by CreatedDate desc];
         for(Account ac:pacid2.values()){   
system.debug('ac--------'+ac);
           for(AccountHistory achlist2:achlist){   
           system.debug('achlist2--------'+achlist2);   
               if(achlist2.Accountid==ac.id){
                 listToUpdate.add(ac);
            }
         }
        
        }
        }
        
        
        Database.SaveResult [] updateResult = Database.update(listToUpdate, false);
         system.debug('listToUpdate-------------->'+listToUpdate);
        //List<Accounts__c> pacclist=[select id,Company_Name__r.id,Billing_Street__c,Billing_City__c,Company_Name__c,Billing_Country__c,Billing_Zip_Postal_Code__c,Billing_State_Province__c,Shipping_Country__c,Shipping_State_Province__c,Shipping_Zip_Postal_Code from Account where Company_Name__c in:pacid];
        List<Account> pacclist=[select Id,Company_Name__r.id,BillingStreet,Lastmodifieddate,BillingCity,ShippingStreet,ShippingCity,Billingpostalcode,shippingpostalcode,BillingCountry,ShippingCountry,BillingState,shippingstate,Check_Address__c,LD_USE_DnB_Optimize__c,AnnualRevenue,LastModifiedby.Name from Account where Company_Name__c in:pacid];
        system.debug('pacclist-------------->'+pacclist);
         for(Account listObj : listToUpdate){
         system.debug('listObj--------'+listObj);  
        for(Account ac:pacclist){
        system.debug('ac--------'+ac);  
        if(ac.Company_Name__r.id==listObj.id){
        ac.BillingStreet=listObj.BillingStreet;
        ac.BillingCity=listObj.Billingcity;
        ac.BillingCountry=listObj.BillingCountry;
        ac.BillingState=listObj.BillingState;
        ac.Billingpostalcode=listObj.BillingPostalCode;
        ac.ShippingStreet=listObj.ShippingStreet;
        ac.ShippingCity=listObj.ShippingCity;
        ac.ShippingCountry=listObj.shippingcountry;
        ac.ShippingState=listObj.ShippingState;
        ac.ShippingPostalCode=listObj.ShippingPostalCode;
        accupdate.add(ac);
        system.debug('accupdate--------'+accupdate); 
        }
        }
        }
         system.debug('accupdate-------------->'+accupdate);
        Database.SaveResult [] updateResult2 = Database.update(accupdate, false);
        ErrorLogHelper.logErrorRecords(updateResult,listToUpdate,Label.CompanyAddressUpdate);
        system.debug('updateResult2-------------->'+updateResult2);
    }catch(Exception ex){
       ErrorLogHelper.logErrorRecord(ex.getMessage(),Label.CompanyAddressUpdate);
      system.debug('error-------------->'+ex.getmessage());
    }
}
global void finish(Database.BatchableContext bc) {
}
}