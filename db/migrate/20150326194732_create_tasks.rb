class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description, default: ''
      t.integer :project_id
      t.integer :executor_id
      t.integer :parent_id
      t.string  :status
      t.integer :time_estimate
      t.integer :elapsed_time
      t.date :release_date
      t.timestamps null: false
    end
    add_index :tasks, :project_id
    add_index :tasks, :parent_id
    add_index :tasks, :executor_id
  end
end
