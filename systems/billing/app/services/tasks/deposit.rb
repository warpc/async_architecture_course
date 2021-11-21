module Tasks
  class Deposit < ApplicationService
    def self.call(task:, completed_by:)
      new(*args).call
    end

    def initialize(task:, completed_by:)
      @task = task
      @completed_by = completed_by
    end

    def call
      tx = nil

      @completed_by.with_lock do
        @completed_by.balance += @task.completed_amount
        tx = @completed_by.transactions.create!(
          amount: @task.completed_amount,
          task: @task,
          reason: "Completed task #{@task.public_id}"
        )
        completed_by.save!
      end

      # Move to serializer
      event = {
        event_name: 'Billing.Deposit',
        event_version: 1,
        data: {
          public_id: tx.public_id,
          task_public_id: tx.task.public_id,
          user_public_id: tx.user.public_id,
          amount: tx.amount.to_s('F'),
          reason: tx.reason
        }
      }

      Producer.call(event: event, topic: 'billing')
    end
  end
end