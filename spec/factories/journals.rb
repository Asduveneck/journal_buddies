FactoryBot.define do
  factory :journal do
    name { 'My personal reflections' }
    description { 'Simple questions about the mundane daily life' }
  
  
    factory :journal_with_both_prompts_and_users do
      transient do
        recurring_prompts_count { 3 }
        prompts_count { 3 }
        users_count { 3 }
      end

      recurring_prompts do
        Array.new(recurring_prompts_count) { association(:recurring_prompt) }
      end

      prompts do
        Array.new(prompts_count) { association(:prompt) }
      end

      # needs to be randomized:
      # users do
      #   Array.new(users_count) { association(:user) }
      # end
    end
  end
end