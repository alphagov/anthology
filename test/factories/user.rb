FactoryGirl.define do
  factory :user do
    name "Winston Smith-Churchill"
    sequence(:github_id)
  end
end
