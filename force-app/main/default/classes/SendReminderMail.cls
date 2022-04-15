//SFDC-5451
public class SendReminderMail implements Database.Batchable<sobject>,Database.stateful {
    public map<id,String> usermap= new map<id,String>();
 //global Messaging.SingleEmailMessage[] allmsg= new Messaging.SingleEmailMessage[]{};

    public Database.QueryLocator start(Database.BatchableContext bc)
    { 
        //get all the accounts with the ProcessInstances where Company_Access_Submitter__r is not blank
       string Query = 'select id ,Account_Number__c,company_Number__c ,Company_Access_Submitter__r.name,Company_Access_Submitter__c,ownerId,Owner.email,Owner_Name__C, createddate,Name,(select id,status from  ProcessInstances where status = \'Pending\')  from Account where (Company_Access_Submitter__c !=\'\' OR Company_Access_Submitter__c != null) order by lastmodifieddate desc '; 
        return Database.getQueryLocator(Query);
    }
    public void execute(Database.BatchableContext bc, List<Account> scope)
    {
        
        list<id> prsInstIds = new list<id>();
       
        for(Account acc:scope){
            for(ProcessInstance pi:acc.ProcessInstances){
                prsInstIds.add(pi.id);
            }
            System.debug('prsInstIds..'+prsInstIds);
        }
        
        //get all the processInstanceWorkitem approvals which are in pending  from last seven dats and get the manager(approver email)
        list<processInstanceWorkItem>  piwrkitems= [select id , actorid,actor.email, ProcessInstanceId from processInstanceWorkItem where ProcessInstanceId in :prsInstIds and ElapsedTimeInDays > 7];
        
        System.debug('piwrkitems>>>..'+piwrkitems);
        set<id> userIds= new Set<id>();
        
        for(processInstanceWorkItem piw:piwrkitems){
            userIds.add(piw.actorid);
            
        }
          System.debug('userIds>>>..'+userIds);
        List<user> lstuser= new List<user>();
        
       
        for(user us: [select id,email from user where id IN: userIds]){
         
            
            for(Account acc:scope){
             String AccountLink= URL.getSalesforceBaseUrl().toExternalForm()+'/'+ acc.id;  
              string msgbody=(' Hi, <br/> <br/>'+ +
                                           'This is an email remainder of the company access request <br/>'
                                       + acc.Company_Access_Submitter__r.name + ' has submitted a request to be  the team member of '+acc.Name + 'company record please Approve or Reject the request.'  
                                          +'<br/> Account # :'+ acc.company_Number__c 
                                          +'<br/> Current Owner :'+ acc.Owner_Name__C
                                                +'<br/> Link to HyperLink:'+  '<a href='+AccountLink+'>Account Link</a>'
                                                 +'<br/><br/>Thank you,<br/> SFDC System Administration.');
                                                
                                       
                  
                    
                                         
                usermap.put(us.id,msgbody);
                
            }
            
        }
    }
       
      
    public void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage[] allmsg= new Messaging.SingleEmailMessage[]{};
            System.debug('list of users:'+usermap.size());
       for(id userid: usermap.keySet()){
          
           
           Messaging.SingleEmailMessage Msg= new Messaging.SingleEmailMessage();
                 System.debug('userid:....'+userid);          
                         
                    Msg.setTargetObjectId(userid);                          
                     Msg.saveasActivity=false;
                     Msg.setSubject('Approval pending in last week');
                          Msg.setHtmlBody(usermap.get(userId));
                        allmsg.add(Msg);
                         System.debug('allmsg.....'+allmsg);

       }
        Messaging.SendEmailResult[] rs = Messaging.sendEmail(allmsg,false);
                
                for(Messaging.SendEmailResult ms : rs){
                    if(!ms.isSuccess()){
                        for(Database.Error er : ms.getErrors()){
                            System.debug('Email Error::' + er.getMessage());   
                        }   
                    }
                }

        
    } 
    
}