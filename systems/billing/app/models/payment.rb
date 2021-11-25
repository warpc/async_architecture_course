class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :billing_cycle

  enum status: { not_paid: 0, processing: 1, paid: 2, paid_failed: 3}
end
