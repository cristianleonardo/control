namespace :assign_components do

  desc "Assigns components to certificates"

  task certificate_component_assignment: :environment do
    Certificate.where(component_id: nil).each do |c|
      component_id = c.sub_component.component_id
      c.update(component_id: component_id)
    end 
  end

end
