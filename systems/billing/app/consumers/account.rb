class Accounts < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case [message.payload['event_name'], message.payload['event_version']]
      when ['Account.RoleChanged', 1]
        User.create_or_update_by_public_id(
          public_id: message.payload['data']['public_id'],
          params: { role: message.payload['data']['role'] }
        )
      else
        # store events in DB
      end
    end
  end
end