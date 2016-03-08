class User < ApplicationRecord
  has_many :social_accounts
  validates :name, presence: true
end
