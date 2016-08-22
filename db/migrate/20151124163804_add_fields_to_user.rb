class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    add_column :users, :birthday, :date
    add_column :users, :avatar, :text
    add_column :users, :salary, :integer
    add_column :users, :employment_date, :date
    add_column :users, :skype, :string
    add_column :users, :phone, :string
    add_column :users, :name, :string
    add_column :users, :patronymic, :string
    add_column :users, :surname, :string
    add_column :users, :detalies, :text
  end
end
