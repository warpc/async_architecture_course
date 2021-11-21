module Payments
  class Creator < ApplicationService
    def self.call(payment_amount:, user:, billing_cycle:)
      new(*args).call
    end

    def initialize(payment_amount:, user:, billing_cycle:)
      @payment_amount = payment_amount
      @user = user
      @billing_cycle = billing_cycle
    end

    def call
      tx = nil
      payment = nil
      @user.with_lock do
        @user.balance -= @payment_amount
        payment = @user.payments.create!(
          billing_cycle: @billing_cycle,
          amount: @payment_amount
        )
        tx = @user.transactions.create!(
          amount: -@payment_amount,
          reason: "Payment for day #{@billing_cycle.date}. Payment id: #{payment.public_id}"
        )
        @user.save!
      end

      # Move to serializer
      event = {
        event_name: 'Billing.Withdrawal',
        event_version: 1,
        data: {
          public_id: tx.public_id,
          user_public_id: tx.user.public_id,
          amount: tx.amount.to_s('F'),
          reason: tx.reason
        }
      }

      Producer.call(event: event, topic: 'billing')

      Processor.call(payment: payment)
      Notifier.call(payment: payment)
    end
  end
end