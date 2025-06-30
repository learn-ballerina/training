# HospitalMgmtSystem

This is a sample integration project demonstrating how to combine patient and hospital data using two HTTP services. The scenario involves retrieving patient and hospital information from a backend service (`Info Service`) and exposing a consolidated response via a frontend service (`Portal Service`).

---

## Sample Payloads

### `Hospital`

```json
{
  "name": "St.David's Hospital",
  "streetName": "430, E.Palm Street",
  "city": "Austin"
}
```

### `Patient`
```json
{
  "id": "102-1234-123",
  "firstName": "John",
  "lastName": "Hickman",
  "age": 31,
  "address": "30, Peter's lane, Austin, TX, 78456",
  "country": "US"
}
```

### `PatientDetails`

```json
{
  "id": "102-1234-123",
  "name": "John Hickman",
  "age": 31,
  "patientAddress": "30, Peter's lane, Austin, TX, 78456",
  "hospitalDetails": {
    "name": "St.David's Hospital",
    "address": "430, E.Palm Street, Austin"
  }
}
```


## Step-by-Step Guide

### 1. Define the types using above sample payloads

### 2. Define a data mapper to return `PatientDetails` 

### 3. Create the **Info Service**

- **Type:** HTTP Service  
- **Base Path:** `/info`  
- **Port:** `9090`

#### Add the following resources:

- **Path:** `/patients`  and **Return Type:** `Patient`
    - Return a sample patient : Declare a variable of Patient type and return it.

        ```Patient patient = {id: "10", firstName: "John", lastName: "Doe", age: 50, address: "40,E.Palm st,Austin", country: "US"};```

- **Path:** `/hospitals` and **Return Type:** `Hospital`
    - Return a sample hospital : Declare a variable of Hospital type and return it.

        ```Hospital hospital = {name: "St.David's", streetName: "3301, E.Chavez Blvd", city: "Austin"};```

### 2. Create the **Portal Service**

- **Type:** HTTP Service  
- **Base Path:** `/portal`  
- **Port:** `9092`

#### Add the following resource:

- **Path:** `/patientdata`  
  - **Return Type:** `PatientDetails`
  - **Steps:**
    - Add an HTTP Client:
    - Invoke:
      - `GET /patients` → map response to `Patient`
      - `GET /hospitals` → map response to `Hospital`
    - Construct and return a combined `PatientDetails` record using data mapper function and return it.

---

## Try the Services

Use your browser, `curl`, or Postman to test the endpoints:

- [http://localhost:9090/info/patients](http://localhost:9090/info/patients)
- [http://localhost:9090/info/hospitals](http://localhost:9090/info/hospitals)
- [http://localhost:9092/portal/patientdata](http://localhost:9092/portal/patientdata)
