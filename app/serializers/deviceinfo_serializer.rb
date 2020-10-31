class DeviceinfoSerializer < ActiveModel::Serializer
    #attributes :uid, :email, :name
    attributes :ping_data, :updated_at, :response

    def ping_data
        self.instance_options[:ping_data]
    end

    def updated_at
        self.instance_options[:updated_at].to_s
    end

    def response
        self.instance_options[:response]
      end
  
  end
