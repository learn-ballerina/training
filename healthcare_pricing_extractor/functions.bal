import ballerina/io;

function processHealthEventMrf(HealthEvent healthEvent, string csvFileName) returns error? {
    HealthEventCsv[] healthEventCsv = mapHealthEventToCsv(healthEvent);
    check io:fileWriteCsv(csvFileName, healthEventCsv);
}

function getCsvFilePath(string mrfFilePath) returns string {
    int startIndex = mrfFilePath.lastIndexOf("/") ?: 0;
    int lastIndex = mrfFilePath.length() - 5;
    return processedCsvPath + mrfFilePath.substring(startIndex, lastIndex) + ".csv";
}
