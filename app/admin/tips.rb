ActiveAdmin.register Tip do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :comment
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :comment]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  ##
  # The +form+ function displays the individual tips fields
  # The default view provided by Active Admin is used in the form  

  form do |f|
    f.inputs do
      f.input :name
      f.input :comment, :as => :text
      end

    f.actions

  end  


end
