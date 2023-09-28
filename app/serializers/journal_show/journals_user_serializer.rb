module JournalShow
  class JournalsUserSerializer
     include JSONAPI::Serializer

      belongs_to :user, serializer: JournalShow::UserSerializer, id_method_name: :user_id
      attributes :user_id, :user_name, :first_name, :last_name

      attribute :user_name do |object|
        object.user.user_name
      end

      attribute :first_name do |object|
        object.user.first_name
      end

      attribute :last_name do |object|
        object.user.last_name
      end
  end
end