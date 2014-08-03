FactoryGirl.define do  
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
