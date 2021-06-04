global class httpCalloutMockImpExecption implements HttpCalloutMock{
 global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('');
        res.setStatusCode(200);        
        return res;
    }
}