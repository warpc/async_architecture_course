class TaskChanges < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case [message.payload['event_name'], message.payload['event_version']]
      when ['Task.Created', 1]
        data = message.payload['data']
        # Ignore creator because we do not have logic with him
        params = {
          title: data['title'],
          description: data['description']
        }
        Tasks::Saver.call(public_id: data['public_id'], params: params)
      when ['Task.Created', 2]
        data = message.payload['data']
        # Ignore creator because we do not have logic with him
        params = {
          title: data['title'],
          jira_id: data['jira_id'],
          description: data['description']
        }
        Tasks::Saver.call(public_id: data['public_id'], params: params)
      else
        # store events in DB
      end
    end
  end
end