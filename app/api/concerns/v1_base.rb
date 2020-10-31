module V1Base
    extend ActiveSupport::Concern
  
    HEADERS_DOCS = {
      Authorization: {
        description: "User Authorization Token",
        required: true
      }
    }
  
    included do
      format :json
      prefix :api
      default_format :json
      formatter :json, 
          Grape::Formatter::ActiveModelSerializers
  
      version 'v1', using: :header, vendor: API_VENDOR
  
      rescue_from ActiveRecord::RecordNotFound do |e|
        render_error(RESPONSE_CODE[:not_found], I18n.t("errors.#{e.model.to_s.downcase}.not_found"))
      end
  
      rescue_from APIException do |e|
        render_error(e.http_status, e.error.message, e.error.debug_info)
      end
  
      helpers do
        def logger
          Rails.logger
        end
  
        def render_error(code, message, debug_info = '')
          error!({meta: {code: code, message: message}}, code)
        end
  
        def render_success(json, extra_meta = {})
          {data: json, meta: {code: RESPONSE_CODE[:success], message: I18n.t('messages.success')}.merge(extra_meta)}
        end

        def render_success_logout(json, extra_meta = {})
          {data: json, meta: {code: RESPONSE_CODE[:success], message: I18n.t('messages.success_logout')}.merge(extra_meta)}
        end

        def render_success_ping(json, extra_meta = {})
          {data: json, meta: {code: RESPONSE_CODE[:success], message: I18n.t('messages.ping_response')}.merge(extra_meta)}
        end

        def render_success_devinfo(json, extra_meta = {})
          {data: json, meta: {code: RESPONSE_CODE[:success], message: I18n.t('messages.current_info')}.merge(extra_meta)}
        end

        def render_success_connverify(json, extra_meta = {})
          {data: json, meta: {code: RESPONSE_CODE[:success], message: I18n.t('messages.conn_verify')}.merge(extra_meta)}
        end

        def render_success_update_errlist(json, extra_meta = {})
          {data: json, meta: {code: RESPONSE_CODE[:success], message: I18n.t('messages.update_err_success')}.merge(extra_meta)}
      end


        def pagination_dict(object)
          {
            current_page: object.current_page,
            next_page: object.next_page || -1,
            prev_page: object.prev_page || -1,
            total_pages: object.total_pages,
            total_count: object.total_count
          }
        end
      end
    end
  end
