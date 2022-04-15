/*
* Story: SFDC-6420, SFDC-6540 : Track usage of 'Revenue Retention Play
* Description : To track usage on how many Profiles are using 'Revenue Retention Play' for mitigating churn
* Date : 07/233/2021
* Author : Sundarayya e
* Test Class - RevenueRetentionPlayBatch_Test
*/
global class RevenueRetentionPlayBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global database.queryLocator start(Database.BatchableContext BC){
        return database.getQueryLocator([SELECT ApexPage.Name, ApexPageId, DailyPageViewCount, Id, Profile.Name, MetricsDate, LogDate FROM VisualforceAccessMetrics where ApexPageId = '0663f000000TOJAAA4'AND Logdate >= LAST_N_DAYS:7]);
    }
    global void execute(Database.BatchableContext BC, List<VisualforceAccessMetrics> vfAccMetrList) 
    {       
        system.debug(' vfAccMetrList records @@ '+vfAccMetrList );
        string header = 'LogDate, Number of visits, Profile Name, ApexPage Name, ApexPageId, Metrics Date \n';
        string finalstr = header ;
        for(VisualforceAccessMetrics vfamRec: vfAccMetrList){
            string recordString = vfamRec.LogDate+','+vfamRec.DailyPageViewCount+','+vfamRec.Profile.Name+','+vfamRec.ApexPage.Name+','+vfamRec.ApexPageId+','+vfamRec.MetricsDate+'\n';
            finalstr = finalstr +recordString;
        }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob recBlob = Blob.valueOf(finalstr);
        string fileName = 'Revenue_Retention_Plan_Usage_Tracking.csv';
        csvAttc.setFileName(fileName);
        csvAttc.setContentType('text/csv');
        csvAttc.setBody(recBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
      
      List<String> sendTo = System.Label.RevenueEmails.split(',');

        //String[] toAddresses = new list<string> {'srini.kodali@rackspace.com','Shravan.godha@rackspace.com','abhishek.vijayvargiya@rackspace.com'};
       // String[] toAddresses = new list<string> {'bbelasco@rackspace.com','Andrew.Welsh@rackspace.com','Kimberly.Gamboa@rackspace.com'};
        String subject ='Revenue_Retention_Plan_Usage_Tracking';
        email.setSubject(subject);
        email.setToAddresses(sendTo);
        //email.setToAddresses( toAddresses );
        email.setPlainTextBody('Here is the attached tracking sheet of Revenue retention plan usage.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    global void finish(Database.BatchableContext BC)  
    {
        
        
    }
}