/**
* File :  HttpServiceCallout.cls
* Description :  This Class is used to make a Http service calls 
* Created Date : 20/Jun/2017 
* Author : RDC
*/

public with sharing class HttpServiceCallout {
    //@Future(callout=true)
    public static HttpResponse HttpRequest(String uri, String httpMethod, String soapAction, String contentType, String body ) {   
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri);
        req.setMethod(httpMethod); 
        req.setHeader('SOAPAction',soapAction); 
        req.setHeader('Content-Type', contentType);
        req.setBody(body);    
        HttpResponse res = h.send(req);  
        return res;
    }
    //@Future(callout=true)
    public static void HttpRequestDelete(String body) {  
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', 'delete'); 
        req.setBody(body);
        req.setCompressed(false);
        req.setEndpoint(System.Label.LiveAgentEndPointURL);
        HTTPResponse resp = h.send(req);
        System.debug(resp.getBody());
    }
    //@Future(callout=true)
    public static void HttpRequestForSkillsAssignment(String uri, String httpMethod, String soapAction, String contentType, String body ) {   
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri);
        req.setMethod(httpMethod); 
        req.setHeader('SOAPAction',soapAction); 
        req.setHeader('Content-Type', contentType);
        req.setBody(body);    
        HttpResponse res = h.send(req);  
        //return res;
    }
}