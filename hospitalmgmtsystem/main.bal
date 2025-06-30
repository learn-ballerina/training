import ballerina/http;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /info on httpDefaultListener {
    resource function get patients() returns error|json|http:InternalServerError {
        do {
            Patient patient = {id: "10", firstName: "John", lastName: "Doe", age: 50, address: "40,E.Palm st,Austin", country: "US"};
            return patient;

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    resource function get hospitals() returns error|json {
        do {
            Hospital hospital = {name: "St.David's", streetName: "3301, E.Chavez Blvd", city: "Austin"};
            return hospital;
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}

listener http:Listener portalListner = new (port = 9092);

service /portal on portalListner {
    resource function get patientdata() returns error|json|http:InternalServerError {
        do {
            Patient patient = check httpClient->get("/patients");
            Hospital hospital = check httpClient->get("/hospitals");
            PatientDetails patientDetails = transform(hospital, patient);
            return patientDetails;
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}
