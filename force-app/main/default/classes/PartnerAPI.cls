public class PartnerAPI{

 public static string sessionId;
 public static string endpoint;
 
 public static String logincall()
 {
           
    DOM.Document doc = new DOM.Document();
        
    String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
    String xsd = 'http://www.w3.org/2001/XMLSchema';
    String partnerNS = 'urn:partner.soap.sforce.com';

    DOM.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'env');
    envelope.setNamespace('xsd', xsd);
    envelope.setNamespace('xsi', xsi);
    
    envelope.addChildElement('Header', soapNS, 'env');
    dom.XmlNode body = envelope.addChildElement('Body', soapNS, 'env');
   
   DOM.XmlNode login = body.addChildElement('login', partnerNS, '');
   System.debug('UserName'+login);
    login.addChildElement('username', null, null).addTextNode('{!$Credential.UserName}');
    login.addChildElement('password', null, null).addTextNode('{!$Credential.password}');
       System.debug('UserName'+login);

    endpoint = 'callout:LiveAgentCredential/services/Soap/u/39.0';
    HTTPResponse res = callout(Doc,endpoint);
    if(res.getStatusCode() == 200)
    {
    Dom.Document respDoc = res.getBodyDocument();
    envelope = respDoc.getRootElement();
      try
      {
      sessionId = envelope.getChildElement('Body',soapNS).getChildElement('loginResponse',partnerNS).getChildElement('result',partnerNS).getChildElement('sessionId',partnerNS).getText();
      endpoint =  envelope.getChildElement('Body',soapNS).getChildElement('loginResponse',partnerNS).getChildElement('result',partnerNS).getChildElement('serverUrl',partnerNS).getText();
      }Catch(Exception e)
      {
        sessionId = '';
        endpoint = '';
      }
    }
    return sessionId;
    
    }
     public static HttpResponse callout(Dom.Document doc,String endPointURL)
 {
  
  HttpRequest req = new HttpRequest();
  req.setEndpoint(endPointURL);
  req.setMethod('POST');
  req.setBodyDocument(doc);
  req.setHeader('Content-Type','text/xml');
  req.setHeader('SOAPAction','Callout');
    System.debug(doc.toXmlString());
  Http http = new Http();
  HTTPResponse res = http.send(req);
    System.debug(res.getBody());
  return res;
 
 }
 }