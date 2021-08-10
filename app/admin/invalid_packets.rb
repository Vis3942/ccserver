ActiveAdmin.register InvalidPacket do

  ##
  # The +InvalidPacket+ resource uses the default views provided by ActiveAdmin.
  # There are no customizations required for displaying the InvalidPacket details to the user

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :packet
  #
  # or
  #
  # permit_params do
  #   permitted = [:packet, :received_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
