class Transaction < ApplicationRecord
  scope :for_day, ->(day) { where("Date(created_at) = ?", day) }

  def self.max_deposit_for_day(date)
    tx = for_day(date).order('amount desc').limit(1).first
    return nil, 0 if tx.present?

    return tx.public_id, tx.amount
  end

  def self.create_or_update_by_public_id(public_id:, params: {})
    tx = create_or_find_by!(public_id: public_id, user_public_id: params[:user_public_id])
    tx.with_lock { tx.update!(**params) } if params.present?

    tx
  end
end
