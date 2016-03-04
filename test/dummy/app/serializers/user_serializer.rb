class UserSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :social_accounts
end
