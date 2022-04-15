/**********************************************************************************

Author: Sundarayya e
Description: This clss is used to Post data opp ddi and quote id to webhook from opp trigger and bacthc class.
date : 07/05/2021

**********************************************************************************/
public class RsvcWebhookHandler {
    
    public static void postDataToWebhook(list<opportunity> oppList){
        try{
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId() limit 1];
        List<cLog__c> errorRecList = new List<cLog__c>();
        List<Opportunity> listOppToUpdate = new List<Opportunity>();
        if(!oppList.isEmpty()){
            JSONGenerator genn = JSON.createGenerator(true);
            
            for(Opportunity opp :oppList){
                genn.writeStartObject();
                genn.writeStringField('domain_id', opp.ddi__c);
                if(opp.quote_id__c != null)
                    genn.writeStringField('quote_id', opp.quote_id__c);
                if(opp.quote_id__c  == null)
                    genn.writeStringField('quote_id', '');
                genn.writeEndObject();
                
                
                Http ht = new Http();
                HttpRequest req1 = new HttpRequest();
                if(org.IsSandbox)
                    req1.setEndpoint('callout:dev_rsvc_rackspace_Credentials');
                if(!org.IsSandbox)
                    req1.setEndpoint('callout:Prod_rsvc_Named_Credentials');
                req1.setHeader('Content-Type','application/json');
                req1.setHeader('Accept','application/json');
                //req1.setHeader('Content-Length', '198');
                //req1.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf('sfdcrsvc:ewov75*(XMppx%43TG!)')));
                req1.setMethod('POST');
                req1.setTimeout(2 *60 * 1000);
                String jsonString = genn.getAsString();
                system.debug('jsonString'+jsonString);
                req1.setBody(jsonString);
                system.debug('req1'+req1);
                HttpResponse res = ht.send(req1);
                system.debug('response'+res);
                system.debug('response'+res.getBody());
                system.debug('response'+res.getStatus());
                
                if(res.getStatusCode() == 201){
                    Opportunity oppRec = new Opportunity(Id = Opp.Id);
                    oppRec.Integration_Type__c = 'RSVC';
                    oppRec.Integration_Status__c = 'Success';
                    oppRec.Integration_Status_Code__c = String.valueof(res.getStatusCode());
                    listOppToUpdate.add(oppRec);
                }else {
                    system.debug('entered to error');
                    Opportunity oppRec = new Opportunity(Id = Opp.Id);
                    oppRec.Integration_Type__c = 'RSVC';
                    oppRec.Integration_Status__c = 'Failure';
                    oppRec.Integration_Status_Code__c = String.valueof(res.getStatusCode());
                    listOppToUpdate.add(oppRec);
                    cLog__c clogRec = new cLog__c();
                    clogRec.Name = opp.Name ;
                    clogRec.Action_Name__c = 'RSVC Web hook';
                    clogRec.Error_Description__c = res.getBody();
                    errorRecList.add(clogRec);
                    
                }
            }
        }
        if(errorRecList.size() > 0) Insert errorRecList;
        if(listOppToUpdate.size() > 0) update listOppToUpdate;
        }catch(Exception e){
            
            cLog__c clogRec = new cLog__c();
                clogRec.Name = 'RSVC Error' ;
                clogRec.Action_Name__c = 'RSVC Web hook';
                clogRec.Error_Description__c = e.getMessage();
            Insert clogRec;
        } 
    }
}