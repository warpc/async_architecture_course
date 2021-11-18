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
      **Task.tasks_event_data,
      event_name: 'TaskCreated',
      data: { public_id: @task.public_id, description: @task.description, creator: { public_id: @task.creator.public_id } }
    }

    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks_stream')

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
    Task.reassign_all_open(current_user)

    redirect_to tasks_path
  end

  def completed
    return if @task.assigned_to != current_user
    @task.mark_completed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:description)
    end

  def check_authentication
    redirect_to login_path unless current_user
  end
end
