
type Tin record {|
    string 'type;
    string value;
|};

type ProvidersItem record {|
    decimal billed_charge;
    int[] npi;
|};

type PaymentsItem record {|
    decimal allowed_amount;
    ProvidersItem[] providers;
|};

type Allowed_amountsItem record {|
    Tin tin;
    string billing_class;
    PaymentsItem[] payments;
|};

type Out_of_networkItem record {|
    string name;
    string billing_code;
    string billing_code_type;
    string billing_code_type_version;
    string description;
    Allowed_amountsItem[] allowed_amounts;
|};

type HealthEvent record {|
    string reporting_entity_name;
    string reporting_entity_type;
    string last_updated_on;
    string version;
    Out_of_networkItem[] out_of_network;
|};

type HealthEventCsv record {|
    string name;
    decimal allowed_amount;
    decimal billed_charge;
    string npi;
    string billing_code;
    string billing_code_type;
    string description;
|};
