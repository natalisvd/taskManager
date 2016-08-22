ActiveAdmin.register Project do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :name, :description, :user_id, :status, :access
 form do |f|
  f.input :creator,collection: User.all.map{|u| [u.name+ " " + u.surname,u.id]}
  f.input :name
  f.input :description
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
