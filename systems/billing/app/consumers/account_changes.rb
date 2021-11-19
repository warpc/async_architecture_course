class AccountChanges < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case message.payload['event_name']
      when 'AccountCreated'
        # TODO: if you want
      when 'AccountUpdated'
        User.update_data_by_public_id(
          public_id: message.payload['data']['public_id'],
          full_name: message.payload['data']['full_name'],
          position: message.payload['data']['position']
        )
      when 'AccountDeleted'
        # TODO: if you want
      else
        # store events in DB
      end
    end
  end
end