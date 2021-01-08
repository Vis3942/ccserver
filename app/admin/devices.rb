ActiveAdmin.register Device do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :serial_number, :imei_number, :location_id, :service_tag, :firmware_version, :language_version, :pay_per_use, :pay_per_use_approved, :decommissioned, :missing
  #
  # or
  #
  # permit_params do
  #   #permitted = [:serial_number, :imei_number, :location_id, :service_tag, :firmware_version, :device_ping_data, :device_ping_at, :pay_per_use, :decommissioned, :missing, :from, :to]
  #   permitted = [:serial_number, :imei_number, :location_id, :service_tag, :firmware_version, :pay_per_use, :decommissioned, :missing]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  preserve_default_filters!

  filter :location, collection: -> {
    Location.all.map { |loc| [loc.shipto_qb_name, loc.id] }
  }

  order_by(:firmware_version) do |order_clause|
    ["devices.firmware_version + 0.0",   order_clause.order].join(' ')
  end

  order_by(:language_version) do |order_clause|
    ["devices.language_version + 0.0",   order_clause.order].join(' ')
  end


  form do |f| 
    f.semantic_errors  *f.object.errors.keys
    f.inputs "Devices" do
      f.input :serial_number
      f.input :imei_number
      f.input :service_tag
      f.input :location_id, :input_html => { :value => !f.object.location_id.nil? ? [Location.find_by_id(f.object.location_id).ss_display_name(), f.object.location_id].join(', ')  : "" , 
            :maxlength => nil  } ,
        :as => :datalist,  
        :collection => Location.all.map { |loc| [loc.ss_display_name(), loc.id].join(', ') }
      f.input :firmware_version 
      f.input :language_version
      f.input :pay_per_use
      f.input :pay_per_use_approved
      f.input :decommissioned
      f.input :missing
    end
      f.actions
  end    

  index do
    selectable_column
    id_column
    column :service_tag
    column :serial_number
    column :imei_number
    column :location_id do |locobj|
      loc_item = Location.find_by_id(locobj.location_id)
      if loc_item.nil?
        link_to locobj.location_id, admin_location_path(locobj.location_id)
      else  
        link_to loc_item.shipto_qb_name, admin_location_path(locobj.location_id)
      end
    end
    column :firmware_version
    column :language_version
    column :device_ping_data
    column "Date Device Ping", :device_ping_at
    column :pay_per_use
    column :pay_per_use_approved
    column :decommissioned
    column :missing
    column :from
    column :to
    #actions
    actions defaults: false do |device|
      if device.to.nil? 
        item "View" , admin_device_path(device)
        text_node "&nbsp;".html_safe
        item "Edit", edit_admin_device_path(device)
        text_node "&nbsp;".html_safe
        item "Delete" , admin_device_path(device), method: :delete, confirm: I18n.t('active_admin.delete_confirmation')
      else
        item "View" , admin_device_path(device)
        text_node "&nbsp;".html_safe
        text_node "Edit"
        text_node "&nbsp;".html_safe
        item "Delete" , admin_device_path(device), method: :delete, confirm: I18n.t('active_admin.delete_confirmation')
      end
    end


  end

  show do
    attributes_table do
      row :service_tag
      row :serial_number
      row :imei_number
      row :location_id do |locobj|
        loc_item = Location.find_by_id(locobj.location_id)
        if loc_item.nil?
          link_to locobj.location_id, admin_location_path(locobj.location_id)
        else  
          link_to loc_item.shipto_qb_name, admin_location_path(locobj.location_id)
        end
      end
      row :firmware_version
      row :language_version
      row :device_ping_data
      row :device_ping_at
      row :pay_per_use
      row :pay_per_use_approved
      row :decommissioned
      row :missing
      row :from
      row :to
    end
  end

  controller do

    def create
      #loc_arr = permitted_params[:device]
      tmpstr = params["device"]["location_id"]
      params["device"]["location_id"] = tmpstr.split(', ').last
      dev_new = Device.create!(permitted_params[:device])
      dev_new.from = Time.now.utc

      if dev_new.save
        flash[:notice] = 'Device created successfully'
        redirect_to admin_device_path(dev_new)
      else 
        flash[:notice] = "Failed to create device. Retry"
        redirect_to edit_admin_device_path(dev_new)
      end
    end

    def update
      tmp_dev = params["device"]
      tmpstr = tmp_dev["location_id"]
      params[:device]["location_id"] = tmpstr.split(', ').last
      db_dev = Device.find_by_id(params["id"])
      if db_dev["location_id"].to_s != params[:device]["location_id"]
        db_dev.update_attributes!(:to => Time.now.utc )
        dev_new = Device.create!(permitted_params[:device])
        dev_new.from = Time.now.utc
        if dev_new.save
          flash[:notice] = 'Device updated successfully'
          redirect_to admin_device_path(dev_new)
        else 
          flash[:notice] = "Failed to update device. Retry"
          redirect_to edit_admin_device_path(dev_new)
        end
          
      else
        db_dev.update_attributes!(permitted_params[:device])
        flash[:notice] = 'Device updated successfully'
        redirect_to admin_device_path(db_dev)

      end
    end
      

  end

end
