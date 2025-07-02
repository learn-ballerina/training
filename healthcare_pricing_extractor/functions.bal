import ballerinax/health.fhir.r4.international401;
import ballerina/io;

function processHealthEventMrf(HealthEvent healthEvent, string csvFileName) returns error? {
    HealthEventCsv[] healthEventCsv = mapHealthEventToCsv(healthEvent);
    check io:fileWriteCsv(csvFileName, healthEventCsv);
    international401:Claim mapHealthEventToFhirClaimResult = mapHealthEventToFhirClaim(healthEvent);
    io:println("Mapped FHIR Claim: ", mapHealthEventToFhirClaimResult);
}

function getCsvFilePath(string mrfFilePath) returns string {
    int startIndex = mrfFilePath.lastIndexOf("/") ?: 0;
    int lastIndex = mrfFilePath.length() - 5;
    return processedCsvPath + mrfFilePath.substring(startIndex, lastIndex) + ".csv";
}
