class TaskLifeCycle < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case [message.payload['event_name'], message.payload['event_version']]
      when ['Task.Assigned', 1], ['Task.CagedBird', 1]
        task = Tasks::Saver.call(public_id: message.payload['data']['public_id'])

        assigned_to_id = message.payload.dig('data', 'assigned_to_public_id')
        assigned_user = User.create_or_find_by(public_id: assigned_to_id)
        Tasks::Withdrawal.call(task: task, assigned_to: assigned_user)
      when ['Task.Reassigned', 1]
        # Do nothing for current moment
      when ['Task.Completed', 1], ['Task.MilletInBowl', 1]
        task = Tasks::Saver.call(public_id: message.payload['data']['public_id'])

        completed_by_id = message.payload.dig('data', 'completed_by_public_id')
        completed_by_user= User.create_or_find_by(public_id: completed_by_id)
        Tasks::Deposit.call(task: task, completed_by: completed_by_user)
      else
        # store events in DB
      end
    end
  end
end