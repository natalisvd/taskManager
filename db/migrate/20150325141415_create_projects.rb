class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description, default: ''
      t.integer :creator_id, null: false
      t.timestamps null: false
    end
    create_table :user_to_projects do |t|
      t.integer :user_id
      t.integer :project_id
      t.timestamps null: false
    end
    add_index :projects, :creator_id
    add_index :user_to_projects, :user_id
    add_index :user_to_projects, :project_id
  end
end