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
  remove_filter :archived

  filter :device, collection: -> {
    Device.all.map { |dev| [dev.service_tag, dev.id] }
  }

  filter :location, collection: -> {
    Location.all.map { |loc| [loc.shipto_qb_name, loc.id] }
  }

  order_by(:treatment_time) do |order_clause|
    ["usage_statistics.treatment_time + 0",   order_clause.order].join(' ')
  end

  order_by(:board_temperature) do |order_clause|
    ["usage_statistics.board_temperature + 0",   order_clause.order].join(' ')
  end

  order_by(:min_co2_temperature) do |order_clause|
    ["usage_statistics.min_co2_temperature + 0.0",   order_clause.order].join(' ')
  end

  order_by(:max_co2_temperature) do |order_clause|
    ["usage_statistics.max_co2_temperature + 0.0",   order_clause.order].join(' ')
  end

  order_by(:average_co2_temperature) do |order_clause|
    ["usage_statistics.average_co2_temperature + 0",   order_clause.order].join(' ')
  end

  order_by(:tank_time_remaining) do |order_clause|
    ["usage_statistics.tank_time_remaining + 0",   order_clause.order].join(' ')
  end

  ## 
  # The +index+ block is used to show the recorded usage statistics of devices as a table
  # All customizations to show the value in a user-friendly way would occur in this block

  index do
    selectable_column
    id_column
    column :device_id
    #column :device_id do |usgstat|
    #  dev_item = Device.find_by_id(usgstat.device_id)
    #  if dev_item.nil? 
    #    link_to usgstat.device_id, admin_device_path(usgstat.device_id)
    #  else
    #    link_to [dev_item.service_tag, dev_item.serial_number].join(' : '), admin_device_path(usgstat.device_id)
    #  end
    #end
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
  # The +show+ block renders the view of an individual usage statistics item
  # The individual elements displayed in the view are based on the values in the attributes_table
  # if this function is missing, a default implementation from Active Admin will be used

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

  ## 
  # The +controller+ block includes functions scoped_collection and get_tip_string. 
  # The function +scoped_collection+ is used to customize the collection extracted from the 
  # database for the display
  # The function +get_tip_string+ is a custom action that retrives the relevant tip for the Device
  # table from the Tips table

  controller do
    def scoped_collection
      if !params["q"].nil?
        if params["q"]["device_id"].nil?
          end_of_association_chain
        else
          end_of_association_chain.where(device_id: params["q"]["device_id"])
        end
      else
        end_of_association_chain
      end
      #end_of_association_chain
    end

    def get_tip_string
      tmp_tip = Tip.find_by_name("UsaageStatisticsTips")
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
