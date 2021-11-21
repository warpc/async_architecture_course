class AddBillingCycleReferenceToPayment < ActiveRecord::Migration[6.1]
  def change
    add_reference :payments, :billing_cycle, null: false, foreign_key: true
  end
end
