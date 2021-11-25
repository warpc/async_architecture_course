class Billing < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      case [message.payload['event_name'], message.payload['event_version']]
      when ['Billing.CycleClosed', 1]
        date = Date.parse(message.payload.dig('data', 'date'))
        ds = DailyStatistic.create_or_find_by!(date: date)
        Statistic::DailyCalculator.call(daily_statistics: ds, params: message.payload['data'])
      when ['Billing.NegativeBalance', 1]
        date = Date.parse(message.payload.dig('data', 'date'))
        ds = DailyStatistic.create_or_find_by!(date: date)
        Statistic::UsersWithDebtCounter.call(daily_statistics: ds)
      when ['Billing.Withdrawal', 1]
        data = message.payload['data']
        params = {
          user_public_id: data['user_public_id'],
          task_public_id: data['task_public_id'],
          amount: data['amount'].to_d,
          reason: data['reason']
        }
        Transaction.create_or_update_by_public_id(public_id: data['public_id'], params: params)
      when ['Billing.Deposit', 1]
        data = message.payload['data']
        params = {
          user_public_id: data['user_public_id'],
          task_public_id: data['task_public_id'],
          amount: data['amount'].to_d,
          reason: data['reason']
        }
        Transaction.create_or_update_by_public_id(public_id: data['public_id'], params: params)
      else
        # store events in DB
      end
    end
  end
end