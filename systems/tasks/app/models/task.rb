class Task < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  def self.create_task(params:, creator:)
    Task.create!(
      creator: creator,
      assigned_to: User.which_to_assign,
      is_completed: false,
      description: params[:description]
    )
    bi_notify_new_assign
  end

  def self.reassign_tasks(initiator)
    Tasks.where(is_completed: false).find_each(100) { |t| t.assign_to_user }

    event = {
      **self.class.tasks_event_data,
      event_name: 'TaskReassigned',
      data: {
        reassigned_by: {
          public_id: initiator.public_id
        }
      }
    }

    WaterDropProducer.sync_call(event.to_json, topic: 'tasks_life_cycle')
  end

  def self.tasks_event_data
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'tasks_service',
    }
  end

  def assign_to_user
    task.update(assigned_to: User.which_to_assign)
    bi_notify_new_assign
  end

  def bi_notify_new_assign
    event = {
      **self.class.tasks_event_data,
      event_name: 'TaskAssigned',
      data: {
        public_id: public_id,
        assigned_to: {
          public_id: assigned_to.public_id
        }
      }
    }
    WaterDropProducer.sync_call(event.to_json, topic: 'tasks_life_cycle')
  end

  def mark_completed
    update(:is_completed, true)
    event = {
      **self.class.tasks_event_data,
      event_name: 'TaskCompleted',
      data: {
        public_id: public_id,
        completed_by: {
          public_id: assigned_to.public_id
        }
      }
    }

    WaterDropProducer.sync_call(event.to_json, topic: 'tasks_life_cycle')
  end
end
