class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).recent
  end

  def show
    # ログインしているユーザー以外が覗こうとしても見つからない
    # @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    # before_actionで@task取得
    # @task = current_user.tasks.find(params[:id])
  end

  def update
    # task = current_user.tasks.find(params[:id])
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新したよ"
  end

  def destroy
    # task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除したよ"
  end

  def create
    # エラーが発生した際、else以下のrender処理で再び入力した値を渡すため、インスタンス変数に格納する
    # また、Taskオブジェクトの抱えるエラーメッセージをユーザーに見せることもできる
    # @task = Task.new(task_params)

    # ユーザーとタスクを紐付けたため、コードを以下のように変更
    @task = current_user.tasks.new(task_params)

    if params[:back].present?
      render :new
      return
    end

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      redirect_to @task, notice: "タスク「#{@task.name}」をとうろくしたよ"      
    else
      # エラー発生の場合には、画面を再表示して再入力を促す。
      render :new
    end
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

    private

    def task_params
      params.require(:task).permit(:name, :description, :image)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
