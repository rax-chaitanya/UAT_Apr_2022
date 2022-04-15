/**
* File :  SendSurveyEmailBatch.cls
* Description : Send Email to the Pilot Account Users if the total MRR Value of the Account is more than 10000. Please refer to the SFDC-3707 for more info 
and requirement.
* Created Date : 23.09.2019   
* Author : Raja
*/
global class SendSurveyEmailBatch implements Database.batchable<Sobject>,Database.Stateful{
    public Set<id> usridexist= new Set<Id>();       
    public Set<string> userlist = new Set<string>();
    public Map<Id,List<Account>> newHighMRRMap = new Map<Id,List<Account>>();
    public SendSurveyEmailBatch(Set<string> users) {
        userlist = users;
        System.debug('userlistSize:' + userlist.size());
    }
    global Database.Querylocator start(database.Batchablecontext BC){  
       List<Id> accRTIds = System.Label.AccountRecordTypes.split(',');           
     
   String query = 'select Id,Name,Account_manager__c,Company_Name__c,Total_MRR__c,(Select id,Account_Name__r.account_manager__c,Account_Name__r.Total_MRR__c,Account_Name__r.Company_Name__c,Survey_Date__c,name,Monthly_Call_Recap__c, Survey_Complete_Date__c,Account_manager__c,CreatedDate from OPC_Account_Surveys__r ORDER BY Name DESC LIMIT 1) from Account where RecordTypeId IN : accRTIds AND Account_manager__r.SSO_Username__c IN :userlist AND Account_manager__r.IsActive = true AND Total_MRR__c>=10000';
        return Database.getquerylocator(query);
    }
    global void Execute(Database.Batchablecontext bc,List<Account> acclisttoupdate){        
        try{
            
            /* The below logic creates OPC Surveys by getting highest MRR Accounts at company level 
                and send mails to Account Managers for new OPC Surveys as well as reminders to Account Managers 
                for existing Current month OPC Surveys. If Account Manager do not complete the Survey in the current month 
                then that Account will carry forward to next month, if still this Account having highest MRR among 
                the other Accounts at company level.  
            */
            if(!acclisttoupdate.isEmpty()){
                List<OPC_Account_Survey__c> opclist= new List<OPC_Account_Survey__c>();
                                    
                for(Account acc:acclisttoupdate){
                    if(acc.OPC_Account_Surveys__r.isEmpty()){
                        newHighMRRMap = getHighMRRAccToCreateNewOPC(newHighMRRMap,acc.Company_Name__c,acc);                                                         
                    }else{
                        for(OPC_Account_Survey__c opcsurvey : acc.OPC_Account_Surveys__r){
                            if((opcsurvey.createddate.month()==System.now().month() && opcsurvey.createddate.year()==System.now().year()) 
                                    && opcsurvey.survey_Complete_Date__c ==null){
                                usridexist.add(opcsurvey.account_manager__c);
                            }else if((opcsurvey.createddate.month() != System.now().month()) 
                                        && opcsurvey.survey_Complete_Date__c ==null){
                                newHighMRRMap = getHighMRRAccToCreateNewOPC(newHighMRRMap,opcsurvey.Account_Name__r.Company_Name__c,acc); 
                            }   
                        }                         
                    }                          
                }
                
                for(List<Account> highMRRAcc : newHighMRRMap.values()){ 
                    for(Account highMRR : highMRRAcc){  
                        OPC_Account_Survey__c opcNew =New OPC_Account_Survey__c();                
                        opcNew.Account_Name__c=highMRR.id;
                        opcNew.Account_Manager__c=highMRR.Account_manager__c;
                        opcNew.Survey_Date__c=System.today();
                        opclist.add(opcNew);                 
                    }   
                }   
                
                System.debug('opclist:' + opclist);
                Database.SaveResult[] srList = Database.insert(opclist, false);
                Boolean chkSuccess = false;
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted OPC Company Survery');
                        chkSuccess = true;
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug(err.getMessage());                         
                        }
                    }
                }                    
                if(chkSuccess){
                    for(OPC_Account_Survey__c highOPC : opclist){
                        if(highOPC != null){
                            if(highOPC.account_manager__c != null){
                                usridexist.add(highOPC.account_manager__c);   
                                System.debug('usridexistin:' + usridexist);                                   
                            }
                        }
                    }
                }                   
            }                          
        }           
        catch(exception e){
            ExceptionHandler.postToAll(e, true);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
    }
    global void finish(Database.Batchablecontext bc){
        /* Send Email to OPC Pilot Users who are Account Managers for the Company Product Accounts */        
        System.debug('usridexist:' + usridexist);        
        List<Messaging.SingleEmailMessage> lstmail = new List<Messaging.SingleEmailMessage>();          
        if(usridexist != null && usridexist.size()>0){
            for(user u: [select id,name,email from user where id=:usridexist]){
                if(u != null){
                    messaging.singleemailmessage emailmessagesent=new messaging.singleemailmessage();
                    emailmessagesent.toAddresses=new string[]{u.email};
                    
                    emailmessagesent.subject=System.label.Survey_not_completed_Subject; 
                    string body=System.label.Survey_not_completed_Body+'<br/>';
                    body+='<br/>'+U.name+ system.label.Send_Survey_Email+u.id+'>  Click here to complete your Survey<br/>';
                    emailmessagesent.sethtmlbody(body);           
                    lstmail.add(emailmessagesent);
                }
            }
            Messaging.sendEmail(lstmail); 
        }
    }   
    
    private Map<Id,List<Account>> getHighMRRAccToCreateNewOPC(Map<Id,List<Account>> newHighMRRMap, Id companyId, Account acc){
        if(!newHighMRRMap.containsKey(companyId)){
            newHighMRRMap.put(companyId, new List<Account>());
        }
        if(newHighMRRMap.containsKey(companyId)){
            if(newHighMRRMap.get(companyId).isEmpty()){
                newHighMRRMap.get(companyId).add(acc);
            }else if(newHighMRRMap.get(companyId)[0].Total_MRR__c < acc.Total_MRR__c){
                newHighMRRMap.put(companyId, new List<Account> { acc });
            }else if(newHighMRRMap.get(companyId)[0].Total_MRR__c == acc.Total_MRR__c){
                newHighMRRMap.get(companyId).add(acc);
            }
                    
        }   
        if(!newHighMRRMap.isEmpty()){
            return newHighMRRMap;
        }
        return null;    
    }   
    
}