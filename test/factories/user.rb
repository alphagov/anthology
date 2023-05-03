FactoryBot.define do
  factory :user do
    name { "Winston Smith-Churchill" }
    sequence(:email) do |n|
      "user#{n}@example.org"
    end
    provider { "google" }
    sequence(:provider_uid)
  end
end
