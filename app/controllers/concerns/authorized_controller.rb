module AuthorizedController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end
private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    current_user || redirect_to(root_path, notice: "Please log in")
  end
end
