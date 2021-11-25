class TaskLifeCycle < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case [message.payload['event_name'], message.payload['event_version']]
      when ['Task.Assigned', 1]
        Task.create_or_update_by_public_id(public_id: message.payload['data']['public_id'])
      when ['Task.Reassigned', 1]
        # Do nothing for current moment
      when ['Task.Completed', 1]
        Task.create_or_update_by_public_id(public_id: message.payload['data']['public_id'])
      else
        # store events in DB
      end
    end
  end
end