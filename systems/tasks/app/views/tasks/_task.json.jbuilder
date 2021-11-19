json.extract! task, :id, :public_id, :title, :description, :creator_id, :assigned_to_id, :created_at, :updated_at
json.url task_url(task, format: :json)
