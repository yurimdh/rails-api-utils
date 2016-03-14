class User < ApplicationRecord
  has_secure_password

  has_many :social_accounts
  validates :name, presence: true
end
