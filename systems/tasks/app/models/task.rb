class Task < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  scope :open, -> { where(is_completed: false) }

  def self.create_task(params:, creator:)
    Task.create!(
      creator: creator,
      assigned_to_id: User.which_to_assign_id,
      is_completed: false,
      title: params[:title],
      description: params[:description]
    )
  end

  def self.all_open
    where(is_completed: false).find_each { |t| t.assign_to_user }
  end

  def assign_to_user
    update(assigned_to_id: User.which_to_assign_id)
  end

  def mark_completed
    update(is_completed: true)
  end
end
