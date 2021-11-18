class AccountChanges < ApplicationConsumer
  params_batch.each do |message|
    puts '-' * 80
    p message
    puts '-' * 80

    case message['event_name']
    when 'AccountRoleChanged'
      User.update_by_public_id(message['data']['public_id'], role: message['data']['role'])
    else
      # store events in DB
    end
  end
end