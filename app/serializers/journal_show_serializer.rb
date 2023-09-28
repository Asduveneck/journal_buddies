class JournalShowSerializer 
  include JSONAPI::Serializer

  attributes :name, :description, :private_read, :prompts, :recurring_prompts, :journals_users

  has_many :prompts, serializer: JournalShow::PromptSerializer
  has_many :recurring_prompts, serializer: JournalShow::RecurringPromptSerializer
  has_many :journals_users, serializer: JournalShow::JournalsUserSerializer
end

# An example response from running the test. Almost but not quite?

'''
{
  "data"=>
    {
      "id"=>"1046",
      "type"=>"journal_show",
      "attributes"=> {
        "name"=>"First journal",
        "description"=>"Simple questions about the mundane daily life",
        "private_read"=>true
      },
        "relationships"=> {
          "prompts"=> {
            "data"=> [
              {"id"=>"432", "type"=>"prompt"},
              {"id"=>"433", "type"=>"prompt"}
            ]
          },
          "recurring_prompts"=>{
            "data"=> [
              {"id"=>"200", "type"=>"recurring_prompt"}]
            },
            "journals_users"=>{
              "data"=>[
                {"id"=>"627", "type"=>"journals_user"},
                {"id"=>"628", "type"=>"journals_user"},
                {"id"=>"629", "type"=>"journals_user"}]
              }}}}
'''