import ballerina/io;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4.international401;

function processHealthEventMrf(HealthEvent healthEvent, string csvFileName) returns error? {
    HealthEventCsv[] healthEventCsv = mapHealthEventToCsv(healthEvent);
    check io:fileWriteCsv(csvFileName, healthEventCsv);
    international401:Claim mappedClaimResult = mapHealthEventToFhirClaim(healthEvent);
    io:println("Mapped FHIR Claim: ", mappedClaimResult);
    fhir:FHIRResponse fhirFhirresponse = check fhirFhirconnector->create(mappedClaimResult.toJson());
    io:println("FHIR Response: ", fhirFhirresponse);
}

function getCsvFilePath(string mrfFilePath) returns string {
    int startIndex = mrfFilePath.lastIndexOf("/") ?: 0;
    int lastIndex = mrfFilePath.length() - 5;
    return processedCsvPath + mrfFilePath.substring(startIndex, lastIndex) + ".csv";
}
