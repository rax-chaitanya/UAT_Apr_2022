/* 
    Epic: SFDC-5677, User Story: SFDC-5686 and SFDC-5687 This Schedule class trigger 
    on Day 01 of every month(Send Emails to internal CMS Team regarding NPS Qualified Contacts) and 
    every month 2nd Tuesday(Send Qualified NPS Contacts to Qualtrics)
*/

public class NPSContact_Sched implements Schedulable{

    public void execute(SchedulableContext SC){  
        Date month1st = Date.newInstance(Date.Today().year(), Date.Today().month(), 01);          
        sendNPSEmail(month1st,false,'','');                    
    }
    
    public void sendNPSEmail(Date onMonth1st,Boolean isFinalError, String genErrCSVFile, String fileName){

        if(isFinalError || (onMonth1st == Date.today() || (System.Label.TestNPSDate != 'NULL' && (onMonth1st == Date.valueOf(System.Label.TestNPSDate))))){        
            List<User> users = new List<User>();
            List<User> users2 = new List<User>();
            String UserRoleQuery = System.Label.NPSEmailRoleBasedUsersQuery;
            if(UserRoleQuery != 'NULL'){
                users = Database.query(UserRoleQuery);
            }    
            String UserQuery = System.Label.NPSEmailUsersQuery;
            if(UserQuery != 'NULL'){
                users2 = Database.query(UserQuery);
                users.addAll(users2);
            }
            
            if(!users.isEmpty()){
                Set<User> allUsers = new Set<User>();
                allUsers.addAll(users);
                
                Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();                  
                EmailTemplate templateId;
                if(isFinalError){
                    String failedqualTemplateName = System.Label.NPSFailedQualifiedTemplateName;
                    templateId = [SELECT Id,Name,Body,subject FROM EmailTemplate WHERE DeveloperName =: failedqualTemplateName];
                    
                    Blob csvBlob = blob.valueOf(genErrCSVFile);
                    csvAttachment.setFileName(fileName);        
                    csvAttachment.setBody(csvBlob);                    
                }else{    
                    String qualTemplateName = System.Label.NPSQualifiedTemplateName;                                
                    templateId = [SELECT Id,Name,Body,subject FROM EmailTemplate WHERE DeveloperName =: qualTemplateName];
                }
                
                Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};
            
                for(User u : allUsers){     
                    if(u.isActive == true && !u.Email.contains('invalid')){                   
                        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();       
                        semail.setTargetObjectId(u.Id);
                        semail.setTemplateId(templateId.Id);
                        semail.saveAsActivity = false;
                        if(isFinalError){
                            semail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
                        }
                        emails.add(semail);                
                    }
                }   
                
                Messaging.SendEmailResult[] rs = Messaging.sendEmail(emails,false);
                
                for(Messaging.SendEmailResult ms : rs){
                    if(!ms.isSuccess()){
                        for(Database.Error er : ms.getErrors()){
                            System.debug('Email Error::' + er.getMessage());   
                        }   
                    }
                }
           } 
        }else{
            NPSContactEvalua_OR_DistributionList nps = new NPSContactEvalua_OR_DistributionList(null, false);
            Database.executeBatch(nps,10);
        }            
    }
    
}