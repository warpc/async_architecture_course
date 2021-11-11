class AccountChanges < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case message['event_name']
      when 'AccountCreated'
        # TODO: if you want
      when 'AccountUpdated'
        User.update_by_public_id(
          public_id: message['data']['public_id'],
          full_name: message['data']['full_name'],
          position: message['data']['position']
        )
      when 'AccountDeleted'
        # TODO: if you want
      else
        # store events in DB
      end
    end
  end
end