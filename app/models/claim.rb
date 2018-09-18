class Claim < ApplicationRecord
  validates :customer_id, :exposure, :date_of_origination, :presence => true
end
