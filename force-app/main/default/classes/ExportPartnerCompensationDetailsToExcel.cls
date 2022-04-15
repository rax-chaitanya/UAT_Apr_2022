/* AUthor : Anilkumar
* Purpose : Downloading Compensation Detail records
* Date : 26-Apr-2018
*/

public without sharing class ExportPartnerCompensationDetailsToExcel{
    public List<Partner_Compensation__c> partnerCompDetails{get; set;}
    public String xlsHeader {set;get;}
    Public string recID{get;set;}
    Public boolean Flag{get;set;}
    Public Boolean Flag1{get;set;}
    
    public ExportPartnerCompensationDetailsToExcel(ApexPages.StandardController controller){
        //recID=controller.getRecord().Id;
        recID = apexpages.currentpage().getparameters().get('recId');// getting from url

        system.debug('ID of Compensation record'+recID);
        
        xlsHeader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        system.debug('ID of Compensation record Inside Method'+recID);
        
        if(recID != null){
            Flag=true;
            partnerCompDetails = new List<Partner_Compensation__c>();        
            User loggedInUser = [Select Id,AccountId From User where Id =: UserInfo.getUserId()];        
            partnerCompDetails =  [ Select Id,Name,Partner_Company__c,
                                   (Select id, Name, Paid_Date__c , Opp_ID__c, AccountName__c, Amount__c,Fix__c,Eligible_Amount__c,
                                    Compensation_Type__c, Opp_Close_Date__c,Contract_Term__c,partner_compensation__r.NAme,
                                    Opportunity__r.Opportunity_ID__c,Opp_Account_Name__c,
                                    Opportunity__r.Acc_Number__c,Account_DDI__c,CurrencyIsoCode,Opp_Type__c,Lead_Sub_Agent__c, Accounts_Aging__c,
                                    Backpay__c,SPIFF_One_time_payments__c,Clawbacks__c
                                    from RV_Compensation_Detail__r)                                
                                   From Partner_Compensation__c Where ID =:recID];
                                   system.debug('Flag Value' +flag);
        }else{
        
            system.debug('ID of Compensation record existing'+recID);   
            xlsHeader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
                   Flag1=true;
            partnerCompDetails = new List<Partner_Compensation__c>();        
            User loggedInUser = [Select Id,AccountId From User where Id =: UserInfo.getUserId()];        
            partnerCompDetails =  [ Select Id,Name,Partner_Company__c,
                               (Select id, Name, Paid_Date__c , Opp_ID__c, AccountName__c, Amount__c,Fix__c,Eligible_Amount__c,
                                Compensation_Type__c, Opp_Close_Date__c,Contract_Term__c,partner_compensation__r.NAme,
                                Opportunity__r.Opportunity_ID__c,Opp_Account_Name__c,
                                Opportunity__r.Acc_Number__c,Account_DDI__c,CurrencyIsoCode,Opp_Type__c,Lead_Sub_Agent__c, Accounts_Aging__c,
                                Backpay__c,SPIFF_One_time_payments__c,Clawbacks__c
                                from RV_Compensation_Detail__r)                                
                               From Partner_Compensation__c Where Partner_Company__c =:loggedInUser.AccountId                               
                               Order By createddate Desc ];
             system.debug('Else ::: '+partnerCompDetails.size()+' - '+partnerCompDetails);   
                               system.debug('Flag Value' +flag1);
        
        }                       
    }

    public ExportPartnerCompensationDetailsToExcel(){  
        system.debug('ID of Compensation record existing'+recID);   
        xlsHeader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
               Flag1=true;
        partnerCompDetails = new List<Partner_Compensation__c>();        
        User loggedInUser = [Select Id,AccountId From User where Id =: UserInfo.getUserId()];        
        partnerCompDetails =  [ Select Id,Name,Partner_Company__c,
                               (Select id, Name, Paid_Date__c , Opp_ID__c, AccountName__c, Amount__c,Fix__c,Eligible_Amount__c,
                                Compensation_Type__c, Opp_Close_Date__c,Contract_Term__c,partner_compensation__r.NAme,
                                Opportunity__r.Opportunity_ID__c,Opp_Account_Name__c,
                                Opportunity__r.Acc_Number__c,Account_DDI__c,CurrencyIsoCode,Opp_Type__c,Lead_Sub_Agent__c, Accounts_Aging__c,
                                Backpay__c,SPIFF_One_time_payments__c,Clawbacks__c
                                from RV_Compensation_Detail__r)                                
                               From Partner_Compensation__c Where Partner_Company__c =:loggedInUser.AccountId                               
                               Order By createddate Desc ];
    } 
    
    public Pagereference exportAll(){
    
        return new Pagereference('/apex/ExportCompensationDetails');
    
    }    
    
    @AuraEnabled
    public static String getbaseUrl(){
        String url = ''+System.Url.getSalesforceBaseUrl().toExternalForm();
        return url;
    }
    
}