global class NotifyUnconvertedLeadBatch Implements Schedulable, Database.Batchable<sObject>
{ 

    global database.queryLocator start(Database.BatchableContext BC) 
    {
        return database.getQueryLocator([SELECT Id,PAM_email__c ,Lead_ID__c,PAMs_Manager__c,Owner.Name,Company, Partner_Company_Name__c ,Name
                                         FROM Lead WHERE 
                                         LeadSource='Partner Network' AND IsConverted = false AND Status!='Pending Approval' 
                                         AND Status!='Unqualified - To Lead Gen'AND Status!='Unqualified - To Marketing' AND 
                                         Lead_Owner_Profile_Name__c=:System.Label.Seller_Profiles_For_Partner_Lead.split(',') AND Current_Owner_Assigned_Date__c=:integer.valueOf(System.Label.LeadNotConvertedDays)]); 
    } 
    
    global void execute(Database.BatchableContext BC, List<Lead> leads) 
    { 
        List<Messaging.SingleEmailMessage> LstSendingMails = new List<Messaging.SingleEmailMessage>();
        
   

        for(Lead ObjLead : leads){ 
            List<String> LstLeadEmails = New list<String>();
            if(String.isNotBlank(ObjLead.PAM_email__c))
                LstLeadEmails.add(ObjLead.PAM_email__c); 
            
            if(String.isNotBlank(ObjLead.PAMs_Manager__c))
                LstLeadEmails.add(ObjLead.PAMs_Manager__c); 
            
            LstLeadEmails.addAll(System.Label.NotifyPartnerEmail.split(','));
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
		    msg.setSubject('A Partner Lead has been assigned for 2 weeks and has not been converted');
			msg.setHtmlBody('<b>A Partner Lead has been assigned for 2 weeks and has not been converted </b><br/><br/>'+'<b>Owner: </b>'+ ObjLead.Owner.Name +'<br/><b>Lead ID </b>:'+ObjLead.Lead_ID__c+'<br/><b>Name </b>:'+ ObjLead.Name+'<br/><b>Company </b>:'+ObjLead.Company+'<br/><b>Partner Company </b>:'+ObjLead.Partner_Company_Name__c+'<br/><b>Link</b>: ' + Url.getSalesforceBaseUrl().toExternalForm()+'/'+ObjLead.id+'<br/><br/><br/><br/>Thanks,'+'<br/>Channel Operations team');
			msg.setToAddresses(LstLeadEmails);
            LstSendingMails.add(msg);
            
        }
        if(!LstSendingMails.isEmpty())
            
            Messaging.sendEmail(LstSendingMails);
        
    } 
    global void finish(Database.BatchableContext BC) {
        
    }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
}