ActiveAdmin.register Location do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :group_id, :shipto_qb_id, :shipto_qb_name, :shipto_qb_address_l1, :shipto_qb_address_l2, :shipto_qb_city, :shipto_qb_state, :shipto_qb_zip, :shipto_qb_country, :shipto_qb_contact, :shipto_qb_phone_number, :time_zone
  #
  # or
  #
  # permit_params do
  #   permitted = [:group_id, :shipto_qb_id, :shipto_qb_name, :shipto_qb_address_l1, :shipto_qb_address_l2, :shipto_qb_city, :shipto_qb_state, :shipto_qb_zip, :shipto_qb_country, :shipto_qb_contact, :shipto_qb_phone_number, :time_zone]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :group_id, :shipto_qb_id, :shipto_qb_name, :shipto_qb_address_l1, :shipto_qb_address_l2, :shipto_qb_city, :shipto_qb_state, :shipto_qb_zip, :shipto_qb_country, :shipto_qb_contact, :shipto_qb_phone_number, :time_zone

  form do |f| 
    f.semantic_errors  *f.object.errors.keys

    f.inputs "Locations" do
      f.input :group_id, :as => :select, :collection => Group.pluck(:name, :id)
      f.input :shipto_qb_id
      f.input :shipto_qb_name
      f.input :shipto_qb_address_l1
      f.input :shipto_qb_address_l2 
      f.input :shipto_qb_city
      f.input :shipto_qb_state
      f.input :shipto_qb_zip
      f.input :shipto_qb_country, :as => :string
      f.input :shipto_qb_contact
      f.input :shipto_qb_phone_number
      f.input :time_zone
    end
      f.actions
  end    

  controller do
    #layout 'active_admin'

    # def index
    #   # index! do |format|
    #   #   #format.html
    #   #   format.json do
    #   #     ta = collection.to_a
    #   #     tam = ta.map {  |x|  {:id => x.id, :ss_disp_name => x.ss_disp_name }  }
    #   #     render json: tam
    #   #   end
    #   # end
    #   build_resource
    #   index!
    # end
  end
  
end
