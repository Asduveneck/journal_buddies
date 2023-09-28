module JournalShow
  class RecurringPromptSerializer
     include JSONAPI::Serializer

     attributes :title, :start_date, :schedule_interval, :schedule_type
  end
end