/*
* SFDC -5219 and SFDC 5253  Created By Shravan Godha
* Description Company name and Address details will be update in PartnerFund Claim
*Test Class - PartnerFundClaimTrigger_Test 
* Last modified : MAR 2022,Dev- Chaitanya,Jira - SFDC-7279
* 
*/
public class PartnerFundClaimTriggerHelper {
    public static void beforeInsertOperations(List<PartnerFundClaim> fundclaims){
        set<id> request = new set<id>();
        for(PartnerFundClaim PFC: fundclaims){
            if (PFC.RequestId != null) 
                request.add(PFC.RequestId);
            //AccId.add(PFC.ChannelPartnerId);
        }
        if(request.size()>0){
            List<PartnerFundClaim> PFCR=[select id,Status from PartnerFundClaim where RequestId IN :request and Status != 'Rejected'];
            System.debug('PFC are ======>'+PFCR);
            If(PFCR.size()>0){
                fundclaims[0].addError(System.Label.PFC_Morethan_1_Error);
            }
        }
        
        PartnerFundRequest PFR =[SELECT id,MDF_Activity_Name__c,Amount,Eligible_Amount_for_the_event__c,Activity_Start_Date__c,Activity_End_Date__c,Eligible_Activities_Activity_Type__c,
                                 CampaignId,Campaign_Name__c,CreatedDate,Fund_Request_Contact__c,MDF_Administrator__c,Management_Approver__c,Partner_Account_Manager__c,Region__c,Title,
                                 Fund_Request_Contact_Email__c,Fund_Contact_Phone__c,ChannelPartnerId,Description,Rackspace_Request_Approval_Date__c
                                 FROM PartnerFundRequest WHERE id=:request];
        system.debug('PFR' + PFR);
        for(PartnerFundClaim fundclaim: fundclaims){
            fundclaim.MDF_Activity_Name__c=PFR.MDF_Activity_Name__c;
            fundclaim.Title=PFR.MDF_Activity_Name__c;
            fundclaim.Amount=PFR.Amount;
            fundclaim.Amount_to_be_reimbursed__c =PFR.Eligible_Amount_for_the_event__c;
            fundclaim.Activity_Start_Date__c=PFR.Activity_Start_Date__c;
            fundclaim.Activity_End_Date__c=PFR.Activity_End_Date__c;
            fundclaim.Approved_eligible_activities__c=PFR.Eligible_Activities_Activity_Type__c;
            fundclaim.Campaign__c=PFR.Campaign_Name__c;
            fundclaim.Date_Of_Request__c=PFR.Rackspace_Request_Approval_Date__c;
            fundclaim.Fund_Request_Contact__c=PFR.Fund_Request_Contact__c;
            fundclaim.MDF_Administrator__c=PFR.MDF_Administrator__c;
            fundclaim.Management_Approver_Name__c=PFR.Management_Approver__c;
            fundclaim.Partner_Account_Manager_c__c=PFR.Partner_Account_Manager__c;
            fundclaim.Region__c=PFR.Region__c;
            fundclaim.Request__c=PFR.Title;
            fundclaim.Description=PFR.Description;
            system.debug('fundclaim@@@@'  + fundclaim);
        }
        Account Acc = [Select Id,BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode,Name from Account where Id =: PFR.ChannelPartnerId];
        for(PartnerFundClaim fundclaim:fundclaims){
            Fundclaim.Company_Name__c=Acc.Name;
        } 
    }
    
    public static void sendInvoicesAfterApproved(List<PartnerFundClaim> claimList, Map<Id,PartnerFundClaim> oldMap){
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Map<Id,List<Id>> claimIdByContentDocIdMap = new Map<Id,List<Id>>(); 
        Set<Id> claimIdSet=new Set<Id>();
        Set<Id> contentDocIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        List<String> emailAddresses = new List<String>();
        Map<Id,User> userMap = new Map<Id,User>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        Set<Id> contactIdSet = new Set<Id>();
        List<EmailTemplate> templates = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'MDF_Email_to_the_Accounts_Payable_Team'];
        for(PartnerFundClaim claimRecord: claimList){
            if(claimRecord.status == 'Approved' && claimRecord.status != oldMap.get(claimRecord.Id).Status){
                claimIdSet.add(claimRecord.Id);
                contactIdSet.add(claimRecord.Fund_Request_Contact__c);
                userIdSet.add(claimRecord.Partner_Account_Manager_c__c);
                userIdSet.add(claimRecord.Management_Approver_Name__c);
                userIdSet.add(claimRecord.MDF_Administrator__c);
                userIdSet.add(claimRecord.OwnerId);
            }
        }
        
        if(contactIdSet.size()>0){
            for(Contact contRec : [Select Id, Name, Email, Phone from Contact where Id=:contactIdSet]){
                contactMap.put(contRec.Id, contRec );
                
            }
        }
        String emailAddress = System.Label.MDF_AccountsPayableEmailId;
        
