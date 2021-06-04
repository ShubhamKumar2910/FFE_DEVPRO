global class CIBResponseGeneratorFailuer implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('{"Batch":{"BatchId":54,"BatchStatus":"Falied","BatchReason":"InValid Json","err":"1001:BATXN-00304 - SFTRANID Already Exists"}}');
        res.setStatusCode(400);
        return res;
    }
}