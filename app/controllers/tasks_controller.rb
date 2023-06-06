class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    if params[:sort_deadline_on]
      tasks = current_user.tasks.sort_deadline_on.sort_created_at
    elsif params[:sort_priority]
      tasks = current_user.tasks.sort_priority.sort_created_at
    else
      tasks = current_user.tasks.sort_created_at
    end
    
    if params[:search].present?
      if params[:search][:status].present? && params[:search][:title].present?
        tasks = tasks.search_status(params[:search][:status]).search_title(params[:search][:title])
      elsif params[:search][:status].present?
        tasks = tasks.search_status(params[:search][:status])
      elsif params[:search][:title].present?
        tasks = tasks.search_title(params[:search][:title])
      end
    end

    @tasks = tasks.page(params[:page]).per(10)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    current_user_required(@task.user)
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    current_user_required(@task.user)
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: t('.created') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t('.updated') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:titre, :content, :deadline_on, :priority, :status)
    end
end
