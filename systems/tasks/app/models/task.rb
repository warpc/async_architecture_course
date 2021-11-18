class Task < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  def self.create_task(params:, creator:)
    task = Task.create!(
      creator: creator,
      assigned_to_id: User.which_to_assign_id,
      is_completed: false,
      description: params[:description]
    )
    task.notify_new_assign

    task
  end

  def self.reassign_all_open(initiator)
    where(is_completed: false).find_each { |t| t.assign_to_user }

    event = {
      **tasks_event_data,
      event_name: 'TaskReassigned',
      data: {
        reassigned_by: {
          public_id: initiator.public_id
        }
      }
    }

    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks_life_cycle')
  end

  def self.tasks_event_data
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'task_managment_service',
    }
  end

  def assign_to_user
    update(assigned_to_id: User.which_to_assign_id)
    notify_new_assign
  end

  def notify_new_assign
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
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks_life_cycle')
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

    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks_life_cycle')
  end
end
