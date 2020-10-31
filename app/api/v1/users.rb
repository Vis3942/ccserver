module V1
  class Users < Grape::API
    include V1Base
    include AuthenticateRequest

    resource :users do
      desc 'login: Authenticate user and return access token', http_codes: [
        { code: RESPONSE_CODE[:success], message: I18n.t('messages.success') },
        { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.login_invalid') }
      ]
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User Password'
      end
 
      
      post "login" do
        email = params[:email]
        password = params[:password]

        if email.nil? or password.nil?
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.login_invalid'))
          return
        end

        #user = User.where(email: email.downcase).first
        user = User.where(email: email).first
        if user.nil? || !user.valid_password?(password)
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.login_invalid'))
          return
        end

        #if (user_signed_in?)
        #end

        # commented this block to allow multiple user logins
        #exist_u_token = UserToken.where(user_id: user.id).first
        #if not exist_u_token.nil?
        #  render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.api_Logged_in'))
        #  return
        #end

        u_token = user.login!
        u_token.regenerate_token
        u_token.expires_at = Time.now + MAX_UI_LOGIN_TIME_MINS * 60
        u_token.save
        serialization = UserSerializer.new(user, {show_token: true, token: u_token.token})

        render_success(serialization.as_json)


      end


    desc 'logout:use access token in header and email', http_codes: [
      { code: RESPONSE_CODE[:success], message: I18n.t('success') },
      { code: RESPONSE_CODE[:unauthorized], message: I18n.t('errors.login.invalid') }
    ]
    params do
      requires :email, type: String, desc: 'User email'
    end

    post "logout" do
        email = params[:email]

        if email.nil?
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.login.invalid'))
          return
        end

        #user = User.where(email: email.downcase).first
        user = User.where(email: email).first
        if user.nil?
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.login.invalid'))
          return
        end

        api_authenticate!
        
        auth_token = headers['Authorization']
        user_token = UserToken.where(token: auth_token, user_id: user.id).first

        if user_token.nil?
          render_error(RESPONSE_CODE[:unauthorized], I18n.t('errors.logout_invalid_token'))
          return
        else
          user_token.destroy
          render_success_logout({})
        end
      end
    end
  end
end
