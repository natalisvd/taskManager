class AddAttachFiles < ActiveRecord::Migration
  def change
    create_table :attach_files do |t|
      t.text :path
      t.integer :fileable_id
      t.string :fileable_type
      t.timestamps null: false
    end

    add_index :attach_files, :fileable_id
    add_index :attach_files, :fileable_type
  end
end
