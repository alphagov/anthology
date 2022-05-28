FactoryBot.define do
  factory :copy do
    book

    factory :copy_on_loan do
      on_loan { true }

      after(:create) do |copy, _e|
        FactoryBot.create(:loan, copy:)
      end
    end
  end
end
