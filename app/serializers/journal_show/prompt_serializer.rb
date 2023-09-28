module JournalShow
  class PromptSerializer
     include JSONAPI::Serializer

     attributes :title, :editable, :scheduled_date
  end
end