import ballerina/file;
import ballerina/io;
import ballerina/log;

listener file:Listener mrfListener = new (path = incomingMRFPath);

service file:Service on mrfListener {
    remote function onCreate(file:FileEvent event) {
        do {
            json jsonResult = check io:fileReadJson(event.name);
            HealthEvent|error healthEvent = jsonResult.cloneWithType(HealthEvent);
            if healthEvent is error {
                log:printError(`Error occurred with parsing json content to type 'HealthEvent'`);
            } else {
                check processHealthEventMrf(healthEvent, getCsvFilePath(event.name));
            }
        } on fail error err {
            log:printError(`Error occurred while processing MRF files at ${incomingMRFPath}`, err);
        }
    }
}
