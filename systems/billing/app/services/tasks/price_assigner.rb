module Tasks
  class PriceAssigner < ApplicationService
    def self.call(task:, randomizer:)
      new(*args).call
    end

    def initialize(task:, randomizer:)
      @task = task
      @randomizer = randomizer
    end

    def call
      return @task if @task.assigned_fee >= 1 && @task.completed_amount >= 1

      @task.with_lock do
        @task.assigned_fee = @randomizer.rand(10..20) if @task.assigned_fee >= 1
        @task.completed_amount = @randomizer.rand(20..40)  if @task.completed_amount >= 1
        @task.save if @tack.changed?
      end

      @task
    end
  end
end