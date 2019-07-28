class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新したよ"
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除したよ"
  end

  def create
    # エラーが発生した際、else以下のrender処理で再び入力した値を渡すため、インスタンス変数に格納する
    # また、Taskオブジェクトの抱えるエラーメッセージをユーザーに見せることもできる
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: "タスク「#{task.name}」をとうろくしたよ"      
    else
      # エラー発生の場合には、画面を再表示して再入力を促す。
      render :new
    end
  end

    private

    def task_params
      params.require(:task).permit(:name, :description)
    end
end
