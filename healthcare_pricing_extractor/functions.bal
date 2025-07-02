import ballerina/io;
import ballerina/log;
import ballerina/sql;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4.international401;

function processHealthEventMrf(HealthEvent healthEvent, string csvFileName) returns error? {
    HealthEventCsv[] healthEventCsv = mapHealthEventToCsv(healthEvent);
    check io:fileWriteCsv(csvFileName, healthEventCsv);
    check pushToFHIRServer(healthEvent);
    foreach HealthEventCsv eventCSV in healthEventCsv {
        check persistToDatabase(eventCSV);
    }
}

function getCsvFilePath(string mrfFilePath) returns string {
    int startIndex = mrfFilePath.lastIndexOf("/") ?: 0;
    int lastIndex = mrfFilePath.length() - 5;
    return processedCsvPath + mrfFilePath.substring(startIndex, lastIndex) + ".csv";
}

function pushToFHIRServer(HealthEvent healthEvent) returns error? {
    international401:Claim mappedClaimResult = mapHealthEventToFhirClaim(healthEvent);
    io:println("Mapped FHIR Claim: ", mappedClaimResult, " to be pushed to FHIR server\n");
    fhir:FHIRResponse fhirFhirresponse = check fhirFhirconnector->create(mappedClaimResult.toJson());
    io:println("FHIR Response: ", fhirFhirresponse, " for the health event");
}

function persistToDatabase(HealthEventCsv healthEventCsv) returns error? {
    sql:ExecutionResult sqlExecutionresult = check mysqlClient->execute(`INSERT INTO out_of_network_rates (
    name,
    billing_code,
    code_type,
    description,
    allowed_amount,
    billed_charge,
    provider_npi
) VALUES (${healthEventCsv.name}, ${healthEventCsv.billing_code}, ${healthEventCsv.billing_code_type}, ${healthEventCsv.description}, ${healthEventCsv.allowed_amount}, ${healthEventCsv.billed_charge}, ${healthEventCsv.npi})`);
    if sqlExecutionresult.affectedRowCount == 1 {
        log:printInfo("Successfully inserted the health event details to database for the  " + healthEventCsv.name);
    }
}
