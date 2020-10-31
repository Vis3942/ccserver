ActiveAdmin.register UsageStatistic do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :device_id, :location_id, :received_at, :cartridge_tag_id, :serum_name, :serum_lot_number, :treatment_time, :datetime_used, :board_temperature, :min_co2_temperature, :max_co2_temperature, :average_co2_temperature, :tank_tag_id, :tank_time_remaining
  #
  # or
  #
  # permit_params do
  #   permitted = [:device_id, :location_id, :received_at, :cartridge_tag_id, :serum_name, :serum_lot_number, :treatment_time, :datetime_used, :board_temperature, :min_co2_temperature, :max_co2_temperature, :average_co2_temperature, :tank_tag_id, :tank_time_remaining]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :device_id, :location_id, :received_at, :cartridge_tag_id, :serum_name, :serum_lot_number, :serum_lot_number, :treatment_time, :datetime_used, :board_temperature, :min_co2_temperature, :max_co2_temperature, :average_co2_temperature, :tank_tag_id, :tank_time_remaining
  
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
    #column :device_id
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
    column :cartridge_tag_id
    column :serum_name
    column :serum_lot_number
    column :serum_part_number
    column :treatment_time
    column :datetime_used
    column :board_temperature
    column :min_co2_temperature
    column :max_co2_temperature
    column :average_co2_temperature
    column :tank_tag_id
    column :tank_time_remaining
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
      row :cartridge_tag_id
      row :serum_name
      row :serum_lot_number
      row :serum_part_number
      row :treatment_time
      row :datetime_used
      row :board_temperature
      row :min_co2_temperature
      row :max_co2_temperature
      row :average_co2_temperature
      row :tank_tag_id
      row :tank_time_remaining
      row :received_at
  end
  
    end
  


end
