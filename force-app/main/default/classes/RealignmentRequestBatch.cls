/* 
    User Story: SFDC-68932 This Batch class trigger when user trying to submit records more than 100 rec from accountrealignmentrequestapproval
    if the records are getting failed multiple time it will send email to submitter and actual approver
    Date : 11/15/2021
    Author : Sundarayya e
*/
global class RealignmentRequestBatch implements Database.Batchable<sObject>, Database.Stateful{
    @TestVisible List<Realignment_Request_Item__c> rrListToUpdate ;
    @TestVisible List<Realignment_Request_Item__c> acrErrorIds;
    @TestVisible Boolean run3rdTime = false;
    @TestVisible Map<Id, String> finalErrMaplist;
    
    @TestVisible String fileRow = '';
    @TestVisible String genErrCSVFile = '';
    @TestVisible String filename = '';
    @TestVisible Boolean isFinalError = false;
    @TestVisible String submitterEmail ;
    @TestVisible String ActualApprovalEmail;
    
    
    global RealignmentRequestBatch(List<Realignment_Request_Item__c> rrRecList, Boolean is3rdRun){
        acrErrorIds = new List<Realignment_Request_Item__c>();
        finalErrMaplist = new map<Id, String>();
        rrListToUpdate = new List<Realignment_Request_Item__c>();
        rrListToUpdate = rrRecList;
        
        if(is3rdRun){
            submitterEmail = rrListToUpdate[0].Submitter__r.Email;
            ActualApprovalEmail = rrListToUpdate[0].Account_Realignment_Request__r.Approver__r.Email;
            String errorfileHeader = 'RecordID, Account Number, Account, Error message \n';
            run3rdTime = is3rdRun;
            genErrCSVFile = errorfileHeader;  
            filename = 'Account_Realignment_Request_Failed_Rec.csv';        
        }
            
       
    }
    global List<Realignment_Request_Item__c> start(Database.BatchableContext BC)
    {
        return rrListToUpdate;
    }
    global void execute(Database.BatchableContext BC, List<Realignment_Request_Item__c> scope) {  
        if(scope.size() > 0){
            Database.SaveResult [] updateResults = Database.update(scope, false);
            for(Integer i=0;i<updateResults.size();i++){
                    if (!updateResults.get(i).isSuccess()){        
                        
                        if(run3rdTime == false){ 
                            acrErrorIds.add(scope.get(i)); 
                        } else{
                            if(!isFinalError){ 
                                isFinalError = true; 
                            }
                            fileRow = '';  
                            Database.Error error = updateResults.get(i).getErrors().get(0); 
                            String failedDML = error.getMessage(); 
                            fileRow = fileRow +','+ scope.get(i).Id; 
                            fileRow = fileRow +','+ scope.get(i).Account__r.Account_Number__c; 
                            fileRow = fileRow +','+ scope.get(i).Account__r.Name; 
                            fileRow = fileRow +','+ failedDML;
                            fileRow = fileRow.replaceFirst(',',''); 
                            genErrCSVFile = genErrCSVFile + fileRow + '\n'; 
                        }                            
                    }
                }               
            
        }
        
    }
    global void finish(Database.BatchableContext BC)
    {
        if(acrErrorIds.size() > 0 && run3rdTime == false){
            
            RealignmentRequestBatch batch = new RealignmentRequestBatch(acrErrorIds, true);
            Database.executeBatch(batch, 1);
        }else if(isFinalError){
            
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob recBlob = Blob.valueOf(genErrCSVFile);
            csvAttc.setFileName(filename);
            csvAttc.setContentType('text/csv');
            csvAttc.setBody(recBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String subject ='Account_Realignment_Request_Failed_Records';
            email.setSubject(subject);
            
            if(Test.isRunningTest()){
                submitterEmail='usr03122021@test.com';
                ActualApprovalEmail = 'usr04122021@test.com';
            }
            
            String[] toAddresses = new list<string> {submitterEmail, ActualApprovalEmail};
            email.setToAddresses(toAddresses);
            
            email.setPlainTextBody('Hello there, <br/> <br/>'+'Attached is the list of records failed during GART ownership change approval. Please approve these records manually.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        
        
    }
}