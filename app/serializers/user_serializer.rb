class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :user_name
end