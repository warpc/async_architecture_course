class Accounts < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case message.payload['event_name']
      when 'AccountRoleChanged'
        User.update_role_by_public_id(
          public_id: message.payload['data']['public_id'],
          role: message.payload['data']['role']
        )
      else
        # store events in DB
      end
    end
  end
end