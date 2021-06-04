global class HttpCalloutMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"asd12123","expires_in": 100,"refresh_token":"asasda123213","emails": [{"value": "abcmockuser@gmail.com","type": "account"}],"email":"abcmockuser@fb.com"}');
        res.setStatusCode(200);        
        return res;
    }

}