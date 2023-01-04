FactoryBot.define do
  factory :entry do
    trait :with_text do
      text_content { 'Today was wonderful. I had lots of yummy food.' }
    end
  end
end