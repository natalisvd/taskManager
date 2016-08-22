ActiveAdmin.register UserToProject do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :project_id, :user_id
form do |f|
 f.input :project
 # f.input :user,collection: User.all.map{|u| [u.firstname+ " " + u.lastname]}
 f.input :user,collection: User.all.map{|u| [u.name+ " " + u.surname,u.id]}


 f.actions
end
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
