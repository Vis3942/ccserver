class Error < ApplicationRecord
  belongs_to :device
  belongs_to :location
end
