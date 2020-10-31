ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("messages.welcome_dashboard")
        small I18n.t("messages.use_dashboard")

        # span I18n.t("active_admin.dashboard_welcome.welcome")
        # small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Tables" do
          ul do
            li link_to("Users", admin_users_path)
            li link_to("Devices", admin_devices_path)
            li link_to("Locations", admin_locations_path)
            li link_to("Error List", admin_errors_path)
            li link_to("Usage Statistics List", admin_usage_statistics_path)
            li link_to "Error Descriptions", admin_error_lists_path
          end
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content

  controller do
    def index
      redirect_to root_path unless current_user.admin?
    end
  end
end
