FactoryBot.define do
  factory :user do
    first_name { 'Sam' }
    last_name { 'Duran' }
    email { 'hello@world.com' }

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