Public class cloudForcastTriggerHandler{
    
    Public void UserSegmentUpdate(List<Cloud_Forecast__c> newList){
        
        set<id> userids= new set<id>();
        for(Cloud_Forecast__c c: newList)
        {
            if(c.User__c != null){                
                userids.add(c.User__c);
            }            
        }        
        Map<Id, user> usermap = new Map<Id, user>( [select id, Region__c, Forecast_Group_1__c from user where id in :userids]);        
        list<Cloud_Forecast__c> updatelist = new list<Cloud_Forecast__c>();
        
        for(Cloud_Forecast__c crf : newList)
        {
            if(usermap.containskey(crf.User__c))
            {                
                user u = usermap.get(crf.User__c);                
                crf.User_Segment__c = u.Forecast_Group_1__c;
                crf.Region__c = u.Region__c;
            }            
        }        
    }   
    
    Public void updateTotalSegmentValue(List<Cloud_Forecast__c> crfList, Map<Id, Cloud_Forecast__c>crfOldMap){
        
        List<decimal> monthdate = new list<decimal>();
        List<string> segmenttype = new List<string>();        
        Map<string, decimal> sumvalues = new Map<string, decimal>();        
        List<Cloud_Forecast__c> updateRecords = new List<Cloud_Forecast__c>();
        
        for(Cloud_Forecast__c c: crfList){
            if((c.month_of_record__c+''+c.User_Segment__c) == c.unique__c) {         
            segmenttype.add(c.User_Segment__c);
            monthdate.add(c.month_of_record__c);
                system.debug('########' + (c.month_of_record__c+''+c.User_Segment__c));
                system.debug('##########' + c.unique__c);
                                      }
        }
        List<aggregateResult> sumSegmentValue = [select sum(Segment_Value__c) total , User_Segment__c st from Cloud_Forecast__c where User_Segment__c IN :segmenttype and month_of_record__c IN:monthdate group by User_Segment__c];        
        List<Cloud_Forecast__c> uniquesegmentrecords = new List<Cloud_Forecast__c>([select id, Segment_Value__c,unique__c, CRF_Month__c,month_of_record__c, User_Segment__c, Total_Segment_Value__c,Azure__c, Azure_Support__c, FAWS__c, FAWS_Support__c, RAX_Cloud__c, RAX_Cloud_Support__c  from Cloud_Forecast__c where User_Segment__c IN :segmenttype and month_of_record__c IN:monthdate]);
        system.debug('&&&&&&& sumSegmentValue' + sumSegmentValue);
        system.debug('&&&&&&& uniquesegmentrecords' + uniquesegmentrecords);
        
        for(AggregateResult Ar:sumSegmentValue){
            Sumvalues.put((string)Ar.get('st'),(Decimal)Ar.get('total'));
        }
        for(Cloud_Forecast__c c : uniquesegmentrecords){
            if((c.month_of_record__c+''+c.User_Segment__c) == c.unique__c) {            
            c.Total_Segment_Value__c = Sumvalues.get(c.User_Segment__c);
            system.debug('&&&&&&& c.Total_Segment_value__c' + c.Total_Segment_Value__c);
            system.debug('&&&&&&& Sumvalues.get(c.User_Segment__c)' + Sumvalues.get(c.User_Segment__c));
            updateRecords.add(c);
                                      }
        }  
        if(!updateRecords.isEmpty()){
            blockIteration.blockRecursiveCRFTriggerUpdateSegmentValue = true;
            Update updateRecords;
        }  
    }  
    
    public void validDuplicateUser(List<Cloud_Forecast__c> crfNewList, Map <Id,Cloud_Forecast__c> crfOldMap) 
    {
        Map<String, Cloud_Forecast__c> crfUniqueMap = new Map<String, Cloud_Forecast__c>();
        set<decimal> month = new Set<decimal>();
        set<Id> userIds = new set<Id> ();
        for (Cloud_Forecast__c c  : crfNewList){            
            if (((c.month_of_record__c+''+c.user__C+''+c.RecordTypeID) !=null) && 
                (Trigger.isInsert || ((c.month_of_record__c+''+c.user__C+''+c.RecordTypeID) != 
                                      (crfOldMap.get(c.Id).month_of_record__c+''+crfOldMap.get(c.Id).user__C+''+crfOldMap.get(c.Id).RecordTypeID)))
               ){               
                   if (crfUniqueMap.containsKey(c.month_of_record__c+''+c.user__C+''+c.RecordTypeID)){
                       c.addError('Duplicate record found with same user in the month.');
                   }else{
                       crfUniqueMap.put((c.month_of_record__c+''+c.user__C+''+c.RecordTypeID), c);
                       month.add(c.month_of_record__c);
                       userIds.add(c.user__C);
                   }
               }            
        }        
        for (Cloud_Forecast__c c : [SELECT user__C, month_of_record__c, RecordTypeID FROM Cloud_Forecast__c 
                                    WHERE month_of_record__c IN :month and user__C IN :  userIds])
                                 {                                                
                                     if(crfUniqueMap.containsKey(c.month_of_record__c+''+c.user__C+''+c.RecordTypeID)) 
                                     {
                                         Cloud_Forecast__c duplicateRecord = crfUniqueMap.get(c.month_of_record__c+''+c.user__C+''+c.RecordTypeID);
                                         duplicateRecord.addError('Duplicate record found with same user in the month.');
                                     }                                                
                                 }
    }
    
    Public void monthUpdate(List<Cloud_Forecast__c> crfNewList){
        
        for(Cloud_Forecast__c c:crfNewList){
            if(c.CRF_Date__c != null){              
                IF(c.CRF_Date__c.month()== 1){ 
                    c.CRF_Month__c = 'January';
                }
                IF(c.CRF_Date__c.month()== 2){ 
                    c.CRF_Month__c = 'February';
                }
                IF(c.CRF_Date__c.month()== 3){ 
                    c.CRF_Month__c = 'March';
                }
                IF(c.CRF_Date__c.month()== 4){ 
                    c.CRF_Month__c = 'April';
                }
                IF(c.CRF_Date__c.month()== 5){ 
                    c.CRF_Month__c = 'May';
                }
                IF(c.CRF_Date__c.month()== 6){ 
                    c.CRF_Month__c = 'June';
                }
                IF(c.CRF_Date__c.month()== 7){ 
                    c.CRF_Month__c = 'July';
                }
                IF(c.CRF_Date__c.month()== 8){ 
                    c.CRF_Month__c = 'August';
                }
                IF(c.CRF_Date__c.month()== 9){ 
                    c.CRF_Month__c = 'September';
                }
                IF(c.CRF_Date__c.month()== 10){ 
                    c.CRF_Month__c = 'October';
                }
                IF(c.CRF_Date__c.month()== 11){ 
                    c.CRF_Month__c = 'November';
                }
                IF(c.CRF_Date__c.month()== 12){ 
                    c.CRF_Month__c = 'December';
                }
            }
        }      
    }    
}