FactoryBot.define do
  factory :recurring_prompt do
    title { 'How was today?' }

    trait :annual do
      schedule_type { 'a' }
    end

    trait :daily do
      schedule_type { 'd' }
    end

    trait :monthly do
      schedule_type { 'm' }
    end

    trait :weekly do
      schedule_type { 'w' }
    end
  end
end