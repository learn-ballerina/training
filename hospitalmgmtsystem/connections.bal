import ballerina/http;

final http:Client httpClient = check new ("http://localhost:9090/info");
