# typed: false
FactoryBot.define do
  factory :loan do
    user
    copy
    state { "on_loan" }
    loan_date { Time.zone.now }
    return_date { nil }
  end
end
