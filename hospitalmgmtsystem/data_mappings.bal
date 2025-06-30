function transform(Hospital hospital, Patient patient) returns PatientDetails => {
    name: patient.firstName + " " + patient.lastName,
    id: patient.id,
    patientAddress: patient.address,
    hospitalDetails: {name: hospital.name, address: hospital.streetName + "," + hospital.city},
    age: patient.age
};