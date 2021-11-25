class Task < ApplicationRecord
  has_many :transactions

  def self.create_or_update_by_public_id(public_id:, params: {})
    task = create_or_find_by!(public_id: public_id)
    task.with_lock { task.update!(**params) } if params.present?

    task
  end
end
