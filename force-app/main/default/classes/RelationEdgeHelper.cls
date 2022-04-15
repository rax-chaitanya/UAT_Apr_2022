public class RelationEdgeHelper{
    
    @future(callout=true)
    public static void createRELead(Set<id> RELids)
    {
        String qry = '';
        String payLoad='';
        String Ids = '';
        for(Id i:RELids)
        {
            Ids += '\''+i+'\','; 
        }
        for(Rax2RE_Field_Mapping__c re: Rax2RE_Field_Mapping__c.getAll().values()){
            qry += re.Name + ',';
        }

        qry = 'SELECT '+qry.subString(0,qry.length()-1)+ ' from RelationEdge_Lead__c where Id IN ('+Ids.subString(0,Ids.Length()-1)+')';
        
        System.debug('###:'+qry);
             
        for(RelationEdge_Lead__c RElead: Database.query(qry))
        {
            payLoad=Label.RE_Lead_payload;
            for(Rax2RE_Field_Mapping__c re: Rax2RE_Field_Mapping__c.getAll().values()){
                
                    if(RElead.get(re.Name) == null ){
                        payLoad += re.RE_Field__c+'='+''+'&';
                    }else{
                        payLoad += re.RE_Field__c+'='+RElead.get(re.Name)+'&';
                    }
                
            }
           
            payLoad+='submit=Submit';
            
            system.debug('****This is my REL payload: ' + payload);
            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();

            if(Label.Prod_Org_ID==UserInfo.getOrganizationId())
                req.setEndpoint(label.RE_Lead_ProdEndpoint);
            else
                req.setEndpoint(label.RE_Lead_StagingEndpoint);
            
            System.debug('####_REQUEST:'+req);
            req.setMethod('POST');
            req.setBody(payLoad);
            res = http.send(req);
            System.debug(res.toString());
        }
    }  
 
}

//endpoint = 'https://test.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8'
//payLoad='oid=00D0R0000000UYj&retURL=http://www.rackspace-thank-you-page.com&lead_source=Rackspace&debug=1&debugEmail=mohan.pk@rackspace.com&
//first_name=Lead2&last_name=Lead2&email=WEARTTU@xyz.com&company=ERGTHYDUK&title=efrtgyhuk&phone=ertydt&description=ergtyd&submit=Submit';