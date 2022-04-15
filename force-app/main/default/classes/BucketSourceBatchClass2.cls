/**********************************************************************************

Author: Sundarayya e
Description: This Batch class is  to run new logic to update bucket source on opp's created from Jan 1st 2019
Story : SFDC-6267
date : 06/30/2021

**********************************************************************************/
global class BucketSourceBatchClass2 implements Database.Batchable<sObject>{
    global database.queryLocator start(Database.BatchableContext BC) 
    {
        return database.getQueryLocator([SELECT Id, Bucket_Source__c, Created_from_Lead__c, CreatedDate, CloseDate, StageName, OwnerId,
                                         (Select Id, Name, Role__c, Status__c, CreatedDate, Opportunity__c from Partner_Roles__r where Role__c = 'Source' limit 1)
                                         FROM Opportunity where 
                                         //Id = '0067g00000Gctd7AAB']);
                                         
                                         CreatedDate  >= 2019-01-01T00:00:00.000Z OR CloseDate >= 2019-01-01]);
    } 
    
    global void execute(Database.BatchableContext BC, List<Opportunity> OppsList) 
    { 
        Map<Id, Opportunity> oppMapWithInwindow = new Map<Id, Opportunity>();
        Map<Id, Opportunity> oppMapWithoutofwindow = new Map<Id, Opportunity>();
        List<ErrorLog__c> errorslist=new  List<ErrorLog__c>();
        List<opportunity> oppToUpdatelist = new List<Opportunity>();
        for(Opportunity Opp : OppsList){
            if(opp.Partner_Roles__r.size() > 0 && opp.CreatedDate < opp.Partner_Roles__r[0].CreatedDate ){
                
                decimal Hours = decimal.valueof((opp.CreatedDate.getTime() - opp.Partner_Roles__r[0].CreatedDate.getTime())/(60*60));
                Integer hoursDiff=Integer.valueOf((Hours/1000));
                system.debug('hoursDiff'+hoursDiff);
                if(hoursDiff < 0){
                    hoursDiff = hoursDiff * -1;
                    system.debug('hoursDiff1'+hoursDiff);
                }        
                if(hoursDiff < 24 && opp.Bucket_Source__c != 'Partner'){
                    //oppMapWithInwindow.put(Opp.Id, Opp);
                    opp.Bucket_Source__c = 'Partner';
                    oppToUpdatelist.add(opp);
                }
                if(hoursDiff > 24 && opp.Bucket_Source__c != 'Marketing' && opp.Bucket_Source__c != 'Partner'){
                    // oppMapWithoutofwindow.put(Opp.Id, Opp);
                    opp.Bucket_Source__c = 'Partner';
                    oppToUpdatelist.add(opp);
                }
            }else if(opp.Partner_Roles__r.size() > 0 && opp.CreatedDate >= opp.Partner_Roles__r[0].CreatedDate && opp.Bucket_Source__c != 'Partner'){
                opp.Bucket_Source__c = 'Partner';
                oppToUpdatelist.add(opp);
            }
        }
        if(oppToUpdatelist.size() > 0){
            Database.SaveResult [] updateResult = Database.update(oppToUpdatelist, false);
            
            for(Integer i=0;i<updateResult.size();i++){
                if( !Test.isRunningTest()){
                    if (!updateResult.get(i).isSuccess()){
                        
                        Database.Error error = updateResult.get(i).getErrors().get(0);
                        //system.debug('Failed ID: '+contoupdate.get(i).Id + 'Error msg: '+ error.getMessage());
                        ErrorLog__c errordetails = new Errorlog__c();
                        errordetails.RecordID__c = (String)oppToUpdatelist.get(i).Id;
                        errordetails.Message__c = error.getMessage();
                        errordetails.Object_name__c = 'Opportunity';
                        errorslist.add(errordetails);
                    }
                }
                
            }
        }
        
    } 
    global void finish(Database.BatchableContext BC) {
        
    }
}