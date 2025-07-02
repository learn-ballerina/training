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
