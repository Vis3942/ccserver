ActiveAdmin.register Error do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :device_id, :location_id, :occured_at, :error_code
  #
  # or
  #
  # permit_params do
  #   permitted = [:device_id, :location_id, :occured_at, :error_code]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :device_id, :location_id, :occured_at, :error_code
  
  actions :all, except: [:destroy, :new, :update, :create, :edit]

  #actions :all, except: [:new]


  preserve_default_filters!
  remove_filter :archived

  filter :device, collection: -> {
    Device.all.map { |dev| [dev.service_tag, dev.id] }
  }

  filter :location, collection: -> {
    Location.all.map { |loc| [loc.shipto_qb_name, loc.id] }
  }


  ## 
  # The +index+ block is used to show the list of Device Errors as a table
  # All customizations to show the value in a user-friendly way would occur in this block

  index :title => "Device Error List" do 
    selectable_column
    id_column
    column :device_id do |usgstat|
      dev_item = Device.find_by_id(usgstat.device_id)
      if dev_item.nil? 
        link_to usgstat.device_id, admin_device_path(usgstat.device_id)
      else
        link_to [dev_item.service_tag, dev_item.serial_number].join(' : '), admin_device_path(usgstat.device_id)
      end
    end
    column :location_id do |usgstat|
      loc_item = Location.find_by_id(usgstat.location_id)
      if loc_item.nil?
        link_to usgstat.location_id, admin_location_path(usgstat.location_id)
      else  
        link_to loc_item.shipto_qb_name, admin_location_path(usgstat.location_id)
      end
    end
    column "Date Occured", :occured_at
    column :error_code do |errstat|
      #link_to errstat.error_code, admin_error_lists_path
      err_item = ErrorList.find_by_code(errstat.error_code)
      if err_item.nil?
        link_to errstat.error_code, admin_error_lists_path
      else
        link_to errstat.error_code, admin_error_list_path(err_item.id)
      end
    end
    column "Date Received", :received_at
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
  # The +show+ block renders the view of an individual device error item
  # The individual elements displayed in the view are based on the values in the attributes_table
  # if this function is missing, a default implementation from Active Admin will be used

  show :title => "Device Error List" do
    attributes_table do
      row :device_id do |usgstat|
        dev_item = Device.find_by_id(usgstat.device_id)
        if dev_item.nil? 
          link_to usgstat.device_id, admin_device_path(usgstat.device_id)
        else
          link_to dev_item.service_tag, admin_device_path(usgstat.device_id)
        end
      end    
      row :location_id do |usgstat|
        loc_item = Location.find_by_id(usgstat.location_id)
        if loc_item.nil?
          link_to usgstat.location_id, admin_location_path(usgstat.location_id)
        else  
          link_to loc_item.shipto_qb_name, admin_location_path(usgstat.location_id)
        end
      end
      row :occured_at
      row :error_code
      row :received_at
    end

  end

  ## 
  # The +controller+ block includes functions get_tip_stting and scoped_collection. 
  # The function +scoped_collection+ is used to customize the collection extracted from the 
  # database for the display
  # The function +get_tip_string+ is a custom action that retrives the relevant tip for the Device Error List
  # table from the Tips table

  controller do
    def get_tip_string
      tmp_tip = Tip.find_by_name("ErrorTips")
      if tmp_tip.nil?
        "tips not defined"
      else
        tmp_tip.comment
      end
    end

    def scoped_collection
      end_of_association_chain.where(archived: false)
    end


  end

end
