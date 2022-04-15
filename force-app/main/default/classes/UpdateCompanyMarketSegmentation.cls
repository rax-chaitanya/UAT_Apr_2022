/**********************************************************************************

Author: Sundarayya e
Description: This apex class is created for the Update Market segmentation logic  
converted 'Update Company Market segmentation'process builder to code
date : 24/08/2020

**********************************************************************************/
public class UpdateCompanyMarketSegmentation {
    
    public static void updateMrketSegment(List<Account> records){
        Boolean hasStandardRecordType;
        Boolean hasGovernMentRecordType;
        
        for(Account acc : records){
            hasStandardRecordType = false;
            hasGovernMentRecordType = false;
            //Integer annualRevenue = VALUE(TEXT(Amount))
            if(System.label.StandardRecordType.contains(acc.RecordtypeId)){
                hasStandardRecordType = true;
            }
            if(System.label.GovernmentRecordType.contains(acc.RecordtypeId)){
                hasGovernMentRecordType = true;
            }
            system.debug('hasStandardRecordType-------'+hasStandardRecordType);
            system.debug('acc.Territory__c---------'+acc.Territory__c);
            system.debug('acc.AnnualRevenue---------'+acc.AnnualRevenue);
           
            if(hasStandardRecordType && acc.Territory__c == 'US/CANADA'){
               if(acc.AnnualRevenue == Null || acc.AnnualRevenue < 1000){
                acc.Company_Segmentation__c = 'UNK';
               }else if(acc.AnnualRevenue >= 1000 && acc.AnnualRevenue < 300000000){
                acc.Company_Segmentation__c = 'SB';                
               }else if(acc.AnnualRevenue >= 300000000 && acc.AnnualRevenue <= 1000000000){
                acc.Company_Segmentation__c = 'MM'; 
               }else if(acc.AnnualRevenue > 1000000000){
                   acc.Company_Segmentation__c = 'ENT'; 
               }
               // system.debug('account territory'+ acc.Territory__c);
            }else if(hasStandardRecordType && acc.Territory__c == 'EMEA'){
                acc.CurrencyIsoCode = 'GBP';
                if(acc.AnnualRevenue == null || acc.AnnualRevenue == 0){
                    acc.Company_Segmentation__c = 'UNK';
                }else if(acc.AnnualRevenue > 0 && acc.AnnualRevenue < 50000000 ){
                    acc.Company_Segmentation__c = 'Commercial';
                }else if(acc.AnnualRevenue >= 50000000 && acc.AnnualRevenue <= 750000000){
                     acc.Company_Segmentation__c = 'MM';
                }else if(acc.AnnualRevenue > 750000000 ){
                     acc.Company_Segmentation__c = 'ENT';
                }             
            }else if(hasStandardRecordType && acc.Territory__c == 'ANZ'){
                acc.CurrencyIsoCode = 'AUD';
                if(acc.AnnualRevenue > 0 && acc.AnnualRevenue != null && acc.AnnualRevenue < 100000000){
                     acc.Company_Segmentation__c = 'SB';
                }else if(acc.AnnualRevenue >= 100000000 && acc.AnnualRevenue <= 500000000){
                     acc.Company_Segmentation__c = 'MM';
                }else if(acc.AnnualRevenue > 500000000){
                    acc.Company_Segmentation__c = 'ENT';
                }else if((acc.AnnualRevenue == 0 || acc.AnnualRevenue == null) && acc.NumberOfEmployees > 0 && acc.NumberOfEmployees <= 999){
                    acc.Company_Segmentation__c = 'SB';
                }else if((acc.AnnualRevenue == 0 || acc.AnnualRevenue == null) && acc.NumberOfEmployees >= 1000){
                    acc.Company_Segmentation__c = 'ENT';
                }else if((acc.AnnualRevenue == 0 || acc.AnnualRevenue == null) && (acc.NumberOfEmployees == 0 || acc.NumberOfEmployees == null)){
                    acc.Company_Segmentation__c = 'UNK';
                }
                
            }else if(hasStandardRecordType && acc.Territory__c == 'LATAM'){
                if(acc.AnnualRevenue == null || acc.AnnualRevenue < 1000){
                    acc.Company_Segmentation__c = 'UNK';
                }else if(acc.AnnualRevenue >= 1000  && acc.AnnualRevenue < 150000000){
                    acc.Company_Segmentation__c = 'SB';
                }else if(acc.AnnualRevenue >= 150000000  && acc.AnnualRevenue <= 800000000){
                    acc.Company_Segmentation__c = 'MM';
                }else if(acc.AnnualRevenue > 800000000 ){
                    acc.Company_Segmentation__c = 'ENT';
                }
                
            }else if(hasStandardRecordType &&(acc.Territory__c == 'Asia' || acc.Territory__c == 'Benelux' || acc.Territory__c == 'DACH')){
                acc.Company_Segmentation__c = 'Not Segmented';
            }else if(hasGovernMentRecordType){
                if(acc.Territory__c == 'US/CANADA'){
                        acc.Company_Segmentation__c = 'FED';
                }else if(acc.Territory__c == 'EMEA'){
                        acc.Company_Segmentation__c = 'FED';
                        acc.CurrencyIsoCode = 'GBP';
                }else if(acc.Territory__c == 'ANZ'){
                    acc.Company_Segmentation__c = 'FED';
                    acc.CurrencyIsoCode = 'AUD';
                }else if(acc.Territory__c == 'LATAM'){
                    acc.Company_Segmentation__c = 'FED';                    
                }else if(acc.Territory__c == 'Asia' || acc.Territory__c == 'Benelux' || acc.Territory__c == 'DACH'){
                    acc.Company_Segmentation__c = 'Not Segmented';
                }
              
            }else if(acc.Territory__c == 'EMEA' && !(hasGovernMentRecordType) && !(hasStandardRecordType) ){
                acc.CurrencyIsoCode = 'GBP';
            }else if(acc.Territory__c == 'ANZ' && !(hasGovernMentRecordType) && !(hasStandardRecordType)){
                acc.CurrencyIsoCode = 'AUD';
            }
            
        }
    }
}