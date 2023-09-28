FactoryBot.define do
  factory :prompt do
    title { 'How was today?' }
    journal

    factory :prompt_with_sibling_entries do
       transient do
        sibling_entries_count { 3 }
      end

      after(:create) do |prompt, evaluator|
        build_stubbed_list(:entry, evaluator.sibling_entries_count, :with_text, prompt: prompt)
        entry.reload
      end
    end
  end
end