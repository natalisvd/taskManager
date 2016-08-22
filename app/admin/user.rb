ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :name, :surname, :patronymic, :role, :detalies, :birthday, :avatar, :salary, :employment_date, :skype, :phone
  after_create do |user|
    UserMailer.welcome_email(user).deliver_now

  end

  index do
    column :surname
    column :name
    column :patronymic
    column :email
    column :role
    column :birthday
    column :salary
    column :employment_date
    column :skype
    column :phone
    column :avatar
    column :detalies
    actions
  end
  form do |f|
    f.input :surname
    f.input :name
    f.input :patronymic
    f.input :email
    f.input :password
    f.input :password_confirmation
    f.input :role, as: :radio, collection: { Administrator: "admin", leadership: "leadership", manager: "manager",  developer: "developer", intern: "intern"}
    f.input :birthday,start_year: 1980,end_year: 2020

    f.input :salary
    f.input :employment_date
    f.input :skype
    f.input :phone
    f.input :avatar
    f.input :detalies
    f.actions
  end

end
