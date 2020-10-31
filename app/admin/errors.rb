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
  filter :device, collection: -> {
    Device.all.map { |dev| [dev.service_tag, dev.id] }
  }

  filter :location, collection: -> {
    Location.all.map { |loc| [loc.shipto_qb_name, loc.id] }
  }

  index do 
    selectable_column
    id_column
    column :device_id do |usgstat|
      dev_item = Device.find_by_id(usgstat.device_id)
      if dev_item.nil? 
        link_to usgstat.device_id, admin_device_path(usgstat.device_id)
      else
        link_to dev_item.service_tag, admin_device_path(usgstat.device_id)
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
    column :occured_at
    column :error_code do |errstat|
      link_to errstat.error_code, admin_error_lists_path
    end
    column :received_at
    actions
  end    

  show do
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

end
