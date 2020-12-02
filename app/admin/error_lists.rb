ActiveAdmin.register ErrorList do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :code, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:code, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  actions :all, except: [:destroy ]

  form do |f| 
    f.semantic_errors  *f.object.errors.keys
    if object.new_record?
      f.inputs "Error List" do
        f.input :code
        f.input :description
      end
  else
      f.inputs "Error List" do
        f.input :code, :input_html => { :readonly => true }
        f.input :description
      end
    end
      f.actions
  end    

end
