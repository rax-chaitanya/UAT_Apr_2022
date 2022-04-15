/**
 * @description       : SFDC- 7195 - Email notification to Partner Contact when Sharing Notes On Opporutnities
 * @author            : Rishabh Anand
 * @group             : 
 * @last modified on  : 03-16-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class PartnerRolesEmailController {

    public static void processOpportunities(Set<Id> notesOppId){

        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        EmailTemplate  et = [Select Id,Name from EmailTemplate where Name = 'Partner Role Email Template'];
        String owEmailAddressId = generateOWEmailId();

        for (Partner_Role__c partnerRoles : [SELECT Id,Name,Opportunity__c,
                                              Partner_Contact__c,Partner_Contact__r.Email,Partner_Company__c,
                                              Opportunity__r.Name
                                              FROM Partner_Role__c WHERE Opportunity__c IN: notesOppId])
            {
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                
                msg.toaddresses=new string[]{partnerRoles.Partner_Contact__r.Email};
                String mailbody = '';
                mail1.setSubject('A Note has been added on Opportunity'+ partnerRoles.Opportunity__r.Name);
                msg= Messaging.renderStoredEmailTemplate(et.id, null, partnerRoles.Id); 
                mailbody = string.valueof(msg.getHtmlBody()) + mailbody; 
                mail1.setHtmlBody(mailbody);
                mail1.toaddresses=new string[]{partnerRoles.Partner_Contact__r.Email};  
                mail1.setOrgWideEmailAddressId(owEmailAddressId);            
                mail1.setWhatId(partnerRoles.Id);
                mail1.setSaveAsActivity(true);
                mail1.setTargetObjectId(partnerRoles.Partner_Contact__r.Id);
                lstMsgs.add(mail1);
            }

        try{  
            if(!lstMsgs.isEmpty()){
                Messaging.sendEmail(lstMsgs);
            }
        } 
        catch(exception ex){
            System.debug(LoggingLevel.Debug,'Unable to send email. Exception message :::'+ex.getMessage());
            ExceptionHandler.postToAll(ex);
        }
    }

    public static String generateOWEmailId(){
        
        String owEmailAddressId='';
        String owEmailDisplayName = 'SF Email Alert';
        List<OrgWideEmailAddress> owea = new List<OrgWideEmailAddress>();

        owea = [SELECT Address,DisplayName FROM OrgWideEmailAddress where DisplayName =: owEmailDisplayName LIMIT 1];
        if (!owea.isEmpty()){
            owEmailAddressId = owea[0].Id;
        }
        return owEmailAddressId;
    }
}