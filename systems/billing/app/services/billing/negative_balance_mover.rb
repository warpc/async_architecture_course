module Billing
  class NegativeBalanceMover < ApplicationService
    def self.call(user:, negative_debt_amount:, date:)
      new(user: user, negative_debt_amount: negative_debt_amount, date: date).call
    end

    def initialize(user:, negative_debt_amount:, date:)
      @user = user
      @negative_debt_amount = negative_debt_amount
      @date = date
    end

    def call
      tx = nil
      @user.with_lock do
        tx = @user.transactions.create!(
          amount: @negative_debt_amount,
          reason: "Move negative balance from previous billing period #{@date}"
        )
        @user.save!
      end

      # https://github.com/rails/rails/issues/43279
      # Wihtout realod public_id will be nil
      tx.reload

      # Move to serializer
      event = {
        event_name: 'Billing.NegativeBalance',
        event_version: 1,
        data: {
          public_id: tx.public_id,
          user_public_id: tx.user.public_id,
          amount: tx.amount.to_s('F'),
          date: @date.to_s,
          reason: tx.reason
        }
      }

      Producer.call(event: event, topic: 'billing')
    end
  end
end