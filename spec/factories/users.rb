FactoryBot.define do
  factory :user do
    first_name { 'Sam' }
    last_name { 'Duran' }
    sequence(:email) { |n| "test_email#{n}@example.com" }
    password { 'weak_password' }

    factory :user_with_journals do
      transient do
        journals_count { 2 }
      end

      after(:create) do |user, evaluator|
        journals = build_stubbed_list(:journal, evaluator.journals_count)
        user.journals = journals
      end
    end
  end
end
