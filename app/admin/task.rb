ActiveAdmin.register Task do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :title, :description, :status, :parent_id, :executer_id, :project_id, :time_estimate , :relese_date, :elapsed_time
 form do |f|
  f.input :project
  f.input :executor,collection: User.all.map{|u| [u.name+ " " + u.surname,u.id]}
  f.input :title
  f.input :description
  f.input :status, as: :select, collection: { open: "open", in_progress: "in_progress", pause: "pause",  field: "field", closed: 'closed'}
  f.input :time_estimate
  f.input :elapsed_time
  f.input :relese_date, as: :datepicker, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }


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
