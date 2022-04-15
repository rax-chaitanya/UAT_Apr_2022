/**
* File :CreateBlockVisitorController.cls
* Description : Block the IP Address of the visitors.
* Created Date : 29/Aug/2017
* Author : RDC
*/

public class CreateBlockVisitorController {
    public String blockVisitorLabel {get;set;}
    public String developerName{ get; set; }
    public String description { get; set; }
    public String fromIpAddress { get; set; }
    public String toIpAddress { get; set; }
    public boolean isSelected {get; set; }
   // public boolean liveChatBlockName {get; set; }
    
    public CreateBlockVisitorController(){
        isSelected=true;
    }
    public PageReference save(){
        try{
            String session=  PartnerAPI.logincall();
            List<LiveChatBlockingRule> existingRule = new List<LiveChatBlockingRule>();
            string query;
            String soapbody;  
            String soapHeader='<?xml version="1.0" encoding="utf-8"?>' +
                              '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                              '<SOAP-ENV:Header>'+
                              '<ns2:SessionHeader>'+
                              '<ns2:sessionId>' + session + 
                              '</ns2:sessionId>'+
                              '</ns2:SessionHeader>'+
                              '</SOAP-ENV:Header>'+
                              '<SOAP-ENV:Body>'+
                              '<ns2:create>';
            String soapFooter ='</ns2:create>' +
                               '</SOAP-ENV:Body>'+
                               '</SOAP-ENV:Envelope>';    
            query = 'Select Id from LiveChatBlockingRule where developerName =:developerName';
            if(toIpAddress != null){
                query += ' OR (FromIpAddress =: fromIpAddress AND ToIpAddress =: toIpAddress)';
            }
            else{ 
                query += ' OR FromIpAddress =: fromIpAddress';
            }                   
            existingRule = Database.query(query);  
            if(blockVisitorLabel==''){
                 ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Live Chat Blocking Rule Name is required.') );
                        }
            else if(blockVisitorLabel!='' && developerName==''){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Developer Name is required.') );
            }
            else if(blockVisitorLabel!='' && developerName!='' && fromIpAddress ==''){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'From Ip Address is required.') );
            }
            else if(developerName !=null && fromIpAddress !=null && existingRule.size()>0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Blocking rule already exists.') );
            }
            else{
               //   insert skill
                soapbody +='<ns2:sObjects>'+
                           '<ns1:type>LiveChatBlockingRule</ns1:type>'+
                           '<ns1:Id xsi:nil="true"/>'+
                           '<DeveloperName>' + developerName +'</DeveloperName>'+
                           '<MasterLabel>' + blockVisitorLabel +'</MasterLabel>'+
                           '<Description>' + description+'</Description>'+  
                           '<FromIpAddress>' + fromIpAddress+'</FromIpAddress>';
                if(toIpAddress != null){
                    soapbody += '<ToIpAddress>' + toIpAddress+'</ToIpAddress>';
                }
                             
                       soapbody  +=  '</ns2:sObjects>';   
                HttpResponse response =  HttpServiceCallout.HttpRequest(SoapConstant.partnerSoapEndPoint, 'POST', 'create', 'text/xml', soapHeader + soapbody + soapFooter);
                system.debug('response'+response.getBody());
                if(response.getStatusCode() ==200){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Live Chat Blocking Rule is created.'));
                }
            }
        }
        catch (Exception e) {
             ExceptionHandler.postToAll(e, true);
         }
         return null;
     }

    public PageReference cancel(){
        blockVisitorLabel='';
        developerName='';
        description='';
        fromIpAddress ='';
        toIpAddress = '';
        return null;
    }


}