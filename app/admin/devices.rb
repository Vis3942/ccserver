ActiveAdmin.register Device do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :serial_number, :imei_number, :location_id, :service_tag, :firmware_version, :language_packs, :pay_per_use, :pay_per_use_approved, :decommissioned, :missing, :pay_per_use_grace_count
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
  remove_filter :archived

  filter :location, collection: -> {
    Location.all.map { |loc| [loc.shipto_qb_name, loc.id] }
  }

  order_by(:firmware_version) do |order_clause|
    ["devices.firmware_version + 0.0",   order_clause.order].join(' ')
  end

  # language_version replaced by language_packs (list of languages and versions)
  # order_by(:language_version) do |order_clause|
  #   ["devices.language_version + 0.0",   order_clause.order].join(' ')
  # end


  form do |f| 
    f.semantic_errors  *f.object.errors.keys
    f.inputs "Devices" do
      if current_user.admin? or current_user.manufacturingtech?
        f.input :serial_number
        f.input :imei_number
        f.input :service_tag
      else # for s2, s1,  logistics, finance
        f.input :serial_number, :input_html => { :disabled => true }
        f.input :imei_number, :input_html => { :disabled => true }
        f.input :service_tag, :input_html => { :disabled => true }
      end
      if current_user.admin? or current_user.logistics? or current_user.finance?
        f.input :location_id, :input_html => { :value => !f.object.location_id.nil? ? [Location.find_by_id(f.object.location_id).ss_display_name(), f.object.location_id].join(', ')  : "" , 
              :maxlength => nil  } ,
          :as => :datalist,  
          :collection => Location.all.map { |loc| [loc.ss_display_name(), loc.id].join(', ') }
      else
        f.input :location_id, :input_html => { :value => !f.object.location_id.nil? ? [Location.find_by_id(f.object.location_id).ss_display_name(), f.object.location_id].join(', ')  : "" , 
              :maxlength => nil, :disabled => true  } ,
          :as => :datalist,  
          :collection => Location.all.map { |loc| [loc.ss_display_name(), loc.id].join(', ') }
      end
      f.input :firmware_version, :input_html => { :disabled => true }
        #f.input :language_packs
      if current_user.admin? or current_user.logistics? or current_user.finance? 
        f.input :pay_per_use
        f.input :pay_per_use_approved
      else
        f.input :pay_per_use, :input_html => { :disabled => true }
        f.input :pay_per_use_approved, :input_html => { :disabled => true }        
      end
      if current_user.admin? 
        f.input :decommissioned
        f.input :missing
      else
          f.input :decommissioned, :input_html => { :disabled => true }
          f.input :missing, :input_html => { :disabled => true }
      end
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
    column "Language Versions", :language_packs do |device|
      if device.language_packs.nil?
        ""
      else
        l_pack_arr = device.language_packs.split(';')
        if l_pack_arr.length == 0
          ""
        elsif l_pack_arr.length == 1
          device.language_packs
        else
          select class: "form-control  ccs-form-control" do
            l_pack_arr.each { |x|
              option do
                x
              end
            }
          end
        end
      end
    end
    column "Ping Data", :device_ping_data do |device|
      tmpstr=device.device_ping_data
      if tmpstr.nil?
        ""
      else
        first_index=tmpstr.index(';')
        if first_index.nil?
          tmpstr
        else
          second_index=tmpstr.index(';', first_index+1)
          if second_index.nil?
            tmpstr
          else
            tmpstr.slice(second_index+1, tmpstr.length-1)
          end
        end
      end
    end
    column "Ping Date", :device_ping_at
    column "Pay Per Use (PPU)", :pay_per_use
    column "PPU Approved", :pay_per_use_approved
    column "PPU Grace Count", :pay_per_use_grace_count
    column :decommissioned
    column :missing
    column :from
    column :to
    #actions
    actions defaults: false do |device|
      if device.to.nil? 
        item "View" , admin_device_path(device)
        if current_user.admin? or current_user.logistics? or current_user.finance?
          text_node "&nbsp;".html_safe
          item "Edit", edit_admin_device_path(device)
        end
        if current_user.admin?
          text_node "&nbsp;".html_safe
          item "Archive" , admin_device_path(device), method: :delete, data: {confirm: I18n.t('messages.archive') }
        end
      else
        item "View" , admin_device_path(device)
        text_node "&nbsp;".html_safe
        if current_user.admin?
          text_node "Edit"
          text_node "&nbsp;".html_safe
          item "Archive" , admin_device_path(device), method: :delete, data: {confirm: I18n.t('messages.archive') }
        end
      end
    end
    panel "Tips and Hints", :id => "tips-panel" do
      disp_str = controller.get_tip_string()
      num_rows = disp_str.lines.count
      if num_rows > 10
        num_rows = 10
      end
      textarea  disp_str,  style: "width: 100%; max-width: 100%;", rows: num_rows, disabled: true #"tips here"
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

    def destroy
      #byebug
      # changing the functionality "delete" action archives the item
      # archival corresponds to setting "archieved" field to true
      device_id = params["id"]
      db_dev = Device.find_by_id(device_id)
      if !db_dev.nil?
        db_dev.archived = true
        db_dev.save
        UsageStatistic.where(device_id: device_id).update_all("archived = true")
        Error.where(device_id: device_id).update_all("archived = true")
      end
      redirect_to(request.referrer || root_path) 
    end

    def scoped_collection
      #end_of_association_chain.where(service_tag: "0Z0Z0")
      end_of_association_chain.where(archived: false)
    end

    def get_tip_string
      tmp_tip = Tip.find_by_name("DeviceTips")
      if tmp_tip.nil?
        "tips not defined"
      else
        tmp_tip.comment
      end
    end


  end

  batch_action :destroy, false

  batch_action  "show usage stats" do |ids|
    # print ids.inspect
    # print "selected parameters"
    # print params["collection_selection"]
    # print "-----xxxxxxx------xxxx----------"
    # redirect_to admin_usage_statistics_path(q: {device_id: 4})
    redirect_to admin_usage_statistics_path(q: {device_id: ids.map{|x| x.to_i} })
  end
  

end
