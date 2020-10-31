class DeviceSerializer < ActiveModel::Serializer
    #attributes :uid, :email, :name
    attributes :serial_number, :imei_number, :service_tag, :response

    def response
      self.instance_options[:response]
    end


  end
