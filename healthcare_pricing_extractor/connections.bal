import ballerinax/health.clients.fhir;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

final fhir:FHIRConnector fhirFhirconnector = check new ({
    baseURL: fhirServerURL
});

final mysql:Client mysqlClient = check new (dbHost, dbUsername, dbPassword, dbName, dbPort);