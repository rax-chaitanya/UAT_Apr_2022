/********************************************************
Class created for testing mock XML response
********************************************************/

@isTest
global class MockHttpResponseGenerator_xml implements HttpCalloutMock {

                      
            global HTTPResponse respond(HTTPRequest req) {  
         HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml');
            res.setBody('<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> </soap:Body> </soap:Envelope>');
             res.setStatusCode(200);
              return res;
    }
     
}