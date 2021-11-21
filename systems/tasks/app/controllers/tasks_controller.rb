class TasksController < ApplicationController
  before_action :check_authentication
  before_action :set_task, only: %i[ show destroy completed]
  before_action :manager_access?, only: %i[ reassign_tasks ]

  # GET /tasks or /tasks.json
  def index
    @tasks = if current_user.manager_access?
      Task.all
    else
      Task.where(assigned_to: current_user).all
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.create_task(creator: current_user, params: task_params)

    event = {
      event_name: 'Task.Created',
      event_version: 1,
      data: {
        public_id: @task.public_id,
        title: @task.title,
        description: @task.description,
        creator_public_id:  @task.creator.public_id
      }
    }

    Producer.call(event: event, topic: 'tasks_stream')

    event = {
      event_name: 'Task.Assigned',
      event_version: 1,
      data: {
        public_id: @task.public_id,
        assigned_to_public_id: @task.assigned_to.public_id
      }
    }

    Producer.call(event: event, topic: 'tasks_life_cycle')

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def reassign_all_open
    Task.open.each do |task|
      task.assign_to_user

      event = {
        event_name: 'Task.Assigned',
        event_version: 1,
        data: {
          public_id: task.public_id,
          assigned_to_public_id: task.assigned_to.public_id
        }
      }

      Producer.call(event: event, topic: 'tasks_life_cycle')
    end

    event = {
      event_name: 'Task.Reassigned',
      event_version: 1,
      data: {
        reassigned_by_public_id: current_user.public_id
      }
    }
    Producer.call(event: event, topic: 'tasks_life_cycle')

    redirect_to tasks_path
  end

  def completed
    return if @task.assigned_to != current_user
    @task.mark_completed

    event = {
      event_name: 'Task.Completed',
      event_version: 1,
      data: {
        public_id: @task.public_id,
        completed_by_public_id: @task.assigned_to.public_id
      }
    }

    Producer.call(event: event, topic: 'tasks_life_cycle')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description)
    end

  def check_authentication
    redirect_to login_path unless current_user
  end
end
