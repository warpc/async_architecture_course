class BillingCyclePeriodCloser < ApplicationService
  def self.call
    new.call
  end

  def call
    bc = BillingCycle.create(date: Date.yesterday)
    bc.update(company_profit_amount: Transaction.company_profit_amount(bc.date))

    # https://github.com/rails/rails/issues/43279
    # Wihtout realod public_id will be nil
    bc.reload

    user_ids = Transaction.user_ids_for_billing_period(bc.date)

    User.where(id: user_ids).each do |user|
      amount = Transaction.for_day(bc.date).where(user_id: user_id).sum(:amount)
      next if amount == 0

      if amount > 0
        Payments::Creator.call(user: user, payment_amount: amount, billing_cycle: bc)
      else
        Billing::NegativeBalanceMover.call(user: user, negative_debt_amount: amount, date: bc.date)
      end
    end

    event = {
      event_name: 'Billing.CycleClosed',
      event_version: 1,
      data: {
        public_id: bc.public_id,
        date: bc.date.to_s,
        company_profit_amount: bc.company_profit_amount.to_s("F")
      }
    }

    Producer.call(event: event, topic: 'billing_cycle')
  end
end