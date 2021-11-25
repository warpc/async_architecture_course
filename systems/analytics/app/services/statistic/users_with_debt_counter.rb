module Statistic
  class UsersWithDebtCounter < ApplicationService
    def self.call(daily_statistics:)
      new(daily_statistics: daily_statistics).call
    end

    def initialize(daily_statistics:)
      @daily_statistics = daily_statistics
    end

    def call
      @daily_statistics.with_lock do
        @daily_statistics.increment!(:users_with_negative_balance_count)
      end
    end
  end
end