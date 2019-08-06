class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  def up
    # 今まで作られたタスクを削除
    # 既存のタスクに紐づくユーザーを決められずNOT NULL制約にひっかかるため
    execute 'DELETE FROM tasks';
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, index: true
  end
end
