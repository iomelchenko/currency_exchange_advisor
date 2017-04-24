supported_currencies = { 36 => 'AUD', 975 => 'BGN', 986 => 'BRL',
                         124 => 'CAD', 756 => 'CHF', 156 => 'CNY',
                         203 => 'CZK', 208 => 'DKK', 978 => 'EUR',
                         826 => 'GBP', 344 => 'HKD', 191 => 'HRK',
                         348 => 'HUF', 360 => 'IDR', 376 => 'ILS',
                         356 => 'INR', 392 => 'JPY', 410 => 'KRW',
                         484 => 'MXN', 458 => 'MYR', 578 => 'NOK',
                         554 => 'NZD', 608 => 'PHP', 985 => 'PLN',
                         946 => 'RON', 643 => 'RUB', 752 => 'SEK',
                         702 => 'SGD', 764 => 'THB', 949 => 'TRY',
                         840 => 'USD', 710 => 'ZAR' }

supported_currencies.each_pair do |key, value|
  Currency.create(id: key, name: value)
end
