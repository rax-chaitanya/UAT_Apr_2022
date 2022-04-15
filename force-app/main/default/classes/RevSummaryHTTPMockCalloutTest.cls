@isTest
global class RevSummaryHTTPMockCalloutTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.debug('endpoint calling::' + req.getEndpoint());
        System.debug('GET::'+ req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"business":"Americans"}');
        res.setStatusCode(200);
        return res;
    }                
}