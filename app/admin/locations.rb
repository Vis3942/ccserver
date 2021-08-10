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

  ## 
  # The +index+ block is used to show the list of locatons as a table
  # Any required customizations to show the value in a user-friendly way would need to be changed in this block

  index do
    selectable_column
    id_column
    column :group_id
    column :shipto_qb_id
    column :shipto_qb_name
    column :shipto_qb_address_l1
    column :shipto_qb_address_l2
    column :shipto_qb_city
    column :shipto_qb_state
    column :shipto_qb_zip
    column :shipto_qb_country
    column :shipto_qb_contact
    column :shipto_qb_phone_number
    column :time_zone
    actions
    panel "Tips and Hints", :id => "tips-panel" do
      disp_str = controller.get_tip_string()
      num_rows = disp_str.lines.count
      if num_rows > 10
        num_rows = 10
      end
      textarea  disp_str,  style: "width: 100%; max-width: 100%;", rows: num_rows, readonly: true #"tips here"
    end

  end


  ##
  # The +form+ function displays the individual location fields

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

    ## 
  # The +controller+ block includes the function get_tip_string
  # The function +get_tip_string+ is a custom action that retrives the relevant tip for the Location
  # table from the Tips table

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

    def get_tip_string
      tmp_tip = Tip.find_by_name("LocationTips")
      if tmp_tip.nil?
        "tips not defined"
      else
        tmp_tip.comment
      end
    end


  end
  
end