        if(userIdSet.size()>0){
            for(User userRecord : [select Id,Email,Name,Phone from User where Id=:userIdSet ]){
                emailAddresses.add(userRecord.Email);
                userMap.put(userRecord.Id, userRecord );
            }
            
            emailAddresses.add(emailAddress );
            List<ContentDocumentLink> claimFiles = [SELECT Id,LinkedEntityId ,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =:claimIdSet];
            for(ContentDocumentLink linkRec : claimFiles ){
                contentDocIdSet.add(linkRec.ContentDocumentId);
                if(claimIdByContentDocIdMap.containsKey(linkRec.LinkedEntityId)){
                    claimIdByContentDocIdMap.get(linkRec.LinkedEntityId).add(linkRec.ContentDocumentId);
                }else{
                    
                    claimIdByContentDocIdMap.put(linkRec.LinkedEntityId,new List<Id>{linkRec.ContentDocumentId});
                }
            }
            
            Map<Id,ContentDocument> contentDocumentMap = new Map<Id,ContentDocument>([Select id, title,filetype,Description from ContentDocument where Id=:contentDocIdSet]);
            Map<Id,Blob> contentDocIdByVersionDataMap = new Map<Id,Blob>();
            List<ContentVersion> contentVersionList = [Select versionData,ContentDocumentId from ContentVersion where ContentDocumentId=:contentDocIdSet];
            for(ContentVersion versionRec: contentVersionList ){
                contentDocIdByVersionDataMap.put(versionRec.ContentDocumentId, versionRec.VersionData);
            }
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'raxpartnerhelp@channel.rackspace.com'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for(PartnerFundClaim claimRecord: claimList){
                IF(claimIdByContentDocIdMap.containsKey(claimRecord.Id)){
                    for(Id contentDocId : claimIdByContentDocIdMap.get(claimRecord.Id)){
                        
                        ContentDocument contDocObj = new ContentDocument();
                        contDocObj = contentDocumentMap.get(contentDocId);
                        
                        //if(contDocObj.Title.Contains('Invoice')){
                        system.debug('file name with case'+contDocObj.Title.Contains('Invoice'));
                        if(contDocObj.Title.containsIgnoreCase('Invoice')){ //SFDC-7279 Updated to containsIgnoreCase to check file name contains invoice without regard to case  
                            system.debug('file name containsignore case'+contDocObj.Title.containsIgnoreCase('Invoice'));
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setContentType('application/pdf');
                            efa.setFileName(contDocObj.Title);
                            
                            
                            efa.Body = contentDocIdByVersionDataMap.get(contentDocId );
                            
                            fileAttachments.add(efa);   
                            if (!templates.isEmpty()) {
                                message.setTemplateId(templates[0].Id);
                                String emailSubject = templates[0].Subject;
                                emailSubject = emailSubject.replace('{!PartnerFundClaim.MDF_Activity_Name__c}',claimRecord.MDF_Activity_Name__c);
                                emailSubject = emailSubject.replace('{!PartnerFundClaim.Request__c}',claimRecord.Request__c);
                                message.setSubject(emailSubject);
                                
                                String htmlBody = templates[0].HtmlValue;
                                htmlBody = htmlBody.replace(']]>', '');
                                decimal amount = claimRecord.Amount;
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Amount}',String.valueOf(amount.format()));
                                decimal amountToBeReimbursed = claimRecord.Amount_to_be_reimbursed__c;
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Amount_to_be_reimbursed__c}',String.valueOf(amountToBeReimbursed.format()));
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Request__c}',claimRecord.Request__c);
                                String startDate = claimRecord.Activity_Start_Date__c.format();
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Activity_Start_Date__c}',startDate );
                                if(claimRecord.Description != null){
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.Description}',claimRecord.Description);
                                }
                                else{
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.Description}','');
                                }
                                String approvalDate = claimRecord.Rackspace_Claim_Approval_Date_Formula__c.format();
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Rackspace_Claim_Approval_Date_Formula__c}',approvalDate );
                                if(userMap.containsKey(claimRecord.Management_Approver_Name__c)){
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.Management_Approver_Name__c}',userMap.get(claimRecord.Management_Approver_Name__c).Name);
                                }else{
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.Management_Approver_Name__c}','');
                                }
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Region__c}',claimRecord.Region__c);
                                htmlBody = htmlBody.replace('{!PartnerFundClaim.Invoice_No__c}',claimRecord.Invoice_No__c);
                                IF(userMap.get(claimRecord.OwnerId).Phone!=null){
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.OwnerPhone}',userMap.get(claimRecord.OwnerId).Phone);
                                }
                                else {
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.OwnerPhone}','');  
                                }
                                if(userMap.containsKey(claimRecord.OwnerId)){
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.OwnerEmail}',userMap.get(claimRecord.OwnerId).Email);
                                }else{
                                    htmlBody = htmlBody.replace('{!PartnerFundClaim.OwnerEmail}','');
                                    
                                }
                                message.setHtmlBody(htmlBody);
                            }
                        }
                    }
                }
                
            }
            message.setFileAttachments(fileAttachments);
            message.setToAddresses(emailAddresses);
            system.debug('message object before email----'+message);
            // SFDC-7279 Update Send EMail call to catch Excetions SFDC-7279
            try{
                if(!test.isRunningTest())
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            }
            catch(System.EmailException e){
                throw new CustomException('------------------------------Please check if invoice is added to Partner Fund Claim.-----------------------'+e.getMessage());
            }
            catch(Exception e) {
                System.debug('Custom Exception Message ===> '+e.getMessage());
               ExceptionHandler.postToAll(e,true);
            }
            
        }
    }
    
    
}