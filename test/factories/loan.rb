# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    user
    copy
    state { 'on_loan' }
    loan_date { Time.now }
    return_date { nil }
  end
end
