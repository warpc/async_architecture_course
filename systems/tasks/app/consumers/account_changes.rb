class AccountChanges < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case [message.payload['event_name'], message.payload['event_version']]
      when ['Account.Created', 1]
        User.create_or_update_by_public_id(
          public_id: message.payload['data']['public_id'],
          params: {
            email:     message.payload['data']['email'],
            full_name: message.payload['data']['full_name']
          })
      when ['Account.Updated', 1]
        User.update_data_by_public_id(
          public_id: message.payload['data']['public_id'],
          full_name: message.payload['data']['full_name'],
          position: message.payload['data']['position']
        )
      when ['Account.Deleted', 1]
        # TODO: if you want
      else
        # store events in DB
      end
    end
  end
end