FactoryBot.define do
  factory :journals_user do
    user_role { 'participant' }

    trait :as_admin do
      user_role { 'admin' }
    end

    trait :as_participant do
      user_role { 'participant' }
    end

    trait :as_prompt_writer do
      user_role { 'prompt_writer' }
    end

    trait :as_viewer do
      user_role { 'viewer' }
    end
  end
end