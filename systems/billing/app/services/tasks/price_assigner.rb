module Tasks
  class PriceAssigner < ApplicationService
    def self.call(task:, randomizer:)
      new(task: task, randomizer: randomizer).call
    end

    def initialize(task:, randomizer:)
      @task = task
      @randomizer = randomizer
    end

    def call
      return @task if @task.assigned_fee >= 1 && @task.completed_amount >= 1

      @task.with_lock do
        @task.assigned_fee = @randomizer.rand(10..20) unless @task.assigned_fee >= 1
        @task.completed_amount = @randomizer.rand(20..40) unless @task.completed_amount >= 1
        @task.save if @task.changed?
      end

      @task
    end
  end
end