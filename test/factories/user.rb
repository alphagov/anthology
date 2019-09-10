FactoryBot.define do
  factory :user do
    name { 'Winston Smith-Churchill' }
    sequence(:email) {|n|
      "user#{n}@example.org"
    }
    provider { 'google' }
    sequence(:provider_uid)
    sequence(:image_url) {|n|
      "https://example.org/users/#{n}.jpg"
    }
  end
end
