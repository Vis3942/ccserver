ActiveAdmin.register User do
    permit_params :email, :password, :password_confirmation, :role, :name

    remove_filter :user_tokens, :superadmin
    index do
      selectable_column
      id_column
      column :email
      #column :current_sign_in_at
      #column :sign_in_count
      column :name
      column :role
      column "Date Created", :created_at
      column "Date Updated", :updated_at
      #actions
      actions defaults: false do |user|
        item "View" , admin_user_path(user)
        text_node "&nbsp;".html_safe
        item "Delete" , admin_user_path(user), method: :delete, confirm: I18n.t('active_admin.delete_confirmation')
        if current_user.admin?
          text_node "&nbsp;".html_safe
          item "Edit", edit_admin_user_path(user)
        end
      end
  end
  
    #filter :email
    #filter :current_sign_in_at
    #filter :sign_in_count
    #filter :created_at
  
    form do |f|
      f.inputs do
        f.input :name
        f.input :email
        f.input :password
        f.input :password_confirmation
        if @resource.id == nil # create new user
          f.input :role, :as => :select, :collection => User.roles
        else
          if current_user.admin?
            f.input :role, :as => :select, :collection => User.roles
          else
            f.input :role, :as => :label #:input_html => { :readonly => true }
          end
        end
      end
      f.actions do
        if @resource.id == nil  #create new user
          f.action :submit
          f.action :cancel, :label => "Cancel", :url => admin_users_path, :wrapper_html => { :class => 'cancel' }
        else
          if @resource.admin?
            f.action :submit
            f.action :cancel, :label => "Cancel", :url => admin_users_path, :wrapper_html => { :class => 'cancel' }
          else 
            # only 2 cases now admin or techsupport so this is techsupport
            f.action :submit
            f.action :cancel, :label => "Cancel", :url => root_path, :wrapper_html => { :class => 'cancel' }
          end
        end
      end
    end


    config.action_items.delete_if { |item| item.display_on?(:show) }

    # Then add in our own conditional Edit Button
    action_item :edit,  only: [ :show ] , if: proc { resource.email == current_user.email } do
      link_to "#{I18n.t('active_admin.edit')} User", edit_resource_path(resource)
    end

    # and our Delete Button
    action_item :delete,  only: [ :show ] , if: proc { current_user.admin? } do
      link_to "#{I18n.t('active_admin.delete')} User", resource_path(resource), method: :delete, confirm: I18n.t('active_admin.delete_confirmation')
    end

    # create_or_edit = Proc.new {
    #   #@user = User.find_or_create_by_id(params[:id])
    #   byebug
    #   @user = User.find_or_create_by(id: params[:id])
    #   @user.superadmin = params[:user][:superadmin]
    #   @user.attributes = params[:user].delete_if do |k, v|
    #     (k == "superadmin") ||
    #     (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
    #   end
    #   if @user.save
    #     redirect_to :action => :show, :id => @user.id
    #   else
    #     render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.erb')
    #   end
    # }

    # member_action :create, :method => :post, &create_or_edit
    # member_action :update, :method => :put, &create_or_edit

    controller do
      # def update(options={}, &block)
      #  # custom code here 
      #  super do |success, failure| 
      #   byebug
      #   block.call(success, failure) if block
      #   failure.html { render :edit }
      #   success.html { redirect_to root_path, notice: "#{resource.model_name.human} was successfully updated." }
      #   end
      # end

      def update
        # update! do |success, failure|
        #   byebug
        #   if current_user.techsupport?
        #     success.html { redirect_to admin_user_url }
        #     failure.html { redirect_to edit_admin_user_url }
        #   else # is admin?
        #     success.html { redirect_to collection_url }
        #     failure.html { redirect_to edit_admin_user_url }
        #   end
        # end
        if @current_user.email == params["user"]["email"] and params["user"]["password"] == "" and  params["user"]["password_confirmation"] == ""
          params["user"].delete("password")
          params["user"].delete("password_confirmation")
        end
        params["user"]["updated_at"]=Time.now
        update! { admin_user_path }
      end
    end
  
  end
  
