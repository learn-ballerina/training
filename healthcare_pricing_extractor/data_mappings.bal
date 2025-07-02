import ballerinax/health.fhir.r4.international401;
import ballerina/time;

function mapHealthEventToCsv(HealthEvent healthEvent) returns HealthEventCsv[] => from Out_of_networkItem item in healthEvent.out_of_network
    from Allowed_amountsItem allowedAmount in item.allowed_amounts
    from PaymentsItem paymentsItem in allowedAmount.payments
    from ProvidersItem provider in paymentsItem.providers
    select mapOutNetworkItem(item, paymentsItem.allowed_amount, provider.billed_charge, provider.npi.toString());

function mapOutNetworkItem(Out_of_networkItem outNetworkItem, decimal allowedAmount, decimal billingAmount, string npi) returns HealthEventCsv => {
    allowed_amount: allowedAmount,
    billed_charge: billingAmount,
    npi: npi,
    name: outNetworkItem.name,
    description: outNetworkItem.description,
    billing_code: outNetworkItem.billing_code,
    billing_code_type: outNetworkItem.billing_code_type
};


function mapHealthEventToFhirClaim(HealthEvent healthEvent) returns international401:Claim => {
    insurance: [],
    provider: {
        identifier: {
            value: healthEvent.out_of_network[0].allowed_amounts[0].payments[0].providers[0].npi.toString(),
            system: "http://hl7.org/fhir/sid/us-npi"
        }
    },
    use: "claim",
    patient: {},
    created: getCurrentDateString(),
    priority: {
        coding: [
            {
                code: "normal",
                system: "http://terminology.hl7.org/CodeSystem/processpriority"
            }
        ]
    },
    'type: {
        coding: [
            {
                code: "institutional",
                system: "http://terminology.hl7.org/CodeSystem/claim-type"
            }
        ]
    },
    status: "draft",
    item: mapHealthEventToFhirClaimItems(healthEvent)
};

function getCurrentDateString() returns string {
    time:Utc currentUtc = time:utcNow();
    string utcString = time:utcToString(currentUtc);
    return utcString.substring(0, 10);
}

function mapHealthEventToFhirClaimItems(HealthEvent healthEvent) returns international401:ClaimItem[] => from Out_of_networkItem item in healthEvent.out_of_network
    from Allowed_amountsItem allowedAmount in item.allowed_amounts
    from PaymentsItem paymentsItem in allowedAmount.payments
    from ProvidersItem provider in paymentsItem.providers
    select mapOutNetworkItemToFhirClaimItem(item, paymentsItem.allowed_amount, provider.billed_charge, provider.npi.toString());

function mapOutNetworkItemToFhirClaimItem(Out_of_networkItem outNetworkItem, decimal allowedAmount, decimal billingAmount, string npi) returns international401:ClaimItem => {
    productOrService: {
        text: outNetworkItem.name,
        coding: [
            {
                system: outNetworkItem.billing_code_type,
                'version: outNetworkItem.billing_code_type_version,
                code: outNetworkItem.billing_code
            }
        ]
    },
    sequence: 1,
    unitPrice: {
        value: billingAmount
    }
};