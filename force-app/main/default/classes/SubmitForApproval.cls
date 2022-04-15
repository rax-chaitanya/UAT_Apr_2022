/*
* Last modified : MAR 2022,Dev- Chaitanya,Jira - SFDC-7279
* Test Class -
*/

public class SubmitForApproval {
    
    @AuraEnabled
    public static string  getPartnerfundclaimdata(ID PFCid){
        string returnMessage='' ; 
        boolean hasInvoiceDoc=false;
        try{
            Partnerfundclaim PFCRecord = [Select Id,Status,File_Uploaded__c,MDF_Administrator__c from Partnerfundclaim where Id = : PFCId ];
            //Added by Nanda SFDC-5402
            List<ContentDocumentLink> fundClaimCDList = [SELECT Id,ContentDocumentId,LinkedEntityId,ContentDocument.title FROM ContentDocumentLink where LinkedEntityId =: PFCId ];
            //end SFDC-5402
            //if(PFCRecord.File_Uploaded__c == false){
            if(fundClaimCDList.size()== 0 || fundClaimCDList == null){
                returnMessage ='Please Upload Invoice Before Submiting For Approval '; 
            }
            else if(fundClaimCDList.size()>0 && PFCRecord.status=='Submitted'){
                returnMessage ='Your Request Is Already Sent For Approval'; 
            }
            //SFDC-7279 Update below if method to check if the existing files has Invoice in name while submitting for approval
            else if (fundClaimCDList.size()>0 ){
                for(ContentDocumentLink recfiled:fundClaimCDList)
                {
                    system.Debug(recfiled);
                    if(recfiled.ContentDocument.title.containsIgnoreCase('Invoice') )
                        hasInvoiceDoc=true;
                    
                }
                if(hasInvoiceDoc){
                    system.debug('PFCRecord@@@@@' + PFCRecord);
                    User currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId()];
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Approval Request');
                    req1.setObjectId(PFCRecord.id);
                    req1.setNextApproverIds(new Id[] {PFCRecord.MDF_Administrator__c});
                    system.debug('req1' + req1);
                    // Submit the approval request for the Opportunity
                    Approval.ProcessResult result = Approval.process(req1);
                    system.debug('result@@@@@@@@' + result);
                    returnMessage ='Your Request Is Sent For Approval'; 
                    //system.debug('returnMessage' + returnMessage);
                }
                else{
                    system.debug('no invoice');
                    returnMessage ='Please Upload File with name contains Invoice Before Submiting For Approval';
                }
            }
            
        }
        
        catch(Exception ex){
            
            
        }
        return returnMessage;  
    }
    
}