module V1
  class Devices < Grape::API
    include V1Base
    include AuthenticateRequest

    resource :devices do
      desc 'ping: {serial_number, data_str} update Devices table and return response', http_codes: [
        { code: RESPONSE_CODE[:success], message: I18n.t('messages.success') },
        { code: RESPONSE_CODE[:bad_request], message: I18n.t('errors.no_device') }
        ]

      params do
          requires :serial_number, type: String, desc: 'device serial number'
          requires :imei_number, type: String, desc: 'device imei number'
          requires :ping_data, type: String, desc: 'device sent ping data'
      end

      post "ping" do
        serial_number = params[:serial_number]
        imei_number = params[:imei_number]
        ping_data = params[:ping_data]

        if serial_number.nil? or ping_data.nil? or imei_number.nil?
          render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.invalid_device_data', meta = {response: ""}))
          return
        end

        device = Device.where(serial_number: serial_number, imei_number: imei_number, to: nil).first
        if device.nil?
          render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
          return
        end

        #Send Ack data packet 7 strings delimited by ‘;’ back to unit consisting of one byte with the following bit fields:
        #a. string0: 0 = ack, 1 = re-send
        #b. string1: from database id 9: 0 = none, 1 = firmware available
        #c. String2: from database id 12: 0 = none, 1 = new language pack available
        #d. String3: from database id 19: 0 = no approval, 1 = unit approved for pay-per-use
        #e. String4: from database id 20: 0 = unit is free, 1 = unit is pay-per-use
        #f. String5: from database id 21: 0 = unit ops normal, 1 = de-commission unit
        #g. String6: 1: UI waiting for connection
        #h. String7: reserved
        #i. String8: 0x0D
        #each bit   "1" or "0" for each "x;x;x;x;x;x;x;x"
        #0x0D will be added by the socket server beffore sending it out
        ##TODO: read the other params from other tables


        # New Ping Packet format
        # A;B;C;D;E;F;G;H1;...Hn\r
        # where 
        # [0] A = IMEI 
        # [1] B = serial number
        # [2] C = stats counts
        # [3] D = error count
        # [4] E = firmware version
        # [5] F = PPU grace treatments left
        # [6] G = total number of language packs
        # [7.. 7 + item[6] - 1]Hi  = each language pack name with version number and i = 0...G-1 

        device.device_ping_at = Time.now.utc
        device.device_ping_data = ping_data
        ping_arr = ping_data.split(";").map!(&:strip)
        device.firmware_version = ping_arr[4]
        device.pay_per_use_grace_count = ping_arr[5].to_i 
        if (ping_arr.count > 7)
          device.language_packs = ping_arr.slice(7, ping_arr.count-1 ).join(';')
        else
          device.language_packs = ""
        end
        device.save
        #TODO: compute response based on other db fields and current time zone               
        resp_str = '0;0;0;0;0;0;0;0' 
        if device.pay_per_use
          resp_str[8] = '1'
          if device.pay_per_use_approved
            resp_str[6] = '1'
          end
        end  
        if device.decommissioned
          resp_str[10] = '1'
        end              
        serialization = DeviceSerializer.new(device, {response: resp_str})
        render_success_ping(serialization.as_json)
      end


        desc 'get-device: {service_tag, email} ui tech support requesting info about device', http_codes: [
          { code: RESPONSE_CODE[:success], message: I18n.t('messages.success') },
          { code: RESPONSE_CODE[:bad_request], message: I18n.t('errors.no_device') }
          ]
          params do
              requires :service_tag, type: String, desc: 'device service tag'
              requires :email, type: String, desc: 'user request e-mail'
          end

          post "get-device" do
              service_tag = params[:service_tag]
              email = params[:email]
      
              if service_tag.nil? or email.nil? 
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.invalid_device_data', meta = {response: ""}))
                return
              end
      
              #authenticate user and source
              if headers["Authorization"].nil?
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
              end

              #byebug
              hdrtoken = headers["Authorization"]
              utoken = UserToken.where(token: hdrtoken )
              if utoken.nil? or utoken.records.size == 0
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
              end

              #has token expired: allow upto 1 hour
              #TODO: check if token has expired if yes sent token expired errors.token_expired

              #does email mataches token
              user4token = User.find_by_id(utoken.records[0].user_id)
              if user4token.nil? or user4token.email != email
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
              end

              if !headers["Host"].starts_with?('127.0.0.1')
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
              end


              #locate device
              device = Device.where(service_tag: service_tag, to: nil).first
              if device.nil?
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
                return
              end

              #device.device_ping_at = Time.now.utc
              #device.device_ping_data = ping_data
              #device.save
              serialization = DeviceinfoSerializer.new(nil, {ping_data: device.device_ping_data, updated_at: device.device_ping_at, response: ""})
              render_success_devinfo(serialization.as_json)
          end

          desc 'connect-verify: {service_tag, email} ui tech support requesting connect', http_codes: [
            { code: RESPONSE_CODE[:success], message: I18n.t('messages.success') },
            { code: RESPONSE_CODE[:bad_request], message: I18n.t('errors.no_device') }
            ]
            params do
                requires :service_tag, type: String, desc: 'device service tag'
                requires :email, type: String, desc: 'user request e-mail'
            end

            post "connect-verify" do
                service_tag = params[:service_tag]
                email = params[:email]
        
                if service_tag.nil? or email.nil? 
                  render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.invalid_device_data', meta = {response: ""}))
                  return
                end
        
                #authenticate user and source
                if headers["Authorization"].nil?
                  render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
                end

                hdrtoken = headers["Authorization"]
                utoken = UserToken.where(token: hdrtoken )
                if utoken.nil? or utoken.records.size == 0
                  render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
                end

                #has token expired: allow upto 1 hour
                #TODO: check if token has expired if yes sent token expired errors.token_expired

                #does email mataches token
                user4token = User.find_by_id(utoken.records[0].user_id)
                if user4token.nil? or user4token.email != email
                  render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
                end

                if !headers["Host"].starts_with?('127.0.0.1')
                  render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.not_authenticated'), meta = {response: ""})
                end


                #locate device
                device = Device.where(service_tag: service_tag, to: nil).first
                if device.nil?
                  render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
                  return
                end

                serialization = DeviceinfoSerializer.new(nil, {ping_data: "", updated_at: "", response: "true"})
                render_success_connverify(serialization.as_json)
            end

          desc 'update-device-errors: {device, errors[]} uploading error data from device', http_codes: [
              { code: RESPONSE_CODE[:success], message: I18n.t('messages.success') },
              { code: RESPONSE_CODE[:bad_request], message: I18n.t('errors.no_device') }
            ]
            params do
              requires :device, type: String, desc: 'device service tag'
              requires :error_list, type: Array[JSON], desc: 'array of error items'
            end
      
      
            post "update-device-errors" do
              #puts params.inspect
              service_tag = params[:device]
              err_list = params[:error_list]
      
              if service_tag.nil? or err_list.nil? or err_list.length == 0
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.invalid_error_list', meta = {response: "false"}))
                return
              end
      
              #locate device
              device = Device.where(service_tag: service_tag, to: nil).first
              if device.nil?
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
                return
              end
              
              #get location_id
              dev_id = device.id
              loc_id = device.location_id
              if loc_id.nil?
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
                return
              end
      
              #todo: update error table from list and return "true" for response
              
              to_ins = []
              recv_at = Time.now.utc
              err_list.each do |item|
                dt_err = DateTime.strptime(item["occured_at"], "%m/%d/%y/ %H:%M")
                err_line = {location_id: loc_id, device_id: dev_id, occured_at: dt_err, error_code: item["error_code"], received_at: recv_at }
                to_ins.push(err_line)
              rescue
                logger.debug "Invalid error logged in device #{service_tag} occured_at #{item["occured_at"]} "
              end

              #to_ins.inspect
              curr_count = Error.count
              result = Error.insert_all(to_ins)
              after_count = Error.count
              if curr_count + to_ins.length == after_count
                serialization = DeviceinfoSerializer.new(nil, {ping_data: "", updated_at: "", response: "true"})
                render_success_update_errlist(serialization.as_json)
              else
                err_serialization = DeviceinfoSerializer.new(nil, {ping_data: "", updated_at: "", response: "false"})
                render_success_update_errlist(err_serialization.as_json)
              end
 
            end

            desc 'update-device-usagestats: {device, usagestats[]} uploading usage stats from device', http_codes: [
              { code: RESPONSE_CODE[:success], message: I18n.t('messages.success') },
              { code: RESPONSE_CODE[:bad_request], message: I18n.t('errors.no_device') }
            ]
            params do
              requires :device, type: String, desc: 'device service tag'
              requires :usagestats_list, type: Array[JSON], desc: 'array of usage statistics'
            end
      
      
            post "update-device-usagestats" do
              #puts params.inspect
              service_tag = params[:device]
              usagestats_list = params[:usagestats_list]
      
              if service_tag.nil? or usagestats_list.nil? or usagestats_list.length == 0
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.invalid_usagestats_list', meta = {response: "false"}))
                return
              end
      
              #locate device
              device = Device.where(service_tag: service_tag, to: nil).first
              if device.nil?
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
                return
              end
              
              #get location_id
              dev_id = device.id
              loc_id = device.location_id
              if loc_id.nil?
                render_error(RESPONSE_CODE[:bad_request], I18n.t('errors.no_device'), meta = {response: ""})
                return
              end
      
              #todo: update UsageStatistics table from list and return "true" for response
              
              to_ins = []
              recv_at = Time.now.utc
              usagestats_list.each do |item|
                usagestats_line = {location_id: loc_id, device_id: dev_id, received_at: recv_at,
                  cartridge_tag_id: item["cartridge_tag_id"], serum_name: item["serum_name"], 
                  serum_part_number: item["serum_part_number"], serum_lot_number: item["serum_lot_number"], 
                  treatment_time: item["treatment_time"], 
                  datetime_used: item["datetime_used"], board_temperature: item["board_temperature"], 
                  min_co2_temperature: item["min_co2_temperature"], max_co2_temperature: item["max_co2_temperature"], 
                  average_co2_temperature: item["average_co2_temperature"], tank_tag_id: item["tank_tag_id"], 
                  tank_time_remaining: item["tank_time_remaining"] }
                to_ins.push(usagestats_line)
              end

              #to_ins.inspect
              curr_count = UsageStatistic.count
              result = UsageStatistic.insert_all(to_ins)
              after_count = UsageStatistic.count
              if curr_count + to_ins.length == after_count
                serialization = DeviceinfoSerializer.new(nil, {ping_data: "", updated_at: "", response: "true"})
                render_success_update_errlist(serialization.as_json)
              else
                err_serialization = DeviceinfoSerializer.new(nil, {ping_data: "", updated_at: "", response: "false"})
                render_success_update_errlist(err_serialization.as_json)
              end
 
            end
            
    end
  end
end
