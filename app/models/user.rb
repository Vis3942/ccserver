class User < ApplicationRecord

  #     techsupport: "techsupport",

  enum role: {
    admin: "admin",
    s2: "s2",
    s1: "s1",
    manufacturingtech: "manufacturingtech",
    logistics: "logistics",
    finance: "finance" }	
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :validatable

  ## Relationship
  has_many :user_tokens, dependent: :destroy

  ## Methods
  def self.by_auth_token(token)
    user_token = UserToken.where(token: token).first
    user_token ? user_token.user : nil
  end

  def login!
    user_tokens.create
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

end
