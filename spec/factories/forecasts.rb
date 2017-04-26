FactoryGirl.define do
  factory :forecast do
    base_currency_id   840
    target_currency_id 985
    term_in_weeks      7
    amount             1000
  end
end
