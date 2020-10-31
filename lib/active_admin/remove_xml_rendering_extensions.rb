module ActiveAdmin
    module RemoveXmlRenderingExtension
      def self.included(base)
        base.send(:clear_respond_to)
        base.send(:respond_to, :html, :json)
        base.send(:respond_to, :csv, only: :index)
      end
    end
  end