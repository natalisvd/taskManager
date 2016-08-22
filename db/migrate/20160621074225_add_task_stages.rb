class AddTaskStages < ActiveRecord::Migration
  def change
      create_table :task_stages do |t|
        t.integer :task_id
        t.string :status
        t.timestamps null: false
      end

      add_index :task_stages, :task_id
  end
end
