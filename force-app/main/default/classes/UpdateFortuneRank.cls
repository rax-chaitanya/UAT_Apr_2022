/**********************************************************************************

Author: Nishith Animesh
Description: This apex class is created to Update Fortune Rank in Company Object. This class 
is being called from Trigger Handler
Created Date: 18 October,2017
Modified Date/Reason:
**********************************************************************************/
public class UpdateFortuneRank{
    public static void rankUpdate(List<SObject> Records,Map<Id, SObject> tMap){
        system.debug('Account##'+Records);
        List<sObject> rankToBeUpdated= new List<sObject>();
        List<Account> newAccLists = new  List<Account>();
        List<String> accIdLists = new  List<String>();
        
        if (!records.isEmpty()) {
            for (Integer i = 0; i < records.size(); i++) {
                sObject record = records[i];
                if (record.getSObjectType() == Account.sObjectType) {
                    newAccLists.add((Account) record);
                }
            }
        }
        system.debug('newAccLists##'+Records);
        //Filtering Company Ids with populated Dunsnumber
        for(Account comObj : newAccLists){
            if(comObj.DunsNumber != null && comObj.DunsNumber !=''){
                rankToBeUpdated.add(comObj);
                accIdLists.add(comObj.Id);
            }
        }  
        system.debug('accIdLists##'+accIdLists);
        system.debug('rankToBeUpdated##'+Records);
        //Calling future method as query on DB company is doing external call. 
        UpdateFortuneRank.updateFortuneRankFuture(accIdLists);
        
        
    }
    //Method created to query on external object DataclouddAndBCompany
    @future 
    public static void updateFortuneRankFuture(List<String> accIds) {
        
        Map<String, List<Account >> dunsToCompanyListMap = new Map<String, List<Account>>();
        List<Account> accUpdateList = new List<Account>();
        if (!accIds.isEmpty()){
            accUpdateList = [SELECT Id,DunsNumber from Account where Id IN : accIds];
        }
        
        for(sObject obj : accUpdateList ) {
            String companyDunsNumber = (String)((Account)obj).DunsNumber;
            if(companyDunsNumber != null && companyDunsNumber.trim() != '') {
                if(dunsToCompanyListMap.get(companyDunsNumber) == null) {
                    dunsToCompanyListMap.put(companyDunsNumber, new List<Account>());
                }
                dunsToCompanyListMap.get(companyDunsNumber).add((Account)obj);
            }
        }
        //system.debug('dunsToCompanyListMap##'+Records);
        //Query the DataclouddAndBCompany object to get the matching Data.com records for the Companies we are appending Fortune Rank to
        Map<Id, Account> accountUpdateMap = new Map<Id, Account>();
        for(DataclouddAndBCompany dAndBCompany : [SELECT Id, Name, DunsNumber, FortuneRank 
                                                  FROM DataclouddAndBCompany
                                                  WHERE DunsNumber IN : dunsToCompanyListMap.keySet()]) {
                                                      
                                                      //Ignore any D&B Company record that doesn't have a Fortune Rank value
                                                      if(dAndBCompany.FortuneRank != null && String.valueOf(dAndBCompany.FortuneRank) != '') {
                                                          
                                                          for(Account acc : dunsToCompanyListMap.get(dAndBCompany.DunsNumber)) {
                                                              acc.Fortune_Rank__c = (Integer)dAndBCompany.FortuneRank;
                                                              accountUpdateMap.put(acc.Id, acc);
                                                          }
                                                      }
                                                  }
        system.debug('accountUpdateMap##'+accountUpdateMap);
        if(accountUpdateMap.size() > 0) {
            update accountUpdateMap.values();
        }
    }
    
}