FactoryBot.define do
  factory :book do
    sequence(:title) {|n| "Alice's Adventures in Wonderland ##{n}" }
    sequence(:author) {|n| "Lewis Carroll ##{n}" }
    sequence(:isbn) {|n| "155481#{n}" }
    google_id { "cdxf__Ch8QMC" }
  end
end
