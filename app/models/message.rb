class Message < ApplicationRecord
  has_many :users
  has_many :messages
end
