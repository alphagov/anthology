FactoryGirl.define do
  factory :book do
    sequence(:title) {|n| "Alice's Adventures in Wonderland ##{n}" }
    sequence(:author) {|n| "Lewis Carroll ##{n}" }
    sequence(:isbn) {|n| "155481#{n}" }
    google_id "cdxf__Ch8QMC"
  end

  factory :user do
    name "Winston Smith-Churchill"
    sequence(:github_id)
  end

  factory :loan do
    user
    copy
    state "on_loan"
    loan_date { Time.now }
    return_date nil
  end

  factory :copy do
    book

    factory :copy_on_loan do
      on_loan true

      after(:create) do |copy, e|
        FactoryGirl.create(:loan, :copy => copy)
      end
    end
  end
end
