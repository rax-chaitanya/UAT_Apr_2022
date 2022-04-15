/*
    Author: Rajasekhar
    Description: This utility apex class is created to get list of Company/Account records or Ids from one common Standard Account.
*/
public class CMPorACCRecordType_Utility{
    
    //Added by Rajasekhar - Starts
    public static Map<String,List<Account>> getRTBasedCMPorAccMap(List<Account> cmporAccList){
        Map<String,List<Account>> tmpcmpMap = new Map<String,List<Account>>();
                
        if(cmporAccList != null && cmporAccList.size()>0){
            for(Account ac:cmporAccList){
                if(System.Label.CompanyRecordTypes.contains(ac.RecordTypeId)){  
                    if(!tmpcmpMap.containsKey('Company'))
                        tmpcmpMap.put('Company', new List<Account>());                  
                    if(tmpcmpMap.containsKey('Company'))    
                        tmpcmpMap.get('Company').add(ac);
                        
                }else if(System.Label.AccountRecordTypes.contains(ac.RecordTypeId)){
                    if(!tmpcmpMap.containsKey('Account'))
                        tmpcmpMap.put('Account', new List<Account>());                  
                    if(tmpcmpMap.containsKey('Account'))    
                        tmpcmpMap.get('Account').add(ac);                                       
                }       
            }
        }       
        return tmpcmpMap;
    }       
    //Added by Rajasekhar - Ends
    
    //Added by Rajasekhar - Starts
    public static List<Id> query_Utility(String RTLabel){
        List<Id> RTIds = new List<Id>();
        RTIds.addAll(RTLabel.split(','));
        System.debug(RTIds.size());
        return RTIds;
    }
    //Added by Rajasekhar - Ends
    
}