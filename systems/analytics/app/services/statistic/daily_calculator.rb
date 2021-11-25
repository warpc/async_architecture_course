module Statistic
  class DailyCalculator < ApplicationService
    def self.call(daily_statistics:, params: {})
      new(daily_statistics: daily_statistics, params: params).call
    end

    def initialize(daily_statistics:, params: {})
      @daily_statistics = daily_statistics
      @params = params
    end

    def call
      @daily_statistics.with_lock do
        task_id, amount = Transaction.max_deposit_for_day(@daily_statistics.date)
        @daily_statistics.update(
          company_profit_amount: params['company_profit_amount'].to_d,
          most_expensive_task_public_id: task_id,
          most_expensive_task_price: amount
        )
      end
    end
  end
end