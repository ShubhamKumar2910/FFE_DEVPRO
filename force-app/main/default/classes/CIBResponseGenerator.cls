global class CIBResponseGenerator implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('{"Batch":{"BatchId":55,"BatchStatus":"Success","BatchReason":"Valid data"}}');
        res.setStatusCode(200);
        return res;
    }
}