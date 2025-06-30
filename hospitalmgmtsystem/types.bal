
type Patient record {|
    string id;
    string firstName;
    string lastName;
    int age;
    string address;
    string country;
|};

type Hospital record {|
    string name;
    string streetName;
    string city;
|};

type HospitalDetails record {|
    string name;
    string address;
|};

type PatientDetails record {|
    string id;
    string name;
    int age;
    string patientAddress;
    HospitalDetails hospitalDetails;
|};
