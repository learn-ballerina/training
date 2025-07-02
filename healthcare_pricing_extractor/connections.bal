import ballerinax/health.clients.fhir;

final fhir:FHIRConnector fhirFhirconnector = check new ({
    baseURL: "https://hapi.fhir.org/baseR4"
});
