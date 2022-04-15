/* 
Epic: SFDC-5677, User Story: SFDC-5687 This Batch class trigger 
on every month 2nd Tuesday(Send Qualified NPS Contacts to Qualtrics by updating NPS_Survey__c field on ACR)

* Last Modified By - Chaitanya 
* Changes - SFDC-6904 --> Added SoqlEyDomain,SoqlBrEyDomain,SoqlRacspaceUk String which will be excluded from query using NPSACREligibleQuery Custom Label
* Test Class - NPS_SurveyAllInOne_Test

*/

public class NPSContactEvalua_OR_DistributionList implements Database.Batchable<sObject>, Database.Stateful {
    
    @TestVisible List<Id> errRecIds;
    @TestVisible Set<String> cEmails;
    @TestVisible String genErrCSVFile = '';    
    @TestVisible String msgSub;
    @TestVisible String filename = '';
    @TestVisible String fileRow = '';
    @TestVisible Set<Id> acrErrorIds;
    @TestVisible Set<Id> acr2ErrorIds;
    @TestVisible static Boolean run3rdTime = false;
    @TestVisible static Boolean isFinalError = false;
    
    public NPSContactEvalua_OR_DistributionList(Set<Id> errorIds, Boolean is3rdTime){
        System.debug('is3rdTime::' + is3rdTime); 
        if(is3rdTime){
            run3rdTime = is3rdTime; 
            acr2ErrorIds = new Set<Id>();
            acr2ErrorIds.addAll(errorIds);
            String errorfileHeader = 'Id,AccountId,ContactId,Error Message \n';
            genErrCSVFile = errorfileHeader;    
            filename = 'Failed NPS Qualified Contacts for Survey.csv';        
        }
        cEmails = new Set<String>();
        acrErrorIds = new Set<Id>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){             
        String conStr = '';
        List<String> Skip_Colle_Status     = System.Label.NPS_Skip_Collection_Status.split(',');
        String accStatus                   = System.Label.NPS_Account_Status;
        //String unQuali                     = System.Label.NPS_Skip_Unqualified;

            String SoqlSFDomain                    = '%' + System.Label.NPS_Skip_Email_Domain1;
            String SoqlrackDomain                  = '%' + System.Label.NPS_Skip_Email_Domain2;
            String SoqlEyDomain                        = '%' +System.Label.NPS_Skip_Email_Domain_Ey_com;
			String SoqlBrEyDomain                        = '%' +System.Label.NPS_Skip_Email_Domain_br_ey_com;
            String SoqlRacspaceUk                        = '%' +System.Label.NPS_Skip_Email_Domain_rackspaceuk;
        
        String npsCon                      = System.Label.NPS_Contact_Role;   
        List<String> acRTIds              = System.Label.AccountRecordtypes.split(',');
        List<String> Skip_OnicaCEIds       = System.Label.NPS_Skip_OnicaCntrType.split(',');
        
        if(acr2ErrorIds != null && acr2ErrorIds.size() > 0){
            conStr = System.Label.NPSACRQueryFieldsString + ' (Id IN :acr2ErrorIds) AND (Roles INCLUDES (:npsCon) AND Contact.NPS_Survey__c = true) AND ' + System.Label.NPSACREligibleQuery;
        }else{
            conStr = System.Label.NPSACRQueryFieldsString + ' (Roles INCLUDES (:npsCon) AND Contact.NPS_Survey__c = true) AND ' + System.Label.NPSACREligibleQuery;
        }
        return Database.getQueryLocator(conStr);        
    }
    
    public void execute(Database.BatchableContext bc, List<AccountContactRelation> acrs){
        if(acrs != null && acrs.size()>0){
            List<AccountContactRelation> acrList = new List<AccountContactRelation>();                
            for(AccountContactRelation acr : acrs){
                if(!cEmails.contains(acr.Contact.Email)){
                    cEmails.add(acr.Contact.Email);
                    acr.NPS_Survey__c = true;
                    acrList.add(acr);                        
                }                   
            }   
            System.debug('acrListSize::' + acrList.size());
            if(!acrList.isEmpty()){
                List<Database.SaveResult> updateResults = Database.update(acrList, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (!updateResults.get(i).isSuccess()){                        
                        if(run3rdTime == false){
                            acrErrorIds.add(acrList.get(i).Id); } else{
                            if(!isFinalError){ isFinalError = true; }
                            fileRow = '';  Database.Error error = updateResults.get(i).getErrors().get(0); String failedDML = error.getMessage(); 
                            fileRow = fileRow +','+ acrList.get(i).Id; 
                            fileRow = fileRow +','+ acrList.get(i).AccountId; 
                            fileRow = fileRow +','+ acrList.get(i).ContactId; 
                            fileRow = fileRow +','+ failedDML; fileRow = fileRow.replaceFirst(',',''); 
                            genErrCSVFile = genErrCSVFile + fileRow + '\n'; 
                        }                            
                    }
                }               
            }                                  
        }                    
    }
    
    public void finish(Database.BatchableContext bc){    
        
        if(!acrErrorIds.isEmpty() && run3rdTime == false){
            System.debug('acrErrorIds::' + acrErrorIds.size());
            NPSContactEvalua_OR_DistributionList nps2ndtime = new NPSContactEvalua_OR_DistributionList(acrErrorIds,true);
            Database.executeBatch(nps2ndtime,1);            
        }else if(isFinalError){    
            NPSContact_Sched nps = new NPSContact_Sched();
            nps.sendNPSEmail(Date.today(),isFinalError,genErrCSVFile,fileName);
        }   
    }
    
}