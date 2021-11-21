class BillingCycle < ApplicationRecord
  has_many :payments
end
