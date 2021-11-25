class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true

  validates :reason, presence: true
  scope :desc, -> { order("id DESC") }
  scope :for_day, ->(day) { where("Date(created_at) = ?", day) }

  def self.user_ids_for_billing_period(day)
    for_day(day).pluck(:user_id).uniq
  end

  def self.company_profit_amount(day)
    -(for_day(day).where.not(task_id: nil).sum(:amount))
  end
end
