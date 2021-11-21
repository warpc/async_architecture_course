module Tasks
  class Withdrawal < ApplicationService
    def self.call(task:, assigned_to:)
      new(*args).call
    end

    def initialize(task:, assigned_to:)
      @task = task
      @assigned_to = assigned_to
    end

    def call
      tx = nil
      @assigned_to.with_lock do
        @assigned_to.balance -= @task.assigned_fee
        tx = @assigned_to.transactions.create!(
          amount: -@task.assigned_fee,
          task: @task,
          reason: "Assigned task #{@task.public_id}"
        )
        @assigned_to.save!
      end

      # Move to serializer
      event = {
        event_name: 'Billing.Withdrawal',
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