class UserToken < ApplicationRecord
  belongs_to :user
  has_secure_token
end
