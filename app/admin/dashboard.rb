##
# This class contains All Dashboard related functions like rendering, controllers

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  ##
  # function +content+ contains the layout for the dashboard page including links for differet elements
  # User roles are used to display the appropriate menu items.
  # The +if+ conditions specify the roles for displaying an item for user to act on  
  # In the +columns+ block the dashboard items are displayed

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
            li link_to("Users", admin_users_path) if current_user.admin?
            li link_to("Devices", admin_devices_path)
            li link_to("Locations", admin_locations_path) if current_user.admin? or current_user.s2? or current_user.s1? or current_user.logistics? or current_user.finance?
            li link_to "Groups", admin_groups_path if current_user.admin? or current_user.s2? or current_user.s1? or current_user.logistics? or current_user.finance?
            li link_to("Device Error List", admin_errors_path) if current_user.admin? or current_user.s2? or current_user.s1?
            li link_to("Usage Statistics List", admin_usage_statistics_path) if current_user.admin? or current_user.s2? or current_user.s1?
            li link_to "Error Code List", admin_error_lists_path if current_user.admin? or current_user.s2? or current_user.s1?
            li link_to "Tips Information", admin_tips_path if current_user.admin? or current_user.s2? or current_user.s1?
            li link_to "Invalid Packets", admin_invalid_packets_path if current_user.admin? or current_user.s2? or current_user.s1?
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

  ##
  # This function used to customzie Controller actions for dashboard supported by ActiveAdmin 
  # In the +index+ function, permissions allow display based on user roles

  controller do
    def index
      authorize :dashboard, :index?
      redirect_to root_path unless current_user.admin? or current_user.s2? or current_user.s1?  or current_user.manufacturingtech? or current_user.finance? or current_user.logistics?
    end
  end

  # def index
  #   authorize :dashboard, :index?
  # end

end
