class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_name
  has_many :social_accounts

  def user_name
    object.name
  end
end
