FactoryBot.define do
  factory :user do
    name { "Winston Smith-Churchill" }
    sequence(:email) do |n|
      "user#{n}@example.org"
    end
    provider { "google" }
    sequence(:provider_uid)
    sequence(:image_url) do |n|
      "https://example.org/users/#{n}.jpg"
    end
  end
end
